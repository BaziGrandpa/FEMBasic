function s = symmetrize(t)
% s = symmetrize(t)
% Return the symmetric part of the 2nd or 4th order tensor `t`. 
% For 4th order tensors this refers to the minor symmetric part. 
% Input:  t [d,d] or [d,d,d,d] - tensor to be symmetrized
% Output: s [d,d] or [d,d,d,d] - symmetrized tensor

    dim = size(t, 1);
    order = ndims(t);
    if dim > 3
        error("symmetrize is not defined for dim>3")
    elseif ~all(dim == size(t))
        error("symmetrize is only defined for tensor with equal dimensions for each base")
    end
    if dim == 1 % Nothing to symmetrize
        s = t;
    elseif order == 2
        s = (t + t') / 2;
    elseif order == 4
        s = (t + permute(t, [1,2,4,3]) + permute(t, [2,1,4,3]) + permute(t, [2,1,3,4])) / 4;
    else
        error("symmetrize only defined for 2nd and 4th order tensors")
    end
end
