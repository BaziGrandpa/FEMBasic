function sig = linear_triangle_elastic_stress(D, coords, ae, nquadpoints)
% sig = linear_triangle_elastic_stress(D, coords, ae, nquadpoints)
% Calculate the stress in each quadrature point for a linear triangle
% Inputs: D [3,3]       - elastic stiffness tensor
%         coords [2,3]  - element coordinates
%         ae [6,1]      - element displacement dofs
%         nquadpoints   - number of quadrature points
% Output: sig [3, nquadpoints] - stress in each quadrature point      

    [weights, points] = triangle_quadrature(nquadpoints);
    sig = zeros(3,nquadpoints);

    for i=1:length(weights)
        xi = points(:,i);%[2x1]
        dN_dxi = linear_triangle_reference_shape_gradients(xi);%[2x3]
        J = calculate_jacobian(dN_dxi,coords);
        dN_dx =J'\dN_dxi;
        Be = voigtize_shape_gradients(dN_dx);%[3x6]
        epsilon =  Be*ae;
        sig(:,i) = D*epsilon;
    end
end
