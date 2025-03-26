function stop = stopTest(z)

    persistent bestInd bestInd_1 bestInd_2  bestInd_3 bestInd_4 bestInd_5 bestInd_6 bestInd_7 bestInd_8 bestInd_9

    if(isempty(bestInd)); bestInd = 0; end
    if(isempty(bestInd_1)); bestInd_1 = 0; end
    if(isempty(bestInd_2)); bestInd_2 = 0; end
    if(isempty(bestInd_3)); bestInd_3 = 0; end
    if(isempty(bestInd_4)); bestInd_4 = 0; end
%     if(isempty(bestInd_5)); bestInd_5 = 0; end
%     if(isempty(bestInd_6)); bestInd_6 = 0; end
%     if(isempty(bestInd_7)); bestInd_7 = 0; end
%     if(isempty(bestInd_8)); bestInd_8 = 0; end
%     if(isempty(bestInd_9)); bestInd_9 = 0; end


%     bestInd_9 = bestInd_8;
%     bestInd_8 = bestInd_7;
%     bestInd_7 = bestInd_6;
%     bestInd_6 = bestInd_5;
%     bestInd_5 = bestInd_4;
    bestInd_4 = bestInd_3;
    bestInd_3 = bestInd_2;
    bestInd_2 = bestInd_1;
    bestInd_1 = bestInd;
    bestInd= z(1,1);


   

    if (bestInd == bestInd_1) && (bestInd_1 == bestInd_2)&& (bestInd_2 == bestInd_3)&& (bestInd_3 == bestInd_4)%&& (bestInd_4 == bestInd_5)&& (bestInd_5 == bestInd_6)&& (bestInd_6 == bestInd_7)&& (bestInd_7 == bestInd_8)&& (bestInd_8 == bestInd_9)

        stop = 1 ;

    
    else
    
        stop = 0;
    end


end