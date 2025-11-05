function N = linear_line_reference_shape_values(xi)
% N = linear_triangle_reference_shape_values(xi)
% Calculate the shape function values for a linear line element. 
% Input: xi [1x1] - local coordinate
% Output: N [1x2] - shape function values at xi
    if ~all(size(xi) == 1)
        error("xi must be 1x1")
    end
    N = [1 - xi(1), 1 + xi(1)] / 2;
end
