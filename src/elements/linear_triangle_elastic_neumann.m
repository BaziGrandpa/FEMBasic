function fe = linear_triangle_elastic_neumann(t, tn, coords, facetnr, nquadpoints)
% function fe = linear_triangle_elastic_neumann(t, tn, coords, facetnr, nquadpoints)
% Calculate the contribution to the element load vector due to the constant 
% traction, `t_total = t + tn * nhat`, on the facet, `facetnr`, of a linear 
% triangle element. `nhat` is the normalized outwards normal vector from 
% the facet. 
% Input: t [2x1]     - boundary traction vector
%        tn [scalar] - outwards normal traction vector
%        coords[2x3] - element coordinates
%        facetnr     - The facet number where the heat flux is applied
%        nquadpoints - Number of quadrature points to use for numerical
%                      integration
% Output: fe [6x1]   - Local element load vector contribution
    if ~(size(t,1) == 2 & size(t, 2) == 1)
        error("Traction vector must be 2x1")
    elseif ~isscalar(tn)
        error("Normal traction must be scalar")
    elseif ~(size(coords,1) == 2 & size(coords, 2) == 3)
        error("Coords must be 2x3")
    elseif ~isscalar(facetnr)
        error("facetnr must be a scalar integer")
    elseif ~isscalar(nquadpoints)
        error("nquadpoints must be a scalar integer")
    end

    [weights, points] = line_quadrature(nquadpoints);
    fe = zeros(6,1);
    for i=1:length(weights)
        xi_line = points(i);
        xi_tri = triangle_facet_coords(xi_line, facetnr);%[2x1]
        wi = weights(i);
        N_xi = linear_triangle_reference_shape_values(xi_tri);%[1x3]
        Me = vectorize_shape_values(N_xi,2);%[2x6]

        %traction
        dN_dxi = linear_triangle_reference_shape_gradients(xi_tri);
        J = calculate_jacobian(dN_dxi,coords);
        nw = triangle_facet_weighted_normal(J,facetnr);
        nhat = nw/norm(nw);
        t_total = t+ tn*nhat;%[2x1]

        fe = fe + Me'*t_total*norm(nw)*wi;
    end
    
        
    
end
