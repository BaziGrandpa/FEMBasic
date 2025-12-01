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
        case 2
            weights = [1,1];
            points = [-0.5773502691896257,0.5773502691896257];
        case 3
            weights = [0.5555555555555556,0.8888888888888889,0.5555555555555556];
            points = [-0.7745966692414834,0,0.7745966692414834];
        case 4
            weights = [0.3478548451374544,0.6521451548625460,0.6521451548625460,0.3478548451374544];
            points = [-0.8611363115940525,-0.3399810435848563,0.3399810435848563,0.8611363115940525];
        % case 2
        %   weights = ... (fill in from formula sheet)
        otherwise
            error("Only 1 <= nquadpoints <= 4 implemented")
    end
end
