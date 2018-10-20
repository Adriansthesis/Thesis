function Final_Detection_Plotter(Ra_Data,Detections_time, Detections_doppler, Detections_combination,range_axis,time_axis,plot_title)

recording_size = size(Ra_Data);
time_step = round(length(time_axis)/35);
if mod(time_step,2) > 0
    time_step = time_step +1;
end
range_step = 4;


figure('rend','painters','pos',[10 10 1100 900])
subplot(2,2,1)
imagesc(range_axis,time_axis,20*log10(abs(Ra_Data)));
ylabel('Time (s)');
xlabel('Range (m)');
title(plot_title);
colormap(jet(256));
colorbar;
axis xy;
title('Recording')

subplot(2,2,2)

imagesc(range_axis,time_axis,20*log10(abs(Ra_Data)));
ylabel('Time (s)');
xlabel('Range (m)');
title(plot_title);
colormap(jet(256));
colorbar;
axis xy;
title('Recording')

for i = time_step/2 +1 :time_step:recording_size(1)-time_step/2 
    for k = range_step/2+1:range_step:recording_size(2)-range_step/2
        e = Detections_time(i-time_step/2:i+time_step/2,k-range_step/2:k+range_step/2);
        if (mean(e(:)>0))
%             disp('x');
            text(range_axis(k),time_axis(i),'X');
        end
    end
end

title('Time-domain Detections')

subplot(2,2,3)

imagesc(range_axis,time_axis,20*log10(abs(Ra_Data)));
ylabel('Time (s)');
xlabel('Range (m)');
title(plot_title);
colormap(jet(256));
colorbar;
axis xy;
title('Recording')

for i = time_step/2 +1 :time_step:recording_size(1)-time_step/2 
    for k = range_step/2+1:range_step:recording_size(2)-range_step/2
        e = Detections_doppler(i-time_step/2:i+time_step/2,k-range_step/2:k+range_step/2);
        if (mean(e(:)>0))
%             disp('x');
            text(range_axis(k),time_axis(i),'X');
        end
    end
end

title('Doppler-domain Detections')


subplot(2,2,4)

imagesc(range_axis,time_axis,20*log10(abs(Ra_Data)));
ylabel('Time (s)');
xlabel('Range (m)');
title(plot_title);
colormap(jet(256));
colorbar;
axis xy;
title('Recording')

for i = time_step/2 +1 :time_step:recording_size(1)-time_step/2 +1
    for k = range_step/2+1:range_step:recording_size(2)-range_step/2
        e = Detections_combination(i-time_step/2:i+time_step/2,k-range_step/2:k+range_step/2);
        if (mean(e(:)>0))
%             disp('x');
            text(range_axis(k),time_axis(i),'X');
        end
    end
end

title('Time-Doppler Combination Detections')

% hold on;







end