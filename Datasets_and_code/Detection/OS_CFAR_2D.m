%% Function takes values and returns threshold value for signal
function [T_OS_CFAR] = OS_CFAR_2D(Pfa, Window_Size, Gaurd_Cells, SD_Signal, index)

N = ((2*Window_Size+2*Gaurd_Cells+1).^2 - (2*Gaurd_Cells+1).^2);
dimensions = size(SD_Signal);

format longE;

alpha_values = 1:1:500;
Pfa_values = factorial(N)*factorial(alpha_values+N-index)./(factorial(N-index)*factorial(alpha_values+N));
[val,ind] =  min(abs(Pfa_values - ones(1,length(alpha_values))*Pfa));
alpha = alpha_values(ind);

T_CFAR = zeros(dimensions(1),dimensions(2));
for i = 1:dimensions(1)
	if(i < Window_Size+Gaurd_Cells+1 || i > dimensions(1) - (Window_Size+Gaurd_Cells+1))
		T_CFAR(i) = 0;
		continue;
	end
	
	for k = 1:dimensions(2)
		if(k < Window_Size+Gaurd_Cells+1 || k > dimensions(2) - (Window_Size+Gaurd_Cells+1))
			T_CFAR(i) = 0;
			continue;
		end
		%Window_Front = SD_Signal(i-Window_Size-Gaurd_Cells:i-1-Gaurd_Cells);
		%Window_Back = SD_Signal(i+1+Gaurd_Cells:i+Window_Size+Gaurd_Cells);
		
		Test_Region = SD_Signal(i-Window_Size-Gaurd_Cells:i+Window_Size+Gaurd_Cells,k-Window_Size-Gaurd_Cells:k+Window_Size+Gaurd_Cells);
		Test_Region(ceil(end/2)-Gaurd_Cells:ceil(end/2)+Gaurd_Cells,ceil(end/2)-Gaurd_Cells:ceil(end/2)+Gaurd_Cells) = 0;
		Test_Region = Test_Region(:);
		
		Test_Region_sorted = sort(Test_Region,'ascend');
		Test_Region_sorted = Test_Region_sorted((1+Gaurd_Cells*2)^2:end);
		%Windows = [Window_Front,Window_Back];
		%Windows = sort(Windows,'ascend');
	
		
	
		g = Test_Region_sorted(index);
	
		T_CFAR(i,k) = g*alpha;
	end
	
end

T_OS_CFAR = T_CFAR;

end
