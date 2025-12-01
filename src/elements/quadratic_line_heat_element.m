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
 
    Ke = zeros(3,3);
    fe = zeros(3,1);

    coords=[1,3,5]

    [weights, points] = line_quadrature(nquadpoints);
    for q=1:nquadpoints
        xi = points(q);
        w = weights(q);
        
        N = quadratic_line_reference_shape_values(xi);%[1x3] [N1 N2 N3]
        dN_dxi = quadratic_line_reference_shape_gradients(xi); % [1x3] 
        % coords should be [1x3]
        J = calculate_jacobian(dN_dxi,coords);%[1] in 2d would be 2x2
        dN_dx = dN_dxi/J;%[1x3] dN1/dx dN2/dx dN3/dx in 2d should not do this, 
        %in matlab A/B means A*B
        
        Ke = Ke + D*(dN_dx'*dN_dx)*J*w;
        fe = fe + (N'*b)*J*w;

    end
end
