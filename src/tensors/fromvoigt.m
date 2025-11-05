function t = fromvoigt(v, offdiagscale)
% t = fromvoigt(v, offdiagscale = 1)
% Convert from a Voigt vector or matrix `v` to a tensor `t`
% Inputs: v [n,1] or [n,n] - Voigt-representation of a tensor
%         offdiagscale (scalar) - Factor to multiply shear terms with, used
%         to differentiate between stress (offdiagscale = 1, default if not 
%         given) and strain (offdiagscale = 2) conversions. 
% Output: t [d,d] or [d,d,d,d] 2nd or 4th order tensor based on the Voigt
%         vector or matrix `v`

    arguments
        v {mustBeA(v, {'double', 'sym'})}   % Check correct type (symbolic entries allowed)
        offdiagscale (1, 1) double = 1      % Default to no scale
    end
    [dim, order] = dim_and_order(v);
    s = 1 / offdiagscale;
    if order == 0 % dim = 1, order doesn't matter
        t = [v(1,1)];
    elseif order == 2
        if dim == 2
            t = [v(1), v(3) * s; 
                 v(3) * s, v(2)];
        else % dim == 3
            t = [v(1), v(6) * s, v(5) * s;
                 v(6) * s, v(2), v(4) * s;
                 v(5) * s, v(4) * s, v(3)];
        end
    elseif order == 4
        if dim == 2
            t = zeros(2, 2, 2, 2);
            t(:, :, 1, 1) = fromvoigt(v(:, 1), offdiagscale);
            t(:, :, 2, 2) = fromvoigt(v(:, 2), offdiagscale);
            t_12 = fromvoigt(v(:,3), offdiagscale) * s;
            t(:, :, 1, 2) = t_12;
            t(:, :, 2, 1) = t_12;
        else % dim == 3
            t = zeros(3, 3, 3, 3);
            t(:, :, 1, 1) = fromvoigt(v(:, 1), offdiagscale);
            t(:, :, 2, 2) = fromvoigt(v(:, 2), offdiagscale);
            t(:, :, 3, 3) = fromvoigt(v(:, 3), offdiagscale);
            t_23 = fromvoigt(v(:,4), offdiagscale) * s;
            t(:, :, 2, 3) = t_23;
            t(:, :, 3, 2) = t_23;
            t_13 = fromvoigt(v(:,5), offdiagscale) * s;
            t(:, :, 1, 3) = t_13;
            t(:, :, 3, 1) = t_13;
            t_12 = fromvoigt(v(:,6), offdiagscale) * s;
            t(:, :, 1, 2) = t_12;
            t(:, :, 2, 1) = t_12;
        end
    end
end

function [dim, order] = dim_and_order(m)
    assert(ismatrix(m));
    n = size(m, 1);
    if n == size(m, 2) && n == 1
        order = 0; % dim = 1 => signal this and that order doesn't matter
    elseif size(m, 2) == 1
        order = 2;
    elseif n == size(m, 2)
        order = 4;
    else
        error("Only vectors or square matrices allowed with nrows >= ncols")
    end
    if n == 1
        dim = 1;
    elseif n == 3
        dim = 2;
    elseif n == 6
        dim = 3;
    else
        error("Only symmetric cases allowed, 1, 3, or 6 rows in the voigt vector/matrix")
    end
end
