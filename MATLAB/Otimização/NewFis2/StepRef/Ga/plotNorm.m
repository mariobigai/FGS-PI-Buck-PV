

function plotNorm(parameters,generationsNeeded,kbests_Chrom) 


a = kbests_Chrom(1:parameters.k:end,end);
Norm_1 = 1+ (a-maxMin(parameters.criterion,a,1))/(maxMin(parameters.criterion,a,1)-maxMin(~parameters.criterion,a,1));


plot(1:generationsNeeded, Norm_1,'b','LineWidth',1);
title('Normalized best subject fitness evolution')
    

end