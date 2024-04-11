function [sort_pop_fitness_matrix,sort_pop_route,sort_population,sort_pop_truck] = elitism(sort_pop_fitness_matrix,sort_pop_route,sort_pop_truck,sort_population,sort_solu,sort_chil,sort_truck,sort_route,replacement)
for etil = 1:replacement
      if(sort_pop_fitness_matrix(1) < sort_solu(etil)) %keep if the child is better the worst of the population
         sort_pop_fitness_matrix(1) = sort_solu(etil);
         sort_population(1,:) = sort_chil(etil,:);
         sort_pop_truck{1} = sort_truck{etil};
         sort_pop_route{1} = sort_route{etil};
         %remove when the child is worse than the worst of the population   
      end
      [sort_pop_fitness_matrix,loc_sort] = sort(sort_pop_fitness_matrix,"ascend");
      sort_population = sort_population(loc_sort,:);
      sort_pop_truck = sort_pop_truck(loc_sort);
      sort_pop_route = sort_pop_route(loc_sort);
end
end