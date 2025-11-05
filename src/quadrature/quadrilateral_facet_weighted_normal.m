function n = quadrilateral_facet_weighted_normal(J, facet_nr)
% n = quadrilateral_facet_weighted_normal(J, facet_nr)
% Calculate the weighted normal, n = norm(dA)/norm(dA_ref) nhat,
% where nhat is the outwards normal vector from facet `facet_nr`, and 
% norm(nhat)=1
% Input
% * J [2,2]: Jacobian for element transformation, dx/dxi
% * facet_nr: Which facet we want to calculate the normal for
% Output
% * n [2,1]: The weighted outwards normal vector

    switch facet_nr
        case 1
            dxi = [1; 0];
        case 2
            dxi = [0; 1];
        case 3
            dxi = [-1; 0];
        case 4
            dxi = [0; -1];
        otherwise
            error("facetnr = %u not in a quadrilateral", facetnr)
    end
    dx = J * dxi;       % Counter clockwise tangent vector
    n = [dx(2); -dx(1)]; % Rotate clockwise to make outward normal
end
