clear all;
close all;

Pfa = 1e-3;


Iterations = 1e6;


Pd_Simulated = [];
Pd_Calculated = [];

for SNR_dB = 0:1:20
    
    SNR_lin = 10^(SNR_dB/10);
    
    Noise_Power = ones(Iterations,1);

    %To add a clutter wall
    %Noise_Power(700:end) = 100*Noise_Power(700:end);

    Target_Power = SNR_lin.*ones(Iterations,1);

    %Target_Power(495:500) = Target_power_lin;
    
    I_Noise = randn(1,Iterations);
    Q_Noise = randn(1,Iterations);
    
    I_Target = randn(1,Iterations);
    Q_Target = randn(1,Iterations);
    
    
    Noise_Signal = sqrt(Noise_Power).*((I_Noise+1j*Q_Noise)/sqrt(2)).';
    Target_Signal = sqrt(Target_Power).*((I_Target+1j*Q_Target)/sqrt(2)).';
    
    Received_Signal =  Noise_Signal;%(Noise_Signal + Target_Signal);
    

    %Outpt after square detector
    SD_Signal = abs(Received_Signal).^2;
    
 
    
    % No. Gaurd cells
    Gaurd_Cells = 0;
    % Window Size:
    Window_Size = 20;
    N = (Window_Size)*2;
    
    T_CFAR = zeros(Iterations,1);
    
    
    for i = 1:Iterations
        if(i < Window_Size+Gaurd_Cells+1 || i > Iterations - (Window_Size+Gaurd_Cells+1))
            T_CFAR(i) = 0;
            continue;
        end
        
        Window_Front = SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
        Window_Back = SD_Signal(i+1+Gaurd_Cells:i+Window_Size+Gaurd_Cells);
        
        Sum_Reference_cells = sum(Window_Front)+sum(Window_Back);
        g = Sum_Reference_cells./N;
        alpha = N*(Pfa^(-1/(N))-1);
        T_CFAR(i) = g*alpha;
        
    end 
    
    False_Alarms_CFAR = sum((SD_Signal-T_CFAR)>0);
    Simulated_Pfa_CFAR = False_Alarms_CFAR/Iterations;
    Pfa_Error_CFAR = 100*(Simulated_Pfa_CFAR-Pfa)/Pfa;
    
    Detections = sum((abs(Target_Signal).^2-T_CFAR)>0);
    
    Pd_Simulated = [Pd_Simulated, Detections/Iterations];
    Pd_Calculated = [Pd_Calculated, 1/((1+alpha/(N*(1+SNR_lin)))^N)];
end

plot(Pd_Calculated);
hold on;
plot(Pd_Simulated);
