

exponents = 1:0.5:3;
Pfa_values = 10.^(-1*exponents);

SD_data = abs(Ra_Data(1:1200,10:end)).^2;
% SD_data = Reference_cells_AD.';

% No. Gaurd cells
Gaurd_Cells_time_1 = 2;
% WIndow Size:
Window_Size_time_1 = 14;
N1 = 2*Window_Size_time_1;


dimensions = size(SD_data);
Threshold = zeros(dimensions(1),dimensions(2));
Threshold2 = zeros(dimensions(1),dimensions(2));


% No. Gaurd cells
Gaurd_Cells_2D_time = 3;
% WIndow Size:
Window_Size_2D_time = 3;

N2 = ((2*Window_Size_2D_time+2*Gaurd_Cells_2D_time+1).^2 - (2*Gaurd_Cells_2D_time+1).^2);

Pfa1 = zeros(1,length(Pfa_values));
Pfa2 = zeros(1,length(Pfa_values));

format longE;
for Pfa_index = 1:length(Pfa_values)
    disp(Pfa_index);
    Pfa = Pfa_values(Pfa_index);
    
    for i = 1:dimensions(1)
        Threshold(i,:) = OS_CFAR(Pfa, Window_Size_time_1, Gaurd_Cells_time_1, SD_data(i,:),round(N1*0.75));
    end
    
    
    Threshold3 = OS_CFAR_2D(Pfa, Window_Size_2D_time, Gaurd_Cells_2D_time, SD_data,round(N2*0.52));
   
    Detections_rt = double((SD_data-Threshold)>0);
    
    Detections3_rt = double((SD_data-Threshold3)>0);
    

    Detections_rt = Detections_rt(:,Window_Size_time_1+Gaurd_Cells_time_1+1 : end-Window_Size_time_1-Gaurd_Cells_time_1-1);
    
    dimensions1 = size(Detections_rt);
    Pfa1(Pfa_index) = sum(Detections_rt(:))/(dimensions1(1)*dimensions1(2));
    
    
    
   Detections3_rt = Detections3_rt(Window_Size_2D_time+Gaurd_Cells_2D_time +1: end-Window_Size_2D_time-Gaurd_Cells_2D_time-1,Window_Size_2D_time+Gaurd_Cells_2D_time +1 : end-Window_Size_2D_time-Gaurd_Cells_2D_time-1);
   dimensions2 = size(Detections3_rt);
   Pfa2(Pfa_index) = sum(Detections3_rt(:))/(dimensions2(1)*dimensions2(2));

end

figure;
loglog(Pfa_values,Pfa_values);
hold on;
loglog(Pfa_values,Pfa1);
hold on;
loglog(Pfa_values,Pfa2);
legend('Desired Pfa','Actual 1D Pfa','Actual 2D Pfa');
title('Desired vs actual Pfa');
xlabel('Desired Pfa');
ylabel('Actual Pfa')