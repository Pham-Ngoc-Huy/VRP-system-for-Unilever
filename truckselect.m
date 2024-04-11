%% decoding truck and sep array
function [sep_decode,truck_decode,sep_decode_org] = truckselect(Num_truck,truck_encode,Num_route)
sep_decode_org = zeros(1, Num_truck);
%truck_array = [];
for i = 1:length(truck_encode)
    binaryArray = truck_encode{i}; % Keep the original order
    Numbits = numel(binaryArray);
    decimalNumber = 0;
    for j = 1:Numbits
        decimalNumber = decimalNumber + binaryArray(end-j+1) * 2^(j-1);
    end
    sep_decode_org(i) = decimalNumber;
    % modified distribution probability function/ reuse sep that > Num
    % route
    if sep_decode_org(i) >= Num_route
        sep_decode_org(i) = 2 * (sep_decode_org(i) - Num_route);  
        if sep_decode_org(i) >= Num_route
        sep_decode_org(i) = sep_decode_org(i) - Num_route;
        end
    end
end
sep_decode_org = unique(sep_decode_org);
% Handle the case when sep_decode_org is empty
if all(sep_decode_org == 0)
    sep_decode = [];
    truck_decode = randi(Num_truck + 1);  % Set truck_decode to 1 for an empty sep_decode
else
    % Sort sep_decode_org and remove zeros
    sep_decode = sort(sep_decode_org);
    sep_decode(sep_decode == 0) = [];
    % Generate truck numbers
    num_trucks_needed = length(sep_decode) + 1;
    % Randomly select trucks to use
    truck_decode = randperm(Num_truck+1, num_trucks_needed);
    % old technique
    % truck_decode = 1:(length(sep_decode)+1);
    % truck_decode(~location_zeros) = [];
end
end
