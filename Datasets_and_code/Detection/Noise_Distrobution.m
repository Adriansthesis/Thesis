close all;
clear all;

%load Filtered_Noise;
load ring_road_filter;

Dataset = '58 Nothing (109MHz).wav';
[Range_Lines,range_axis,time_axis,Np] = Get_Range_Lines(Dataset,109e6);


Filtered_Range_Lines = filter(h,1,Range_Lines,[],1);
Filtered_Range_Lines = Filtered_Range_Lines(length(h):end,:);
Filtered_Range_Lines = Filtered_Range_Lines(1:end/4,end/1.5:end);

SD_Noise = abs(Filtered_Range_Lines(:)).^2;
SD_Noise = SD_Noise(randperm(length(SD_Noise)));

Training_Data = SD_Noise(1:end/2);
Testing_Data = SD_Noise(end/2:end);

x = linspace(0,3e-10,100);
[mu,ci] = expfit(Training_Data,(1-0.95));


figure;
h = histogram(abs(Filtered_Range_Lines(:)).^2,1e3);
xlim([0,3e-10]);
title('Histogram of noise');
xlabel('x')
ylabel('Frequency');



%% Test KS test on simulated normal data
% 
% data = randn(1,2e5);
% 
% test_CDF = makedist('Normal');
% % x = linspace(0,1,1e6);
% [h,p,k,c] = kstest(data,test_CDF);
% 
% %% KS Test on simulated exponential data
% 
% data = exprnd(mu/4.3, 67340,1);
% 
% test_CDF = makedist('Exponential','mu',mu/4.3);
% [h,p,k,c] = kstest(data,test_CDF)
% 
% %% Plot simulated exponential data
% 
% [f,x_values] = ecdf(data);
% J = plot(x_values,f);
% hold on;
% K = plot(x_values,expcdf(x_values,0.2));
% xlim([0,1]);


%% Test KS with measured data
test_CDF = makedist('Exponential','mu',mu);
[h,p,k,c] = kstest(Testing_Data,test_CDF)

%% Plot Estimated statistic

figure;
[f,x_values] = ecdf(Testing_Data);
J = plot(x_values,f);
hold on;
K = plot(x_values,expcdf(x_values,mu));
xlim([0,3e-10]);
legend('CDF of Tesing dataset','CDF of exponential PDF with fitted \mu')
title('CDF of Distributions');
ylabel('Probability');
xlabel('x');
