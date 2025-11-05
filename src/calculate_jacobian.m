function J = calculate_jacobian(dN_dxi, element_coordinates)
% J = CALCULATE_JACOBIAN(dN_dxi, element_coordinates)
% Calculate the jacobian of the mapping from reference to the physical
% element with `num` nodes. 
% Inputs
% * dN_dxi: [dim,num] - shape gradients in the reference domain at current
%           local coordinate
% * element_coordinates: [dim,num] - Coordinates of the element nodes
% Outputs
% * J: [dim,dim] - the jacobian, dx/dxi

    if size(dN_dxi, 1) ~= size(element_coordinates, 1)
        error("dimensions of element coordinates and shape gradients must be equal")
    elseif size(dN_dxi, 2) ~= size(element_coordinates, 2)
        error("number of shape functions must match the number of element coordinates")
    end
end
