clear all;
close all;
%% Specify Dataset


Range_align = 1;

PRF = 100;
% Dataset = '41 Jason walking arms swinging (109MHz).wav';
% Dataset = '42 Adrian on bike @ 10kmh (109MHz).wav'; %nice'ish
% Dataset = '43 Adrin driving away 10kmh 109MHz.wav'; % nice
% Dataset = '44 Adrian driving towards 10kmh 109MHz.wav'; %nice (two targets, doesn't like range allignment)
% Dataset = '45 adrian driving away 10kmh 109mhz.wav'; % not so nice
% Dataset = '46 adrian driving towards 15kmh 109mhz.wav'; % nice
% Dataset = '48 Jason driving away slowly (109 MHz).wav';
% Dataset = '49 Jason driving away slowly (109 MHz).wav';
% Dataset = '50 Jason driving away faster (109 MHz).wav';
% Dataset = '51 Jason driving towards faster (109 MHz).wav';
% Dataset = '52 Jason wlaking arms swinging 1(109 MHz).wav';
% Dataset = '53 Jason wlaking arms swinging 2(109 MHz).wav';
% Dataset = '54 Jason wlaking arms swinging 3(109 MHz).wav';
% Dataset = '55 Jason wlaking arms swinging 4(109 MHz).wav';

Dataset = '80 walking to and from 6 kmh.wav';


%% Get range lines

[Range_Lines,range_axis,time_axis,Np] = Get_Range_Lines(Dataset,109e6);
lamda = 3e8/2.45e9;


%% Filter cluter
    % figure;
    % plot(sum(abs(fft(Range_Lines,[],1)).^2,2));

disp('Filtering');
load ring_road_filter;

Filtered_Range_Lines = filter(h,1,Range_Lines,[],1);
Filtered_Range_Lines = Filtered_Range_Lines(length(h):end,:);
Filtered_Range_Lines = Filtered_Range_Lines(:,1:end);
range_axis = range_axis(1:end);
time_axis = time_axis(length(h):end);

% figure;	
% plot(sum(abs(fft(Filtered_Range_Lines,[],1)).^2,2));


% 
% figure;
% imagesc(range_axis,time_axis,20*log10(abs(Filtered_Range_Lines)));
% % imagesc(20*log10(abs(Filtered_Range_Lines)));
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('RTI With Equiripple Filter');
% colormap(jet(256));
% colorbar;
% axis xy;

%% Range allignmet
if(Range_align)
    disp('Range Allignment');

    [Ra_Data,otherstuff] = RobustRangeAlignment(Filtered_Range_Lines);
else
    Ra_Data = Filtered_Range_Lines;
    
end

%% Range Detection
disp('Range detection');
SD_data = abs(Ra_Data).^2;

% No. Gaurd cells
Gaurd_Cells_time_1 = 2;
% WIndow Size: 
Window_Size_time_1 = 14;

Pfa = 1e-6; %For actual detection
dimensions = size(SD_data);
Threshold = zeros(dimensions(1),dimensions(2));
Threshold2 = zeros(dimensions(1),dimensions(2));
N = 2*Window_Size_time_1;

for i = 1:dimensions(1)
	Threshold(i,:) = OS_CFAR(Pfa, Window_Size_time_1, Gaurd_Cells_time_1, SD_data(i,:),round(N*0.75));
end

% No. Gaurd cells
Gaurd_Cells_time_2 = 2;
% WIndow Size: 
Window_Size_time_2 = 32;

N = 2*Window_Size_time_2;




% for i = 1:dimensions(2)
% 	Threshold2(:,i) = OS_CFAR(Pfa, Window_Size_time_2, Gaurd_Cells_time_2, SD_data(:,i),round(N*0.75));
% 	
% end

format longE;

% No. Gaurd cells
Gaurd_Cells_2D_time = 3;
% WIndow Size: 
Window_Size_2D_time = 3;

N = ((2*Window_Size_2D_time+2*Gaurd_Cells_2D_time+1).^2 - (2*Gaurd_Cells_2D_time+1).^2);


Threshold3 = OS_CFAR_2D(Pfa, Window_Size_2D_time, Gaurd_Cells_2D_time, SD_data,round(N*0.52));%0.52));


Detections_rt = double((SD_data-Threshold)>0);

% Detections2_rt = (SD_data-Threshold2)>0;

Detections3_rt = double((SD_data-Threshold3)>0);



% figure;
% imagesc(range_axis,time_axis,Detections_rt);
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('Time domain detections');
% %colormap(jet(256));
% %colorbar;
% axis xy;	
% 
% figure;
% imagesc(range_axis,time_axis,Detections2_rt);
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('Detections2');
% %colormap(jet(256));
% %colorbar;
% axis xy;	
% 
% figure;
% imagesc(range_axis,time_axis,Detections3_rt);
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('Detections3');
% %colormap(jet(256));
% %colorbar;
% axis xy;

% Detections_Plotter(Ra_Data,Detections_rt,range_axis,time_axis,'1D Time Domain Detection');
% Detections_Plotter(Ra_Data,Detections3_rt,range_axis,time_axis, '2D Time Domain Detection');

% Detections_rt(:,1:Window_Size_time_1+Gaurd_Cells_time_1) = 0;
% Detections_rt(:,end-Window_Size_time_1-Gaurd_Cells_time_1:end) = 0;
% close all;
% Detections3_rt(:,1:Window_Size_2D_time+Gaurd_Cells_2D_time) = 0;
% Detections3_rt(:,end-Window_Size_2D_time-Gaurd_Cells_2D_time:end) = 0;
% Detections3_rt(1:Window_Size_2D_time+Gaurd_Cells_2D_time,:) = 0;
% Detections3_rt(end-Window_Size_2D_time-Gaurd_Cells_2D_time:end,:) = 0;

% Ra_Data(:,1:Window_Size_2D_time+Gaurd_Cells_2D_time) = 0;
% Ra_Data(:,end-Window_Size_2D_time-Gaurd_Cells_2D_time:end) = 0;
% Ra_Data(1:Window_Size_2D_time+Gaurd_Cells_2D_time,:) = 0;
% Ra_Data(end-Window_Size_2D_time-Gaurd_Cells_2D_time:end,:) = 0;

% X_Marker(Ra_Data,Detections_rt,range_axis,time_axis,'1D Time Domain Detection');
% X_Marker(Ra_Data,Detections3_rt,range_axis,time_axis, '2D Time Domain Detection');

% Detections_rt(:,1:Window_Size_time_1+Gaurd_Cells_time_1) = 0;
% Detections_rt(:,end-Window_Size_time_1-Gaurd_Cells_time_1:end) = 0;
% Detections_time_combination = Detections_rt +Detections3_rt;
% X_Marker(Ra_Data,Detections_time_combination,range_axis,time_axis, 'Combination of Time Domain Detections');

%% Doppler Detection
disp('Doppler Detection');


% Ra_Data = Filtered_Range_Lines(1:end,5:end);
% Ra_Data = Filtered_Range_Lines;

Pfa = 1e-10;
% Pfa = 1e-6;
%bike
% Gaurd_Cells_doppler_2 = 1;
% Window_Size_doppler_2 = 5;
% Detections_rd = Doppler_Detector(0.5,0.25,5,2.5,Pfa, Window_Size_doppler_2, Gaurd_Cells_doppler_2,Np,PRF,Ra_Data,0.01);

%bike
Gaurd_Cells_2D_doppler = 3;
Window_Size_2D_doppler = 3;

N = ((2*Window_Size_2D_doppler+2*Gaurd_Cells_2D_doppler+1).^2 - (2*Gaurd_Cells_2D_doppler+1).^2);
disp(N);

Detections_2D_rd = Doppler_Detector_2D(0.5,0.25,20,5,Pfa, Window_Size_2D_doppler, Gaurd_Cells_2D_doppler,Np,PRF,Ra_Data);

Gaurd_Cells_2D_doppler_X = 3;
Window_Size_2D_doppler_X = 6;
Gaurd_Cells_2D_doppler_Y = 2;
Window_Size_2D_doppler_Y = 2;

Pfa = 1e-8;
% Pfa = 1e-6;
N = ((2*Window_Size_2D_doppler_X+2*Gaurd_Cells_2D_doppler_X+1)*(2*Window_Size_2D_doppler_Y+2*Gaurd_Cells_2D_doppler_Y+1) - (2*Gaurd_Cells_2D_doppler_X+1)*(2*Gaurd_Cells_2D_doppler_Y+1));
disp(N);

% Detections_Rec_rd = Doppler_Detector_Rec(0.8,0.3,10,2,Pfa, Window_Size_2D_doppler_X, Gaurd_Cells_2D_doppler_X, Window_Size_2D_doppler_Y, Gaurd_Cells_2D_doppler_Y,Np,PRF,Ra_Data);

% Detections_Plotter(Ra_Data,Detections_2D_rd,range_axis,time_axis,'Doppler Domain Detection Square');
% Detections_Plotter(Ra_Data,Detections_Rec_rd,range_axis,time_axis,'Doppler Domain Detection Rectangle');

% close all;
% X_Marker(Ra_Data,Detections_2D_rd,range_axis,time_axis,'Doppler Domain Detection');
% 
%% Freq plot
% 
% 
% Doppler_Freq_Axis = (-Np/2:1:(Np/2-1))*PRF/Np;
% Radial_Velocity_Axis = Doppler_Freq_Axis*lamda;
%  
% Target_region = Ra_Data(:,1:22);
% 
% 
% target_doppler_series = [];
% Detection_series = [];
% Detection_series_2D = [];
% count = 0;
% target_size = size(Target_region);
% 
% FFT_period_s = 0.5; % seconds
% Samples_per_seond = PRF/Np*target_size(1);
% FFt_period_samples = FFT_period_s*Samples_per_seond;
% overlap_factor = 4;
% 
% 
% % % No. Gaurd cells
% Gaurd_Cells = 1;
% % % WIndow Size: 
% Window_Size = 5;
% 
% N = 2*Window_Size;
% 
% % No. Gaurd cells
% Gaurd_Cells_2D = 3;
% % WIndow Size: 
% Window_Size_2D = 3;
% 
% N_2D = ((2*Window_Size_2D+2*Gaurd_Cells_2D+1).^2 - (2*Gaurd_Cells_2D+1).^2);
% 
% Pfa = 1e-6;
% 
% disp(factorial(N+20));
% % 
% for i =  round(FFt_period_samples/2)+1:round(FFt_period_samples/overlap_factor):target_size(1)-round(FFt_period_samples/2);
% 	target_space = Target_region( i -round(FFt_period_samples/2)+1:i+round(FFt_period_samples/2),:);
% 	
% 	Hamming_Filter = hamming(size(target_space,1));
% 	Hamming_Matrix =  repmat(Hamming_Filter.',size(target_space,2),1); 
% 	Hamming_Matrix = Hamming_Matrix.';
% 
% 	Windowed_Result = target_space.*Hamming_Matrix;
% 	
% 	
% % 	target_doppler = fft(target_space,[],1);
% 	target_doppler = fft(Windowed_Result,[],1);
% 
% 	target_doppler_series = [target_doppler_series,target_doppler];
% 	
% 	
% 	
% 	Threshold =[]; 
% 	SD_data = abs(target_doppler).^2;
% 
% 	
% 	target_doppler_size = size(SD_data);
% 	
% 	for k = 1:target_doppler_size(2)
% 		Threshold(:,k) = OS_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_data(:,k),round(2*Window_Size*0.95));	
% 	end
% 	
% 	
% 	Threshold_2D = OS_CFAR_2D(Pfa, Window_Size_2D, Gaurd_Cells_2D, SD_data,round(N_2D*0.75));
% 	
% 	Detections = (SD_data-Threshold)>0;
% 	Detections(1:Window_Size+Gaurd_Cells,:) = 0;
% 	Detections(end - (Window_Size+Gaurd_Cells): end,:) = 0;
% 	
% 	Detections_2D = (SD_data-Threshold_2D)>0;
% 	Detections_2D(1:Window_Size_2D+Gaurd_Cells_2D,:) = 0;
% 	Detections_2D(end - (Window_Size_2D+Gaurd_Cells_2D): end,:) = 0;
% 	Detections_2D(:,1:Window_Size_2D+Gaurd_Cells_2D) = 0;
% 	Detections_2D(:,end - (Window_Size_2D+Gaurd_Cells_2D): end) = 0;
% 	
% 	
% 	Detection_series = [Detection_series,Detections];
% 	Detection_series_2D = [Detection_series_2D,Detections_2D];
% 	count = count+1;
% 	
% end;
% 
% range_series = repmat(range_axis(1:50),count,1);
% Doppler_Freq_Axis = Doppler_Freq_Axis(1:25);
% 
% figure;
% %imagesc(range_series,Doppler_Freq_Axis,(abs(target_doppler_series)));
% imagesc((abs(target_doppler_series)));
% colormap(jet(256));
% %colormap winter;
% 
% figure;
% % imagesc(range_series,Doppler_Freq_Axis,(abs(target_doppler_series)));
% imagesc((Detection_series));
% colormap(jet(256));
% 
% figure;
% % imagesc(range_series,Doppler_Freq_Axis,(abs(target_doppler_series)));
% imagesc((Detection_series_2D));
% colormap(jet(256));
% 
% target_doppler_series = target_doppler_series(:,end/2:end);
% Detection_series = Detection_series(:,end/2:end);
% 
% figure;
% subplot(2,1,1)
% imagesc((abs(target_doppler_series)));
% colormap(jet(256));
% title('Doppler Domain Recording');
% 
% subplot(2,1,2)
% 
% imagesc((abs(target_doppler_series)));
% % imagesc(Detection_series);
% colormap(jet(256));
% 
% time_step = 4;
% range_step = 20;
% 
% title('Doppler Domain Detections');
% recording_size = size(target_doppler_series);
% 
% for i = time_step/2 +1 :time_step:recording_size(1)-time_step/2 +1
%     for k = range_step/2+1:range_step:recording_size(2)-range_step/2
%         e = Detection_series(i-time_step/2:i+time_step/2,k-range_step/2:k+range_step/2);
%         if (mean(e(:)>0))
% %             disp('x');
%             text(k,i,'X', 'Color', 'w');
%         end
%     end
% end


%% Logical combination of detection methods

%Detections_time_doppler = Detections_2D_rd.*Detections_rt.*Detections2_rt.*Detections3_rt;

recording_size = size(Ra_Data);

Detections_time_doppler = zeros(recording_size(1),recording_size(2));
Detections_time_doppler_2 = zeros(recording_size(1),recording_size(2));
time_step = 10;
range_step = 2;

Detections_rt(:,1:Window_Size_time_1+Gaurd_Cells_time_1) = 0;
Detections_rt(:,end-Window_Size_time_1-Gaurd_Cells_time_1:end) = 0;

Detections_time_combination = Detections_rt +Detections3_rt;


for i = 1:1:recording_size(1)-time_step
	for k = 1:1:recording_size(2)-range_step

		c = zeros(time_step+1,range_step+1);

				
		if((i > (Gaurd_Cells_2D_time+Window_Size_2D_time)) && ((recording_size(1)-i)-time_step > (Gaurd_Cells_2D_time+Window_Size_2D_time)))
			if((k > (Gaurd_Cells_2D_time+Window_Size_2D_time)) && ((recording_size(2)-k)-range_step > (Gaurd_Cells_2D_time+Window_Size_2D_time)))
				c = Detections_time_combination(i:i+time_step,k:k+range_step);
			end
		end
		
		d = Detections_2D_rd(i:i+time_step,k:k+range_step);

		if (mean(d(:)>0))*(mean(c(:)>0)) > 0
			Detections_time_doppler(i:i+time_step,k:k+range_step) = 1;
        end
        
	end
end

% figure;
% imagesc(Detections_time_combination);
% 
% 
% figure;
% imagesc(range_axis,time_axis,20*log10(abs(Ra_Data))+20*log10(30*(Detections_time_doppler)+1));
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('Time and Doppler domain detection');
% colormap(jet(256));
% colorbar;
% axis xy;
% 
% Detections_Plotter(Ra_Data,Detections_time_combination,range_axis,time_axis,'Range combination detection');
% Detections_Plotter(Ra_Data,Detections_time_doppler,range_axis,time_axis,'Time and Square Doppler domain detection');
% Detections_Plotter(Ra_Data,Detections_time_doppler_2,range_axis,time_axis,'Time and Rectangle Doppler domain detection ');

% X_Marker(Ra_Data,Detections_time_doppler,range_axis,time_axis,'Time and Doppler domain combination detection');

% figure
% imagesc(log10(abs(Ra_Data)));

% X_Marker(Ra_Data,Detections_time_doppler_2,range_axis,time_axis,'Time and Rectangle Doppler domain detection ');

% X_Marker(Ra_Data,Detections_time_combination,range_axis,time_axis,'Range combination detection');

close all;
% 
% Detections_time_combination(:,1:Window_Size_2D_time+Gaurd_Cells_2D_time) = 0;
% Detections_time_combination(:,end-Window_Size_2D_time-Gaurd_Cells_2D_time:end) = 0;
% Detections_time_combination(1:Window_Size_2D_time+Gaurd_Cells_2D_time,:) = 0;
% Detections_time_combination(end-Window_Size_2D_time-Gaurd_Cells_2D_time:end,:) = 0;
Final_Detection_Plotter(Ra_Data,Detections_time_combination, Detections_2D_rd, Detections_time_doppler,range_axis,time_axis,'one');
