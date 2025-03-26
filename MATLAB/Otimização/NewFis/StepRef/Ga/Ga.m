function [kbests_Chrom,generationsNeeded, cont_simu] = Ga(parameters)

% Inicialização --------------------------------------------------------
    cont_simu = 0;
    count = 1;  %inicializa o contador de atualizações do fitness de referência
    generationsNeeded = 1;

    
%inicia a matriz de melhores individuos --------------------------------------------------------
    kbests_Chrom =[];

    ini_ind = [[1/3 0.1]  ...% Ganhos de fuzificação ke kde - [0 ... 10]
        [0.0015 1.5] ... % Ganhos de defuzificação kkp kki - [0 ... 1]
        [0.2 1 0.6 0 0.8 0.2 -0.4 0.1] ... % Pontos MF entrada E - [-1 ... 1]
        [0.2 1 0.6 0 0.8 0.2 -0.4 0.1]  ...% Pontos MF entrada dE -[-1 ... 1]
        [0.2 1 0.6 0 0.8 0.2 -0.4 0.3]  ...% Pontos MF saída kp [-1 ... 1]
        [0.2 1 0.6 0 0.8 0.2 -0.4 0.3]  ...% Pontos MF saída ki [-1 ... 1]
        [7 4 7 4 6 7 6 6 5 6 5 4 4 4 7 7 7 7 6 6 6 6 5 5 4 4 4 4 6 6 6 6 6 5 5 4 5 5 3 3 2 2 6 6 3 3 4 4 4 4 4 4 3 3 2 2 6 6 5 5 3 3 3 4 2 3 2 2 2 2 4 4 4 4 3 3 2 2 2 2 1 1 1 1 4 4 3 4 3 2 2 2 2 1 1 4 1 4] ...
        [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]; % Peso das Regras - [0 ... 1]

    population1 = parameters.Restr(1) +(parameters.Restr(2)-parameters.Restr(1))*rand(parameters.populationSize-1,2); % aplica a restrição dos universos de discusos simetricos
    population2 = parameters.Restr(3) +(parameters.Restr(4)-parameters.Restr(3))*rand(parameters.populationSize-1,2);
    population3 = parameters.Restr(5) +(parameters.Restr(6)-parameters.Restr(5))*rand(parameters.populationSize-1,32);
    population4 = parameters.Restr(7) +(parameters.Restr(8)-parameters.Restr(7))*rand(parameters.populationSize-1,98);
    population5 = parameters.Restr(7) +(parameters.Restr(10)-parameters.Restr(9))*rand(parameters.populationSize-1,49);

    population = [ini_ind;population1 population2 population3 population4 population5];


%Looping principal --------------------------------------------------------
    for i=1:parameters.maxGenerations


        clearvars -except population kbests_Chrom count parameters generationsNeeded i cont_simu
        close_system('buck_pv_otm_step_ref', 0);
        Simulink.sdi.clear;

        [fitness, cont] = evaluatePopulation(parameters,population);
        cont_simu = cont_simu + cont

%Definição dos k melhores, segundo o critério, a cada geração --------------------------------------------------------        
        [z,I] = maxMin(parameters.criterion,fitness,parameters.k);
        
% critério de parada --------------------------------------------------------
              
        % 
        % [stop ,parameters, count] = stopTest(parameters,z,count);
        % 
        % count
        % 
        % if stop ;break;end
    
%Cria uma matriz com os K's melhores individuos de cada geração e os concatena. Assim para cada multiplo inteiro de K tem-se uma geração  --------------------------------------------------------
    kbests_Chrom = [kbests_Chrom; population(I(1:parameters.k,1),1:parameters.chromosomeLength) z(1:parameters.k,1)];
   
    kbests_Chrom(:,end)

    best_subject = kbests_Chrom((generationsNeeded-1)*parameters.k + 1,:);
    best_fitness = best_subject(1,end);
    fid = fopen('Fitness_evo.txt', 'a');
    fprintf(fid, '%f \n', best_fitness);

%Salva resultados parciais e limpa a memória a cada 5 gerações --------------------------------------------------------   
        if mod(i,5)==0

           
            best_subject = kbests_Chrom((generationsNeeded-1)*parameters.k + 1,:);
            best_fitness = best_subject(1,end);

            fid = fopen('Resultados parciais.txt', 'a');         
        
            fprintf(fid,'\n -----------------------------------------------------\n');
            fprintf(fid,'O melhor valor encontrado foi %f na posição [%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f]\n',best_fitness,best_subject);
            fprintf(fid,'\nCom um numero de iterações de %d \n', i);
            fprintf(fid,'\nCom um numero de simulações de %d \n', cont_simu);
            fprintf(fid,'-----------------------------------------------------\n\n');        
         
            fclose(fid);
        end

% Seleção (Método de Torneio) --------------------------------------------------------        
        selectedPopulation = tournamentSelection(parameters,fitness,population);
        
%Crossover --------------------------------------------------------
        sizeTest = mod(size(selectedPopulation,1),2);
        newPopulation1 = crossover(parameters,selectedPopulation,sizeTest);
        
% Mutação --------------------------------------------------------
        newPopulation2 = mutation(parameters,newPopulation1,sizeTest);
    
        population = newPopulation2;


%  % Elitismo -------------------------------------------------------- 
%     
% 
%         population(randi([1,parameters.populationSize],1,1),:) = best_ind(1,1:parameters.chromosomeLength); %O melhor individuo substitui aleatoriamente um individuo
%    
%  

generationsNeeded = i  
    end
end