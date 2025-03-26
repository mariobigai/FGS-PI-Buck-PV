
function plot2d(parameters,generationsNeeded,kbests_Chrom)

   
    plot(1:generationsNeeded, kbests_Chrom(1:parameters.k:end,end),'b');
    
    title('Best subject fitness evolution')
    


end