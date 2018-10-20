clear all;
close all;
%% Specify Dataset



Range_align = 0;

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
Dataset = '55 Jason wlaking arms swinging 4(109 MHz).wav';
%% Get range lines

[Range_Lines,range_axis,time_axis,Np] = Get_Range_Lines(Dataset,109e6);
Range_Lines = Range_Lines(:,3:end);
range_axis = range_axis(3:end);
lamda = 3e8/2.45e9;


%% Filter cluter
figure;
plot(sum(abs(fft(Range_Lines,[],1)).^2,2));

disp('Filtering');
load ring_road_filter;


Filtered_Range_Lines = filter(h,1,Range_Lines,[],1);
Filtered_Range_Lines = Filtered_Range_Lines(length(h):end,:);
time_axis = time_axis(length(h):end);

Filtered_Range_Lines = Filtered_Range_Lines(:,3:end);
range_axis = range_axis(3:end);

% figure;	
% plot(sum(abs(fft(Filtered_Range_Lines,[],1)).^2,2));
% 
% figure;
% imagesc(range_axis,time_axis,20*log10(abs(Filtered_Range_Lines)));
% % imagesc(20*log10(abs(Filtered_Range_Lines)));
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('RTI With clutter rejection');
% colormap(jet(256));
% colorbar;
% axis xy;


%% Detection Algorithm
disp('Range detection');
SD_data = abs(Filtered_Range_Lines).^2;
load Filtered_Noise;

Pfa = 1e-6;
dimensions = size(SD_data);
Threshold = zeros(dimensions(1),dimensions(2));
Threshold2 = zeros(dimensions(1),dimensions(2));


for i = 1:dimensions(2)
	Filtered_Noise_Slice = Filtered_Noise(200:300,i);
	SD_Noise = abs(Filtered_Noise_Slice).^2;
	Threshold(:,i) = FN_OS_CFAR(Pfa, SD_data(:,i),SD_Noise);
end

format longE;

Detections_time = (SD_data-Threshold)>0;

% figure;
% imagesc(range_axis,time_axis,Detections_time);
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('Detections');
% axis xy;	


%% Range allignmet
% disp('Range Allignment');
% % Bus
% % [Ra_Data,otherstuff] = RobustRangeAlignment(Filtered_Range_Lines(100:end,10:end));
% % Car
% % [Ra_Data,otherstuff] = RobustRangeAlignment(Filtered_Range_Lines(1:end,1:end));
% % Person
% %[Ra_Data,otherstuff] = RobustRangeAlignment(Filtered_Range_Lines(1:400,5:end));
% % bike
% [Ra_Data,otherstuff] = RobustRangeAlignment(Filtered_Range_Lines(1:end,5:end));

%% Doppler Detection
disp('Doppler Detection');

load Filtered_Noise_Doppler.mat

Pfa = 1e-6;
PRF = 100;

Ra_Data = Filtered_Range_Lines;

Detections_doppler = FN_Doppler_Detector(0.5,0.25,5,2.5,Pfa,Np,PRF,Ra_Data,Filtered_Noise);

figure;
imagesc(20*log10(abs(Ra_Data))+20*log10(30*(Detections_doppler)+1));
colormap(jet(256));

 %% Freq plot
% disp('Doppler Detection plot');
% 
% 
% 
% PRF = 100;
% Doppler_Freq_Axis = (-Np/2:1:(Np/2-1))*PRF/Np;
% Radial_Velocity_Axis = Doppler_Freq_Axis*lamda;
%  
% Target_region = Ra_Data(:,1:30);
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
% Pfa = 1e-8;
%  
% for i =  round(FFt_period_samples/2)+1:round(FFt_period_samples/overlap_factor):target_size(1)-round(FFt_period_samples/2);
% 	target_space = Target_region( i -round(FFt_period_samples/2)+1:i+round(FFt_period_samples/2),:);
% 	
% 	Hamming_Filter = hamming(size(target_space,1));
% 	Hamming_Matrix =  repmat(Hamming_Filter.',size(target_space,2),1); 
% 	Hamming_Matrix = Hamming_Matrix.';
% 
% 	Windowed_Result = target_space.*Hamming_Matrix;
% 	
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
% 		Filtered_Noise_Slice = fft(Filtered_Noise(200:300,k),[],1);
% 		SD_Noise = abs(Filtered_Noise_Slice).^2;
% 		Threshold(:,k) = FN_OS_CFAR(Pfa, SD_data(:,k),SD_Noise);	
% 	end
% 	
% 		
% 	Detections = (SD_data-Threshold)>0;
% 
% 	Detection_series = [Detection_series,Detections];
% 	count = count+1;
% 	
% end;
% 
% % range_series = repmat(range_axis(1:50),count,1);
% % Doppler_Freq_Axis = Doppler_Freq_Axis(1:25);
% 
% figure;
% imagesc((abs(target_doppler_series)));
% colormap(jet(256));
% 
% 
% figure;
% imagesc((Detection_series));
% colormap(jet(256));

%% Logical combination of detection methods

disp('Time and Doppler Detection combination');

recording_size = size(Ra_Data);

Detections_time_doppler = zeros(recording_size(1),recording_size(2));
time_step = 10;
range_step = 2;



for i = 1:1:recording_size(1)-time_step
	for k = 1:1:recording_size(2)-range_step

        c = Detections_time(i:i+time_step,k:k+range_step);
        d = Detections_doppler(i:i+time_step,k:k+range_step);

		if (mean(d(:)>0))*(mean(c(:)>0)) > 0
			Detections_time_doppler(i:i+time_step,k:k+range_step) = 1;
		end
	end
end



% 
% figure;
% imagesc(range_axis,time_axis,20*log10(abs(Ra_Data))+20*log10(30*(Detections_time_doppler)+1));
% ylabel('Time (s)');
% xlabel('Range (m)');
% title('Time and Doppler domain detection');
% colormap(jet(256));
% colorbar;
% axis xy;

close all;
% X_Marker(Ra_Data,Detections_time,range_axis,time_axis,'Time Domain Detection');
% X_Marker(Ra_Data,Detections_doppler,range_axis,time_axis,'Doppler Domain Detection');
% X_Marker(Ra_Data,Detections_time_doppler,range_axis,time_axis,'Time and Doppler domain combination detection');

Final_Detection_Plotter(Ra_Data,Detections_time, Detections_doppler, Detections_time_doppler,range_axis,time_axis,'one');
