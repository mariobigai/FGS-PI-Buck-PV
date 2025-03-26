
clc;
clear;

% Parâmetros do PSO
parameters.num_particles = 100;      % Número de partículas
parameters.max_iter = 100;          % Número máximo de iterações
parameters.dim = 2;                 % Dimensão do problema
parameters.w = 0.7;                 % Inércia
parameters.c1 = 1.5;                % Coeficiente cognitivo (aprendizado pessoal)
parameters.c2 = 1;                  % Coeficiente social (aprendizado do enxame)
parameters.x_min = -500;              % Limites do problema
parameters.x_max = 500;               %
parameters.criterion = 1;           % 1 para maximizar, 0 para minimizar
parameters.runsNumber = 30;         %Numero de rodagens do codigo


[LastPositions,g_bestEV,fitnessEV, iterationsNeeded] = PSO(parameters);

fprintf('O melhor valor encontrado foi %f na posição [%f %f]\n', goalFunction(g_best), g_best);
fprintf('Com um numero de iterações de %d \n\n', iterationsNeeded);

fprintf('-----------------------------------------------------\n\n')






plot_Firs_Mid_Last(LastPositions,fitnessEV,g_bestEV,iterationsNeeded,parameters);

Boxplot(parameters)







