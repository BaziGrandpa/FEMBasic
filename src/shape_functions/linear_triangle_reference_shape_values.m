function N = linear_triangle_reference_shape_values(xi)
% N = linear_triangle_reference_shape_values(xi)
% Calculate the shape function values for a linear triangle element. 
% Input: xi [2x1] - local coordinates
% Output: N [1x3] - shape function values at xi
    if size(xi,1) ~= 2 || size(xi,2) ~= 1
        error("xi must be a 2x1 vector [xi1; xi2]");
    end

    xi1 = xi(1);
    xi2 = xi(2);

    N1 = xi1;   
    N2 = xi2;             
    N3 = 1-xi1-xi2;             

    % Output row vector
    N = [N1, N2, N3];
end
