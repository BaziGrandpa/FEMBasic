
function [weights, points] = triangle_quadrature(nquadpoints)
% [weights, points] = triangle_quadrature(nquadpoints)
% Return the weights and quadrature points for numerically integrating
% the reference triangle using `nquadpoints` quadrature points. 
% Input: nquadpoints [1x1] Number of quadrature points (1 & 3 implemented)
% Output: weights [1, nquadpoints] - quadrature weights
%         points  [2, nquadpoints] - quadrature points

    switch nquadpoints
        case 1
            weights = 1/2;                 % area = 1/2
            points  = [1/3; 1/3];

        case 3
            weights = (1/6) * [1, 1, 1];  % area =1/2, 1/6 * 3
            points = [ ...
                1/6, 2/3, 1/6;   % xi1
                1/6, 1/6, 2/3 ]; % xi2

        otherwise
            error("Only nquadpoints = 1 or 3 are implemented.");
    end
end
