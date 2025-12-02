function [Ke, fe] = bilinear_quadrilateral_heat_element(D, b, coords, nquadpoints)
% [Ke, fe] = bilinear_quadrilateral_heat_element(D, b, coords, nquadpoints)
% 
% Calculate the element stiffness and load vector for heat conduction 
% on a bilinear quadrilateral element, with constant conductivity, `D`, and 
% constant heat (per area), `b`. Use `nquadpoints` to perform the
% numerical quadrature.
% Inputs
% * D: [2,2] - conductivity following Fourier's law
% * b: [1] - heat source per length
% * coords: [2,4] - nodal coordinates of the element
% * nquadpoints: [1] - Number of quadrature points in each direction for 
%   numerical integration
% Outputs
% * Ke: [4,4] - the element stiffness matrix
% * fe: [4,1] - the element load vector (due to heat source)


    Ke = zeros(4,4);
    fe = zeros(4,1);

    [weights, points] = quadrilateral_quadrature(nquadpoints);
    % weights: [1xn^2]
    % points : [2xn^2], each column = [xi1; xi2]

    nqp = length(weights);  % = nquadpoints^2

    for q = 1:nqp
        xi = points(:, q);   % [xi1; xi2]
        w  = weights(q);

        % Shape function values and reference gradients
        N = bilinear_quadrilateral_reference_shape_values(xi);        % [1x4]
        dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi); % [2x4]

        % Jacobian matrix J = dx/dxi
        J = calculate_jacobian(dN_dxi, coords);  % [2x2]

        % Determinant
        detJ = det(J);

        % Map gradients to physical coordinates
        % dN_dx = J^{-T} dN_dxi
        dN_dx = J' \ dN_dxi;   % (2x2)'\(2x4) => (2x4)

        % Stiffness matrix
        Ke = Ke + (dN_dx' * D * dN_dx) * detJ * w;

        % Load vector
        fe = fe + (N' * b) * detJ * w;
    end
end
