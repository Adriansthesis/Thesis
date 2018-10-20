clear all;
format longE;

Iterations = 1e6;
N = 20;
index =15;



Reference_cells = zeros(N,Iterations);

alpha_range = 4:1:20;

Pfa = [];
Pfa_average = [];

I = randn(N,Iterations);
Q = randn(N,Iterations);
Reference_cells = (I + 1j*Q)/sqrt(2);
	

Reference_cells_AD = abs(Reference_cells).^2;
Sorted_Cells = sort(Reference_cells_AD,1,'ascend');
	
g = Sorted_Cells(index,:);

    
    
for alpha  = alpha_range

	disp(alpha);

	
	T = g*alpha;

	I_test = randn(Iterations,1);
	Q_test = randn(Iterations,1);
	Test_Signal = (I_test + 1j*Q_test)/sqrt(2);
	Test_AD = abs(Test_Signal).^2;

	False_Alarms = sum((Test_AD.'-T)>0);
	Pfa = [Pfa;False_Alarms/Iterations];
    
    Pfa_average = [Pfa_average; factorial(N)*factorial(alpha+N-index)/(factorial(N-index)*factorial(alpha+N))];
   
end;
close all
figure;
semilogy(alpha_range,Pfa);
hold on;
semilogy(alpha_range,Pfa_average);
grid on;
xlabel('Alpha Value');
ylabel('Pfa');
title('OS-CFAR Pfa vs alpha')
legend('Simulated Pfa','Expected Pfa')

