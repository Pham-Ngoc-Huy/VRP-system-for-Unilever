%% Delayed - for today /decoding process
function [delayed_decode,delayed_decode_feasible] = delayed(Num_route,delayed_yesterday, delayed_today_encode,size_delayed)
    encode = zeros(1, numel(delayed_today_encode));   
    for i = 1:length(delayed_today_encode)
        binaryArray = delayed_today_encode{i}; % Keep the original order
        Numbits = numel(binaryArray);
        decimalNumber = 0;
        for j = 1:Numbits
            decimalNumber = decimalNumber + binaryArray(end-j+1) * 2^(j-1);
        end
        encode(i) = decimalNumber;
    end
    delayed_decode = unique(encode);
    common_elements = delayed_decode(ismember(delayed_decode, delayed_yesterday));
    delayed_decode_feasible = delayed_decode(~ismember(delayed_decode, [common_elements, 0]));
    delayed_decode_feasible = delayed_decode_feasible(delayed_decode_feasible <= Num_route);
end
