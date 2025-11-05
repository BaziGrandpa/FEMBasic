function [element_nodes, node_coordinates, element_sets, facet_sets, node_sets, element_type] = read_mesh(inpfile)
% function [element_nodes, node_coordinates, element_sets, facet_sets, node_sets, element_type] = read_mesh(inpfile)
% Read the Abaqus input file and and return a mesh specification
% Inputs:
% * `inpfile`: The absolute or relative path to the Abaqus input (`.inp`) file
% 
% Outputs:
% * `element_nodes` [num_elem_nodes, num_elems]: `element_nodes(:, e)` gives
%   the node numbers of the nodes of element `e`. 
% * `node_coordinates` [dim, num_nodes]: The coordinates of each node in
%   the mesh. 
% * `element_sets` dictionary: string -> cell array: Gives the element
%   numbers for elements included in a set. The key is the name.
% * `facet_sets` dictionary: string -> cell array: Each column contains the
%   element number and facet number. The name is taken from node sets in 
%   the input file, but node sets not representing boundaries may be
%   removed.
% * `node_sets` dictionary: string -> cell array: The node numbers
%   belonging to the set
% * `element_type` string: The element code in BasicFEM.
% 
% Notes on the dictionaries
% Due to limitations in MATLAB, we cannot save standard arrays directly as
% values in dictionaries, therefore these are wrapped in a cell array. To
% access these sets, index with curly braces and assign to a variable, e.g.
% -------------------------------------------------------------------------
% left_side = facet_sets{"left"}
% for f = 1:size(left_side, 2)
%     element_id, facet_nr = left_side(:, f)
%     ...
% -------------------------------------------------------------------------

    num_node_instances = 0; % Only one set of node coordinates supported
    num_elem_instances = 0; % Only one set of elements supported (i.e different element types not accepted)
    
    fid = fopen(inpfile, "r");
    
    node_sets = dictionary();
    element_sets = dictionary();
    line = string(fgetl(fid));
    while ~feof(fid)

        if strcmpi(strip(line), "*Node") % case-insensitive comparison
            [node_coordinates, line] = read_indexed_datalines(fid);
            num_node_instances = num_node_instances + 1;
        elseif startsWith(line, "*element, type=", 'IgnoreCase', true)
            num_elem_instances = num_elem_instances + 1;
            element_type = read_element_type(line);
            [element_nodes, line] = read_indexed_datalines(fid);
        elseif startsWith(line, "*Nset, nset=", 'IgnoreCase', true)
            key = read_set_key(line);
            [set, line] = read_set(fid, line);
            node_sets{key} = set;
        elseif startsWith(line, "*Elset, elset=", 'IgnoreCase', true)
            key = read_set_key(line);
            [set, line] = read_set(fid, line);
            element_sets{key} = set;
        else
            line = string(fgetl(fid));
        end
    end
    if num_node_instances ~= 1
        num_node_instances
        error("Exactly one *Node list can exist in the input file")
    end
    if num_elem_instances ~= 1
        num_elem_instances
        error("Only a single *Element list supported (not mixed elements)")
    end
    
    facet_sets = create_facet_sets(node_sets, element_nodes, element_type, size(node_coordinates, 2));
    
    fclose(fid);
end

function [data, next_line] = read_indexed_datalines(fid)
    nguess = 100;
    line = string(fgetl(fid));
    [i, d] = read_indexed_line(line);
    data = zeros(length(d), nguess);
    n = 1;
    data(:, n) = d;
    assert(i == n);
    while ~feof(fid)
        line = string(fgetl(fid));
        if startsWith(line, "**") || strcmp(line, "") % Comment/emtpy line
            continue 
        elseif startsWith(line, "*") % New keyword
            break 
        end
        n = n + 1;
        [i, d] = read_indexed_line(line);
        if i ~= n
            fprintf("Error on the line with content\n")
            fprintf("%s\n", line)
            error("indices (first column) must be in order")
        end
        if n > size(data, 2)
            data = addcols(data, nguess);
        end
        data(:, n) = d;
    end
    data = data(:, 1:n); % Shrink to have correct size
    next_line = line;
end

function [i, d] = read_indexed_line(line)
    data = double(split(line, ','));
    i = data(1);
    d = data(2:end);
end

function mnew = addcols(mold, nadd)
    [r, c] = size(mold);
    mnew = zeros(r, c + nadd);
    mnew(:, 1:c) = mold;
end

function [set, next_line] = read_set(fid, header_line)
    set = [];
    generated = endsWith(header_line, "generate");
    
    while ~feof(fid)
        line = string(fgetl(fid));
        if startsWith(line, "**") || strcmp(line, "") % Comment/emtpy line
            continue 
        elseif startsWith(line, "*") % New keyword
            break 
        end
        data = double(split(line, ','));
        nan_check = isnan(data);
        if any(nan_check)
            if all(nan_check) || any(nan_check(1:end-1))
                error("Failed parsing: %s", line)
            end
            data = data(1:end-1); % Last line contain commas or other EOL
        end
        if generated
            if length(data) == 2
                set = [set; data(1):data(2)];
            elseif length(data) == 3
                set = [set; data(1):data(3):data(2)];
            else
                disp(line)
                error("generated set must have either 2 or 3 values per line")
            end
        else
            set = [set; data];
        end
    end
    next_line = line;
end

function key = read_set_key(line)
    key = "";
    parts = split(line, ",");
    for i = 1:length(parts)
        part = parts(i);
        stripped = strip(part);
        if startsWith(stripped, ["elset", "nset"], 'IgnoreCase', true)
            kw = split(stripped, '=');
            assert(length(kw)==2)
            key = kw(2);
            break;
        end
    end
    if strcmp(key, "")
        disp(line)
        error("could not find the set key")
    end
end

function element_type = read_element_type(line)
    split_line = split(line, ',');
    codespec = strip(split_line(end));
    assert(startsWith(codespec, "type=", "IgnoreCase",true))
    kw = split(codespec, "=");
    abaqus_code = kw(2);
    switch abaqus_code
        case {"CPS3", "CPE3", "DC2D3"}
            element_type = "LinearTriangle";
        case {"CPE6", "CPS6", "CPE6M", "CPS6M"}
            element_type = "QuadraticTriangle";
        case {"CPE4", "CPS4", "CPE4R", "CPS4R", "DC2D4"}
            element_type = "BilinearQuadrilateral";
        case {"CPS8", "CPS8R", "CPE8", "CPE8R"}
            element_type = "SerendipityQuadraticQuadrilateral";
        case "C3D4"
            element_type = "LinearTetrahedron";
        case "C3D10"
            element_type = "QuadraticTetrahedron";
        case {"C3D8", "C3D8R"}
            element_type = "LinearHexahedron";
        case {"C3D20", "C3D20R"}
            element_type = "QuadraticHexahedron";
        otherwise
            disp(abaqus_code)
            error("Element code, ""%s"" not supported", abaqus_code)
    end
end

