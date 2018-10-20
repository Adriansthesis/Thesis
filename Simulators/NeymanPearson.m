clear all;
close all;
Pfa = 1e-4;

SNR_dB = 20;
SNR_lin = 10^(SNR_dB/10);

Iterations = 1e6;

%% Pfa
I_interf = randn(1,Iterations);
Q_interf = randn(1,Iterations);

Input_Signal_H0 = (I_interf+j*Q_interf)/sqrt(2);

H0_Signal_After_Detector = abs(Input_Signal_H0);

T = 1*sqrt(-log(Pfa));

False_Alarms = sum((H0_Signal_After_Detector-T)>0);
Simulated_Pfa = False_Alarms/Iterations

Pfa_Error = 100*(Simulated_Pfa-Pfa)/Pfa

%% Pd

I_targ = randn(1,Iterations);
Q_targ = randn(1,Iterations);    
    

Pd_simulated = [];
Pd_calculated = [];

SNR_dB_Range = 0:1:30;

for SNR_dB = SNR_dB_Range

    SNR_lin = 10.^(SNR_dB/10);
    Target_Voltage = sqrt(SNR_lin);
    
    Target_Signal = Target_Voltage*(I_targ + j*Q_targ)/sqrt(2);
    
    Input_Signal_H1 = Input_Signal_H0 + Target_Signal;
    
    H1_Signal_After_Detector = abs(Input_Signal_H1);
    
    Detections = sum((H1_Signal_After_Detector-T)>0);
    
    Pd_simulated = [Pd_simulated,Detections/Iterations];
    %Pd_calculated = [Pd_calculated, marcumq(sqrt(2*SNR_lin),sqrt(-2*log(Pfa)))];
    Pd_calculated = [Pd_calculated, Pfa.^(1/(1+SNR_lin))];

end

figure;
plot(SNR_dB_Range,Pd_calculated);
hold on; 
plot(SNR_dB_Range,Pd_simulated); 
xlabel('SNR [dB]');
ylabel('Pd');
title(strcat('Optimum Detector Pd vs SNR for Pfa of : ',num2str(Pfa)));
legend('Expected Pd','Simulated Pd')
