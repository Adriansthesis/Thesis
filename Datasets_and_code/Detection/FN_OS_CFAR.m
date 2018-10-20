%% Function takes values and returns threshold value for signal
function [T_OS_CFAR] = FN_OS_CFAR(Pfa, SD_Signal,FN)

Iterations = length(SD_Signal);

T_CFAR = zeros(Iterations,1);
for i = 1:Iterations
	
	Windows = sort(FN,'ascend');
	
	alpha_values = 4:1:20;
	N = length(FN);
	index = round(N*0.7);
	
	Pfa_values = factorial(N).*factorial(alpha_values+N-index)./(factorial(N-index).*factorial(alpha_values+N));
	
	if factorial(alpha_values+N) == Inf
		disp('overflow');
	end
	
	[val,ind] =  min(abs(Pfa_values - ones(1,17)*Pfa));
	
	alpha = alpha_values(ind);
	
	g = Windows(index(1));

	T_CFAR(i) = g*alpha;
	
end

T_OS_CFAR = T_CFAR;

end