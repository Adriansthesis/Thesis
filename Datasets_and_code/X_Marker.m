function X_Marker(Ra_Data,Detections,range_axis,time_axis,plot_title)

recording_size = size(Ra_Data);


figure;
imagesc(range_axis,time_axis,20*log10(abs(Ra_Data)));
ylabel('Time (s)');
xlabel('Range (m)');
title(plot_title);
colormap(jet(256));
colorbar;
axis xy;

% hold on;

time_step = round(length(time_axis)/30);
if mod(time_step,2) > 0
    time_step = time_step +1;
end
range_step = 2;


for i = time_step/2 +1 :time_step:recording_size(1)-time_step/2 +1
    for k = range_step/2+1:range_step:recording_size(2)-range_step/2
        e = Detections(i-time_step/2:i+time_step/2,k-range_step/2:k+range_step/2);
        if (mean(e(:)>0))
%             disp('x');
            text(range_axis(k-1),time_axis(i-1),'X');
        end
    end
end



end