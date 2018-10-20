close all;
% clear all;

N = 32;
Pfa = 1e-3;
index = 0.75*(N);
p = index;

alpha_values = 1:1:500;
Pfa_values = factorial(N)*factorial(alpha_values+N-index)./(factorial(N-index)*factorial(alpha_values+N));
[val,ind] =  min(abs(Pfa_values - ones(1,length(alpha_values))*Pfa));
alpha = alpha_values(ind);

SNR_dB = 0:1:30;


Iterations = 1e6;


Reference_cells = zeros(N,Iterations);

for i = 1:N
    I = raylrnd(1,1,Iterations);
    Q = raylrnd(1,1,Iterations);
    Reference_cells(i,:) = (I + 1j*Q)/sqrt(2);
end


Reference_cells_AD = abs(Reference_cells).^2;




	
Sorted_Reference_cells = sort(Reference_cells_AD,1,'ascend');
g = Sorted_Reference_cells(index);

alpha_go_array = ones(1,Iterations)*alpha;
T = g.*alpha_go_array;

I_test = raylrnd(1,1,Iterations);
Q_test = raylrnd(1,1,Iterations);
Test_Signal = (I_test + 1j*Q_test)/sqrt(2);
Test_AD = abs(Test_Signal).^2;

False_Alarms = sum((Test_AD-T)>0);
Simulated_Pfa = False_Alarms/Iterations

Pfa_Error = 100*(Simulated_Pfa-Pfa)/Pfa

%% two

Pd = [];
Pd_sim = [];
for index = 1:length(SNR_dB)
    SNR = 10^(SNR_dB(index)/10);
    disp(SNR_dB(index));
    %Math for simulated values
    
    I_test = randn(Iterations,1);
    Q_test = randn(Iterations,1);
    Test_Signal = sqrt(SNR)*(I_test + 1j*Q_test)/sqrt(2)+ Reference_cells(10,:).';
    Test_AD = abs(Test_Signal).^2;
    
    
    
	Sorted_Reference_cells = sort(Reference_cells_AD,1,'descend');
    g = Sorted_Reference_cells(index);
	T_CFAR = g.*alpha_go_array;
    
    
    Detections = ( Test_AD.'-T_CFAR )>0;
    
    Pd_sim = [Pd_sim; sum(Detections(:))/Iterations];
    
    
    % Math for expected values
    
    multiplication_OS = 1;
    for l = 0:1:p-1
        multiplication_OS = multiplication_OS*(N-l)/(N-l+alpha/(1+SNR));
    end
    
    Pd = [Pd ; multiplication_OS];

end

plot(SNR_dB,Pd);
hold on;
plot(SNR_dB,Pd_sim.');
title(strcat('Pd vs SNR for GO-CA-CFAR with Pfa of :',num2str(Pfa)));
xlabel('SNR [dB]');
ylabel('Pd');
legend('Expected Pd','Simulated Pd');

% %clear all;
% format longE;
% 
% Iterations = 1e6;
% N = 24;
% 
% %Create values for Pfa comparison
% % Iterations = 1821;
% % N = 142;
% 
% % % Create values for Pd comparison
% % Iterations = 456;
% % N = 27;
% 
% index =0.75*N;
% %SNR_dB = 28;
% SNR_dB = 27;
% 
% 
% Pfa = [];
% Pfa_average = [];
% 
% I = randn(N,Iterations);
% Q = randn(N,Iterations);
% Reference_cells = (I + 1j*Q)/sqrt(2);
% 	
% exponents = 1:0.2:5;
% Pfa_values = 10.^(-1*exponents);
% 
% Reference_cells_AD = abs(Reference_cells).^2;
% Sorted_Cells = sort(Reference_cells_AD,1,'ascend');
%     
% g = Sorted_Cells(index,:);
% Pd = [];
% 
% for i = 1:length(Pfa_values)
%     Pfa = Pfa_values(i);
%     
%     alpha_values = 1:1:500;
%     Pfa_value_list = factorial(N)*factorial(alpha_values+N-index)./(factorial(N-index)*factorial(alpha_values+N));
%     [val,ind] =  min(abs(Pfa_value_list - ones(1,length(alpha_values))*Pfa));
%     alpha = alpha_values(ind);
%     
%     T = g.*alpha;
%     
%     I = randn(1,Iterations);
%     Q = randn(1,Iterations);
%     
%     SNR_lin = 10^(SNR_dB/10);
%     CUT =  sqrt(SNR_lin)*(I + 1j*Q)/sqrt(2);
%     CUT_AD = abs(CUT).^2;
%     Detections = sum((CUT_AD-T)>0);
%     
%     Pd = [Pd,sum(Detections(:))/(size(CUT_AD,1)*(size(CUT_AD,2)))];
% end
% 
% hold on;
% semilogx(Pfa_values,Pd);
% 
% semilogy(Pd);
