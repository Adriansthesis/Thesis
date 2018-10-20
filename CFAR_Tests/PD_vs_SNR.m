clear all;
close all;

Iterations = 1e6;
N = 16;
Pfa = 1e-6;

SNR_dB = 20:1:30;

alpha_SO = SO_CA_CFAR_Statistic(Pfa,N);
alpha_GO = GO_CA_CFAR_Statistic(Pfa,N);
alpha_CA = N*(Pfa^(-1/(N))-1);

Pd_CA = [];
Pd_SO = [];
Pd_GO = [];
Pd_NP = [];
Pd_OS = [];

index = 0.75*N;
p = index;


alpha_values_OS = 1:1:500;
Pfa_values_OS = factorial(N)*factorial(alpha_values_OS+N-index)./(factorial(N-index)*factorial(alpha_values_OS+N));
[val,ind] =  min(abs(Pfa_values_OS - ones(1,length(alpha_values_OS))*Pfa));
alpha_OS = alpha_values_OS(ind);

for index = 1:length(SNR_dB)
   SNR = 10^(SNR_dB(index)/10);
   
   multiplication_OS = 1;
   for l = 0:1:p-1
        multiplication_OS = multiplication_OS*(N-l)/(N-l+alpha_OS/(1+SNR));
   end
   
    summation_SO = 0;
    for k = 0:1:(N/2-1)
        summation_SO = summation_SO + nchoosek((N/2 -1 +k),k)*(2+alpha_SO/(1+SNR))^(-k);
    end
    
    summation_GO = 0;
    for n = 0:1:(N/2-1)
        summation_GO = summation_GO + nchoosek((N/2 -1 +n),n)*(2+alpha_GO/(1+SNR))^(-n);
    end
   
   Pd_GO = [Pd_GO ; 2*((1+alpha_GO/(1+SNR))^(-N/2) - ((2+ alpha_GO/(1+SNR))^(-N/2) * summation_GO))]; % GO_CA_CFAR
   Pd_SO = [Pd_SO ; 2*(((2+ alpha_SO/(1+SNR))^(-N/2) * summation_SO))]; % SO_CA_CFAR
   Pd_CA = [Pd_CA; 1/((1+alpha_CA/(N*(1+SNR)))^N)]; %CFAR
   Pd_NP = [Pd_NP; Pfa.^(1/(1+SNR))]; %Optimal
   Pd_OS = [Pd_OS;multiplication_OS]; %OS_CFAR
    
end


figure;
plot(SNR_dB,Pd_NP);
hold on;
plot(SNR_dB,Pd_CA);
hold on;
plot(SNR_dB,Pd_GO);
hold on;
plot(SNR_dB,Pd_SO);
hold on;
plot(SNR_dB,Pd_OS);

legend('Optimum','CA-CFAR','GO-CA-CFAR','SO-CA-CFAR','OS-CFAR');
title(strcat('Pd vs SNR for: ','N = ',num2str(N),', and Pfa = ',num2str(Pfa)));
xlabel('SNR [dB]');
ylabel('Pd');