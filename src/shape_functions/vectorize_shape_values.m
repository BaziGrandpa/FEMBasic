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

    shape_func_number = size(N,2);

    M = zeros(dim,dim*shape_func_number);

    for i = 1:shape_func_number
        x_j = 2*i -1;
        y_j = 2*i;
        M(1,x_j) = N(i);
        M(2,x_j) = 0;
        
        M(1,y_j) = 0;
        M(2,y_j) = N(i);

    end
end
