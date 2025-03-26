function [E, dE, E1, dE1] = mapea(erro, derro)
   n_pontos = 21;

    E = floor(((n_pontos-1)/2)*erro + (((n_pontos-1)/2)+1));
    dE = floor(((n_pontos-1)/2)*derro + (((n_pontos-1)/2)+1));
    if(E+1 > n_pontos)
        E1 = E;
    else
        E1 = E+1;
    end

    if(dE+1 > n_pontos)
        dE1 = dE;
    else
        dE1 = dE+1;
    end