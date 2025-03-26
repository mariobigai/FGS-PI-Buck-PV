function fitness = fitnessmetodo1(error)

% tira o transitório incial e começa a calcular a IAE a partir dos transitórios de temperatura

n11 = find(error(:,1)<0.1); n11 = n11(end);
n12 = find(error(:,1)<0.1+50e-3); n12 = n12(end);

n21 = find(error(:,1)<0.2); n21 = n21(end);
n22 = find(error(:,1)<0.2+50e-3); n22 = n22(end);

% n31 = find(error(:,1)<2.5); n31 = n31(end);
% n32 = find(error(:,1)<2.53); n32 = n32(end);
% 
% n41 = find(error(:,1)<3); n41 = n41(end);
% n42 = find(error(:,1)<3.03); n42 = n42(end);


% nf = length(error(:,1));

%IAE transitorio 1
erro_velhoT1 = abs(error(n11:n12,2));
IAET1 = trapz(error(n11:n12,1),erro_velhoT1);

%IAE Regime 1
erro_velhoR1 = abs(error(n12:n21,2));
IAER1 = trapz(error(n12:n21,1),erro_velhoR1);



%IAE transitorio 2
erro_velhoT2 = abs(error(n21:n22,2));
IAET2 = trapz(error(n21:n22,1),erro_velhoT2);;

%IAE Regime 2
erro_velhoR2 = abs(error(n22:end,2));
IAER2 = trapz(error(n22:end,1),erro_velhoR2);

% %IAE transitorio 3
% erro_velhoT3 = abs(error(n31:n32,2));
% IAET3 = trapz(error(n31:n32,1),erro_velhoT3);
% 
% %IAE Regime 3
% erro_velhoR3 = abs(error(n32:n41,2));
% IAER3 = trapz(error(n32:n41,1),erro_velhoR3);      
% 
% 
% 
% 
% %IAE transitorio 4
% erro_velhoT4 = abs(error(n41:n42,2));
% IAET4 = trapz(error(n41:n42,1),erro_velhoT4);
% 
% %IAE Regime 4
% erro_velhoR4 = abs(error(n42:end,2));
% IAER4 = trapz(error(n42:end,1),erro_velhoR4);      


% erro_velhoTotal = abs(error(n11:end,2));


%Definição do fitness como combinação linear da IAE e da amplitude
k1 = 1;
k2 = 1000;
% (IAER1+IAER2+IAER3+IAER4)% =  0.0451 para o original
% (IAET1+IAET2+IAET3+IAET4)% =  0.1181 para o original
% fitness = k1*(IAET1+IAET2+IAET3+IAET4)+ k2*(IAER1+IAER2+IAER3+IAER4); 
fitness = k1*(IAET1+IAET2)+ k2*(IAER1+IAER2); 
end