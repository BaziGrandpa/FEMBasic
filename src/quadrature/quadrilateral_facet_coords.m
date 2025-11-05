function xi_quad = quadrilateral_facet_coords(xi_line, facetnr)
% xi_quad = quadrilateral_facet_coords(xi_line, facetnr)
% Given the coordinate local to the facet (line), `xi_line`, on facet 
% `facetnr` of a quadrilateral, return the corresponding local coordinate 
% as the quadrilateral's local coordinate. 
% Inputs: xi_line (scalar) - coordinate along the line [-1, 1]
%         facetnr (scalar) - facet number (1-4)
% Output: xi_quad [2x1] - Coordinate in the quadrilateral coordinate system

    switch facetnr
        case 1
            xi_quad = [xi_line; -1.0];
        case 2
            xi_quad = [1.0; xi_line];
        case 3
            xi_quad = [-xi_line; 1.0];
        case 4
            xi_quad = [-1.0; -xi_line];
        otherwise
            error("facetnr = %u not in a quadrilateral", facetnr)
    end
end
