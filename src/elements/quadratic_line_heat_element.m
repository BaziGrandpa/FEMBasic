function [Ke, fe] = quadratic_line_heat_element(D, b, coords, nquadpoints)
% [Ke, fe] = quadratic_line_heat_element(D, b, coords, nquadpoints)
% 
% Calculate the element stiffness and load vector for heat conduction 
% on a quadratic line element, with constant conductivity, `D`, and 
% constant heat (per length), `b`. Use `nquadpoints` to perform the
% numerical quadrature.
% Inputs
% * D: [1,1] - conductivity following Fourier's law
% * b: [1] - heat source per length
% * coords: [1,3] - nodal coordinates of the element
% * nquadpoints: [1] - Number of quadrature points for numerical
%   integration
% Outputs
% * Ke: [3,3] - the element stiffness matrix
% * fe: [3,1] - the element load vector (due to heat source)
end
