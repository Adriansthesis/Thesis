function Detections_Plotter(Range_Doppler,Detections,range_axis,time_axis,plot_title)

figure;
rd = imagesc(range_axis,time_axis,20*log10(abs(Range_Doppler)));
ylabel('Time (s)');
xlabel('Range (m)');
title(plot_title);
colormap(jet(256));
colorbar;
axis xy;

hold on;

im_size = size(Detections);
b = ones(im_size(1),im_size(2),3,'uint8')*0;
d = image(range_axis,time_axis,b);
alpha(d,Detections);


end