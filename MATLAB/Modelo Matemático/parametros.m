%% Declaração dos Parâmetros do Painel (PV ARRAY (Simulink): 1000 W/m2 @ 25°C -> Vmpp = 37.3 V, Impp = 8.85 A)
eta=1.4; % Fator de qualidade (Otimização)
Isc=8.21; % Corrente CC
alpha = 0.003177; % coef de Isc 
k=1.38E-23; %8.62E-5; % Boltzmann
q=1.6E-19; % Carga elementar
EG = 1.12; % Energia de banda proibida
Rs_cell = 0.0045;
Rp_cell = 2.116;
Tr=298; % Temperatura de referência
Voc=32.9; % Tensão CA
n_cell = 45; % Número de Células PV em Série
Irr = 1.26e-8; % Corrente de satiração reversa de referência (Otimização)

%% Parâmetros do conversor Buck
Vbat = 12; % Tensão da Bateria
L  = 22.109e-6; % Indutância
Rl = 3e-3; % Resistência CC Indutor
Cin = 2.7e-3; % Capacitância de Entrada
Rcin = 6.519e-3; %Resistência Relacionada a Capacitância de Entrada 
%Ron = 6.5e-3; % Resistência MOSFET
Ron = 0.15; % Estimação de perdas - sistema mais amortecido
Vto = 1; % Tensão Direta DIODO

%% Parametros PI
kp_0 = 0.0055;
ki_0 = 3.23;
kE = 0.3333;
kdE = 0.1;
kkp = 0.0015;
kki = 1.5;