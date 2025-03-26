
function [stop fitnessRef count] = stopTest(fitnessRef,g_best,count)

    if  g_best < fitnessRef
    
       
        fitnessRef = g_best;
        count = count +1;

        if count == 5; stop =1;else;stop = 0; end
        


    else
    
        stop = 0;
    end



    
end
