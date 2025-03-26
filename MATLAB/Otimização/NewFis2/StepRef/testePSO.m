clc;
clear;


%Inicia o timer  --------------------------------------------------------
tic 

%Fis inicial --------------------------------------------------------

discourseUniverse_E = [-1 1];
discourseUniverse_delE = [-1 1];
discourseUniverse_U= [-15 15];


fis_Ini = mamfis("Name","FLC",'DefuzzificationMethod','centroid');

fis_Ini = addInput(fis_Ini,discourseUniverse_E,"Name","E");
fis_Ini = addMF(fis_Ini,"E","trimf",  [-1 -1 1],"Name","N");
fis_Ini = addMF(fis_Ini,"E","trimf",  [-1 1 1],"Name","P");




fis_Ini = addInput(fis_Ini,discourseUniverse_delE,"Name","delE");
fis_Ini = addMF(fis_Ini,"delE","trimf",  [-1 -1 1],"Name","N");
fis_Ini = addMF(fis_Ini,"delE","trimf",  [-1 1 1],"Name","P");




fis_Ini = addOutput(fis_Ini,discourseUniverse_U,"Name","U");
fis_Ini = addMF(fis_Ini,"U","trapmf",   [-15 -15 -9 0],"Name","N");
fis_Ini = addMF(fis_Ini,"U","trimf",   [-3 0 3],"Name","Z");
fis_Ini = addMF(fis_Ini,"U","trapmf",    [0 9 15 15],"Name","P");


ruleList = [1 1 1 1 1;%1
            1 2 2 1 1;%2
            2 1 2 1 1;%3
            2 2 3 1 1];%4

fis_Ini = addRule(fis_Ini,ruleList);

fis = fis_Ini;


% Parâmetros do PSO

parameters.num_particles = 100;      % Número de partículas
parameters.max_iter = 40;          % Número máximo de iterações
parameters.dim = 11;                 % Dimensão do problema ([[limite inferior E limite superior E] [limite inferior delE limite inferior delE] [limite inferior saida limite inferior saida] ])
parameters.w = 0.5;                 % Inércia
parameters.c1 = 2;                % Coeficiente cognitivo (aprendizado pessoal)
parameters.c2 = 0.5;                  % Coeficiente social (aprendizado do enxame)
parameters.Restr = [ [0 100] [1 3] [0 1] ];
parameters.criterion = 0;       % 1 para maximizar, 0 para minimizar
parameters.k = 5;
parameters.runsNumber = 10;     %Numero de rodagens do codigo
parameters.fitnessRef = 2.5066;

%Adiciona o caminho dos otimizadores --------------------------------------------------------
addpath('C:\Users\lucas\Documents\planejamento das aulas\Eletrica\Iniciacao\FuzzyVsPID\PSO')


%Carrega o sistema --------------------------------------------------------
load_system('PidVsFuzzy');
warning('off','all')


% Configura os parâmetros da simulação --------------------------------------------------------
set_param('PidVsFuzzy', 'StopTime', '15','SimulationMode','accelerator')


% Chama o otimizador --------------------------------------------------------
% [LastPositions,g_bestEV,p_bestEV, iterationsNeeded] = PSO(fis,parameters);
[LastPositions,g_bestEV, iterationsNeeded] = PSO(parameters);


% Separa a melhor posição + fitness retornada pela otimização --------------------------------------------------------
best_subject = g_bestEV(end,1:parameters.dim);
best_fitness = g_bestEV(end,parameters.dim+1);

% Imprime o resultado da otimização --------------------------------------------------------    
fprintf('O melhor valor encontrado foi %f na posição [ %f %f %f %f %f %f %f ]',best_fitness,best_subject);
fprintf('\nCom um numero de iterações de %d \n\n', iterationsNeeded);
fprintf('-----------------------------------------------------\n\n')


%Fecha o timer  --------------------------------------------------------
toc



% Abrindo/criando um arquivo .txt ('w' para sobreescrever o texto anterior e 'a' para adicionar texto ao anterior)
fid = fopen('Resultados.txt', 'a');


% Verificando se o arquivo foi aberto corretamente
if fid == -1
    error('Não foi possível abrir o arquivo.');
end


% Escrevendo o resultado no arquivo
fprintf(fid,'\nPSO -----------------------------------------------------\n');
fprintf(fid,'O melhor valor encontrado foi %f na posição [ %f %f %f %f %f %f %f ]',best_fitness,best_subject);
fprintf(fid,'\nCom um numero de iterações de %d \n', iterationsNeeded);
fprintf(fid,'-----------------------------------------------------\n\n');

% Fechando o arquivo  --------------------------------------------------------
fclose(fid);
disp('Resultado salvo em resultado.txt');


% Traça o perfil de evolução do fitness do melhor --------------------------------------------------------
figure(1);clf();title('Fitness X iterationsNeeded');hold on
plot2d(parameters,g_bestEV);


% Traça o perfil de fitness normalizado --------------------------------------------------------
figure(2);clf();title('Fitness X iterationsNeeded (Norm)');hold on
plotNorm(parameters,g_bestEV);


% [BoxX, BoxI] = Boxplot(fis,parameters)


%Traça a comparação dos erros do fis inicial e do fis otimizado  --------------------------------------------------------
figure(3);clf();title('Error Evolution');hold on  
errorEV(fis_Ini,best_subject)

