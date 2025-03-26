clear
clc

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

%% Condições Operacionais

% MPP p/ 
% 1000 W/m2 @ 25°C => Vpv=37.3; Ipv=8.85; Ppv=337.369
% 800 W/m2 @ 20ºC => Vpv=38.8376;  Ipv=8.8107; Ppv=342.187
% 600 W/m2 @ 15ºC => Vpv= 35.7681; Ipv=8.83706; Ppv=325.4339
% 400 W/m2  @ 10ºC => Vpv= 37.5598; Ipv=7.06448; Ppv=265.341
% 200 W/m2  @ 5ºC => Vpv= 37.5373; Ipv=3.5495; Ppv=113.105

T = [25, 45];
G = [1000, 800];
Vpv = [26.5 25.5];
Ipv = [7.5 5.81];
Ppv = Ipv.*Vpv;

%% Linearização do PV

T = T + 273;
Iph = (Isc+(alpha.*(T-Tr))).*(G/1000); % Fotocorrente
Is = Irr.*((T/Tr).^3).*exp((q*EG)/(eta*k).*((1/Tr) - (1./T))); % Corrente de Saturação Reversa
Vt=(eta*k*T)/q; % Tensão Térmica

Vd = Vpv./n_cell + Rs_cell.*Ipv; %Tensão do diodo

Rd = (eta*Vt)./(Is.*exp(Vd./(eta*Vt))); %Resistência equivalente do diodo (Linearização)

Req_cell = Rs_cell+ (Rd.*Rp_cell)./(Rd+Rp_cell); %Resistência equivalente de cálula

Req = n_cell.*Req_cell; %Resistência Equivalente do Módulo

Veq = Vpv - Ipv./Req; % Thevenin

Ieq = Veq./Req; % Northon

%% Parâmetros do conversor Buck
Vbat = 12; % Tensão da Bateria
L  = 22.109e-6; % Indutância
Rl = 3e-3; % Resistência CC Indutor
Cin = 2.7e-3; % Capacitância de Entrada
Rcin = 6.519e-3; %Resistência Relacionada a Capacitância de Entrada 
%Ron = 6.5e-3; % Resistência MOSFET
Ron = 0.15; % Estimação de perdas - sistema mais amortecido
Vto = 1; % Tensão Direta DIODO

%% Funções de transferência
if(Ron == 0.15)
    IL = [14.55 11.07];
    D = [0.5152 0.5247];
end

if(Ron == 6.5e-3)        
    IL = [15.75 11.77];
    D =  [0.4762 0.4933 ];
end

% figure(1); clf(); hold on
for i=1:length(D)
    s = tf('s');
    num_s = Req(i)*(2*D(i)*IL(i)*Ron + D(i)*Vpv(i) + D(i)*Vto + IL(i)*Rl + IL(i)*L*s);
    den_s = Cin*L*Req(i)*s^2 + s*(Cin*D(i)*Ron*Req(i) + Cin*Rl*Req(i) + L) + D(i)^2*Req(i) + D(i)*Ron + Rl;
    
    num_teste = num_s.num{1}(1)/(Cin*L*Req(i))*s + num_s.num{1}(2)/(Cin*L*Req(i));
    den_teste = s^2 + s*((D(i)*Ron+Rl)/L + 1/(Cin*Req(i))) + (D(i)^2*Req(i) + D(i)*Ron + Rl)/(Cin*L*Req(i)); %polinômio característico (canonico)
    G_vcin(i) = num_teste/den_teste
    
end
hold off

%% Projeto do controlador PI padrão
% W = [0:0.01:10^5];
% [MAG,PHASE,W] = bode(G_vcin(1),W);
% wo =  W(find(MAG==max(MAG))); %Frequência de ressonancia par LC
% wcg_f = (wo/10); % 10 vezes menor (1 décadas abaixo) em rad/s
wcg_f = 1/(sqrt((L*Cin)/(D(1)^2)))/10;
MF = (100*pi)/180; % MF ajustada para o controlador ser factível e ter apenas 1 ponto de cruzamento de ganho

rp = freqresp(G_vcin(1), wcg_f);
mp = abs(rp); thetap = angle(rp);
mk = 1/mp; thetak = MF - thetap - pi;

kp_0 = mk*cos(thetak);
ki_0 = -mk*sin(thetak)*wcg_f;

Ks_PI_0 = tf([kp_0 ki_0],[1 0]);

figure(1);clf();hold on
G_pv = G_vcin(1);
FTLA = G_vcin(1)*Ks_PI_0;
bode(G_pv)
bode(FTLA)
hold off

%% Verificando controle para outros pontos de linearização
for i=2:length(G_vcin)
    figure(i);clf();hold on; grid on;
    G_pv = G_vcin(i);
    FTLA = G_vcin(i)*Ks_PI_0;
    bode(G_pv)
    bode(FTLA)
    hold off
end

%% Discretização do controlador contínuo (fs = 150 kHz)
fs = 150000;
Kz_PI = c2d(Ks_PI_0, 1/fs, 'tustin')
% Gv_z = c2d(G_vcin, 1/fs);
% figure(5); clf(); bode(Gv_z*Kz_PI); grid on;
% figure(6); clf(); step(feedback(Gv_z*Kz_PI, 1), 0.02)
% figure(7); clf(); pzmap(Gv_z)