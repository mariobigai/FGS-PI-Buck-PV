
function fitness= evaluatePosition(x)

IAE = zeros(size(x,1),1);
settlingTime = zeros(size(x,1),1);
fitness = zeros(size(x,1),1);

    parfor j=1:size(x,1)
       warning('off','all')
        try
%         fis = newFis(fis,x(j,:));
        fis = newFis(x(j,:));
        simIn = Simulink.SimulationInput('PidVsFuzzy');
        simIn = simIn.setVariable('fis',fis);
    
% Executa a simulação e captura o output --------------------------------------------------------
        simOut = sim(simIn);
    
% Acessa os dados salvos pela simulação --------------------------------------------------------

        erro = simOut.get('erro');
        erro = [erro.time erro.data];

        n11 = 1;
        n21 = length(erro(:,1));
        
        erro_velho = abs(erro(n11:n21,2));
        
%Calculo da integral absoluta do erro --------------------------------------------------------
        IAE(j,1)=trapz(erro(n11:n21,1),erro_velho);

%Calculo do settling time --------------------------------------------------------
        saida = simOut.get('saida');
        saida = [saida.time saida.data];
        a = stepinfo(saida(:,2),saida(:,1));


        settlingTime(j,1) = a.SettlingTime;
        

        % eta = 100/(1+Iae)

     catch ME

        IAE(j,1) = 1000;

        end


%Calculo do fitness --------------------------------------------------------
        alpha = 0.4;

        fitness(j,1) = alpha*IAE(j,1) + (1-alpha)*settlingTime(j,1);


    end

    

end

