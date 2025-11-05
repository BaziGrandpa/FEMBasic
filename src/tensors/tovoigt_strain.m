function v = tovoigt_strain(t)
% v = tovoigt_strain(t)
% Convert the tensor representation, `t`, of the strain to the Voigt
% representation `v`
% Input:  t [m, m] - Tensor representation
% Output: v [n, 1] - Voigt vector representation

    if size(t, 1) ~= size(t, 2)
        error("tovoigt_strain expects a square matrix")
    end
    v = tovoigt(t, 2);
end
