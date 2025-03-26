function [a, b] = maxMin(criterion,y,k)

if criterion == 1
    [a,b] = maxk(y,k);
else

    [a,b] = mink(y,k);
end


end