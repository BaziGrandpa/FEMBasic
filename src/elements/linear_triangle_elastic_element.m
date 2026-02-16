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

    Ke = zeros(6,6);
    fe = zeros(6,1);

    [weights, points] =triangle_quadrature(nquadpoints);

    for i=1:length(weights)
        xi = points(:,i);%[2x1]
        wi = weights(i);
        %construct B from dn/dx
        dN_dxi = linear_triangle_reference_shape_gradients(xi);%[2x3]
        J = calculate_jacobian(dN_dxi,coords);% [2x2] 
        dN_dx = J'\ dN_dxi;
        Be = voigtize_shape_gradients(dN_dx);% [3x 6]

        Ke = Ke + Be'*D*Be*wi*det(J);

        %construct M from N
        N_xi = linear_triangle_reference_shape_values(xi);%[1x3]
        Me = vectorize_shape_values(N_xi,2);
        fe = fe + Me'*b*wi*det(J);
    end

end
