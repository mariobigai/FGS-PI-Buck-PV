function newPopulation1 = crossover(parameters,selectedPopulation,sizeTest)
    
    newPopulation1 = zeros(parameters.populationSize,parameters.chromosomeLength);
    

% se o numero de selecionados for ímpar , toma-se o melhor individuo e
% passa para a proxima geração

    

    if sizeTest ~= 0


        [~, Bestindex] = maxMin(parameters.criterion, selectedPopulation(:,parameters.chromosomeLength+1),1);

        newPopulation1(parameters.populationSize,1:parameters.chromosomeLength) = selectedPopulation(Bestindex,1:parameters.chromosomeLength);

        selectedPopulation(Bestindex,:) = [];
        
        

    end
    
    

     %se o tamanho do cromossomo é par

     chromolengthTest = mod(parameters.chromosomeLength,2);

    if chromolengthTest == 0

        crossoverPoint = parameters.chromosomeLength/2;

            %se não
    else

        crossoverPoint = (parameters.chromosomeLength-1)/2 +1;

    end



    for i = 1:2:size(selectedPopulation,1)

        parent1 = selectedPopulation(i,1:parameters.chromosomeLength);
        parent2 = selectedPopulation(i+1,1:parameters.chromosomeLength);
       


        if rand < parameters.crossoverRate

            %Troca paralela do segundo trecho de cada pai

            newPopulation1(i, 1:parameters.chromosomeLength) = [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
            newPopulation1(i+1, 1:parameters.chromosomeLength) = [parent2(1:crossoverPoint), parent1(crossoverPoint+1:end)];

        else

            newPopulation1(i, 1:parameters.chromosomeLength) = parent1;
            newPopulation1(i+1, 1:parameters.chromosomeLength) = parent2;
            
        end
    end
    
end
