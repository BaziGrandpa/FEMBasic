function ea = get_element_dofs(element_nodes, a, dofs_per_node)
% ea = get_element_dofs(element_nodes, a, dofs_per_node)
% Obtain the dof-values organized per element such that `ea(:, e)` contains
% the dof-values for the element number `e` in its local ordering.
% Inputs
%  element_nodes - [nodes_per_element, num_elements] (part of grid output)
%  a [ndofs, 1] - the solved degree of freedom vector
%  dofs_per_node (int) - Number of dofs per node (1 for scalar problems,
%                        dim for vector-valued problems
% Output
% ea [ndofs_per_element, num_elements] - degree of freedom values organized
%                                        per element
% 

    nel = size(element_nodes, 2);
    ea = zeros(size(element_nodes, 1) * dofs_per_node, nel);
    edofs = zeros(size(ea, 1), 1);
    for e = 1:nel
        for i = 1:dofs_per_node
            edofs(i:dofs_per_node:end) = dofs_per_node * element_nodes(:, e) - (dofs_per_node - i);
        end
        ea(:, e) = a(edofs);
    end
end
