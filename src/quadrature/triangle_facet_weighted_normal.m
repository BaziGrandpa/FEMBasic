function n = triangle_facet_weighted_normal(J, facet_nr)
% n = triangle_facet_weighted_normal(J, facet_nr)
% Calculate the weighted normal, n = norm(dA)/norm(dA_ref) nhat,
% where nhat is the outwards normal vector from facet `facet_nr`, and 
% norm(nhat)=1. `dA_ref` is the area of the facet geometry that the
% quadrature rule is based on. 
% Input
% * J [2,2]: Jacobian for element transformation, dx/dxi
% * facet_nr: Which facet we want to calculate the normal for
% Output
% * n [2,1]: The weighted outwards normal vector

    switch facet_nr
        case 1
            dxi = [-1; 1]/2;
        case 2
            dxi = [0; -1/2];
        case 3
            dxi = [1/2; 0];
        otherwise
            error("facetnr = %u not in a triangle", facetnr)
    end
    dx = J * dxi;        % Counter clockwise tangent vector
    n = [dx(2); -dx(1)]; % Rotate clockwise to make outward normal
end
