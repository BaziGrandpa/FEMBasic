function N = bilinear_quadrilateral_reference_shape_values(xi)
% N = linear_quadrilateral_reference_shape_values(xi)
% Calculate the shape function values for a bilinear quadrilateral element. 
% Input: xi [2x1] - local coordinates
% Output: N [1x4] - shape function values at xi
%try git
    if size(xi,1) ~= 2 || size(xi,2) ~= 1
        error("xi must be 2x1")
    end
end
