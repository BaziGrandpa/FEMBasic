function q = linear_triangle_heat_flux(D, coords, ae, nquadpoints)
% q = linear_triangle_heat_flux(D, coords, ae, nquadpoints)
% Calculate the flux in each quadrature point for a linear triangle
% Inputs: D [2,2]       - conductivity tensor
%         coords [2,3]  - element coordinates
%         ae [3,1]      - element temperature dofs
%         nquadpoints   - number of quadrature points
% Output: q [2, nquadpoints] - flux in each quadrature point        
 % Preallocate storage
    q = zeros(2, nquadpoints);

    % Quadrature rule for triangle
    [weights, points] = triangle_quadrature(nquadpoints);

    for k = 1:nquadpoints
        xi = points(:,k);  % [xi1; xi2]  2×1

        % shape gradients on reference triangle
        dN_dxi = linear_triangle_reference_shape_gradients(xi);   % [2×3]

        % Jacobian
        J = calculate_jacobian(dN_dxi, coords);   % [2×2]

        dN_dx = J' \ dN_dxi;    % gives 2×3

        gradT = dN_dx * ae;     % [2×1]

        % Heat flux q = -D grad(T)
        q(:,k) = -D * gradT;
    end
end
