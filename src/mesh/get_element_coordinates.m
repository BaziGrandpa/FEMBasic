function [ex, ey, ez] = get_element_coordinates(element_nodes, node_coordinates, element_type)
% [ex, ey, ez] = get_element_coordinates(element_nodes, node_coordinates, element_type)
% Get the coordinates of each element that can be used to plot the element
% shape. Note that this does not correspond the the element nodal 
% coordinates used in the geometric interpolation (e.g. to calculate the
% jacobian tensor. 
% The output can be used to plot the grid and data for each node, examples:
% Plot only mesh: `fill(ex, ey, 'w')`
% Plot the mesh colored by y-coordinate: `fill(ex, ey, ey)`
% 
% Input
% * element_nodes: [num_node_per_elem, num_elems]
% * node_coordinates: [dim, num_nodes]
% * element_type: string - the element code, e.g. "LinearTriangle"
% 
% Output
% * ex: [num_elem_nodes, num_elems] - x coordinates
% * ey: [num_elem_nodes, num_elems] - y coordinates
% * ez: [num_elem_nodes, num_elems] - z coordinates
% 
    if nargout ~= size(node_coordinates, 1)
        error("Number of outputs must match the number of dimensions")
    end
    perm = element_coord_outline_permutation(element_type, size(element_nodes,1));
    element_plot_nodes = element_nodes(perm, :);
    ex = get_element_data(element_plot_nodes, node_coordinates(1, :));
    if nargout >= 2
        ey = get_element_data(element_plot_nodes, node_coordinates(2, :));
    end
    if nargout >= 3
        ez = get_element_data(element_plot_nodes, node_coordinates(3, :));
    end
end

function element_data = get_element_data(elems, nodal_data)
    element_data = reshape(nodal_data(reshape(elems, numel(elems), [])), size(elems));
end

function perm = element_coord_outline_permutation(element_type, num_enodes)
    switch element_type
        case "LinearTriangle"
            assert(num_enodes == 3)
            perm = 1:3;
        case "BilinearQuadrilateral"
            assert(num_enodes == 4)
            perm = 1:4;
        case "QuadraticTriangle"
            assert(num_enodes == 6)
            perm = reshape([1:3; 4:6], 1, []);
        case {"QuadraticQuadrilateral", "QuadraticSerendipityQuadrilateral"}
            assert(num_enodes == 8 || num_enodes == 9)
            perm = reshape([1:4; 5:8], 1, []);
        otherwise
            error("%s not supported", element_type)
    end
end
