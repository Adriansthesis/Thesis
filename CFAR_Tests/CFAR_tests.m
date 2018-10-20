clear all;
close all;

Pfa = 1e-3;

%Neyman Pearson threshold value
T_NP = 1*sqrt(-log(Pfa));

Iterations = 2e3;
Target_Power_dB  = 50;
Target_power_lin = 10^(Target_Power_dB/20);


Noise_Power = ones(Iterations,1);

%To add a clutter wall
Noise_Power(700:end) = 100*Noise_Power(700:end);

Target_Power = ones(Iterations,1);

%Single bin target
Target_Power(500) = Target_power_lin;

%Multiple bin target
% Target_Power(499:502) = Target_power_lin;

%Multiple targets
% Target_Power(495) = Target_power_lin;
% Target_Power(505) = Target_power_lin;

% R = raylrnd(B
% 
% I_Noise = randn(1,Iterations);
% Q_Noise = randn(1,Iterations);
% 
% I_Target = randn(1,Iterations);
% Q_Target = randn(1,Iterations);


I_Noise = raylrnd(1,1,Iterations);
Q_Noise = raylrnd(1,1,Iterations);

I_Target = raylrnd(1,1,Iterations);
Q_Target = raylrnd(1,1,Iterations);

Noise_Signal = sqrt(Noise_Power).*((I_Noise+1j*Q_Noise)/sqrt(2)).';
Target_Signal = sqrt(Target_Power).*((I_Target+1j*Q_Target)/sqrt(2)).';

Received_Signal = (Noise_Signal + Target_Signal)/sqrt(2);

%Output after linear detector
LD_Signal = abs(Received_Signal);

%Outpt after square detector
SD_Signal = abs(Received_Signal).^2;

% False_Alarms_NP = sum((LD_Signal-T_NP)>0);
% Simulated_Pfa_NP = False_Alarms_NP/Iterations
% 
% Pfa_Error_NP = 100*(Simulated_Pfa_NP-Pfa)/Pfa

% No. Gaurd cells
Gaurd_Cells = 2;
% WIndow Size: 
Window_Size = 24;
N = (Window_Size)*2;
	
T_CA_CFAR = CA_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal);
T_GO_CA_CFAR = GO_CA_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal);
T_SO_CA_CFAR = SO_CA_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal);
T_OS_CFAR = OS_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal,round(N*0.75));


% False_Alarms_CFAR = sum((LD_Signal-T_CFAR)>0);
% Simulated_Pfa_CFAR = False_Alarms_CFAR/Iterations
% 
% Pfa_Error_CFAR = 100*(Simulated_Pfa_CFAR-Pfa)/Pfa
% 
% figure;
% plot(LD_Signal(450:550));
% hold on;
% plot(T_NP*ones(100,1));


% figure;
% plot(20*log10(SD_Signal(450:550)));
% hold on;
% plot(20*log10(T_CA_CFAR(450:550)),'LineWidth',1);
% hold on;
% plot(20*log10(T_GO_CA_CFAR(450:550)),'LineWidth',1);
% hold on;
% plot(20*log10(T_SO_CA_CFAR(450:550)),'LineWidth',1);
% hold on;
% plot(20*log10(T_OS_CFAR(450:550)),'LineWidth',1);
% title('Detection CFAR');
% xlabel('Range Bins');
% ylabel('dB');
% legend('Signal','CA CFAR','GO CA CFAR','SO CA CFAR','OS CFAR');

figure;
plot(20*log10(SD_Signal(600:1e3)));
hold on;
plot(20*log10(T_CA_CFAR(600:1e3)),'LineWidth',1);
hold on;
plot(20*log10(T_GO_CA_CFAR(600:1e3)),'LineWidth',1);
hold on;
plot(20*log10(T_SO_CA_CFAR(600:1e3)),'LineWidth',1);
hold on;
plot(20*log10(T_OS_CFAR(600:1e3)),'LineWidth',1);
title('Detection CFAR');
xlabel('Range Bins');
ylabel('dB');
legend('Signal','CA CFAR','GO CA CFAR','SO CA CFAR','OS CFAR');