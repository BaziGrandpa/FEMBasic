function t = fromvoigt_strain(v)
% t = fromvoigt_strain(v)
% Convert the Voigt representation, `v`, of the strain to a tensor
% representation `t`
% Input:  v [n, 1] - Voigt vector representation
% Output: t [m, m] - Tensor representation

    if size(v, 2) ~= 1
        error("fromvoigt_strain expects a column vector")
    end
    t = fromvoigt(v, 2);
end
