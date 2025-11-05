function [Ke, fe] = linear_line_heat_element(D, b, coords, nquadpoints)
% [Ke, fe] = linear_line_heat_element(D, b, coords, nquadpoints)
% 
% Calculate the element stiffness and load vector for heat conduction 
% on a linear line element, with constant conductivity, `D`, and 
% constant heat (per length), `b`. Use `nquadpoints` to perform the
% numerical quadrature.
% Inputs
% * D: [1,1] - conductivity following Fourier's law
% * b: [1] - heat source per length
% * coords: [1,2] - nodal coordinates of the element
% * nquadpoints: [1] - Number of quadrature points for numerical
%   integration
% Outputs
% * Ke: [2,2] - the element stiffness matrix
% * fe: [2,1] - the element load vector (due to heat source)
end
