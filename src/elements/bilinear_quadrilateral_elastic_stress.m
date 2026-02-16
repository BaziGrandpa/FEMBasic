function sig = bilinear_quadrilateral_elastic_stress(D, coords, ae, nquadpoints)
% sig = linear_triangle_elastic_stress(D, coords, ae, nquadpoints)
% Calculate the stress in each quadrature point for a linear triangle
% Inputs: D [3,3]       - elastic stiffness tensor (Voigt notation)
%         coords [2,4]  - element coordinates
%         ae [8,1]      - element displacement dofs
%         nquadpoints   - number of quadrature points
% Output: sig [3, nquadpoints^2] - stress in each quadrature point      
  
    [weights, points] = quadrilateral_quadrature(nquadpoints);
    sig = zeros(3,nquadpoints^2);
    for i = 1:length(weights)

        xi = points(:,i);%[2x1]

        dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);%[2x4]
        J = calculate_jacobian(dN_dxi,coords);
        dN_dx = J'\dN_dxi;
        Be = voigtize_shape_gradients(dN_dx);%[3x8]
        %reconstruct epsilon
        %reconstruct sigma D*e
        epsilon = Be*ae;%[3x1]
        sig(:,i) = D*epsilon;
    end
end
