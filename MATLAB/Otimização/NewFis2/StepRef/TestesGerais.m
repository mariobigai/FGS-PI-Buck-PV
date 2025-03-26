clc
clear
tic
%Fis inicial --------------------------------------------------------
ini_ind = [[1/3 0.1]  ...% Ganhos de fuzificação ke kde - [0 ... 10]
      [0.0015 1.5] ... % Ganhos de defuzificação kkp kki - [0 ... 1]
      [0.2 0.2 0.5 0.2] ... % Pontos MF entrada E - [0 ... 1]
      [0.2 0.2 0.5 0.2]  ...% Pontos MF entrada dE -[0 ... 1]
      [0.2 0.2 0.5 0.2]  ...% Pontos MF saída kp [0 ... 1]
      [0.2 0.2 0.5 0.2]  ...% Pontos MF saída ki [0 ... 1]
      [5 5 5 5 4 4 4 4 3 3 5 5 4 4 4 4 3 3 2 2 4 4 4 4 3 3 2 2 2 2 4 4 3 3 2 2 2 2 1 1 3 3 2 2 2 2 1 1 1 1] ...  %Regras [-5, ... 5]
      [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]; % Peso das Regras - [0 ... 1]

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
addpath('D:\Google Sync\Mestrado\2 - Dissertação\Parceria Eletrônica de Potência\Projetos\Buck_PV_Charger\MATLAB\Buck_PV_Simulink\Otimização\NewFis2 (1)\StepRef\Ga')


%Carrega o sistema --------------------------------------------------------
load_system('buck_pv_otm_step_vref2.slx');
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
