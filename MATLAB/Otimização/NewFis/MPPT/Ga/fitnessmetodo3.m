function fitness = fitnessmetodo3(error, kp, ki)
% Fitness baseado na IAE com punição de erro estacionário e kp e ki fora do
% do valor de ressonância em RP

% tira o transitório incial e começa a calcular a IAE a partir dos outros transitórios
n11 = find(error(:,1)<0.1); n11 = n11(end);
n12 = find(error(:,1)<0.1+40e-3); n12 = n12(end);

n21 = find(error(:,1)<0.2); n21 = n21(end);
n22 = find(error(:,1)<0.2+40e-3); n22 = n22(end);

n31 = find(error(:,1)<0.3); n31 = n31(end);
n32 = find(error(:,1)<0.3+40e-3); n32 = n32(end);

n41 = find(error(:,1)<0.35); n41 = n41(end);
n42 = find(error(:,1)<0.35+40e-3); n42 = n42(end);

n51 = find(error(:,1)<0.4); n51 = n51(end);
n52 = find(error(:,1)<0.4+40e-3); n52 = n52(end);

n61 = find(error(:,1)<0.45); n61 = n61(end);
n62 = find(error(:,1)<0.45+40e-3); n62 = n62(end);

n71 = find(error(:,1)<0.5); n71 = n71(end);
n72 = find(error(:,1)<0.5+40e-3); n72 = n72(end);

n81 = find(error(:,1)<0.55); n81 = n81(end);
n82 = find(error(:,1)<0.55+40e-3); n82 = n82(end);

n91 = find(error(:,1)<0.6); n91 = n91(end);
n92 = find(error(:,1)<0.6+40e-3); n92 = n92(end);

n101 = find(error(:,1)<0.65); n101 = n101(end);
n102 = find(error(:,1)<0.65+40e-3); n102 = n102(end);

n111 = find(error(:,1)<0.7); n111 = n111(end);
n112 = find(error(:,1)<0.7+40e-3); n112 = n112(end);

n121 = find(error(:,1)<0.75); n121 = n121(end);
n122 = find(error(:,1)<0.75+40e-3); n122 = n122(end);

n11_ganhos = find(kp(:,1)<0.1); n11_ganhos = n11_ganhos(end);
n12_ganhos = find(kp(:,1)<0.1+40e-3); n12_ganhos = n12_ganhos(end);

n21_ganhos = find(kp(:,1)<0.2); n21_ganhos = n21_ganhos(end);
n22_ganhos = find(kp(:,1)<0.2+40e-3); n22_ganhos = n22_ganhos(end);

n31_ganhos = find(kp(:,1)<0.3); n31_ganhos = n31_ganhos(end);
n32_ganhos = find(kp(:,1)<0.3+40e-3); n32_ganhos = n32_ganhos(end);

n41_ganhos = find(kp(:,1)<0.35); n41_ganhos = n41_ganhos(end);
n42_ganhos = find(kp(:,1)<0.35+40e-3); n42_ganhos = n42_ganhos(end);

n51_ganhos = find(kp(:,1)<0.4); n51_ganhos = n51_ganhos(end);
n52_ganhos = find(kp(:,1)<0.4+40e-3); n52_ganhos = n52_ganhos(end);

n61_ganhos = find(kp(:,1)<0.45); n61_ganhos = n61_ganhos(end);
n62_ganhos = find(kp(:,1)<0.45+40e-3); n62_ganhos = n62_ganhos(end);

n71_ganhos = find(kp(:,1)<0.5); n71_ganhos = n71_ganhos(end);
n72_ganhos = find(kp(:,1)<0.5+40e-3); n72_ganhos = n72_ganhos(end);

n81_ganhos = find(kp(:,1)<0.55); n81_ganhos = n81_ganhos(end);
n82_ganhos = find(kp(:,1)<0.55+40e-3); n82_ganhos = n82_ganhos(end);

n91_ganhos = find(kp(:,1)<0.6); n91_ganhos = n91_ganhos(end);
n92_ganhos = find(kp(:,1)<0.6+40e-3); n92_ganhos = n92_ganhos(end);

n101_ganhos = find(kp(:,1)<0.65); n101_ganhos = n101_ganhos(end);
n102_ganhos = find(kp(:,1)<0.65+40e-3); n102_ganhos = n102_ganhos(end);

n111_ganhos = find(kp(:,1)<0.7); n111_ganhos = n111_ganhos(end);
n112_ganhos = find(kp(:,1)<0.7+40e-3); n112_ganhos = n112_ganhos(end);

n121_ganhos = find(kp(:,1)<0.75); n121_ganhos = n121_ganhos(end);
n122_ganhos = find(kp(:,1)<0.75+40e-3); n122_ganhos = n122_ganhos(end);

%Amplitudes
amp_eest_v(1) = mean((error(n12:n21,2)));
amp_eest_v(2) = mean((error(n22:n31,2)));
amp_eest_v(3) = mean((error(n32:n41,2)));
amp_eest_v(4) = mean((error(n42:n51,2)));
amp_eest_v(5) = mean((error(n52:n61,2)));
amp_eest_v(6) = mean((error(n62:n71,2)));
amp_eest_v(7) = mean((error(n72:n81,2)));
amp_eest_v(8) = mean((error(n82:n91,2)));
amp_eest_v(9) = mean((error(n92:n101,2)));
amp_eest_v(10) = mean((error(n102:n111,2)));
amp_eest_v(11) = mean((error(n112:n121,2)));
amp_eest_v(12) = mean((error(n122:end,2)));

if (any(amp_eest_v > 1e-1)) || ((any(amp_eest_v < -1e-1))); pen_eest = 100; else pen_eest = 0; end

mean_kpest_v(1) = mean(kp(n12_ganhos:n21_ganhos,2));
mean_kpest_v(2) = mean(kp(n22_ganhos:n31_ganhos,2));
mean_kpest_v(3) = mean(kp(n32_ganhos:n41_ganhos,2));
mean_kpest_v(4) = mean(kp(n42_ganhos:n51_ganhos,2));
mean_kpest_v(5) = mean(kp(n52_ganhos:n61_ganhos,2));
mean_kpest_v(6) = mean(kp(n62_ganhos:n71_ganhos,2));
mean_kpest_v(7) = mean(kp(n72_ganhos:n81_ganhos,2));
mean_kpest_v(8) = mean(kp(n82_ganhos:n91_ganhos,2));
mean_kpest_v(9) = mean(kp(n92_ganhos:n101_ganhos,2));
mean_kpest_v(10) = mean(kp(n102_ganhos:n111_ganhos,2));
mean_kpest_v(11) = mean(kp(n112_ganhos:n121_ganhos,2));
mean_kpest_v(12) = mean(kp(n122_ganhos:end,2));
mean_kpest_v = round(mean_kpest_v, 4);

max_kpest_v(1) = max(kp(n12_ganhos:n21_ganhos,2));
max_kpest_v(2) = max(kp(n22_ganhos:n31_ganhos,2));
max_kpest_v(3) = max(kp(n32_ganhos:n41_ganhos,2));
max_kpest_v(4) = max(kp(n42_ganhos:n51_ganhos,2));
max_kpest_v(5) = max(kp(n52_ganhos:n61_ganhos,2));
max_kpest_v(6) = max(kp(n62_ganhos:n71_ganhos,2));
max_kpest_v(7) = max(kp(n72_ganhos:n81_ganhos,2));
max_kpest_v(8) = max(kp(n82_ganhos:n91_ganhos,2));
max_kpest_v(9) = max(kp(n92_ganhos:n101_ganhos,2));
max_kpest_v(10) = max(kp(n102_ganhos:n111_ganhos,2));
max_kpest_v(11) = max(kp(n112_ganhos:n121_ganhos,2));
max_kpest_v(12) = max(kp(n122_ganhos:end,2));

min_kpest_v(1) = min(kp(n12_ganhos:n21_ganhos,2));
min_kpest_v(2) = min(kp(n22_ganhos:n31_ganhos,2));
min_kpest_v(3) = min(kp(n32_ganhos:n41_ganhos,2));
min_kpest_v(4) = min(kp(n42_ganhos:n51_ganhos,2));
min_kpest_v(5) = min(kp(n52_ganhos:n61_ganhos,2));
min_kpest_v(6) = min(kp(n62_ganhos:n71_ganhos,2));
min_kpest_v(7) = min(kp(n72_ganhos:n81_ganhos,2));
min_kpest_v(8) = min(kp(n82_ganhos:n91_ganhos,2));
min_kpest_v(9) = min(kp(n92_ganhos:n101_ganhos,2));
min_kpest_v(10) = min(kp(n102_ganhos:n111_ganhos,2));
min_kpest_v(11) = min(kp(n112_ganhos:n121_ganhos,2));
min_kpest_v(12) = min(kp(n122_ganhos:end,2));

if (any(mean_kpest_v > 0.0055*1.01) || any(mean_kpest_v < 0.0055*0.99) || any(max_kpest_v > (0.0055*1.05))) || (any(min_kpest_v < (0.0055*0.95))); pen_kpest = 100; else; pen_kpest = 0; end

mean_kiest_v(1) = mean(ki(n12_ganhos:n21_ganhos,2));
mean_kiest_v(2) = mean(ki(n22_ganhos:n31_ganhos,2));
mean_kiest_v(3) = mean(ki(n32_ganhos:n41_ganhos,2));
mean_kiest_v(4) = mean(ki(n42_ganhos:n51_ganhos,2));
mean_kiest_v(5) = mean(ki(n52_ganhos:n61_ganhos,2));
mean_kiest_v(6) = mean(ki(n62_ganhos:n71_ganhos,2));
mean_kiest_v(7) = mean(ki(n72_ganhos:n81_ganhos,2));
mean_kiest_v(8) = mean(ki(n82_ganhos:n91_ganhos,2));
mean_kiest_v(9) = mean(ki(n92_ganhos:n101_ganhos,2));
mean_kiest_v(10) = mean(ki(n102_ganhos:n111_ganhos,2));
mean_kiest_v(11) = mean(ki(n112_ganhos:n121_ganhos,2));
mean_kiest_v(12) = mean(ki(n122_ganhos:end,2));
mean_kiest_v = round(mean_kiest_v, 2);

max_kiest_v(1) = max(ki(n12_ganhos:n21_ganhos,2));
max_kiest_v(2) = max(ki(n22_ganhos:n31_ganhos,2));
max_kiest_v(3) = max(ki(n32_ganhos:n41_ganhos,2));
max_kiest_v(4) = max(ki(n42_ganhos:n51_ganhos,2));
max_kiest_v(5) = max(ki(n52_ganhos:n61_ganhos,2));
max_kiest_v(6) = max(ki(n62_ganhos:n71_ganhos,2));
max_kiest_v(7) = max(ki(n72_ganhos:n81_ganhos,2));
max_kiest_v(8) = max(ki(n82_ganhos:n91_ganhos,2));
max_kiest_v(9) = max(ki(n92_ganhos:n101_ganhos,2));
max_kiest_v(10) = max(ki(n102_ganhos:n111_ganhos,2));
max_kiest_v(11) = max(ki(n112_ganhos:n121_ganhos,2));
max_kiest_v(12) = max(ki(n122_ganhos:end,2));

min_kiest_v(1) = min(ki(n12_ganhos:n21_ganhos,2));
min_kiest_v(2) = min(ki(n22_ganhos:n31_ganhos,2));
min_kiest_v(3) = min(ki(n32_ganhos:n41_ganhos,2));
min_kiest_v(4) = min(ki(n42_ganhos:n51_ganhos,2));
min_kiest_v(5) = min(ki(n52_ganhos:n61_ganhos,2));
min_kiest_v(6) = min(ki(n62_ganhos:n71_ganhos,2));
min_kiest_v(7) = min(ki(n72_ganhos:n81_ganhos,2));
min_kiest_v(8) = min(ki(n82_ganhos:n91_ganhos,2));
min_kiest_v(9) = min(ki(n92_ganhos:n101_ganhos,2));
min_kiest_v(10) = min(ki(n102_ganhos:n111_ganhos,2));
min_kiest_v(11) = min(ki(n112_ganhos:n121_ganhos,2));
min_kiest_v(12) = min(ki(n122_ganhos:end,2));

if (any(mean_kiest_v > 3.23*1.01) || any(mean_kiest_v < 3.23*0.99) || any(max_kiest_v > (3.23*1.05))) || (any(min_kiest_v < (3.23*0.95))); pen_kiest = 100; else; pen_kiest = 0; end
%IAE + Penalizações
erro_velho = abs(error(n11:end,2));
IAE = trapz(error(n11:end,1),erro_velho);

fitness = IAE + pen_eest + pen_kiest + pen_kpest;
end