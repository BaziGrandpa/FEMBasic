
clear; clc; close all;

%% -------------------------------------------------------
% Read mesh (T3 or Q4)
% -------------------------------------------------------
tria_mesh = 'assignments/CA1/inputdata/floormesh_tria.inp'
quad_mesh = 'assignments/CA1/inputdata/floormesh_quad.inp'

meshfile = quad_mesh;
[element_nodes, node_coordinates, element_sets, facet_sets, node_sets, element_type] = ...
    read_mesh(meshfile);

ndofs = size(node_coordinates,2);

%% -------------------------------------------------------
% Physical parameters
% -------------------------------------------------------
Troom = 20;       % °C (Γ3 + Γ4)
Tout  = -10;      % °C (Γ6)
Qh    = 200;      % W/m outward flux on heating pipe boundary (Γ2 = "hole")

% Conductivities per region (adjust if assignment gives specific values)
k_tiles         = 1.0;
k_floorstruct   = 0.5;
k_wall          = 0.3;

D_tiles       = k_tiles * eye(2);
D_floorstruct = k_floorstruct * eye(2);
D_wall        = k_wall * eye(2);

b = 0;               % No volumetric heat source
nquadpoints = 3;     % Requested

%% -------------------------------------------------------
% Allocate global K, f
% -------------------------------------------------------
K = spalloc(ndofs, ndofs, 40*ndofs);
f = zeros(ndofs,1);

%% -------------------------------------------------------
% Assembly over all elements
% -------------------------------------------------------
for e = 1:size(element_nodes, 2)

    enods  = element_nodes(:, e);
    coords = node_coordinates(:, enods);

    % Pick conductivity matrix using element sets
    if ismember(e, element_sets{"tiles"})
        D = D_tiles;
    elseif ismember(e, element_sets{"floorstructure"})
        D = D_floorstruct;
    elseif ismember(e, element_sets{"wallstructure"})
        D = D_wall;
    else
        error("Element not assigned to a domain set.");
    end

    % Element matrices
    if element_type == "LinearTriangle"
        [Ke, fe] = linear_triangle_heat_element(D, b, coords, nquadpoints);
    elseif element_type == "BilinearQuadrilateral"
        [Ke, fe] = bilinear_quadrilateral_heat_element(D, b, coords, nquadpoints);
    else
        error("Unknown element type.");
    end

    % Assemble
    K(enods, enods) = K(enods,enods) + Ke;
    f(enods)         = f(enods)       + fe;
end

%% -------------------------------------------------------
% Neumann BCs: Γ2 = "hole" = heating pipe flux
% -------------------------------------------------------
if isKey(facet_sets, "hole")
    facets = facet_sets{"hole"};   % [2 × Nfacets]

    for fct = 1:size(facets,2)

        e   = facets(1,fct);    % element id
        fnr = facets(2,fct);    % local facet number

        enods    = element_nodes(:, e);
        coords_e = node_coordinates(:, enods);

        if element_type == "LinearTriangle"
            feN = linear_triangle_heat_neumann(Qh, coords_e, fnr, nquadpoints);
        else
            feN = bilinear_quadrilateral_heat_neumann(Qh, coords_e, fnr, nquadpoints);
        end

        f(enods) = f(enods) - feN;
    end
end

%% -------------------------------------------------------
% Dirichlet BCs:
% Γ3 = tilesurface, Γ4 = wallsurface, Γ6 = outsurface
% Must union Γ3 & Γ4 (assignment note)
% -------------------------------------------------------
roomside = union(node_sets{"tilesurface"}, node_sets{"wallsurface"});
outs     = node_sets{"outsurface"};

cdofs = unique([ roomside(:); outs(:) ]);

constrained_vals = [
    Troom * ones(numel(roomside),1);
    Tout  * ones(numel(outs),1)
];

fdofs = setdiff(1:ndofs, cdofs);

%% -------------------------------------------------------
% Solve partitioned system Kff af = ff – Kfc ac
% -------------------------------------------------------
af = K(fdofs,fdofs) \ ( f(fdofs) - K(fdofs,cdofs)*constrained_vals );

a = zeros(ndofs,1);
a(fdofs) = af;
a(cdofs) = constrained_vals;

%% -------------------------------------------------------
% Temperature Plot (simple node scatter)
% -------------------------------------------------------
%figure; hold on; axis equal;
%scatter(node_coordinates(1,:), node_coordinates(2,:), 40, a, 'filled');
%colorbar; title("Nodal Temperature (°C)");
%xlabel('x'); ylabel('y');
figure; hold on; axis equal;
title("Nodal Temperature (°C) - FEM Mesh Visualization");
xlabel('x'); ylabel('y');

nel = size(element_nodes, 2);
nnode_per_ele = size(element_nodes, 1);

% Ensure you are using the correct element type for plotting
if element_type == "BilinearQuadrilateral" && nnode_per_ele == 4
    
    % Loop over all elements to draw them with patch
    for e = 1:nel
        enods = element_nodes(:, e);
        
        % Get the coordinates of the current element's nodes
        x_coords = node_coordinates(1, enods);
        y_coords = node_coordinates(2, enods);
        
        % Get the temperature values at the current element's nodes
        temp_vals = a(enods);
        
        % Use 'patch' to draw the element. 
        % CData determines the color (based on temperature values).
        % FaceColor 'interp' provides a smooth, interpolated color map.
        patch(x_coords, y_coords, temp_vals, ...
              'FaceColor', 'interp', ...
              'EdgeColor', [0.7 0.7 0.7]); % Light grey edges for visibility
    end

elseif element_type == "LinearTriangle" && nnode_per_ele == 3
    for e = 1:nel
        enods = element_nodes(:, e);
        
        % Get the coordinates of the current element's nodes
        x_coords = node_coordinates(1, enods);
        y_coords = node_coordinates(2, enods);
        
        % Get the temperature values at the current element's nodes
        temp_vals = a(enods);
        
        % Use 'patch' to draw the element. 
        % FaceColor 'interp' provides a smooth, interpolated color map.
        patch(x_coords, y_coords, temp_vals, ...
              'FaceColor', 'interp', ...
              'EdgeColor', [0.7 0.7 0.7]); % Light grey edges for visibility
    end
    
else
    error("Unsupported element type or node count for FEM plot.");
end

colorbar;

%% -------------------------------------------------------
% Compute heat flux at element centers
% -------------------------------------------------------
nel = size(element_nodes, 2);
flux = zeros(2, nel);
xc = zeros(1, nel);
yc = zeros(1, nel);

for e = 1:nel
    enods  = element_nodes(:,e);
    coords = node_coordinates(:,enods);
    ae     = a(enods);

    % Determine region for proper D
    if ismember(e, element_sets{"tiles"})
        D = D_tiles;
    elseif ismember(e, element_sets{"floorstructure"})
        D = D_floorstruct;
    elseif ismember(e, element_sets{"wallstructure"})
        D = D_wall;
    end

    % Compute element flux using 1-point quad
    if element_type == "LinearTriangle"
        q = linear_triangle_heat_flux(D, coords, ae, 1);
    else
        q = bilinear_quadrilateral_heat_flux(D, coords, ae, 1);
    end

    flux(:,e) = q(:,1);

    % Element center = average of its nodes
    xc(e) = mean(coords(1,:));
    yc(e) = mean(coords(2,:));
end

%% -------------------------------------------------------
% Heat Flux Vector Plot
% -------------------------------------------------------
figure; hold on; axis equal;
quiver(xc, yc, flux(1,:), flux(2,:), 2, 'k');
title("Heat Flux Vectors");
xlabel('x'); ylabel('y');
