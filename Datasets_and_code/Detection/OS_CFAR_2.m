%% Function takes values and returns threshold value for signal
function [T_OS_CFAR] = OS_CFAR_2(Pfa, Window_Size, Gaurd_Cells, SD_Signal, index)

N = 2*(Window_Size);
Iterations = length(SD_Signal);

T_CFAR = zeros(Iterations,1);
for i = 1:Iterations
	if(i < Window_Size+Gaurd_Cells+1 )
		Window_Front = [];%SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
		Window_Back = SD_Signal(i:i+2*Window_Size+Gaurd_Cells);
	elseif(i > Iterations - (Window_Size+Gaurd_Cells+1))
		Window_Front =  SD_Signal(i-2*Window_Size-Gaurd_Cells:i);
		Window_Back = [];
	else
		Window_Front = SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
		Window_Back = SD_Signal(i+1+Gaurd_Cells:i+Window_Size+Gaurd_Cells);
	end
	Windows = [Window_Front,Window_Back];
	Windows = sort(Windows,'ascend');
	
	alpha_values = 4:1:20;
	Pfa_values = factorial(N)*factorial(alpha_values+N-index)./(factorial(N-index)*factorial(alpha_values+N));
	[val,ind] =  min(abs(Pfa_values - ones(1,17)*Pfa));
	alpha = alpha_values(ind);
	
	g = Windows(index);
	%alpha = N*(Pfa^(-1/(N))-1);
	T_CFAR(i) = g*alpha;
	
end

T_OS_CFAR = T_CFAR;

end
