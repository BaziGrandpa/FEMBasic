function svm = vonmises(sigma)
% Calculate the von Mises stress given the stress sigma in Voigt notation,
% Input: sigma [n, 1] - stress with n dependent on the dimension
%                       n = 1 (1d), n = 3 (2d), n = 6 (3d)
% Output: svm [1,1] - von Mises stress (scalar)

    if size(sigma, 2) ~= 1
        error("Column vector expected")
    end
    if size(sigma, 1) == 1 % 1d
        svm = sqrt(sigma(1,1)^2);
    elseif size(sigma, 1) == 3 % 2d plane stress
        % Implement for this case
    elseif size(sigma, 1) == 6 % 3d
        s11_s22 = (sigma(1) - sigma(2))^2;
        s22_s33 = (sigma(2) - sigma(3))^2;
        s33_s11 = (sigma(3) - sigma(1))^2;
        s23 = sigma(4)^2;
        s13 = sigma(5)^2;
        s12 = sigma(6)^2;
        svm = sqrt(0.5 * (s11_s22 + s22_s33 + s33_s11) + 3 * (s12 + s13 + s23));
    else
        error("sigma must be column vector with length 1, 3, or 6")
    end
end
