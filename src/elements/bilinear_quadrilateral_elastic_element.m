function [Ke, fe] = bilinear_quadrilateral_elastic_element(D, b, coords, nquadpoints)
% [Ke, fe] = bilinear_quadrilateral_elastic_element(D, b, coords, nquadpoints)
% Calculate the element stiffness and load vector for linear elasticity
% on a bilinear quadrilateral element, with constant stiffness, `D`, and 
% constant body force (per area), `b`. Use `nquadpoints` in each direction
% to perform the numerical quadrature.
% Inputs
% * D: [3,3] - elasticity tensor following Hooke's law
% * b: [2,1] - body load (per area)
% * coords: [2,4] - nodal coordinates of the element
% * nquadpoints: [1] - Number of quadrature points in each direction for 
%   numerical integration
% Outputs
% * Ke: [8,8] - the element stiffness matrix
% * fe: [8,1] - the element load vector (due to heat source)
Ke  =zeros(8,8);
fe = zeros(8,1);
end
