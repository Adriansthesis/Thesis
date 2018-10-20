function [Detections] = FN_Doppler_Detector(time_step,time_overlap,range_step,range_overlap,Pfa,Np,PRF,Target_region,Filtered_Noise_Doppler)

target_size = size(Target_region);

Samples_per_seond = PRF/Np*target_size(1);
time_step_s = time_step*Samples_per_seond;
time_overlap_s = time_overlap*Samples_per_seond;

Detections = zeros(target_size(1),target_size(2));

for i = ceil(time_step_s/2):round(time_overlap_s):target_size(1)-ceil(time_step_s/2)
	for k = ceil(range_step/2):round(range_overlap):target_size(2)- ceil(range_step/2)
		
		Window = Target_region(i-round(time_step_s/2)+1:i+round(time_step_s/2),k-round(range_step/2)+1:k+round(range_step/2));
		
		Hamming_Filter = hamming(size(Window,1));
		Hamming_Matrix =  repmat(Hamming_Filter.',size(Window,2),1); 
		Hamming_Matrix = Hamming_Matrix.';

		Windowed_Result = Window.*Hamming_Matrix;
	
		Window_doppler = fft(Windowed_Result,[],1);
		Window_doppler = abs(Window_doppler).^2;
		
		target_doppler_size = size(Window_doppler);
		Threshold = zeros(target_doppler_size(1),target_doppler_size(2));
		
		for l = 1:target_doppler_size(2)
			Filtered_Noise_Slice = fft(Filtered_Noise_Doppler(200:350,l),[],1);
			SD_Noise = abs(Filtered_Noise_Slice).^2;
			Threshold(:,l) = FN_OS_CFAR(Pfa, Window_doppler(:,l),SD_Noise);	
		end
	
		Detections_doppler = (Window_doppler-Threshold)>0;
		
		if mean(Detections_doppler(:)) > 0
			Detections(i-round(time_step_s/2)+1:i+round(time_step_s/2),k-round(range_step/2)+1:k+round(range_step/2)) = 1;
		end
	end
	
end










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
% 	target_doppler = fft(target_space,[],1);
% 	%target_doppler = target_doppler(0.15*length(target_doppler):end,:); 
% 
% 	target_doppler = fftshift(target_doppler,1);
% 	target_doppler_series = [target_doppler_series,target_doppler];
% 	
% 	
% 	
% 	Threshold =[]; 
% 	SD_data = abs(target_doppler).^2;
% 	target_doppler_size = size(SD_data);
% 	
% 	for k = 1:target_doppler_size(1)
% 		Threshold(k,:) = OS_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_data(k,:),round(2*Window_Size*0.75));	
% 	end
% 	
% 	Detections = (SD_data-Threshold)>0;
% 	
% 	Detection_series = [Detection_series,Detections];
% 	count = count+1;
% 	
% end;
% 
% range_series = repmat(range_axis(1:50),count,1);
% end