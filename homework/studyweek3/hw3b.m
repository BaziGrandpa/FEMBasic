% VSM167, StudyWeek 3
% Homework 3b: 1D heat flow finite elements
% Written by: Knut Andreas Meyer
% Date: 2025-10-02

% Define the given input parameters
x_left  = 0.0;  % [m]
x_right = 1.0;  % [m]
k = 0.5;        % [Wm/K] Thermal conductivity
b = 1e2;        % [W/m] Internal heat source
nels = 10;      % Number of elements
element_type = "LinearLine";
nquadpoints = 1;

T_left = 20;    % [C] Prescribed temperature on left side
qn_right = 10;  % [W] Outwards boundary flux on right side

% Generate the mesh
[element_nodes, node_coordinates, facet_sets, node_sets] = generate_mesh(element_type, nels, x_left, x_right);

% Dirichlet boundary condition
constrained_dofs = [node_sets{"left"}];
constrained_vals = [T_left];

% Neumann boundary conditions
neumann_dof = node_sets{"right"};

% Pre-allocate the system matrix and vector
ndofs = size(node_coordinates, 2); % 1 dof per node
K = spalloc(ndofs, ndofs, 4 * ndofs); % Max 4 dofs per row due to 1D => 4*ndofs total elements
f = zeros(ndofs, 1);

% Assemble the equation system
for i = 1:size(element_nodes, 2)
    enods = element_nodes(:, i); % Get the element's nodes
    coords = node_coordinates(:, enods); % Get the element's coordinates
    [Ke, fe] = linear_line_heat_element(k, b, coords, nquadpoints);
    edofs = enods; % For scalar problems, we use same numbering of nodes and dofs
    K(edofs, edofs) = K(edofs, edofs) + Ke; % Add stiffness contribution to global matrix
    f(edofs) = f(edofs) + fe; % Add load vector contribution to global vector
end

% Add Neumann boundary contributions
f(neumann_dof) = f(neumann_dof) - qn_right;

% Solve the equation system via partitioning
cdofs = constrained_dofs; % Dofs with known temperature, so constrain them!
fdofs = setdiff(1:ndofs, cdofs); % The rest are unknown -> free to change

% Solve for the unknown dofs: af = Kff^{-1} * (ff - Kfc * ac)
af = K(fdofs, fdofs) \ (f(fdofs) - K(fdofs, cdofs) * constrained_vals);

% Re-create the full solution vector
a = zeros(ndofs, 1);
a(fdofs) = af;
a(cdofs) = constrained_vals;

% Plot the results
% In 1D we sometimes (like here with linear elements) have that the node
% coordinate is monotonic. But this doesn't work for quadratic elements.
% Therefore, we do the general and plot the temperature for each element
% individually:
figure(); hold on;
xlabel("Coordinate [m]")
ylabel("Temperature [C]")
for i = 1:size(element_nodes, 2)
    enods = element_nodes(:, i); % Get the element's nodes
    % Need to sort the node coordinates for a nice plot
    [coords, inds] = sort(node_coordinates(:, enods)); % Get the element's coordinates
    edofs = enods; % For scalar problems, we use same numbering of nodes and dofs
    plot(coords, a(edofs(inds)), "k")
end
