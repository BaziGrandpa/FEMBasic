function fig = plot_fe_mesh(element_nodes, node_coordinates, element_type)
% fig = plot_fe_mesh(element_nodes, node_coordinates, element_type)
% Plot a 2d mesh with elements of type `element_type` and show the element 
% and node numbers. 
% Inputs: element_nodes [num_elem_nodes, num_elems] - node numbers for each
%                                                     element
%         node_coordinates [dim, num_nodes] - node coordinates
%         element_type (string) - the element type name
% Output: fig - the figure handle to the plotted figure. 

    show_element_numbers = true;
    show_node_numbers = true;
    dim = size(node_coordinates, 1);
    if dim ~= 2
        error("Only 2d is currently supported")
    end
    [Ex, Ey] = get_element_coordinates(element_nodes, node_coordinates, element_type);

    fig = figure();
    hold on;
    fill(Ex, Ey, 'w', EdgeColor='b')
    x = node_coordinates(1, :);
    y = node_coordinates(2, :);
    scatter(x, y, 400, 'k', 'o', MarkerFaceColor='k');
    if show_element_numbers
        if element_type == "QuadraticQuadrilateral"
            shift = 0.5; % Avoid writing on top of node. 
        else
            shift = 0.0;
        end
        xc = (1-shift) * mean(Ex,1) + shift * Ex(1,:); 
        yc = (1-shift) * mean(Ey,1) + shift * Ey(1,:); 
        elem_labels = string(1:size(Ex,2));
        scatter(xc, yc, 400, 'b', 'o', MarkerFaceColor='w');
        text(xc, yc, elem_labels, ...
            HorizontalAlignment='center', FontSize=12, Color='b', ...
            FontWeight='bold');
    end
    if show_node_numbers
        node_labels = string(1:size(node_coordinates,2));
        text(x, y, node_labels, ...
            HorizontalAlignment='center', FontSize=12, Color='w', ...
            FontWeight='bold');
    end
    xlabel("x")
    ylabel("y")
end
