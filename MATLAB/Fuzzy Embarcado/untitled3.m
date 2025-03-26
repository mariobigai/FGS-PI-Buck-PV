clc
clear all

FLS_FGS_PI = readfis('FLS_FGS_PI2.fis');

n_pontos = 200
erro = linspace(-1,1,n_pontos);
derro = linspace(-1,1,n_pontos);

kp = zeros(n_pontos,n_pontos);
ki = zeros(n_pontos,n_pontos);
for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos 
        OUT = evalfis(FLS_FGS_PI, [erro(i), derro(j)]);
        kp(i,j) = OUT(1);
        ki(i,j) = OUT(2);
    end
end

kp_lut = zeros(n_pontos,n_pontos);
ki_lut = zeros(n_pontos,n_pontos);

n_pontos_tab = 21
erro_tab = linspace(-1,1,n_pontos_tab);
derro_tab = linspace(-1,1,n_pontos_tab);

kp_tab = zeros(n_pontos_tab,n_pontos_tab);
ki_tab = zeros(n_pontos_tab,n_pontos_tab);
for i =1:n_pontos_tab % Loop para mapear todos pontos
    for j =1:n_pontos_tab
        OUT = evalfis(FLS_FGS_PI, [erro_tab(i), derro_tab(j)]);
        kp_tab(i,j) = OUT(1);
        ki_tab(i,j) = OUT(2);
    end
end

for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos
        [E, dE, E1, dE1] = mapea(erro(i), derro(j));
        [kp_lut(i,j), ki_lut(i,j)] = interp(erro(i), derro(j), E, dE, E1, dE1, kp_tab(E,dE), kp_tab(E,dE1), kp_tab(E1,dE), kp_tab(E1,dE1), ki_tab(E,dE), ki_tab(E,dE1), ki_tab(E1,dE), ki_tab(E1,dE1));
    end
end
%%
erro_kp = 0;
for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos 
        erro_kp = erro_kp + ((kp(i,j) - kp_lut(i,j)))^2;
    end
end
MSE_kp  = sqrt(erro_kp/(200*200));

erro_ki = 0;
for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos
        erro_ki = erro_ki + abs((ki(i,j) - ki_lut(i,j)))^2;
    end
end
MSE_ki  = sqrt(erro_ki/(200*200));

%% 
figure(1); clf();
surf(erro, derro, kp) %Plotar a superficie
figure(2); clf();
surf(erro, derro, kp_lut)