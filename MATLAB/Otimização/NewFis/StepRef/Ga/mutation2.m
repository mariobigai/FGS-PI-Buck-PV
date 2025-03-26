function mutatedPopulation = mutation(parameters,newPopulation1,sizeTest)

    mutatedPopulation = newPopulation1;

    if sizeTest ~=0

       for i = 1:(size(newPopulation1, 1)-1)
        for j = 1:size(newPopulation1, 2)
            if rand < mutationRate
                mutatedPopulation(i, j) = newPopulation1(i, j) - (newPopulation1(i, j)-parameters.Restr_sup)/(parameters.Restr_sup-parameters.Restr_inf);
            end
        end
       end
    
    else

        for i = 1:size(newPopulation1, 1)
            for j = 1:2:size(newPopulation1, 2)
                if rand < parameters.mutationRate
                    mutatedPopulation(i, j) = newPopulation1(i, j) - (newPopulation1(i, j)-parameters.Restr_1(2))/(parameters.Restr_1(2)-parameters.Restr_1(1));
                end
            end

            for j = 2:2:size(newPopulation1, 2)
                if rand < parameters.mutationRate
                    mutatedPopulation(i, j) = newPopulation1(i, j) - (newPopulation1(i, j)-parameters.Restr_2(2))/(parameters.Restr_2(2)-parameters.Restr_2(1));
                end
            end







        end

    end

    end
