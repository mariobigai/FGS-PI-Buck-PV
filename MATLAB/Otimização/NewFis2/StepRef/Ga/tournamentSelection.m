function selectedPopulation = tournamentSelection(parameters,fitness,population)

    % Implementação do Método de Torneio
    selectedPopulation = zeros(parameters.populationSize,parameters.chromosomeLength+1);

    for i = 1:parameters.populationSize

        % Seleciona aleatoriamente indivíduos para o torneio
        tournamentIndices = randi(parameters.populationSize, parameters.tournamentSize, 1);
        tournamentFitness = fitness(tournamentIndices);
        
        % Seleciona o indivíduo com a melhor aptidão
        [bestFit, bestIndex] = maxMin(parameters.criterion,tournamentFitness,1);
       
        selectedPopulation(i, :) = [population(tournamentIndices(bestIndex), :) bestFit ];
    end
end