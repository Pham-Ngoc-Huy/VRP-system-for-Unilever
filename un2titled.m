route = [1 2 6 7 8 9];

travelTime = zeros(9, 9);

earliestStart = [8 0 0 0 0 0 0 0 0]; 
latestFinish = [0 0 0 0 0 0 0 17 18];

% Tính toán và kiểm tra lịch trình
currentTime = earliestStart(route(1)); 
feasible = true; 

for i = 1:length(route)-1
    nextPoint = route(i+1);
    currentTime = currentTime + travelTime(route(i), nextPoint); 
    
  
    if nextPoint > 1 && earliestStart(nextPoint) > 0 && currentTime < earliestStart(nextPoint)
        currentTime = earliestStart(nextPoint); 
    end
    
    if latestFinish(nextPoint) > 0 && currentTime > latestFinish(nextPoint)
        feasible = false; 
        break; 
    end
end

if feasible
    disp('Lịch trình khả thi.');
else
    disp(['Lịch trình không khả thi tại điểm ', num2str(nextPoint), '.']);
end
