%% Function takes values and returns threshold value for signal
function [T_OS_CFAR] = OS_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal, index)

N = (Window_Size);
Iterations = length(SD_Signal);

T_CFAR = zeros(Iterations,1);
for i = 1:Iterations
	if(i < Window_Size+Gaurd_Cells+1 || i > Iterations - (Window_Size+Gaurd_Cells+1))
		T_CFAR(i) = 0;
		continue;
	end
	Window_Front = SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
	Window_Back = SD_Signal(i+1+Gaurd_Cells:i+Window_Size+Gaurd_Cells);
	
	Window_Front = sort(Window_Front);
	Window_Back = sort(Window_Back);
	
	%Sum_Reference_cells = min(sum(Window_Front),sum(Window_Back));
	%g = Sum_Reference_cells./N;
	g = min(Window_Front(index),Window_Back(index));
	alpha = N*(Pfa^(-1/(N))-1);
	T_CFAR(i) = g*alpha;
	
end

T_OS_CFAR = T_CFAR;

end
