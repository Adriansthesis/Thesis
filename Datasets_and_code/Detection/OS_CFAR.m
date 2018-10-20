%% Function takes values and returns threshold value for signal
function [T_OS_CFAR] = OS_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal, index)

N = 2*(Window_Size);
Iterations = length(SD_Signal);

alpha_values = 1:1:500;
Pfa_values = factorial(N)*factorial(alpha_values+N-index)./(factorial(N-index)*factorial(alpha_values+N));
[val,ind] =  min(abs(Pfa_values - ones(1,length(alpha_values))*Pfa));
alpha = alpha_values(ind);

T_CFAR = zeros(Iterations,1);
for i = 1:Iterations
	if(i < Window_Size+Gaurd_Cells+1 || i > Iterations - (Window_Size+Gaurd_Cells+1))
		T_CFAR(i) = 0;
		continue;
	end
	Window_Front = SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
	Window_Back = SD_Signal(i+1+Gaurd_Cells:i+Window_Size+Gaurd_Cells);
	
	Windows = [Window_Front,Window_Back];
	Windows = sort(Windows,'ascend');
	
	
	
	g = Windows(index);
	%alpha = N*(Pfa^(-1/(N))-1);
	T_CFAR(i) = g*alpha;
	
end

T_OS_CFAR = T_CFAR;

end
