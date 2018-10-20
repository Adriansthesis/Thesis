function [Detections] = Doppler_Detector_2D(time_step,time_overlap,range_step,range_overlap,Pfa, Window_Size, Gaurd_Cells,Np,PRF,Target_region)

target_size = size(Target_region);

Samples_per_seond = PRF/Np*target_size(1);
time_step_s = time_step*Samples_per_seond;
time_overlap_s = time_overlap*Samples_per_seond;


N = ((2*Window_Size+2*Gaurd_Cells+1).^2 - (2*Gaurd_Cells+1).^2);

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
		
		
		Threshold = OS_CFAR_2D(Pfa, Window_Size, Gaurd_Cells, Window_doppler,round(N*0.8));	
			
		
	
		Detections_doppler = (Window_doppler-Threshold)>0;
		Detections_doppler(1:Window_Size+Gaurd_Cells,:) = 0;
		Detections_doppler(end - (Window_Size+Gaurd_Cells): end,:) = 0;
		Detections_doppler(:,1:Window_Size+Gaurd_Cells) = 0;
		Detections_doppler(:,end - (Window_Size+Gaurd_Cells): end) = 0;
		
		%0.1 works for bus
		
		if mean(Detections_doppler(:)) > 0
			%disp(mean(Detections_doppler(:)))
			Detections(i-round(time_step_s/2)+1:i+round(time_step_s/2),k-round(range_step/2)+1:k+round(range_step/2)) = 1;
		end
	end
	
end










