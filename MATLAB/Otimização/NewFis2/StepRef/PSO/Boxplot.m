


function [BoxX, BoxI] = Boxplot(parameters)
    
    BoxX = zeros(parameters.runsNumber,parameters.dim+1);
    BoxI = zeros(parameters.runsNumber,1);

    for i = 1:parameters.runsNumber

        run_Number = i

         [~,g_bestEV, iterationsNeeded] = PSO(parameters);
        
        melhor_individuo = g_bestEV(end,:);

        BoxX(i,:) = melhor_individuo;  
        BoxI(i) = iterationsNeeded; 
    end

    [melhor_individuo,Index] = maxMin(parameters.criterion,BoxX,1)

    figure(4);boxplot(BoxX(:,parameters.dim+1))
    title('FitnessBox')
    fprintf('O melhor')

    figure(5);boxplot(BoxI)
    title('iterationsNeededBox')
end
