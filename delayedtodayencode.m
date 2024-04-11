%% delayed today creating -encode
function delayed_today_encode = delayedtodayencode(Num_route,size_delayed) 
    delayed_today_encode = cell(1,size_delayed);
    numBits_route = ceil(log2(Num_route));
    for i = 1:size_delayed
        delayed_today_encode{i} = randi([0, 1], 1, numBits_route);
    end
end