function N = quadratic_line_reference_shape_values(xi)
% N = linear_triangle_reference_shape_values(xi)
% Calculate the shape function values for a quadratic line element. 
% Input: xi [1x1] - local coordinate
% Output: N [1x3] - shape function values at xi
    if ~all(size(xi) == 1)
        error("xi must be 1x1")
    end

    N = [xi*(xi-1)/2,xi*(xi+1)/2,1-xi*xi];
end
