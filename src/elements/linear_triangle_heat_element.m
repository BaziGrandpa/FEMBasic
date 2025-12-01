function [Ke, fe] = linear_triangle_heat_element(D, b, coords, nquadpoints)
% [Ke, fe] = linear_triangle_heat_element(D, b, coords, nquadpoints)
% 
% Calculate the element stiffness and load vector for heat conduction 
% on a linear triangle element, with constant conductivity, `D`, and 
% constant heat (per area), `b`. Use `nquadpoints` to perform the
% numerical quadrature.
% Inputs
% * D: [2,2] - conductivity following Fourier's law
% * b: [1] - heat source per length
% * coords: [2,3] - nodal coordinates of the element
% * nquadpoints: [1] - Number of quadrature points for numerical
%   integration
% Outputs
% * Ke: [3,3] - the element stiffness matrix
% * fe: [3,1] - the element load vector (due to heat source)

    Ke = zeros(3,3);
    fe = zeros(3,1);

    % Get quadrature rule on reference triangle
    [weights, points] = triangle_quadrature(nquadpoints);

    % Loop over quadrature points
    for q = 1:nquadpoints
        xi  = points(:,q);   % xi = [xi1; xi2]  (2x1)
        w   = weights(q);

        N = linear_triangle_reference_shape_values(xi);         % [1x3]
        dN_dxi = linear_triangle_reference_shape_gradients(xi); % [2x3]

        % --- Jacobian from reference triangle → physical triangle
        % coords is [2x3], dN_dxi is [2x3]
        J = calculate_jacobian(dN_dxi, coords);   % Should return [2x2]

        % Determinant for area scaling
        detJ = det(J);

        % --- Map shape function gradients to physical space
        % ∇N = J^{-T} * (∂N/∂ξ)
        dN_dx = J'\dN_dxi;     % (2x2)' backslash (2x3) => (2x3)

        % --- Stiffness contribution
        % Ke_ij += (∇N_i)^T * D * (∇N_j) * detJ * w
        Ke = Ke + (dN_dx' * D * dN_dx) * detJ * w;

        % --- Load vector (source term)
        % fe_i += N_i * b * detJ * w
        fe = fe + (N' * b) * detJ * w;
    end
end
