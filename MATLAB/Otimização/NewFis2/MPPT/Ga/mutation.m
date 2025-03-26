function mutatedPopulation = mutation(parameters,newPopulation1,sizeTest)

    mutatedPopulation = newPopulation1;

    if sizeTest ~=0

       for i = 1:(size(newPopulation1, 1)-1)
            for j = 1:parameters.chromosomeLength-8

                if rand < parameters.mutationRate

                    mutatedPopulation(i, j) = newPopulation1(i, j)*(-2+4*rand);                    

                end

            end        
       end
    






    else

        for i = 1:size(newPopulation1, 1)

            for j = 1:parameters.chromosomeLength-8
                if rand < parameters.mutationRate

                    mutatedPopulation(i, j) = newPopulation1(i, j)*(-2+4*rand);                    

                end
            end

                 
        end



    end



    end
