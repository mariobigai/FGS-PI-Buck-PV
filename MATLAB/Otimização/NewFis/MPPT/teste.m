%% FLS FGS-PI (original) - 7VL Triangulares Deffuz MOM ou Centroide
clear
clc
x = [[1/3 1]  ...% Ganhos de fuzificação ke kde - [0 ... 10]
      [0.00013 0.036] ... % Ganhos de defuzificação kkp kki - [0 ... 1]
      [0.4 1 0.6 0 0.8 0.2 -0.4 0.1] ... % Pontos MF entrada E - [-1 ... 1]
      [0.4 1 0.6 0 0.8 0.2 -0.4 0.1]  ...% Pontos MF entrada dE -[-1 ... 1]
      [0.4 1 0.6 0 0.8 0.2 -0.4 0.1]  ...% Pontos MF saída kp [-1 ... 1]
      [0.4 1 0.6 0 0.8 0.2 -0.4 0.1]  ...% Pontos MF saída ki [-1 ... 1]
      [7 4 7 4 6 7 6 6 5 6 5 4 4 4 7 7 7 7 6 6 6 6 5 5 4 4 4 4 6 6 6 6 6 5 5 4 5 5 3 3 2 2 6 6 3 3 4 4 4 4 4 4 3 3 2 2 6 6 5 5 3 3 3 4 2 3 2 2 2 2 4 4 4 4 3 3 2 2 2 2 1 1 1 1 4 4 3 4 3 2 2 2 2 1 1 4 1 4] ...
      [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]; % Peso das Regras - [0 ... 1]

FLS_FGS_PI = newFis(x);