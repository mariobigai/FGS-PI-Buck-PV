
function [LastPositions,g_bestEV, iterationsNeeded] = PSO(parameters)

% Inicialização --------------------------------------------------------
    count = 1;
  

    g_bestEV = [];     % armazena a posição + fitness
    p_bestEV = [];       %armazena a posição + fitness das melhores, medianas e piores posições



%     x1 = parameters.Restr_1(1) +(parameters.Restr_1(2)-parameters.Restr_1(1))*rand(parameters.num_particles,parameters.dim/2);
%     x2 = parameters.Restr_2(1) +(parameters.Restr_2(2)-parameters.Restr_2(1))*rand(parameters.num_particles,parameters.dim/2);
%     x = [x1(:,1) x2(:,1) x1(:,2) x2(:,2) x1(:,3) x2(:,3) ]% Posições iniciais
    
%     x = parameters.x_min +(parameters.x_max-parameters.x_min)*rand(parameters.num_particles,parameters.dim);
    
    x1 = parameters.Restr(1) +(parameters.Restr(2)-parameters.Restr(1))*rand(parameters.num_particles,parameters.dim-8); % aplica a restrição dos universos de discusos simetricos
    x2 = parameters.Restr(3) +(parameters.Restr(4)-parameters.Restr(3))*rand(parameters.num_particles,parameters.dim-7);
    x3 = parameters.Restr(5) +(parameters.Restr(6)-parameters.Restr(5))*rand(parameters.num_particles,parameters.dim-7);
    x = [x1 x2 x3]


    v = zeros(parameters.num_particles,parameters.dim);% Velocidades iniciais
    p_best = x;  % Melhor posição pessoal
    g_best = p_best(1,:);   % Melhor posição global
    
% Avaliação inicial --------------------------------------------------------

   
%     p_best = [p_best evaluatePosition(fis,p_best)]

    p_best = [p_best evaluatePosition(p_best)]

    [Value, Index] = maxMin(parameters.criterion,p_best(:,parameters.dim+1),parameters.num_particles);

    if g_best ~= Value(1,1)

        g_best =  [p_best(Index(1,1),1:parameters.dim) Value(1,1)] 
        g_bestEV = g_best;
    end

%Armazena a posição e fitness do primeiro, do mediano e do pior da primeira iteração --------------------------------------------------------

    p_bestEV =[p_best(Index(1:parameters.k,1),1:parameters.dim) Value(1:parameters.k,1)] 


% Loop de otimização --------------------------------------------------------
    for iter = 1:parameters.max_iter
        for i = 1:parameters.num_particles

% Atualização da velocidade --------------------------------------------------------
            v(i,:) = parameters.w*v(i,:) + parameters.c1*rand(1,parameters.dim).*(p_best(i,1:parameters.dim) - x(i,:)) + parameters.c2*rand(1,parameters.dim).*(g_best(parameters.dim) - x(i,:));
                 
% Atualização da posição --------------------------------------------------------
            x(i,:) = x(i,:) + v(i,:);


            
% Limites e ricochete --------------------------------------------------------
            x(i,1:parameters.dim-8) = max(x(i,1:parameters.dim-8), parameters.Restr(1));
            x(i,1:parameters.dim-8) = min(x(i,1:parameters.dim-8), parameters.Restr(2));
            x(i,parameters.dim-8:parameters.dim-4) = max(x(i,parameters.dim-8:parameters.dim-4), parameters.Restr(3));
            x(i,parameters.dim-8:parameters.dim-4) = min(x(i,parameters.dim-8:parameters.dim-4), parameters.Restr(4));
            x(i,parameters.dim-4:parameters.dim) = max(x(i,parameters.dim-4:parameters.dim), parameters.Restr(5));
            x(i,parameters.dim-4:parameters.dim) = min(x(i,parameters.dim-4:parameters.dim), parameters.Restr(6));
            
          
            if any(x(i,:))==any(parameters.Restr(1,:));    x(i,:) = x(i,:) - v(i,:);   end
                

%             x(i,:) = max(x(i,:), parameters.x_min);
%             x(i,:) = min(x(i,:), parameters.x_max);
%             if any(x(i,:))==parameters.x_min || any(x(i,:))==parameters.x_max; x(i,:) = x(i,:) - v(i,:); end
%                

            if parameters.criterion == 1
% Atualização da melhor posição pessoal e seu fitness --------------------------------------------------------
%                  a = evaluatePosition(fis,x(i,:));
                a = evaluatePosition(x(i,:));
                if  a > p_best(i,parameters.dim+1)
                    p_best(i,1:parameters.dim) = x(i,:);
                    p_best(i,parameters.dim+1) = a;   
                    clear a;
                end
                
% Atualização da melhor posição global e seu fitness --------------------------------------------------------
                if p_best(i,parameters.dim+1) > g_best(1,parameters.dim+1)
                    g_best(1,1:parameters.dim) = p_best(i,1:parameters.dim);
                    g_best(1,parameters.dim+1) = p_best(i,parameters.dim+1);
                    clear a;
                end 



            else
               
               
% Atualização da melhor posição pessoal e seu fitness --------------------------------------------------------
%                  a = evaluatePosition(fis,x(i,:));
                a = evaluatePosition(x(i,:));
                if  a < p_best(i,parameters.dim+1)
                    p_best(i,1:parameters.dim) = x(i,:);
                    p_best(i,parameters.dim+1) = a;   
                    clear a;
                end
                
% Atualização da melhor posição global e seu fitness --------------------------------------------------------
                if p_best(i,parameters.dim+1) < g_best(1,parameters.dim+1)
                    g_best(1,1:parameters.dim) = p_best(i,1:parameters.dim);
                    g_best(1,parameters.dim+1) = p_best(i,parameters.dim+1);
                    clear a;
                end 



           
            end
            
        end

        
     if g_best ~= g_bestEV(end,parameters.dim+1)
        g_bestEV = [g_bestEV ;g_best]    
     end

      [Value, Index] = maxMin(parameters.criterion,p_best(:,parameters.dim+1),parameters.num_particles);
        
        p_bestEV = [p_bestEV ; p_best(Index(1:parameters.k,1),1:parameters.dim) Value(1:parameters.k,1)]  


        iterationsNeeded = iter
        [stop, parameters.fitnessRef, count] = stopTest(parameters.fitnessRef,g_best(parameters.dim+1),count);

         if stop
               
                break;
        
        else
                continue;
            
         end

    

    end

    LastPositions = x;

   
end


