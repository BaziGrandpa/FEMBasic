function fe = bilinear_quadrilateral_elastic_neumann(t, tn, coords, facetnr, nquadpoints)
% function fe = bilinear_quadrilateral_elastic_neumann(t, coords, facetnr, nquadpoints)
% Calculate the contribution to the element load vector due to the constant 
% traction, `t_total = t + tn * nhat`, on the facet, `facetnr`, of a 
% bilinear quadrilateral element. `nhat` is the normalized outwards normal
% vector from the facet. 
% Input: t [2x1      - boundary traction vector
%        tn [scalar] - outwards normal traction vector
%        coords[2x4] - element coordinates
%        facetnr     - The facet number where the heat flux is applied
%        nquadpoints - Number of quadrature points to use for numerical
%                      integration
% Output: fe [8x1]   - Local element load vector contribution
    if ~(size(t,1) == 2 & size(t, 2) == 1)
        error("Traction vector must be 2x1")
    elseif ~isscalar(tn)
        error("Normal traction must be scalar")
    elseif ~(size(coords,1) == 2 & size(coords, 2) == 4)
        error("Coords must be 2x4")
    elseif ~isscalar(facetnr)
        error("facetnr must be a scalar integer")
    elseif ~isscalar(nquadpoints)
        error("nquadpoints must be a scalar integer")
    end
     % Quadrature rule on reference line
    [weights, points] = line_quadrature(nquadpoints);

    fe = zeros(8,1);  % 2 DOFs × 4 nodes

    for q = 1:length(weights)
        xi_line = points(:,q);
        w = weights(q);

        % Map to reference quadrilateral facet
        xi = quadrilateral_facet_coords(xi_line, facetnr);

        % Shape functions
        N = bilinear_quadrilateral_reference_shape_values(xi);
        dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);

        % Jacobian
        J = calculate_jacobian(dN_dxi, coords);

        % Vector-valued shape function matrix
        M = vectorize_shape_values(N, 2);

        % Weighted outward normal
        nw = quadrilateral_facet_weighted_normal(J, facetnr);
        nhat = nw / norm(nw);

        % Total traction (constant)
        t_total = t + tn * nhat;

        % Assemble contribution
        fe = fe + M' * t_total * norm(nw) * w;
    end
end
