function ipv = ipv_f(G, T, vpv)
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
    Voccell = Voc/n_cell;
    Irr = 1.26e-8; % Corrente de satiração reversa de referência (Otimização)

    T = T + 273.; 
    Vt = (eta*k*T)/q;
    Iph = (Isc+(alpha*(T-Tr)))*G/1000; 
    Ir = Irr*((T/Tr)^3)*exp(q*EG/eta/k*(1/Tr-1/T));
    K1 = Iph + Ir;
    K2 = 1./Rp_cell;
    K3 = Ir;
    K4 = 1. + (Rs_cell/Rp_cell);
    K5 = (Ir*q*Rs_cell)/(eta*k*T);

    vcell = vpv/(n_cell);
    kaux = exp(vcell/Vt);
    ipv = (K1-K2*vcell-K3*kaux)/(K4+K5*kaux);
    
end