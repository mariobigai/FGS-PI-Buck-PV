
function [fitness, cont_simu] = evaluatePopulation(parameters,population)

   cont_simu = 0; 
   fitness = zeros(size(population,1),1);

   for j=1:size(population,1)
           warning('off','all')


       %Penalizações com base nas restrições --------------------------------------------------------
    
        if (any(population(j,1:2) > parameters.Restr(2)) || any(population(j,1:2) < parameters.Restr(1)));fitness(j,1) = 1000; continue; end
        if (any(population(j,3:4) > parameters.Restr(4)) || any(population(j,3:4) < parameters.Restr(3)));fitness(j,1) = 1000; continue; end
        if (any(population(j,5:20) > parameters.Restr(6)) || any(population(j,5:20) < parameters.Restr(5)));fitness(j,1) = 1000; continue; end
        if (any(population(j,21:70) > parameters.Restr(8)) || any(population(j,21:70) < parameters.Restr(7)));fitness(j,1) = 1000; continue; end
        if (any(population(j,71:end) > parameters.Restr(10)) || any(population(j,71:end) < parameters.Restr(9)));fitness(j,1) = 1000; continue; end

        try
            fis = newFis2(population(j,:));
            n_pontos = 20;
            erro = linspace(-1,1,n_pontos+1);
            var_erro = linspace(-1,1,n_pontos+1);
            kp = zeros(n_pontos+1,n_pontos+1);
            ki = zeros(n_pontos+1,n_pontos+1);
            for a =1:n_pontos+1 % Loop para mapear todos pontos
                for b =1:n_pontos+1 
                    OUT = evalfis(fis, [erro(a), var_erro(b)]);
                    kp(a,b) = OUT(1);
                    ki(a,b) = OUT(2);
                end
            end
            kE = population(j,1);
            kdE = population(j,2);
            kkp = population(j,3);       
            kki = population(j,4);

            try
%Estabelece os inputs da simulação
                simIn = Simulink.SimulationInput('buck_pv_otm_MPPT2');

                simIn = simIn.setVariable('kp',kp);
                simIn = simIn.setVariable('ki',ki);
                simIn = simIn.setVariable('kE',kE);
                simIn = simIn.setVariable('kdE',kdE);
                simIn = simIn.setVariable('kkp',kkp);
                simIn = simIn.setVariable('kki',kki);
                simIn = simIn.setVariable('kp_0',0.0055);
                simIn = simIn.setVariable('ki_0',3.23);
                simIn = simIn.setVariable('n_pontos',n_pontos);                

% Executa a simulação e captura o output --------------------------------------------------------
                simOut = sim(simIn);
                clc


                try
% Acessa os dados salvos pela simulação--------------------------------------------------------

                    error = simOut.get('erro');
                    error = [error.time error.data];

                    kp = simOut.get('kp');
                    kp = [kp.time kp.data];

                    ki = simOut.get('ki');
                    ki = [ki.time ki.data];

                    fitness(j,1) = fitnessmetodo3(error, kp, ki);
                    cont_simu = cont_simu+1;
                      %fitness(j,1) = fitnessmetodo2(error);
                    



                    % n11 = find(error(:,1)<0.1); n11 = n11(end);         
                    % n21 = length(error(:,1));
                    % 
                    % 
                    % erro_velho = abs(error(n11:end,2));
                    % 
                    % IAE(j,1)=trapz(error(n11:n21,1),erro_velho);
                    % 
                    % 
                    % fitness(j,1) = IAE(j,1);


                catch ME
% penaliza o erro de CALCULO--------------------------------------------------------
%                     disp(ME)
                    fitness(j,1) = 602;continue;
                end


            catch ME
% penaliza o erro de simulação--------------------------------------------------------
                %disp(ME)
                fitness(j,1) = 601;continue;

            end


        catch ME
% penaliza o erro de criação do Fuzzy--------------------------------------------------------
        %disp(ME)
        fitness(j,1) = 600;continue;

        end


    end

       
end

