function [AlignedMatrix,BinShiftFound_Fitted] = RobustRangeAlignment(sif)

%Function to perform range alignment on unaligned range profiles

%[AlignedMatrix] - This is the range aligned range profiles
%[sif] - This is the input range lines matrix.


%Step 0: Initialisation
UnalignedMatrix = sif(4:end-4,:);
N = size(UnalignedMatrix,1);    %range profile
M = size(UnalignedMatrix,2);    %range bins
AlignedMatrix = zeros(N,M);
[MaxUnal Idx] = max(max(UnalignedMatrix,[],2));
AlignedMatrix(Idx,:) = UnalignedMatrix(Idx,:);  %first profile
RefProfile = abs(UnalignedMatrix(Idx,:)); % first profile
BinShifts_NonInteger = -0.5:0.0025:0.5; % number of non-integer bin shifts to consider
BinShifts_NonInteger_initial = BinShifts_NonInteger;
P = length(BinShifts_NonInteger); 

for m = setdiff(2:N, Idx)
%Step 1:
%shift m th unaligned profile by non-integer bin shifts given by �BinShifts_NonInteger�
ProfileToAlign = UnalignedMatrix(m,:);
ShiftedMthProfile = zeros(P,size(ProfileToAlign,2));

k = fftshift(-M/2:1:(M/2-1)); % Yunus: check if M is even

for i = 1:P
% ShiftedMthProfile(i,:) = fraccircshift(ProfileToAlign,BinShifts_NonInteger(i));
% ShiftedMthProfile(i,:) = fshift(ProfileToAlign,BinShifts_NonInteger(i));
    PhaseVector = exp(1i*2*pi*k/M*BinShifts_NonInteger(i));
    ShiftedMthProfile(i,:) = ifft(fft(ProfileToAlign).*PhaseVector);
end

%figure;
%imagesc(20*log10(abs(ShiftedMthProfile)));

%Step 2
%Identify the non-integer bin shift that gives the highest correlation value
RefProfileMatrix = repmat(RefProfile,P,1);
CorrelationValuesMatrix = (RefProfileMatrix).*abs(ShiftedMthProfile);
CorrelationVector = sum(CorrelationValuesMatrix,2);
[MaxVal MaxIdx] = max(CorrelationVector);
BinShiftFound(m) = BinShifts_NonInteger(MaxIdx);  
AlignedProfile = ShiftedMthProfile(MaxIdx,:);

%Step 3:
%Save aligned profile found in step 2 into �AlignedMatrix�
AlignedMatrix(m,:) = AlignedProfile;

%disp(['Profile num =' num2str(m) ' of ' num2str(N) ', bin shift = ' num2str(BinShiftFound(m)) ', Min = ' num2str(min(BinShifts_NonInteger)) ', Max = ' num2str(max(BinShifts_NonInteger)) ]);
 
%Step 4: THIS COULD BE CAUSING TROUBLES
%Update the bin shift vector, so previously found �bin shift� in step 2 is in the middle
BinShifts_NonInteger = BinShifts_NonInteger_initial + BinShiftFound(m);

%Step 5:
%Compute new reference profile that is the mean of the previously m th aligned profile
RefProfile =  mean(abs(AlignedMatrix(1:m,:)),1); % only take the m profiles that have been aligned

end

%Fit smooth curve to the binshifts found
x = 1:1:length(BinShiftFound);
p = polyfit(x,BinShiftFound,5);
BinShiftFound_Fitted = polyval(p,x);

% figure;
% plot(BinShiftFound,'-r');
% hold on
% plot(BinShiftFound_Fitted,'-b');
% title('Bin shifts found');
% legend('Unfitted','Fitted');
% xlabel('Range profile number');
% ylabel('Bin shifts');

k = fftshift(-M/2:1:(M/2-1)); % Yunus: check if M is even

for j = 2:N     %Normally for j = 2:N
    PhaseVector = exp(1i*2*pi*k/M*BinShiftFound_Fitted(j));
    AlignedMatrix(j,:) = ifft(fft(UnalignedMatrix(j,:)).*PhaseVector); %Circular shift by the fitted values found
end

% figure; imagesc(20*log10(abs(UnalignedMatrix)));
% colormap('jet');
% title('Before RA');
% axis xy;
%    
% figure; imagesc(20*log10(abs(AlignedMatrix)));
% colormap('jet');
% axis xy;
% title('After RA');

%close all;
end

