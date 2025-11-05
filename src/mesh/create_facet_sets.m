function facet_sets = create_facet_sets(node_sets, element_nodes, element_type, num_nodes)
% facet_sets = create_facet_set(node_sets, element_nodes, element_type, num_nodes)
% Internal function to create facet sets from the nodesets, used in 
% `read_mesh` and `generate_mesh`. TODO: Only include nodesets that don't 
% contain facets shared between elements. Currently, all nodesets, except 
% with all nodes, are turned into facetsets.
    facet_sets = dictionary();
    names = keys(node_sets);
    for i = 1:length(names)
        name = names(i);
        node_set = node_sets{name};
        if length(node_set) == num_nodes
            continue % Skip node sets containing all nodes in the grid
        end
        facet_set = create_facet_set(node_set, element_nodes, element_type);
        if ~isempty(facet_set)
            facet_sets{name} = facet_set;
        end
    end
end


function facet_set = create_facet_set(node_set, element_nodes, element_type)
% facet_set = create_facet_set(node_set, element_nodes, element_type)
    facet_indices = facets(element_type);
    nguess = max(round(length(node_set) / 2), 10);
    facet_set = zeros(2, nguess);
    i = 0;
    nodes = dictionary(node_set, boolean(zeros(size(node_set))));
    for e = 1:size(element_nodes, 2)
        enodes = element_nodes(:, e);
        found_nodes = isKey(nodes, enodes);
        if any(found_nodes)
            nodes_intersection = enodes(found_nodes);
            nodes_check = dictionary(nodes_intersection, nodes_intersection);
            for f = 1:size(facet_indices, 2)
                facet_nodes = enodes(facet_indices(:, f));
                if all(isKey(nodes_check, facet_nodes))
                    i = i + 1;
                    if size(facet_set, 2) < i
                        facet_set = addcols(facet_set, nguess);
                    end
                    facet_set(:, i) = [e; f];
                end
            end
        end
    end
    facet_set = facet_set(:, 1:i);
end

function facet_ids = facets(element_type)
    switch element_type
        case {"LinearLine", "QuadraticLine"}
            facet_ids = [1, 2];
        case {"LinearTriangle", "QuadraticTriangle"}
            facet_ids = [1:3; 2:3, 1];
        case {"BilinearQuadrilateral", "QuadraticQuadrilateral", "SerendipityQuadraticQuadrilateral"}
            facet_ids = [1:4; 2:4, 1];
        case {"LinearTetrahedron", "QuadraticTetrahedron"}
            facet_ids = [1, 1, 2, 1; 3, 2, 3, 4; 2, 4, 4, 3];
        otherwise
            error("facets not implemented for %s", element_type)
    end
end

function mnew = addcols(mold, nadd)
    [r, c] = size(mold);
    mnew = zeros(r, c + nadd);
    mnew(:, 1:c) = mold;
end
