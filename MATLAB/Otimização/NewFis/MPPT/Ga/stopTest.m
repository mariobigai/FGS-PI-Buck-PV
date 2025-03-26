
function [stop ,parameters, count] = stopTest(parameters,z,count)





if parameters.criterion == 0


    if  z(1,1) < parameters.fitnessRef


        parameters.fitnessRef = z(1,1);
        count = count +1;

        if count == parameters.countmax; stop =1; else;stop = 0; end
        


    else
    
        stop = 0;
    end


else

     if  z(1,1) > parameters.fitnessRef


        parameters.fitnessRef = z(1,1);
        count = count +1;

        if count == parameters.countmax; stop =1; else;stop = 0; end
        


    else
    
        stop = 0;
    end



end


    
end