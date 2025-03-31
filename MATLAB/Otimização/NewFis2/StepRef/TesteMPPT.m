clc
clear

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

%Carrega o sistema --------------------------------------------------------
load_system('buck_pv_MPPT2.slx');
warning('off','all')

fis = newFis2(ini_ind);
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
kE = ini_ind(1);
kdE = ini_ind(2);
kkp = ini_ind(3);       
kki = ini_ind(4);

simIn = Simulink.SimulationInput('buck_pv_MPPT2');

simIn = simIn.setVariable('kp',kp);
simIn = simIn.setVariable('ki',ki);
simIn = simIn.setVariable('kE',kE);
simIn = simIn.setVariable('kdE',kdE);
simIn = simIn.setVariable('kkp',kkp);
simIn = simIn.setVariable('kki',kki);
simIn = simIn.setVariable('kp_0',0.0055);
simIn = simIn.setVariable('ki_0',3.23);
simIn = simIn.setVariable('n_pontos',n_pontos); 

tic
simOut = sim(simIn);

error = simOut.get('erro');
error = [error.time error.data];

kp = simOut.get('kp');
kp = [kp.time kp.data];

ki = simOut.get('ki');
ki = [ki.time ki.data];

n11 = find(error(:,1)<0.1); n11 = n11(end);
erro_abs = abs(error(n11:end,2));
IAE = trapz(error(n11:end,1),erro_abs);

fitness = IAE

toc
