clear
clc

%% Declaração dos Parâmetros do Painel (PV ARRAY (Simulink): 1000 W/m2 @ 25°C -> Vmpp = 37.3 V, Impp = 8.85 A)
eta=0.97384; % Fator de qualidade (Otimização)
Isc=9.29; % Corrente CC
alpha = 0.0005; % coef de Isc 
k=1.38E-23; %8.62E-5; % Boltzmann
q=1.6E-19; % Carga elementar
EG = 1.12; % Energia de banda proibida
Rp=1329.6875; %Resistência em paralelo do módulo (Otimização)
Rs=0.38666; %Resistência em série do módulo (Otimização)
Tr=298; % Temperatura de referência
Voc=46.1; % Tensão CC
n_cell = 72; % Número de Células PV em Série
Irr = 7.1464e-11; % Corrente de satiração reversa de referência (Otimização)
%Cálculo das resistências Rs e Rp de célula
Rs_cell = Rs/n_cell;
Rp_cell = Rp*n_cell;

%% Condições Operacionais

% MPP p/ 
% 1000 W/m2 @ 25°C => Vpv=37.3; Ipv=8.85; Ppv=337.369
% 800 W/m2 @ 20ºC => Vpv=38.8376;  Ipv=8.8107; Ppv=342.187
% 600 W/m2 @ 15ºC => Vpv= 35.7681; Ipv=8.83706; Ppv=325.4339
% 400 W/m2  @ 10ºC => Vpv= 37.5598; Ipv=7.06448; Ppv=265.341
% 200 W/m2  @ 5ºC => Vpv= 37.5373; Ipv=3.5495; Ppv=113.105

T = [25, 20, 15, 10, 5];
G = [1000, 800, 600, 400, 200];
Vpv = [37.3, 38.42, 39.29, 40.23, 40.03];
Ipv = [8.85, 7.04, 5.29, 3.51, 1.77];
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
Ron = 6.5e-3; % Resistência MOSFET
Vto = 1; % Tensão Direta DIODO

%% Funções de transferência

% Vpv = 37.3;    Ipv = 8.85 => 

IL = [25.8056 21.1695 16.2906 11.0843 5.5743]; 
D =  [0.3429 0.3326 0.3247 0.3167 0.3175];

for i=1:length(D)
    s = tf('s');
    num_s = Req(i)*(2*D(i)*IL(i)*Ron + D(i)*Vpv(i) + D(i)*Vto + IL(i)*Rl + IL(i)*L*s);
    den_s = Cin*L*Req(i)*s^2 + s*(Cin*D(i)*Ron*Req(i) + Cin*Rl*Req(i) + L) + D(i)^2*Req(i) + D(i)*Ron + Rl;
    
    num_teste = num_s.num{1}(1)/(Cin*L*Req(i))*s + num_s.num{1}(2)/(Cin*L*Req(i));
    den_teste = s^2 + s*((D(i)*Ron+Rl)/L + 1/(Cin*Req(i))) + (D(i)^2*Req(i) + D(i)*Ron + Rl)/(Cin*L*Req(i)); %polinômio característico (canonico)
    G_vcin(i) = num_teste/den_teste;
end

%% Projeto do controlador PI padrão
W = [0:0.01:10^5];
[MAG,PHASE,W] = bode(G_vcin(1),W);
wo =  W(find(MAG==max(MAG))); %Frequência de ressonancia par LC
wcg_f = (wo/10); % 10 vezes menor (1 décadas abaixo) em rad/s
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
    figure(i);clf();hold on
    G_pv = G_vcin(i);
    FTLA = G_vcin(i)*Ks_PI_0;
    bode(G_pv)
    bode(FTLA)
    hold off
end

%% Discretização do controlador contínuo (fs = 150 kHz)
fs = 100000;
Kz_PI = c2d(Ks_PI_0, 1/fs, 'Tustin')
% Gv_z = c2d(G_vcin, 1/fs);
% figure(5); clf(); bode(Gv_z*Kz_PI); grid on;
% figure(6); clf(); step(feedback(Gv_z*Kz_PI, 1), 0.02)
% figure(7); clf(); pzmap(Gv_z)