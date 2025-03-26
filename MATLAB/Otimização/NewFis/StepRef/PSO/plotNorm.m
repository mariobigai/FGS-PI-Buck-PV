

function plotNorm(parameters,g_bestEV)

    a = g_bestEV(end,parameters.dim+1);
    Norm_1 = 1+ (a-maxMin(parameters.criterion,a,1))/(maxMin(parameters.criterion,a,1)-maxMin(~parameters.criterion,a,1));
    
    
    plot(Norm_1,'b','LineWidth',1);
    title('Normalized particle fitness evolution')
    


end