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

    Ke = zeros(2,2);
    fe = zeros(2,1);
    [weights, points] = line_quadrature(nquadpoints);
    for q = 1:nquadpoints
        w = weights(q);
        xi = points(q);

        N = linear_line_reference_shape_values(xi); % [1x2] [N1(xi),N2(xi)]
        dN_dxi = linear_line_reference_shape_gradients(xi);% [1x2] [dN1/dxi , dN2/dxi]
        J = calculate_jacobian(dN_dxi,coords);% [1] in 1d

        % now estimate the integral D dNi/dx dNj/dx 
        dN_dx = dN_dxi/J; %[1x2]
        % dN_dx'*dN_dx would be a [2x2]
        % [ dN1dx*dN1dx, dN1dx*dN2dx;
        %   dN2dx*dN1dx, dN2dx*dN2dx]
        Ke = Ke + (D * (dN_dx'*dN_dx))*J*w;

        % [ N1(xi)*b*w ;
        %   N2(xi)*b*w]
        fe = fe + (N'*b)*J*w;
    end
end
