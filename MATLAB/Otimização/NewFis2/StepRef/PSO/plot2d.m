
function plot2d(parameters,g_bestEV)

      
    plot(g_bestEV(:,parameters.dim + 1),'b');
    
    title('fitness evolution')
    legend('Global',Location='northeast')


end