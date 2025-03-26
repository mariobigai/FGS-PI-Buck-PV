clc;
clear all;

%Fis inicial --------------------------------------------------------
ini_ind = [[1/3 0.1]  ...% Ganhos de fuzificação ke kde - [0 ... 10]
      [0.0015 1.5] ... % Ganhos de defuzificação kkp kki - [0 ... 1]
      [0.2 0.2 0.5 0.2] ... % Pontos MF entrada E - [0 ... 1]
      [0.2 0.2 0.5 0.2]  ...% Pontos MF entrada dE -[0 ... 1]
      [0.2 0.2 0.5 0.2]  ...% Pontos MF saída kp [0 ... 1]
      [0.2 0.2 0.5 0.2]  ...% Pontos MF saída ki [0 ... 1]
      [5 5 5 5 4 4 4 4 3 3 5 5 4 4 4 4 3 3 2 2 4 4 4 4 3 3 2 2 2 2 4 4 3 3 2 2 2 2 1 1 3 3 2 2 2 2 1 1 1 1] ...  %Regras [-5, ... 5]
      [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]; % Peso das Regras - [0 ... 1]

% ini_ind = [0.249612 0.020610 0.014174 0.969422 0.001874 0.204856 0.813888 0.030469 0.335244 0.034198 0.783849 0.051893 0.691947 0.080850 0.830662 0.797502 0.002353 0.059000 0.826142 0.122094 0.975171 0.171594 0.001130 0.012312 0.000117 0.060765 0.000002 0.998462 0.174112 0.748719 0.005274 0.124989 0.453952 0.933224 0.556688 0.455020 0.157184 0.868277 0.490868 0.249955];

% Parameters --------------------------------------------------------
parameters.populationSize = 50;

parameters.chromosomeLength = 95;

parameters.maxGenerations = 200;

parameters.mutationRate = 0.03;

parameters.crossoverRate = 0.35;

parameters.Restr = [[0 5] [0 5] [0 1] [-5 5] [0 1]];

parameters.tournamentSize = 20;

parameters.criterion = 0;%criterio para maximizar (1) ou para minimizar (0) a função objetivo

parameters.k = 1 ;%parametro para printar no commandWindow os K's melhores de cada geração

parameters.runsNumber = 10;

parameters.fitnessRef = 0.144986;

parameters.countmax = 10;% define o numero de vezes que o fitness de referencia deve ser superado

%Adiciona o caminho dos otimizadores --------------------------------------------------------
addpath('C:\Users\UTFPR\Desktop\Mario\Otimização\NewFis2\MPPT\Ga')


%Carrega o sistema --------------------------------------------------------
load_system('buck_pv_otm_MPPT2.slx');
warning('off','all')

% Configura os parâmetros da simulação --------------------------------------------------------
%set_param('buck_pvLucas', 'StopTime', '4','SimulationMode','accelerator')

% % Deleta o parallel pool atual sem criar um.
% delete(gcp('nocreate'))
% 
% % %Inicia o pool de trabalhadores paralelos --------------------------------------------------------
% parpool('local',2); 

% Chama o otimizador --------------------------------------------------------
tic
[kbests_Chrom,generationsNeeded, cont_simu] = Ga(parameters);

enlapsedTime =toc; 

% Separa o melhor individuo+fitness retornado pela otimização --------------------------------------------------------
best_subject = kbests_Chrom(end-parameters.k+1,1:parameters.chromosomeLength);
best_fitness = kbests_Chrom(end-parameters.k+1,parameters.chromosomeLength+1);

% Imprime o resultado da otimização --------------------------------------------------------
fprintf('\nGA -----------------------------------------------------\n');
%fprintf('O melhor valor encontrado foi %f na posição [%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f]',best_fitness,best_subject);
fprintf('O melhor valor encontrado foi %f na posição [',best_fitness); fprintf('%f ',best_subject); fprintf('] \n');
fprintf('\nCom um numero de iterações de %d e tempo de %f \n', generationsNeeded,enlapsedTime);
fprintf('\nCom um numero de simulações de %d \n', cont_simu);
fprintf('-----------------------------------------------------\n\n');      

% Abrindo/criando um arquivo .txt ('w' para sobreescrever o texto anterior e 'a' para adicionar texto ao anterior)  --------------------------------------------------------
fid = fopen('Resultados.txt', 'a');

% Verificando se o arquivo foi aberto corretamente
if fid == -1
    error('Não foi possível abrir o arquivo.');
end

% Escrevendo o resultado no arquivo
fprintf(fid,'\nGA -----------------------------------------------------\n');
%fprintf(fid,'O melhor valor encontrado foi %f na posição [%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f]',best_fitness,best_subject);
fprintf(fid, 'O melhor valor encontrado foi %f na posição [',best_fitness); fprintf(fid, '%f ',best_subject); fprintf(fid, '] \n');
fprintf(fid,'\nCom um numero de iterações de %d e tempo de %f \n', generationsNeeded,enlapsedTime);
fprintf(fid,'\nCom um numero de simulações de %d \n', cont_simu);
fprintf(fid,'-----------------------------------------------------\n\n');      

% Fechando o arquivo  --------------------------------------------------------
fclose(fid);
disp('Resultado salvo em resultado.txt')

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