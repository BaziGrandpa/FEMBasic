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
    fe = zeros(4,1);

    % Facet base on sheet
    edge_nodes = [1 2;
                  2 3;
                  3 4;
                  4 1];
    % select two nodes, [1x2], and its node index
    en = edge_nodes(facetnr, :);   

    [weights, points] = line_quadrature(nquadpoints);
    for q = 1:nquadpoints
        s = points(q);     % s[-1,1] on an edge
        w = weights(q);

        % Determine (ξ1, ξ2) on the chosen facet
        % and the direction of derivative wrt s
        switch facetnr
            case 1     % bottom edge: ξ2 = -1, ξ1 = s
                xi  = [s; -1];
                % dN_dxi [2x4]
                dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);
                % coord [2x4]
                J = calculate_jacobian(dN_dxi, coords);
                % J [2x2]
                dxds = J(:,1);  % derivative wrt ξ1 [dx1/dxi1; dx2/dxi1] [2x1]

            case 2     % right edge: ξ1 = 1, ξ2 = s
                xi  = [1; s];
                dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);
                J = calculate_jacobian(dN_dxi, coords);
                dxds = J(:,2);  % derivative wrt ξ2

            case 3     % top edge: ξ2 = 1, ξ1 = s
                xi  = [s; 1];
                dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);
                J = calculate_jacobian(dN_dxi, coords);
                dxds = J(:,1);

            case 4     % left edge: ξ1 = -1, ξ2 = s
                xi  = [-1; s];
                dN_dxi = bilinear_quadrilateral_reference_shape_gradients(xi);
                J = calculate_jacobian(dN_dxi, coords);
                dxds = J(:,2);
        end

        % physical edge Jacobian = |dx/ds|
        Jedge = norm(dxds);

        % shape functions at this edge point
        N = bilinear_quadrilateral_reference_shape_values(xi);   % [1×4]
        % [N1(xi) N2(xi) N3(xi) N4(xi)]

        % update only the two nodes on this facet
        fe(en) = fe(en) - (N(en)' * (qn * Jedge * w));
    end
end
