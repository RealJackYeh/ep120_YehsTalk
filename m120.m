Rs=1.2;
Ld=0.0057;
wc=2*pi*300;
Kp=wc*Ld;
Ki=wc*Rs;
s=tf('s');
Td=250e-6; 
tf_delay=exp(-s*Td);
PID_id = tf([Kp Ki],[1 0]);
plant_id = tf(1, [Ld Rs]);
loop_id_nodelay = feedback(series(PID_id, plant_id), 1);
loop_id_withdalay = feedback(series(series(PID_id, plant_id),tf_delay), 1);
% h=bodeoptions;
% h.PhaseMatching='on';
% bodeplot(loop_id_nodelay,'-b',loop_id_withdalay,'-.r',{0.1,10000},h);
% legend('sysclose','sysclose_delay');
% grid on

beta = wc*Td;
alpha = beta*(abs(sqrt(sin(beta)^2+1))-sin(beta));
Kp_a = alpha*Ld/Td;
Ki_a = alpha*Rs/Td;
PID_id_a = tf([Kp_a Ki_a],[1 0]);
loop_id_withdalay_corrected = feedback(series(series(PID_id_a, plant_id),tf_delay), 1);

%bandwidth(loop_id)
h=bodeoptions;
h.PhaseMatching='on';
bodeplot(loop_id_nodelay,'-b',loop_id_withdalay,'-.r',loop_id_withdalay_corrected,'-.g',{0.1,10000},h);
legend('sysclose','sysclose_delay','loop_id_withdalay_corrected');