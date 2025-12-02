function q = bilinear_quadrilateral_heat_flux(D, coords, ae, nquadpoints)
% q = bilinear_quadrilateral_heat_flux(D, coords, ae, nquadpoints)
% Calculate the flux in each quadrature point for a bilinear quadrilateral
% Inputs: D [2,2]       - conductivity tensor
%         coords [2,4]  - element coordinates
%         ae [4,1]      - element temperature dofs
%         nquadpoints   - number of quadrature points
% Output: sig [2, nquadpoints^2] - flux in each quadrature point 

    % Use your quadrature routine
    [weights, points] = quadrilateral_quadrature(nquadpoints);
    
    nqp = nquadpoints^2;   % = nquadpoints^2 

    q = zeros(2, nqp);       % store q(:,k) per quadrature point

    % Loop over quadrature points
    for k = 1:nqp
        xi = points(:,k);    % [xi1; xi2]

        % Shape gradients wrt reference coordinates
        dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi); % [2x4]

        % Jacobian J = dx/dxi
        J = calculate_jacobian(dN_dxi, coords);  % [2x2]

        % Transform gradients to physical coordinates
        % grad(N) = J^{-T} * grad_hat(N)
        dN_dx = J' \ dN_dxi;   % (2x2)'\(2x4) => (2x4)

        % Temperature gradient:
        % grad(T) = sum_i dN_i/dx * T_i
        gradT = dN_dx * ae;   % [2x1]

        % Heat flux
        q(:,k) = -D * gradT;  % [2x1]
    end
end
