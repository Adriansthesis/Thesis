clear all;
close all;

Pfa = 1e-4;


Iterations = 1e6;
N = 24;


Reference_cells = zeros(N,Iterations);

for i = 1:N
    I = randn(1,Iterations);
    Q = randn(1,Iterations);
    Reference_cells(i,:) = (I + 1j*Q)/sqrt(2);
end

Reference_cells_AD = abs(Reference_cells).^2;
Sum_Reference_cells = sum(Reference_cells_AD,1);
g = Sum_Reference_cells./N;
%Scaling factor
alpha = N*(Pfa^(-1/(N))-1);


%CA Threshold
T = g*alpha;

I_test = randn(Iterations,1);
Q_test = randn(Iterations,1);
Test_Signal = (I_test + 1j*Q_test)/sqrt(2);
Test_AD = abs(Test_Signal).^2;

False_Alarms = sum((Test_AD.'-T)>0);
Simulated_Pfa = False_Alarms/Iterations

Pfa_Error = 100*(Simulated_Pfa-Pfa)/Pfa




SNR_dB_Range = 0:1:25;
Pd_Simulated = [];
Pd_Calculated = [];

I = randn(1,Iterations);
Q = randn(1,Iterations);

for SNR_dB = SNR_dB_Range
    SNR_lin = 10^(SNR_dB/10);
    CUT =  sqrt(SNR_lin)*(I + 1j*Q)/sqrt(2) + Reference_cells(10,:);    
    CUT_AD = abs(CUT).^2;
    Detections = sum((CUT_AD-T)>0);
    Pd_Simulated = [Pd_Simulated, Detections/Iterations];
    Pd_Calculated = [Pd_Calculated, 1/((1+alpha/(N*(1+SNR_lin)))^N)];
        
end

figure;
plot(SNR_dB_Range,Pd_Simulated);
hold on;
plot(SNR_dB_Range,Pd_Calculated);
xlabel('SNR [dB]');
ylabel('Pd');
title(strcat('CA-CFAR Pd vs SNR for Pfa of : ',num2str(Pfa)));
legend('Simulated Pd','Expected Pd')
