function fitness = fitnessmetodo2(error)

% tira o transitório incial e começa a calcular a IAE a partir dos transitórios de temperatura

n11 = find(error(:,1)<1.5); n11 = n11(end);
n12 = find(error(:,1)<1.53); n12 = n12(end);

n21 = find(error(:,1)<2); n21 = n21(end);
n22 = find(error(:,1)<2.03); n22 = n22(end);

n31 = find(error(:,1)<2.5); n31 = n31(end);
n32 = find(error(:,1)<2.53); n32 = n32(end);

n41 = find(error(:,1)<3); n41 = n41(end);
n42 = find(error(:,1)<3.03); n42 = n42(end);


%Amplitudes
amp1 = max(abs(error(n12:n21,2)));
amp2 = max(abs(error(n22:n31,2)));
amp3 = max(abs(error(n32:n41,2)));
amp4 = max(abs(error(n42:end,2)));



if amp1 > (0.05) || amp2 > (0.05) || amp3> (0.05) || amp4 > (0.05); amp= 500; else; amp = 0; end



%IAE
erro_velho = abs(error(n11:end,2));
IAE = trapz(error(n11:end,1),erro_velho);      


fitness = IAE + amp;




end