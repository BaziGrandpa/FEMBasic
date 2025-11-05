function dNdxi = quadratic_line_reference_shape_gradients(xi)
% dNdxi = quadratic_line_reference_shape_gradients(xi)
% Calculate the shape function gradients for a quadratic line element. 
% Input: xi [1x1] - local coordinate
% Output: dNdxi [1x3] - shape function gradients at xi
%         dNdxi(:, i) is the gradient of the ith shape function
    if ~all(size(xi) == 1)
        error("xi must be 1x1")
    end
end
