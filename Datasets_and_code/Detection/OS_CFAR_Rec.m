%% Function takes values and returns threshold value for signal
function [T_OS_CFAR] = OS_CFAR_Rec(Pfa, Window_Size_X, Gaurd_Cells_X, Window_Size_Y, Gaurd_Cells_Y, SD_Signal, index)

N = ((2*Window_Size_X+2*Gaurd_Cells_X+1)*(2*Window_Size_Y+2*Gaurd_Cells_Y+1) - (2*Gaurd_Cells_X+1)*(2*Gaurd_Cells_Y+1));
dimensions = size(SD_Signal);

format longE;
T_CFAR = zeros(dimensions(1),dimensions(2));
for i = 1:dimensions(1) %X - dimension
	if(i < Window_Size_X+Gaurd_Cells_X+1 || i > dimensions(1) - (Window_Size_X+Gaurd_Cells_X+1))
		T_CFAR(i) = 0;
		continue;
	end
	
	for k = 1:dimensions(2) % Y - Dimension
		if(k < Window_Size_Y+Gaurd_Cells_Y+1 || k > dimensions(2) - (Window_Size_Y+Gaurd_Cells_Y+1))
			T_CFAR(i) = 0;
			continue;
        end
		
		Test_Region = SD_Signal(i-Window_Size_X-Gaurd_Cells_X:i+Window_Size_X+Gaurd_Cells_X,k-Window_Size_Y-Gaurd_Cells_Y:k+Window_Size_Y+Gaurd_Cells_Y);
		Test_Region(ceil(end/2)-Gaurd_Cells_X:ceil(end/2)+Gaurd_Cells_X,ceil(end/2)-Gaurd_Cells_Y:ceil(end/2)+Gaurd_Cells_Y) = 0;
		Test_Region = Test_Region(:);
		
		Test_Region_sorted = sort(Test_Region,'ascend');
		Test_Region_sorted = Test_Region_sorted((1+Gaurd_Cells_X*2)*(1+Gaurd_Cells_Y*2):end);
	
		alpha_values = 4:1:20;
		Pfa_values = factorial(N)*factorial(alpha_values+N-index)./(factorial(N-index)*factorial(alpha_values+N));
		[val,ind] =  min(abs(Pfa_values - ones(1,17)*Pfa));
		alpha = alpha_values(ind);
	
		g = Test_Region_sorted(index);
	
		T_CFAR(i,k) = g*alpha;
	end
	
end

T_OS_CFAR = T_CFAR;

end
