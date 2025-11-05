function M = vectorize_shape_values(N, dim)
% M = vectorize_shape_values(N, dim)
% Convert the shape values of scalar base functions to vector-valued shape
% function values. 
% Inputs
% * N: [1, num] - The scalar shape functions. 
% Outputs 
% * M: [dim, dim * num] - The vector-valued shape functions. 
%      M(:,i) gives the (vector) value of the ith vectorized shape function

    if size(N, 1) ~= 1
        error("N must be of size [1, dim]")
    end
end
