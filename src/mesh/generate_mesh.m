function [element_nodes, node_coordinates, facet_sets, node_sets] = ...
    generate_mesh(element_type, num_elems, min_coord, max_coord)
% [element_nodes, node_coordinates, facet_sets, node_sets] = ...
%     generate_mesh(element_type, num_elems, min_coord, max_coord)
%   Create a mesh for a hyper-rectangle with `element_type`
% Inputs
% * `element_type`: String specifying the element type, supported types are
%   - `LinearLine`: 2-noded line element (1d)
%   - `QuadraticLine`: 3-noded line element (1d)
%   - `LinearTriangle`: 3-noded triangular element (2d)
%   - `QuadraticTriangle`: 6-noded triangular element (2d)
%   - `BilinearQuadrilateral`: 4-noded quadrilateral element (2d)
%   - `QuadraticQuadrilateral`: 8-noded quadrilateral element (2d)
% * `num_elems` [ndim, 1]: Number of element edges on the surface in each 
%    coordinate direction
% * `min_coord` [ndim, 1]: Coordinate of the point with the minimum
%   coordinate components (e.g. lower left). Defaults to `-ones(ndim, 1)`
% * `max_coord` [ndim, 1]: Coordinate of the point with the maximum
%   coordinate components (e.g. upper right). Defaults to `ones(ndim, 1)`
%
% Outputs:
% * `element_nodes` [num_elem_nodes, num_elems]: `element_nodes(:, e)` gives
%   the node numbers of the nodes of element `e`. 
% * `node_coordinates` [dim, num_nodes]: The coordinates of each node in
%   the mesh. 
% * `facet_sets` dictionary: string -> cell array: Each column contains the
%   element number and facet number.
% * `node_sets` dictionary: string -> cell array: The node numbers
%   belonging to the set
% 
% In 1d, the `facet_sets` and `node_sets` includes "left" and "right",
% whereas in 2d, they contain "corners", "left", "right", "bottom" & "top".
% 
% Notes on the dictionaries
% Due to limitations in MATLAB, we cannot save standard arrays directly as
% values in dictionaries, therefore these are wrapped in a cell array. To
% access these sets, index with curly braces and assign to a variable, e.g.
% -------------------------------------------------------------------------
% left_side = facet_sets{"left"}
% for f = 1:size(left_side, 2)
%     element_id, facet_nr = left_side(:, f)
%     ...
% -------------------------------------------------------------------------

    % Defaults
    if nargin < 4
        max_coord = ones(size(num_elems));
    end
    if nargin < 3
        min_coord = -ones(size(num_elems));
    end

    [node_coordinates, node_sets] = ...
        generate_coords(element_type, num_elems, min_coord, max_coord);
    element_nodes = generate_elements(element_type, num_elems);
    num_nodes = size(node_coordinates, 2);
    facet_sets = create_facet_sets(node_sets, element_nodes, element_type, num_nodes);
end

function [node_coordinates, node_sets] = ...
    generate_coords(element_type, num_elems, min_coord, max_coord)
    num_nodes = get_num_nodes(element_type, num_elems);
    if (all(size(num_elems) ~= size(min_coord)) ||...
        all(size(num_elems) ~= size(max_coord)))
        error("num_elems, min_coord, and max_coord should " + ...
            "all be column vectors of the same size")
    end
    dim = length(num_nodes);
    if dim == 1
        node_coordinates = linspace(min_coord(1), max_coord(1), num_nodes(1));
        node_sets = dictionary(["left", "right"], [{[1]}, {[num_nodes(1)]}]);
    elseif dim == 2
        x = linspace(min_coord(1), max_coord(1), num_nodes(1));
        y = linspace(min_coord(2), max_coord(2), num_nodes(2));
        [X, Y] = meshgrid(x, y);
        node_coordinates = [reshape(X, 1, []); reshape(Y, 1, [])];
        N = size(node_coordinates, 2);
        n = [1; N - num_nodes(2) + 1; N; num_nodes(2)];
        node_sets = dictionary(["corners"; "left"; "right"; "bottom"; "top"], [
            {n}; % corners
            {(1:n(4))'};
            {(n(2):n(3))'}; 
            {(n(1):num_nodes(2):n(2))'}; 
            {(n(4):num_nodes(2):n(3))'}
            ]);
    elseif dim == 3
        x = linspace(min_coord(1), max_coord(1), num_nodes(1));
        y = linspace(min_coord(2), max_coord(2), num_nodes(2));
        z = linspace(min_coord(3), max_coord(3), num_nodes(3));
        [X, Y, Z] = meshgrid(x, y, z);
        node_coordinates = [reshape(X, 1, []); reshape(Y, 1, []), reshape(Z, 1, [])];
        node_sets = dictionary(); % TODO: node sets not implemented for 3d yet
    else
        error("%uD not supported, num_elems = [%s]", dim, num2str(num_elems))
    end 
end

function num_nodes = get_num_nodes(element_type, num_elems)
    switch element_type
        case {"LinearLine", "LinearTriangle", "BilinearQuadrilateral", "LinearTetrahedron", "LinearHexahedron"}
            num_nodes = num_elems + 1;
        case {"QuadraticLine", "QuadraticTriangle", "QuadraticQuadrilateral"}
            num_nodes = 2 * num_elems + 1;
        otherwise
            error("element_type = %s is not implemented", element_type)
    end
end

function element_nodes = generate_elements(element_type, num_elems)
    switch element_type
        case "LinearLine"
            element_nodes = generate_linear_lines(num_elems);
        case "QuadraticLine"
            element_nodes = generate_quadratic_lines(num_elems);
        case "LinearTriangle"
            element_nodes = generate_linear_triangles(num_elems);
        case "QuadraticTriangle"
            element_nodes = generate_quadratic_triangles(num_elems);
        case "BilinearQuadrilateral"
            element_nodes = generate_linear_quadrilaterals(num_elems);
        case "QuadraticQuadrilateral"
            element_nodes = generate_quadratic_quadrilaterals(num_elems);
        otherwise
            error("%s not implemented", element_type)
    end
end

function elems = generate_linear_lines(num_elems)
    elems = [1:num_elems; 2:(num_elems + 1)];
end

function elems = generate_quadratic_lines(num_elems)
    nnodes = 2 * num_elems + 1;
    elems = [1:2:(nnodes-2); 3:2:nnodes; 2:2:(nnodes-1)];
end

function elems = generate_linear_triangles(num_elems)
    % Global nodes are numbered in y-direction before x-direction
    % Local nodes are numbered by vertices, then edges, then faces
    % n2 -m2    
    % | \ B|   A: n1 - m1 - n2
    % |A \ |   B: n2 - m1 - m2
    % n1--m1
    nel = prod(num_elems) * 2;
    elems = zeros(3, nel);
    nn_per_col = (num_elems(2) + 1); % Number of nodes in each column
    ne_per_col = 2 * num_elems(2);   % Number of elements in each column
    for col = 1:num_elems(1) % x-direction
        node0 = nn_per_col * (col - 1) + 1;% First node in col
        node1 = node0 + nn_per_col;           % First node in col+1
        elem0 = ne_per_col * (col - 1) + 1;% First element in col
        n1 = node0:(node0 + nn_per_col - 2);
        n2 = n1 + 1;
        m1 = node1:(node1 + nn_per_col - 2);
        m2 = m1 + 1;
        % Element A
        A_range = elem0:2:(elem0+ne_per_col-1);
        elems(1, A_range) = n1;
        elems(2, A_range) = m1;
        elems(3, A_range) = n2;
        % Element B
        B_range = A_range + 1;
        elems(1, B_range) = n2;
        elems(2, B_range) = m1;
        elems(3, B_range) = m2;
    end
end

function elems = generate_quadratic_triangles(num_elems)
    % Global nodes are numbered in y-direction before x-direction
    % Local nodes are numbered by vertices, then edges, then faces
    % i3-j3-k3      vertices |  edges
    % | \ (B)|      v1-v2-v3 | e1-e2-e3
    % i2 j2 k2      ---------|---------
    % |(A) \ |   A: i1-k1-i3 | j1-j2-i2 
    % i1-j1-k1   B: k1-k3-i3 | k2-j3-j2 
    nel = prod(num_elems) * 2;
    elems = zeros(6, nel);
    nn_per_col = (2 * num_elems(2) + 1); % Number of nodes in each column
    ne_per_col = 2 * num_elems(2);   % Number of elements in each column
    for col = 1:num_elems(1) % x-direction
        i0 = nn_per_col * 2 * (col - 1) + 1; % First node in col
        
        i1 = i0:2:(i0 + nn_per_col - 3);
        j1 = i1 + nn_per_col;
        k1 = j1 + nn_per_col;

        elem0 = ne_per_col * (col - 1) + 1;% First element in col
        
        % Element A
        A_range = elem0:2:(elem0+ne_per_col-1);
        elems(1, A_range) = i1;   % v1: i1
        elems(2, A_range) = k1;   % v2: k1
        elems(3, A_range) = i1+2; % v3: i3
        elems(4, A_range) = j1;   % e1: j1
        elems(5, A_range) = j1+1; % e2: j2
        elems(6, A_range) = i1+1; % e3: i2
        % Element B
        B_range = A_range + 1;
        elems(1, B_range) = k1;   % v1: k1
        elems(2, B_range) = k1+2; % v2: k3
        elems(3, B_range) = i1+2; % v3: i3
        elems(4, B_range) = k1+1; % e1: k2
        elems(5, B_range) = j1+2; % e2: j3
        elems(6, B_range) = j1+1; % e3: j2
    end
end

function elems = generate_linear_quadrilaterals(num_elems)
    % Global nodes are numbered in y-direction before x-direction
    % Local nodes are numbered by vertices, then edges, then faces
    %                   vertices  | edges
    % i2---j2         ------------|---------
    % | (A) |         i1-j1-j2-i2
    % i1---j1
    nel = prod(num_elems);
    elems = zeros(4, nel);
    nn_per_col = num_elems(2) + 1; % Number of nodes in each column
    ne_per_col = num_elems(2);   % Number of elements in each column
    for col = 1:num_elems(1) % x-direction
        i0 = nn_per_col * (col - 1) + 1; % First node in col
        
        i1 = i0:(i0 + nn_per_col - 2);
        j1 = i1 + nn_per_col;
        
        elem0 = ne_per_col * (col - 1) + 1; % First element in col
        
        % Fill into elems
        erange = elem0:(elem0+ne_per_col-1);
        elems(1, erange) = i1;   % v1: i1
        elems(2, erange) = j1;   % v2: j1
        elems(3, erange) = j1+1; % v3: j2
        elems(4, erange) = i1+1; % v4: i2
    end
end

function elems = generate_quadratic_quadrilaterals(num_elems)
    % Global nodes are numbered in y-direction before x-direction
    % Local nodes are numbered by vertices, then edges, then faces
    %                    vertices  |    edges    | faces
    % i3--j3--k3       v1-v2-v3-v4 | e1-e2-e3-e4 | f1
    % |        |       ------------|-------------|-----
    % i2 (j2) k2       i1-k1-k3-i3 | j1-k2-j3-i2 | j2
    % |        |       
    % i1--j1--k1
    nel = prod(num_elems);
    elems = zeros(9, nel);
    nn_per_col = 2 * num_elems(2) + 1; % Number of nodes in each column
    ne_per_col = num_elems(2);   % Number of elements in each column
    for col = 1:num_elems(1) % x-direction
        i0 = nn_per_col * 2 * (col - 1) + 1; % First node in col
        
        i1 = i0:2:(i0 + nn_per_col - 3);
        j1 = i1 + nn_per_col;
        k1 = j1 + nn_per_col;
        
        elem0 = ne_per_col * (col - 1) + 1; % First element in col
        
        % Fill into elems
        erange = elem0:(elem0+ne_per_col-1);
        elems(1, erange) = i1;   % v1: i1
        elems(2, erange) = k1;   % v2: j1
        elems(3, erange) = k1+2; % v3: k3
        elems(4, erange) = i1+2; % v4: i3

        elems(5, erange) = j1;   % e1: j1
        elems(6, erange) = k1+1; % e2: k2
        elems(7, erange) = j1+2; % e3: j3
        elems(8, erange) = i1+1; % e4: i2

        elems(9, erange) = j1+1; % f1: j2
    end
end
