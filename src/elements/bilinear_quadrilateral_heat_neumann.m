function fe = bilinear_quadrilateral_heat_neumann(qn, coords, facetnr, nquadpoints)
% function fe = bilinear_quadrilateral_heat_neumann(qn, coords, facetnr, nquadpoints)
% Calculate the contribution to the element load vector due to a constant 
% outwards boundary flux, `qn`, on the facet, `facetnr`, of a bilinear 
% quadrilateral element.
% Input: qn          - outwards heat flux
%        coords[2x4] - element coordinates
%        facetnr     - The facet number where the heat flux is applied
%        nquadpoints - Number of quadrature points to use for numerical
%                      integration
% Output: fe [4x1]   - Local element load vector contribution
    [weights, points] = line_quadrature(nquadpoints);

    fe = zeros(4,1);  % 1 DOF × 4 nodes

    for q = 1:length(weights)
        xi_line = points(:,q);   % scalar for 1D line quadrature
        w = weights(q);

        % Map 1D line point to 2D reference quad facet coordinate
        xi = quadrilateral_facet_coords(xi_line, facetnr);

        % Shape functions and gradients on reference quad
        N = bilinear_quadrilateral_reference_shape_values(xi);
        dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);

        % Jacobian (2x2)
        J = calculate_jacobian(dN_dxi, coords);

        % Edge weighted normal (magnitude equals edge Jacobian scaling)
        nw = quadrilateral_facet_weighted_normal(J, facetnr);

        % Boundary integral contribution:
        % fe_i += ∫_facet N_i * qn ds
        %      ≈ Σ N_i(xi_q) * qn * |nw| * w_q
        fe = fe + N' * qn * norm(nw) * w;
    end
end
