function errorEV(fis_Ini,best_subject)


% Plota o perfil do erro --------------------------------------------------------
      
    
    fis = newFis(best_subject);
    simIn = Simulink.SimulationInput('PidVsFuzzy');
    simIn = simIn.setVariable('fis',fis);
    simOut = sim(simIn);
    error = simOut.get('erro');
    
   
    plot(error.time,error.data,'r');
    
    fis = fis_Ini
    simIn = Simulink.SimulationInput('PidVsFuzzy');
    simIn = simIn.setVariable('fis',fis);
    simOut = sim(simIn);
    error = simOut.get('erro');
    
    plot(error.time,error.data,'b');

    legend('Otimized error','Original error')
end