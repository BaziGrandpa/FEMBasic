function dNdxi = bilinear_quadrilateral_reference_shape_gradients(xi)
% dNdxi = bilinear_quadrilateral_reference_shape_gradients(xi)
% Calculate the shape function gradients for a bilinear quadrilateral elem.
% Input: xi [2x1] - local coordinates
% Output: dNdxi [2x4] - shape function gradients at xi
%         dNdxi(:, i) is the gradient of the ith shape function
    if size(xi,1) ~= 2 || size(xi,2) ~= 1
        error("xi must be 2x1")
    end
    xi1 = xi(1);
    xi2 = xi(2);

    % N1 = 1/4 (1 - xi1)(1 - xi2)
    dN1_dxi1 = -(1 - xi2) / 4;
    dN1_dxi2 = -(1 - xi1) / 4;

    % N2 = 1/4 (1 + xi1)(1 - xi2)
    dN2_dxi1 =  (1 - xi2) / 4;
    dN2_dxi2 = -(1 + xi1) / 4;

    % N3 = 1/4 (1 + xi1)(1 + xi2)
    dN3_dxi1 =  (1 + xi2) / 4;
    dN3_dxi2 =  (1 + xi1) / 4;

    % N4 = 1/4 (1 - xi1)(1 + xi2)
    dN4_dxi1 = -(1 + xi2) / 4;
    dN4_dxi2 =  (1 - xi1) / 4;
    
    % output matrix [2x4]
    dNdxi = [
        dN1_dxi1,  dN2_dxi1,  dN3_dxi1,  dN4_dxi1;
        dN1_dxi2,  dN2_dxi2,  dN3_dxi2,  dN4_dxi2
    ];
end
