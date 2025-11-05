function dNdxi = bilinear_quadrilateral_reference_shape_gradients(xi)
% dNdxi = bilinear_quadrilateral_reference_shape_gradients(xi)
% Calculate the shape function gradients for a bilinear quadrilateral elem.
% Input: xi [2x1] - local coordinates
% Output: dNdxi [2x4] - shape function gradients at xi
%         dNdxi(:, i) is the gradient of the ith shape function
    if size(xi,1) ~= 2 || size(xi,2) ~= 1
        error("xi must be 2x1")
    end
end
