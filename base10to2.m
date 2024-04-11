%% turning sep_decode and delayed_today_order from base 10 to base 2
function truck_encode = base10to2(sep_decode,numBits_sep)
truck_encode = cell(1,length(sep_decode));
y = sep_decode;
for i = 1:length(sep_decode)
    for j = numBits_sep:-1:1
        I(j) = fix(mod(y(i),2));
        y(i) = fix(y(i)/2);
    end
    truck_encode{i} = I;
end
end