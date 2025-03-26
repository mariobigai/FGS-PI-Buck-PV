function [kp, ki] = interp(erro, derro, E, dE, E1, dE1, kp_E_dE, kp_E_dE1, kp_E1_dE, kp_E1_dE1, ki_E_dE, ki_E_dE1, ki_E1_dE, ki_E1_dE1)
    
    if (E == E1 || dE == dE1)
        kp = kp_E_dE;
        ki = ki_E_dE;
    else
        n = 21;
        erro_E = 2*E/n - (1+2/n);
        derro_dE = 2*dE/n - (1+2/n);
        erro_E1 = 2*E1/n - (1+2/n);
        derro_dE1 = 2*dE1/n - (1+2/n);
    
        kp_erro_dE = ((kp_E1_dE - kp_E_dE)/(erro_E1 - erro_E))*(erro-erro_E)+kp_E_dE;
        ki_erro_dE = ((ki_E1_dE - ki_E_dE)/(erro_E1 - erro_E))*(erro-erro_E)+ki_E_dE;
    
        kp_erro_dE1 = ((kp_E1_dE1 - kp_E_dE1)/(erro_E1-erro_E))*(erro-erro_E)+kp_E_dE1;
        ki_erro_dE1 = ((ki_E1_dE1 - ki_E_dE1)/(erro_E1-erro_E))*(erro-erro_E)+ki_E_dE1;
    
        kp = ((kp_erro_dE1 - kp_erro_dE)/(derro_dE1-derro_dE))*(derro-derro_dE) + kp_erro_dE;
        ki = ((ki_erro_dE1 - ki_erro_dE)/(derro_dE1-derro_dE))*(derro-derro_dE) + ki_erro_dE;
    end