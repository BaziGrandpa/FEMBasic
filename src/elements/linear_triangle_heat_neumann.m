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
end
