clc
clear all

FLS_FGS_PI = readfis('FLS_FGS_PI2.fis');

n_pontos = 21
erro = linspace(-1,1,n_pontos);
derro = linspace(-1,1,n_pontos);

kp = zeros(n_pontos,n_pontos);
ki = zeros(n_pontos,n_pontos);
for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos 
        OUT = evalfis(FLS_FGS_PI, [erro(i), derro(j)]);
        kp(i,j) = OUT(1);
        ki(i,j) = OUT(2);
    end
end

figure(1); clf();
surf(erro, derro, kp) %Plotar a superficie
figure(2); clf();

surf(erro, derro, ki)

%% Implementação no DSP
fid = fopen("kp.txt", "w"); 
for i =1:n_pontos % Loop para mapear todos pontos
    fprintf(fid,"{");
    for j =1:n_pontos
        if j == n_pontos
            fprintf(fid,"%f", round(kp(i,j),7));
        else
            fprintf(fid,"%f, ", round(kp(i,j),7));
        end
    end
    fprintf(fid,"},\n");
end
fclose(fid);

fid = fopen("ki.txt", "w"); 
for i =1:n_pontos % Loop para mapear todos pontos
    fprintf(fid,"{");
    for j =1:n_pontos
        if j == n_pontos
            fprintf(fid,"%f", round(ki(i,j),7));
        else
            fprintf(fid,"%f, ", round(ki(i,j),7));
        end
    end
    fprintf(fid,"},\n");
end
fclose(fid);

%% Implementação PSIM - 2-D Lookup table (integer)
fid = fopen("kp.csv", "w"); 
fprintf(fid, '%d, %d\n', n_pontos, n_pontos);
for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos
         if j==n_pontos
            fprintf(fid, "%f", kp(i,j));
        else 
            fprintf(fid, "%f, ", kp(i,j));
        end 
    end
    fprintf(fid, "\n");
end
fclose(fid);

fid = fopen("ki.csv", "w"); 
fprintf(fid, '%d, %d\n', n_pontos, n_pontos);
for i =1:n_pontos % Loop para mapear todos pontos
    for j =1:n_pontos
         if j==n_pontos
            fprintf(fid, "%f", ki(i,j));
        else 
            fprintf(fid, "%f, ", ki(i,j));
        end 
    end
    fprintf(fid, "\n");
end
fclose(fid);