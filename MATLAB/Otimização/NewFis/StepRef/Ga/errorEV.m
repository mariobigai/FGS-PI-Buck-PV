function errorEV(a,b)


% Plota o perfil do erro --------------------------------------------------------
    E = b(1,1);
    delE = b(1,2);
    FlcOut = b(1,3);
    fis = newFis(b);  


    simIn = Simulink.SimulationInput('buck_pvLucas');
    simIn = simIn.setVariable('fis',fis);
    simIn = simIn.setVariable('E',E);
    simIn = simIn.setVariable('delE',delE);
    simIn = simIn.setVariable('FlcOut',FlcOut);   

    simOut = sim(simIn);

    error = simOut.get('erro');
    error = [error.time error.data];


    n11 = find(error(:,1)<1.5); n11 = n11(end);         
    n21 = length(error(:,1));
  
   
    plot(error(n11:n21,1),error(n11:n21,2),'b');hold on;
    
    E = a(1,1);
    delE = a(1,2);
    FlcOut = a(1,3);
    fis = newFis(a);  


    simIn = Simulink.SimulationInput('buck_pvLucas');
    simIn = simIn.setVariable('fis',fis);
    simIn = simIn.setVariable('E',E);
    simIn = simIn.setVariable('delE',delE);
    simIn = simIn.setVariable('FlcOut',FlcOut);   

    simOut = sim(simIn);

    error = simOut.get('erro');
    error = [error.time error.data];


    n11 = find(error(:,1)<1.5); n11 = n11(end);         
    n21 = length(error(:,1));
  
   
    plot(error(n11:n21,1),error(n11:n21,2),'r');hold on;
    

  
end