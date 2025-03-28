clear
clc

G = 800;
T = 20;

vpv = [0:0.1:50];
for i=1:length(vpv)
    ipv(i)  = ipv_f(G, T, vpv(i));
    if(ipv(i)<0); ipv(i) = 0; end
end
 ppv = vpv.*ipv;
 figure(1)
 plot(vpv, ipv)
 figure(2)
 plot(vpv, ppv)
 i_MPP =find(ppv == max(ppv));
 V_MPP = vpv(i_MPP)
