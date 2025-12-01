function fe = linear_triangle_heat_neumann(qn, coords, facetnr, nquadpoints)
% function fe = linear_triangle_heat_neumann(qn, coords, facetnr, nquadpoints)
% Calculate the contribution to the element load vector due to a constant 
% outwards boundary flux, `qn`, on the facet, `facetnr`, of a linear 
% triangle element.
% Input: qn          - outwards heat flux
%        coords[2x3] - element coordinates
%        facetnr     - The facet number where the heat flux is applied
%        nquadpoints - Number of quadrature points to use for numerical
%                      integration
% Output: fe [3x1]   - Local element load vector contribution

 % Initialize
    fe = zeros(3, 1);

    % Facet → (local) node pairs for T3 triangle
    % facet 1: nodes 1 → 2
    % facet 2: nodes 2 → 3
    % facet 3: nodes 3 → 1
    edge_nodes = [1 2;
                  2 3;
                  3 1];

    % Get nodes of the chosen edge
    en = edge_nodes(facetnr, :);   % e.g. [1 2] [1x2]

    % Physical coordinates of the two edge nodes
    xa = coords(:, en(1));   % [2x1]
    xb = coords(:, en(2));   % [2x1]

    % Edge length & Jacobian for mapping from [-1,1] → edge
    edge_length = norm(xb - xa);
    Jedge = edge_length / 2;

    % Quadrature on [-1, 1]
    [weights, points] = line_quadrature(nquadpoints);

    % Loop over quadrature points
    for q = 1:nquadpoints
        xi = points(q);     % reference coordinate
        w  = weights(q);

        % Shape functions on the *edge* (2-node line element)
        % on linear_triangle arbitrary two edge is linear_line so its okay
        % to use it like this. but for quadratic we can do like this
        Nedge = linear_line_reference_shape_values(xi);  % [1x2]

        % Add Neumann contribution to the correct DOFs
        % Only the two nodes on this edge receive flux load
        fe(en) = fe(en) - Nedge' * qn * Jedge * w;
    end
end
