function [weights, points] = line_quadrature(nquadpoints)
% [weights, points] = line_quadrature(nquadpoints)
% Return the weights and quadrature points for numerically integrating
% the reference line with `nquadpoints` points.
% Input: nquadpoints [1x1] Number of quadrature points
% Output: weights [1, nquadpoints] - quadrature weights
%         points  [1, nquadpoints] - quadrature points
%

    switch nquadpoints
        case 1
            weights = [2];
            points  = [0];
        % case 2
        %   weights = ... (fill in from formula sheet)
        otherwise
            error("Only 1 <= nquadpoints <= 4 implemented")
    end
end
