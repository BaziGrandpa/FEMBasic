function m = tovoigt(ts, offdiagscale)
% m = tovoigt(ts, offdiagscale = 1)
% Convert the 2nd or 4th order tensor `ts` to a Voigt vector or matrix. 
% Note that the tensor is automatically symmetrized. 
% Inputs: t [d,d] or [d,d,d,d] 2nd or 4th order tensor
%         offdiagscale (scalar) - Factor to multiply shear terms with, used
%         to differentiate between stress (offdiagscale = 1, default if not 
%         given) and strain (offdiagscale = 2) conversions. 
% Output: v [n,1] or [n,n] - Voigt-representation of the tensor `ts`
    arguments
        ts {mustBeA(ts, {'double', 'sym'})}   % Check correct type (symbolic entries allowed)
        offdiagscale (1, 1) double = 1      % Default to no scale
    end
    dim = size(ts, 1);
    order = ndims(ts);
    if dim == 0
        error("length must be greater than 0")
    elseif dim > 3
        error("tovoigt is not defined for dim>3")
    elseif ~all(dim == size(ts))
        error("tovoigt is only defined for tensor with equal dimensions for each base")
    elseif order ~= 2 && order ~= 4
        error("Only 2nd and 4th order tensors support voigt conversion")
    end
    
    s = offdiagscale;
    s2 = offdiagscale^2;
    ts = symmetrize(ts);
    if dim == 1
        m = ts(1);
    elseif order == 2
        if dim == 2
            m = [ts(1,1); ts(2,2); ts(1,2) * s];
        else % dim = 3
            m = [ts(1,1); ts(2,2); ts(3,3); ts(2,3) * s; ts(1,3) * s; ts(1,2) * s];
        end
    elseif order == 4
        if dim == 2
            m = [ts(1,1,1,1),     ts(1,1,2,2),     ts(1,1,1,2) * s;
                 ts(2,2,1,1),     ts(2,2,2,2),     ts(2,2,1,2) * s;
                 ts(1,2,1,1) * s, ts(1,2,2,2) * s, ts(1,2,1,2) * s2];
        else % dim = 3
            m = [ts(1,1,1,1),     ts(1,1,2,2),     ts(1,1,3,3),     ts(1,1,2,3) * s,  ts(1,1,1,3) * s,  ts(1,1,1,2) * s;
                 ts(2,2,1,1),     ts(2,2,2,2),     ts(2,2,3,3),     ts(2,2,2,3) * s,  ts(2,2,1,3) * s,  ts(2,2,1,2) * s;
                 ts(3,3,1,1),     ts(3,3,2,2),     ts(3,3,3,3),     ts(3,3,2,3) * s,  ts(3,3,1,3) * s,  ts(3,3,1,2) * s;
                 ts(2,3,1,1) * s, ts(2,3,2,2) * s, ts(2,3,3,3) * s, ts(2,3,2,3) * s2, ts(2,3,1,3) * s2, ts(2,3,1,2) * s2;
                 ts(1,3,1,1) * s, ts(1,3,2,2) * s, ts(1,3,3,3) * s, ts(1,3,2,3) * s2, ts(1,3,1,3) * s2, ts(1,3,1,2) * s2;
                 ts(1,2,1,1) * s, ts(1,2,2,2) * s, ts(1,2,3,3) * s, ts(1,2,2,3) * s2, ts(1,2,1,3) * s2, ts(1,2,1,2) * s2];
        end
    else
        error("Only 2nd and 4th order tensors support voigt conversion")
    end
end
