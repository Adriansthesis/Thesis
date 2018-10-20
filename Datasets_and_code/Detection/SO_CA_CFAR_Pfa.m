%% Function takes values and returns threshold value for signal
function [error] = SO_CA_CFAR_Error(alpha,Pfa, Window_Size)
    summation_result = 0;
    N = 2*Window_Size;
    for k =0:N/2-1
        summation_result = summation_result + nchoosek(N/2 -1 +k,k)*(2+alpha/(N/2)^(-k));
    end
    
    Pfa_calc = 2*(2+alpha/(N/2))^(-N/2)*summation_result;
    
    error = abs(Pfa-Pfa_calc);
end