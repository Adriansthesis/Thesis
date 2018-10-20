%% Function takes values and returns threshold value for signal
function [alpha] = SO_CA_CFAR_alpha(Pfa, Window_Size)
    initial_value = 1;
    fun = @(b) SO_CA_CFAR_Error(b(1),Pfa, Window_Size);
    alpha = abs(fminsearch(fun, initial_value));
end




