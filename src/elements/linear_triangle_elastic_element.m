function [Ke, fe] = linear_triangle_elastic_element(D, b, coords, nquadpoints)
% [Ke, fe] = linear_triangle_elastic_element(D, b, coords, nquadpoints)
% Calculate the element stiffness and load vector for linear elasticity
% on a linear triangle element, with constant stiffness, `D`, and 
% constant body force (per area), `b`. Use `nquadpoints` to perform the
% numerical quadrature.
% Inputs
% * D: [3,3] - elasticity tensor following Hooke's law
% * b: [2,1] - body load (per area)
% * coords: [2,3] - nodal coordinates of the element
% * nquadpoints: [1] - Number of quadrature points for numerical integration
% Outputs
% * Ke: [6,6] - the element stiffness matrix
% * fe: [6,1] - the element load vector (due to heat source)
end
