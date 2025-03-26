


function [BoxV, BoxG] =Boxplot(parameters)
    
    BoxV = [];
    BoxG = [];

    k =parameters.k;

    for i = 1:parameters.runsNumber

        run_Number = i
        [kbests_Chrom,generationsNeeded] = Ga(parameters);
        
        melhor_individuo = [kbests_Chrom(parameters.k*generationsNeeded-(parameters.k-1),:)];

        BoxV = [BoxV; melhor_individuo];  
        BoxG = [BoxG; generationsNeeded]; 
    end

    
    BoxV
    BoxG
  
    figure(4);boxplot(BoxV(:,parameters.chromosomeLength+1))
    title('FitnessBox')
    

    figure(5);boxplot(BoxG)
    title('GenerationsNeededBox')
end
