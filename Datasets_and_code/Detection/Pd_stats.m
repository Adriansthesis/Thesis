%% Setup
% 1 - 1D
% 0 - 2D
Dimension = 0;


%%Using dataset 54 SNR approx 40dB

Shifted_Ra = circshift(Ra_Data,[0,round(size(Ra_Data,2)/2)]);
% [Shifted_Ra,otherstuff] = RobustRangeAlignment(Shifted_Ra);
[Shifted_Ra_1,otherstuff] = RobustRangeAlignment(Shifted_Ra(1:end/2,:));
[Shifted_Ra_2,otherstuff] = RobustRangeAlignment(Shifted_Ra(end/2:end,:));

Shifted_Ra = [circshift(Shifted_Ra_1,[0,-6]);Shifted_Ra_2];
% imagesc(20*log10(abs(Shifted_Ra)))
close all;
%% Coherrent integration
Itegrated_range_lines = [];

for i = 1:5:size(Shifted_Ra,2)-5
    integrated_section = sum(Shifted_Ra(:,i:i+5),2);
    Itegrated_range_lines = [Itegrated_range_lines , integrated_section ];
end

Signal_Power = 20*log10(abs(mean(Itegrated_range_lines(:,14:16))));
Signal_Power = mean(Signal_Power);
Noise = [Itegrated_range_lines(:,1:14),Itegrated_range_lines(:,17:end)];
Noise_Power = 20*log10(abs(mean(Noise(:))));
SNR_dB = Signal_Power - Noise_Power;
% SNR_dB = 12;

 
%% Detection
% SNR_dB = 26;
SNR = 10^(SNR_dB/10);

% Target_region = (abs(Shifted_Ra(:,73:80)));
% format longE;
% Signal_Power_dB = 20*log10(mean(Target_region(:)));
% Noise_Poser_dB = -1.050016371541981e+02;
% SNR = Signal_Power_dB - Noise_Poser_dB;

exponents = 1:0.2:5;
Pfa_values = 10.^(-1*exponents);

%Use Measured Data
SD_data = abs(Itegrated_range_lines).^2;

%Use Simulated Data
% SD_data = Reference_cells_AD.';
% SD_data(:,12) = CUT_AD;


% No. Gaurd cells
Gaurd_Cells_time_1 = 0;
% WIndow Size:
Window_Size_time_1 = 6;
N1 = 2*Window_Size_time_1;


dimensions = size(SD_data);
Threshold = zeros(dimensions(1),dimensions(2));
Threshold2 = zeros(dimensions(1),dimensions(2));


% No. Gaurd cells
Gaurd_Cells_2D_time = 1;
% WIndow Size:
Window_Size_2D_time = 3;

N2 = ((2*Window_Size_2D_time+2*Gaurd_Cells_2D_time+1).^2 - (2*Gaurd_Cells_2D_time+1).^2);

Pd1 = zeros(1,length(Pfa_values));
Pd2 = zeros(1,length(Pfa_values));
Pd_OS = [];

format longE;
for Pfa_index = 1:length(Pfa_values)
    disp(Pfa_index);
    Pfa = Pfa_values(Pfa_index);
    
    for i = 1:dimensions(1)
        Threshold(i,:) = OS_CFAR(Pfa, Window_Size_time_1, Gaurd_Cells_time_1, SD_data(i,:),round(N1*0.75));
    end
    
    
    Threshold3 = OS_CFAR_2D(Pfa, Window_Size_2D_time, Gaurd_Cells_2D_time, SD_data,round(N2*0.75));
   
    Detections_rt = double((SD_data-Threshold)>0);
    
    Detections3_rt = double((SD_data-Threshold3)>0);
    

    Detections_rt = Detections_rt(:,Window_Size_time_1+Gaurd_Cells_time_1+1 : end-Window_Size_time_1-Gaurd_Cells_time_1-1);
    
    Target_region_1 = Detections_rt(:,8);
    dimensions1 = size(Target_region_1);
    Pd1(Pfa_index) = sum(Target_region_1(:))/(dimensions1(1)*dimensions1(2));
    
    
    
   Detections3_rt = Detections3_rt(Window_Size_2D_time+Gaurd_Cells_2D_time +1: end-Window_Size_2D_time-Gaurd_Cells_2D_time-1,Window_Size_2D_time+Gaurd_Cells_2D_time +1 : end-Window_Size_2D_time-Gaurd_Cells_2D_time-1);
   
   Target_region_2 = Detections3_rt(Window_Size_2D_time:end - Window_Size_2D_time,10);
   dimensions2 = size(Target_region_2);
   Pd2(Pfa_index) = sum(Target_region_2(:))/(dimensions2(1)*dimensions2(2));
   
   
   if Dimension
        N = N1;
   else
       N = N2;
   end
   index = round(N*0.75);
   alpha_values_OS = 1:1:500;
   Pfa_values_OS = factorial(N)*factorial(alpha_values_OS+N-index)./(factorial(N-index)*factorial(alpha_values_OS+N));
   [val,ind] =  min(abs(Pfa_values_OS - ones(1,length(alpha_values_OS))*Pfa));
   alpha_OS = alpha_values_OS(ind);
   
   multiplication_OS = 1;
   for l = 0:1:index-1
        multiplication_OS = multiplication_OS*(N-l)/(N-l+alpha_OS/(1+SNR));
   end
   
   Pd_OS = [Pd_OS;multiplication_OS]; %OS_CFAR
   

end

if Dimension
figure;
semilogx(Pfa_values,Pd1);
hold on;
semilogx(Pfa_values,Pd_OS);
legend('1D Pd','Ideal Pd');
title(strcat('Pd vs Pfa for SNR: ',num2str(SNR_dB),' dB'));
xlabel('Pfa');
ylabel('Pd');

else
figure;

semilogx(Pfa_values,Pd2)
hold on;
semilogx(Pfa_values,Pd_OS);
legend('2D Pd','Ideal Pd');
title(strcat('Pd vs Pfa for SNR: ',num2str(SNR_dB),' dB'));
xlabel('Pfa');
ylabel('Pd');
end
