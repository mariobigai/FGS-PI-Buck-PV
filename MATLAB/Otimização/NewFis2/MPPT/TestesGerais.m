clc
clear
tic
%Fis inicial --------------------------------------------------------
% ini_ind = [[1/3 0.1]  ...% Ganhos de fuzificação ke kde - [0 ... 10]
%       [0.0015 1.5] ... % Ganhos de defuzificação kkp kki - [0 ... 1]
%       [0.2 0.2 0.5 0.2] ... % Pontos MF entrada E - [0 ... 1]
%       [0.2 0.2 0.5 0.2]  ...% Pontos MF entrada dE -[0 ... 1]
%       [0.2 0.2 0.5 0.2]  ...% Pontos MF saída kp [0 ... 1]
%       [0.2 0.2 0.5 0.2]  ...% Pontos MF saída ki [0 ... 1]
%       [5 5 5 5 4 4 4 4 3 3 5 5 4 4 4 4 3 3 2 2 4 4 4 4 3 3 2 2 2 2 4 4 3 3 2 2 2 2 1 1 3 3 2 2 2 2 1 1 1 1] ...  %Regras [-5, ... 5]
%       [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]; % Peso das Regras - [0 ... 1]

ini_ind = [0.333333 0.475256 0.002337 3.949520 0.133375 0.200000 0.500000 0.070644 0.039174 0.200000 0.500000 0.171717 0.200000 0.200000 0.631075 0.005577 0.825800 0.097465 0.854142 0.389314 -0.038396 3.206204 -0.318138 -1.470180 0.948951 4.000000 -0.957620 0.727674 0.929792 0.130742 4.408422 5.000000 4.428938 0.417871 0.552244 4.000000 0.161352 4.406024 -1.065053 0.152762 -2.192883 0.005707 -4.404515 4.000000 0.016262 3.000000 -1.694826 0.038771 -0.005633 -4.231907 0.665304 -0.228326 1.177742 4.003674 -0.353094 -0.564626 -0.221382 0.645754 0.111498 4.842746 -0.224057 1.069113 -0.000789 3.741213 0.801523 0.056661 1.078006 -0.281346 -0.229593 3.945247 0.010490 0.099741 0.994459 0.002039 0.066387 0.689582 0.959001 0.909187 0.963938 0.073910 0.071294 0.276329 0.422878 0.194831 0.635032 0.173337 0.851281 0.710456 0.054540 0.245542 0.078739 0.329410 0.070955 0.704824 0.253716];

% Parameters --------------------------------------------------------
parameters.populationSize = 50;

parameters.chromosomeLength = 95;

parameters.maxGenerations = 100;

parameters.mutationRate = 0.03;

parameters.crossoverRate = 0.35;

parameters.Restr = [[0 5] [0 5] [0 1] [-5 5] [0 1]];

parameters.tournamentSize = 20;

parameters.criterion = 0;%criterio para maximizar (1) ou para minimizar (0) a função objetivo

parameters.k = 5;%parametro para printar no commandWindow os K's melhores de cada geração

parameters.runsNumber = 10;

parameters.fitnessRef = 0.144986;

% parameters.fitnessRef = 0.5696;% (valor de fitness com média movel e IAE's separadas)
% parameters.fitnessRef = 0.1632; %(valor de fitness com média movel e só IAE. Serve para o metodo 2)
%1.5982(valor de fitness sem média movel)

parameters.countmax = 10;% define o numero de vezes que o fitness de referencia deve ser superado


%Adiciona o caminho dos otimizadores --------------------------------------------------------
addpath('C:\Users\UTFPR\Desktop\Mario\Otimização\NewFis2\MPPT\Ga')


%Carrega o sistema --------------------------------------------------------
load_system('buck_pv_otm_MPPT2.slx');
warning('off','all')

% %Estabelece os inputs da simulação
% simIn = Simulink.SimulationInput('buck_pvLucas');
% simIn = simIn.setVariable('fis',fis);
% simIn = simIn.setVariable('E',E);
% simIn = simIn.setVariable('delE',delE);
% simIn = simIn.setVariable('FlcOut',FlcOut);
% 
% % Executa a simulação e captura o output --------------------------------------------------------
% simOut = sim(simIn);
% 
% 
% error = simOut.get('erro');
% error = [error.time error.data];
% 
% fitness(j,1) = fitnessmetodo1(error);
% 

[fitness, cont_simu] = evaluatePopulation(parameters,ini_ind)

toc
