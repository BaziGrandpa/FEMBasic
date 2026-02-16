function fe = linear_triangle_heat_neumann(qn, coords, facetnr, nquadpoints)
% function fe = linear_triangle_heat_neumann(qn, coords, facetnr, nquadpoints)
% Calculate the contribution to the element load vector due to a constant 
% outwards boundary flux, `qn`, on the facet, `facetnr`, of a linear 
% triangle element.
% Input: qn          - outwards heat flux
%        coords[2x3] - element coordinates
%        facetnr     - The facet number where the heat flux is applied
%        nquadpoints - Number of quadrature points to use for numerical
%                      integration
% Output: fe [3x1]   - Local element load vector contribution

 % Initialize
    fe = zeros(3, 1);
    % xiline -> xi N J nw normnw
    [weights,points] = line_quadrature(nquadpoints);
    for i=1:length(weights)
        xi_line = points(:,i);
        wi= weights(i);
        xi = triangle_facet_coords(xi_line,facetnr);

        N = linear_triangle_reference_shape_values(xi);
        dN_dxi = linear_triangle_reference_shape_gradients(xi);
        J = calculate_jacobian(dN_dxi,coords);
        nw = triangle_facet_weighted_normal(J,facetnr);
        fe = fe + N'*qn*norm(nw)*wi;
    end
end
