Num_truck = 11; %this is separator number - wrong in named index
Num_route = 15;
Num_product = 3;
BigM = 100000;
%Initialization initial variable
delayed_yesterday = [1 2 3 4];
size_delayed = round(0.4*Num_route);
numBits_sep = ceil(log2(Num_route));
% both tabusearch and GA
Number_inner_loop = 6;
%Tabusearch initial variable
Number_Iteration = 500;
tabusize = 2;
%GA initial variable
pmax = 20;
Number_outer_loop_muitation = 5;
child_set = 14;
Number_of_GA_Iteration = 500;
replacement = 7;
percentage_of_infeasible = round(2*pmax/3);