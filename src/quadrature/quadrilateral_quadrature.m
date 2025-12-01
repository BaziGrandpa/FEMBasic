function [weights, points] = quadrilateral_quadrature(nquadpoints)
% [weights, points] = quadrilateral_quadrature(nquadpoints)
% Return the weights and quadrature points for numerically integrating
% the reference quadrilateral with `nquadpoints^2` points.
% Input: nquadpoints [1x1] Number of quadrature points
% Output: weights [1, nquadpoints^2] - quadrature weights
%         points  [2, nquadpoints^2] - quadrature points

    %weights [1xnquadpoints]
    %points [2xnquadpoints]
    [w1D, x1D] = line_quadrature(nquadpoints);  % weight: [1×n], points: [1×n]

    % Total number of 2D points
    N = nquadpoints^2;

    weights = zeros(1, N);
    points  = zeros(2, N);

    k = 1;
    for i = 1:nquadpoints      % xi1
        for j = 1:nquadpoints  % xi2
            points(:, k)  = [x1D(i);...
                             x1D(j)];
            weights(k)    = w1D(i) * w1D(j);
            k = k + 1;
        end
    end
end

