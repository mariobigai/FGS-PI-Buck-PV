clc
total = 593857/10;
horas = floor(total / 3600);
minutos = floor((total - (horas * 3600)) / 60);
segundos = floor(mod(total, 60));
fprintf("%d h %d min %d s\n", horas, minutos, segundos)