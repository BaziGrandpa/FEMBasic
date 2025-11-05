function xi_triangle = triangle_facet_coords(xi_line, facetnr)
% xi_triangle = triangle_facet_coords(xi_line, facetnr)
% Given the coordinate local to the facet (line), `xi_line`, on facet 
% `facetnr` of a triangle, return the corresponding local coordinate as the
% triangle's local coordinate. 
% Inputs: xi_line (scalar) - coordinate along the line [-1, 1]
%         facetnr (scalar) - facet number (1-3)
% Output: xi_triangle [2x1]- Coordinate in the triangle's coordinate system

    s = (xi_line + 1)/2; % [0, 1]
    switch facetnr
        case 1
            xi_triangle = [1.0 - s; s];
        case 2
            xi_triangle = [0; s];
        case 3
            xi_triangle = [s; 0];
        otherwise
            error("facetnr = %u not in a triangle", facetnr)
    end
end
