%% Truck selected and seperator encoding
function truck_encode = truckencode(Num_truck,Num_route)
    numBits_sep = ceil(log2(Num_route));
    truck_encode = cell(1, Num_truck);
    for i = 1:Num_truck
        truck_encode{i} = randi([0, 1], 1, numBits_sep);
    end
end
