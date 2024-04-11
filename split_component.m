function [route_cell,delayed_cell,separator_cell] = split_component(population,Num_route,Num_truck,numBits_sep)
    route_cell = cell(2,1);
    delayed_cell = cell(2,1);
    separator_cell = cell(2,1);
    for i = 1:2
        route_cell{i} = population{i}(1:Num_route);
        separator_cell{i} = population{i}(Num_route+1:Num_route+numBits_sep*Num_truck);
        delayed_cell{i} = population{i}(Num_route+numBits_sep*Num_truck+1:end);
    end
end