function fitness = fitnessmetodo3(error, kp, ki)
% Fitness baseado na IAE com punição de erro estacionário e kp e ki fora do
% do valor de ressonância em RP

% tira o transitório incial e começa a calcular a IAE a partir dos transitórios de temperatura
n11 = find(error(:,1)<0.1); n11 = n11(end);
n12 = find(error(:,1)<0.1+50e-3); n12 = n12(end);

n21 = find(error(:,1)<0.2); n21 = n21(end);
n22 = find(error(:,1)<0.2+50e-3); n22 = n22(end);

n11_ganhos = find(kp(:,1)<0.1); n11_ganhos = n11_ganhos(end);
n12_ganhos = find(kp(:,1)<0.1+50e-3); n12_ganhos = n12_ganhos(end);

n21_ganhos = find(kp(:,1)<0.2); n21_ganhos = n21_ganhos(end);
n22_ganhos = find(kp(:,1)<0.2+50e-3); n22_ganhos = n22_ganhos(end);

%Amplitudes
amp_eest_v(1) = mean((error(n12:n21,2)));
amp_eest_v(2) = mean((error(n22:end,2)));

if (any(amp_eest_v > 1e-1)) || ((any(amp_eest_v < -1e-1))); pen_eest = 100; else pen_eest = 0; end

mean_kpest_v(1) = mean(kp(n12_ganhos:n21_ganhos,2));
mean_kpest_v(2) = mean(kp(n22_ganhos:end,2));
mean_kpest_v = round(mean_kpest_v, 4);

max_kpest_v(1) = max(kp(n12_ganhos:n21_ganhos,2));
max_kpest_v(2) = max(kp(n22_ganhos:end,2));

min_kpest_v(1) = min(kp(n12_ganhos:n21_ganhos,2));
min_kpest_v(2) = min(kp(n22_ganhos:end,2));

if (any(mean_kpest_v > 0.0055*1.01) || any(mean_kpest_v < 0.0055*0.99) || any(max_kpest_v > (0.0055*1.05))) || (any(min_kpest_v < (0.0055*0.95))); pen_kpest = 100; else; pen_kpest = 0; end

mean_kiest_v(1) = mean(ki(n12_ganhos:n21_ganhos,2));
mean_kiest_v(2) = mean(ki(n22_ganhos:end,2));
mean_kiest_v = round(mean_kiest_v, 2);

max_kiest_v(1) = max(ki(n12_ganhos:n21_ganhos,2));
max_kiest_v(2) = max(ki(n22_ganhos:end,2));

min_kiest_v(1) = min(ki(n12_ganhos:n21_ganhos,2));
min_kiest_v(2) = min(ki(n22_ganhos:end,2));

if (any(mean_kiest_v > 3.23*1.01) || any(mean_kiest_v < 3.23*0.99) || any(max_kiest_v > (3.23*1.05))) || (any(min_kiest_v < (3.23*0.95))); pen_kiest = 100; else; pen_kiest = 0; end

%IAE + Penalizações
erro_velho = abs(error(n11:end,2));
IAE = trapz(error(n11:end,1),erro_velho);

fitness = IAE + pen_eest + pen_kiest + pen_kpest;
end