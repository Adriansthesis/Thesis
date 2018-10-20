val1 = [];
val2 = [];

for i =1:20
	CFAR_Sim_Accuracy;
	val1(:,i) = Pd_Simulated;
	val2(:,i) = Pd_Calculated;
end
out1 = mean(val1,2);
out2 = mean(val2,2);
clf;
plot(out1);
hold on
plot(out2);