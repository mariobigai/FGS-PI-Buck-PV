
function fitness= evaluatePopulation2(parameters,population)

    IAE = zeros(size(population,1),1);
    fitness = zeros(size(population,1),1);

    for j=1:size(population,1)
           warning('off','all')
        try
            
%             population(j,4:19) = int32(population(j,4:19));

            fis = newFis(population(j,:));
            E = population(j,1);
            delE = population(j,2);
            FlcOut = population(j,3);

          

%Penalizações com base nas restrições --------------------------------------------------------

            if any(population(j,1:3)) > parameters.Restr(2) || any(population(j,1)) < parameters.Restr(1) ;fitness(j,1) = 500;continue ;end
            if any(population(j,4:19)) > parameters.Restr(4) || any(population(j,1)) < parameters.Restr(3) ;fitness(j,1) = 500;continue ;end
            if any(population(j,20:44)) > parameters.Restr(6) || any(population(j,1)) < parameters.Restr(5) ;fitness(j,1) = 500;continue ;end
            if any(population(j,45:end)) > parameters.Restr(8) || any(population(j,1)) < parameters.Restr(7) ;fitness(j,1) = 500;continue ;end
            

%Estabelece os inputs da simulação
            simIn = Simulink.SimulationInput('buck_pvLucas');
            simIn = simIn.setVariable('fis',fis);
            simIn = simIn.setVariable('E',E);
            simIn = simIn.setVariable('delE',delE);
            simIn = simIn.setVariable('FlcOut',FlcOut);

% Executa a simulação e captura o output --------------------------------------------------------
            simOut = sim(simIn);


          catch ME
% penaliza o erro --------------------------------------------------------
        fitness(j,1) = 600;
        continue;

        end


% Acessa os dados salvos pela simulação--------------------------------------------------------

            error = simOut.get('erro');
            error = [error.time error.data];
    
            % tira o transitório incial e começa a calcular a IAE a partir
            % dos transitórios de temperatura
            n11 = find(error(:,1)<1.5); n11 = n11(end);
            n21 = length(error(:,1));
            
            erro_velho = abs(error(n11:n21,2));
        
%Calculo da integral absoluta do erro --------------------------------------------------------
            IAE(j,1)=trapz(error(n11:n21,1),erro_velho);


        fitness(j,1) = IAE(j,1);


    end


       
end

