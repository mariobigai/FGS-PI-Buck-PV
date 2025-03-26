clc;
clear;

%Fis inicial --------------------------------------------------------
tic

ini_ind = [[1/3 0.1]  ...% Ganhos de fuzificação ke kde - [0 ... 10]
      [0.0015 1.5] ... % Ganhos de defuzificação kkp kki - [0 ... 1]
      [0.2 1 0.6 0 0.8 0.2 -0.4 0.1] ... % Pontos MF entrada E - [-1 ... 1]
      [0.2 1 0.6 0 0.8 0.2 -0.4 0.1]  ...% Pontos MF entrada dE -[-1 ... 1]
      [0.2 1 0.6 0 0.8 0.2 -0.4 0.3]  ...% Pontos MF saída kp [-1 ... 1]
      [0.2 1 0.6 0 0.8 0.2 -0.4 0.3]  ...% Pontos MF saída ki [-1 ... 1]
      [7 4 7 4 6 7 6 6 5 6 5 4 4 4 7 7 7 7 6 6 6 6 5 5 4 4 4 4 6 6 6 6 6 5 5 4 5 5 3 3 2 2 6 6 3 3 4 4 4 4 4 4 3 3 2 2 6 6 5 5 3 3 3 4 2 3 2 2 2 2 4 4 4 4 3 3 2 2 2 2 1 1 1 1 4 4 3 4 3 2 2 2 2 1 1 4 1 4] ...
      [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]; % Peso das Regras - [0 ... 1]

% Parameters --------------------------------------------------------
parameters.populationSize = 50;

parameters.chromosomeLength = 183;

parameters.maxGenerations = 200;

parameters.mutationRate = 0.03;

parameters.crossoverRate = 0.35;

parameters.Restr = [[0 5] [0 5] [-1 1] [-7 7] [0 1]];

parameters.tournamentSize = 20;

parameters.criterion = 0;%criterio para maximizar (1) ou para minimizar (0) a função objetivo

parameters.k = 1;%parametro para printar no commandWindow os K's melhores de cada geração

parameters.runsNumber = 10;

parameters.fitnessRef = 0.144986;

% parameters.fitnessRef = 0.5696;% (valor de fitness com média movel e IAE's separadas)
% parameters.fitnessRef = 0.1632; %(valor de fitness com média movel e só IAE. Serve para o metodo 2)
%1.5982(valor de fitness sem média movel)

parameters.countmax = 10;% define o numero de vezes que o fitness de referencia deve ser superado

%Adiciona o caminho dos otimizadores --------------------------------------------------------
addpath('E:\Mario\Otimização\NewFis\StepRef\Ga')

%Carrega o sistema --------------------------------------------------------
load_system('buck_pv_otm_step_vref.slx');
warning('off','all')


% Configura os parâmetros da simulação --------------------------------------------------------
%set_param('buck_pvLucas', 'StopTime', '4','SimulationMode','accelerator')

% Deleta o parallel pool atual sem criar um.
% delete(gcp('nocreate'))
% 
% % %Inicia o pool de trabalhadores paralelos --------------------------------------------------------
% parpool('local',6); 



% Chama o otimizador --------------------------------------------------------
% for n = 1:10
[kbests_Chrom,generationsNeeded, cont_simu] = Ga(parameters);

enlapsedTime =toc; 

% Separa o melhor individuo+fitness retornado pela otimização --------------------------------------------------------
best_subject = kbests_Chrom(end-parameters.k+1,1:parameters.chromosomeLength);
best_fitness = kbests_Chrom(end-parameters.k+1,parameters.chromosomeLength+1);


% Imprime o resultado da otimização --------------------------------------------------------
fprintf('\nGA -----------------------------------------------------\n');
fprintf('O melhor valor encontrado foi %f na posição [',best_fitness); fprintf('%f ', best_subject); fprintf(']');
fprintf('\nCom um numero de iterações de %d e tempo de %f \n', generationsNeeded,enlapsedTime);
fprintf('\nCom um numero de simulações %d \n', cont_simu);
fprintf('-----------------------------------------------------\n\n');      

% Abrindo/criando um arquivo .txt ('w' para sobreescrever o texto anterior e 'a' para adicionar texto ao anterior)  --------------------------------------------------------
fid = fopen('Resultados.txt', 'a');

% Verificando se o arquivo foi aberto corretamente
if fid == -1
    error('Não foi possível abrir o arquivo.');
end

% Escrevendo o resultado no arquivo
fprintf(fid,'\nGA -----------------------------------------------------\n');
fprintf(fid,'O melhor valor encontrado foi %f na posição[',best_fitness); fprintf(fid, '%f ', best_subject); fprintf(fid, ']');
fprintf(fid,'\nCom um numero de iterações de %d e tempo de %f \n', generationsNeeded,enlapsedTime);
fprintf(fid,'\nCom um numero de simulações de %d \n', cont_simu);
fprintf(fid,'-----------------------------------------------------\n\n'); 

%Fechando o arquivo  --------------------------------------------------------
fclose(fid);
disp('Resultado salvo em resultado.txt')

% end



% %Traça a comparação dos erros do fis inicial e do fis otimizado  --------------------------------------------------------
% figure(1);clf();title('Error Evolution');hold on  
% errorEV(ini_ind,best_subject)
% legend('Otimized error','Original error')
% 
% % Traça o perfil de evolução do fitness do melhor, mediano e pior individuo --------------------------------------------------------
% figure(2);clf();title('Fitness X GenerationsNeeded');hold on
% 
% plot2d(parameters,generationsNeeded,kbests_Chrom);
% 
% % Traça o perfil de fitness normalizado --------------------------------------------------------
% figure(3);clf();title('Fitness X GenerationsNeeded (Norm)');hold on
% 
% plotNorm(parameters,generationsNeeded,kbests_Chrom);


% fis = fis_Ini;
% figure(3);clf();
% 
% subplot(3,1,1)
% plotmf(fis_Ini,'input',1)
% subplot(3,1,2)
% plotmf(fis_Ini,'input',2)
% subplot(3,1,3)
% plotmf(fis_Ini,'output',1)
% 
% 
% fis = newFis(fis_Ini,kbests_Chrom(parameters.k*generationsNeeded-(parameters.k-1),:)) ;
% 
% figure(4);clf();
% 
% subplot(3,1,1)
% plotmf(fis_Ini,'input',1)
% subplot(3,1,2)
% plotmf(fis_Ini,'input',2)
% subplot(3,1,3)
% plotmf(fis_Ini,'output',1)






% [BoxV, BoxG] = Boxplot(parameters);