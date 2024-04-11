run('datasource.m')  
Num_truck =3;

truck_number = 1:length(employ_cost);
    truck_to_use = randperm(numel(truck_number),Num_truck);
    truck_decode = truck_number(truck_to_use);
    Num_truck_real = length(truck_decode);

disp(truck_decode)