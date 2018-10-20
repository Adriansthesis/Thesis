%% Function takes values and returns threshold value for signal
function [T_CA_CFAR] = CA_CFAR(Pfa, Window_Size, Gaurd_Cells, SD_Signal)

N = (Window_Size)*2;
Iterations = length(SD_Signal);

T_CFAR = zeros(Iterations,1);
for i = 1:Iterations
	if(i < Window_Size+Gaurd_Cells+1 || i > Iterations - (Window_Size+Gaurd_Cells+1))
		T_CFAR(i) = 0;
		continue;
	end
	Window_Front = SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
	Window_Back = SD_Signal(i+1+Gaurd_Cells:i+Window_Size+Gaurd_Cells);
	
	Sum_Reference_cells = sum(Window_Front)+sum(Window_Back);
	g = Sum_Reference_cells./N;
	alpha = N*(Pfa^(-1/(N))-1);
	T_CFAR(i) = g*alpha;
	
end

T_CA_CFAR = T_CFAR;

end
