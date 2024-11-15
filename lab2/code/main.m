clear
close all
clc

[x_ref,y_ref,dist,theta_ref,I_color,tot_dist]=trajectory(0.05, 0.1);

pos(1,:) = [x_ref(1),y_ref(1)];
theta(1) = theta_ref(1);
phi(1)=0;
V=zeros(size(x_ref,2),2);
E = 0;
dt=.1;
total_time =0;

for k=1:length(dist)-1

    Vel = controller(pos(k,1), pos(k,2), theta(k), x_ref(k+1), y_ref(k+1), theta_ref(k+1));
    V(k,:)=Vel;
    [pos(k+1,:), theta(k+1), phi(k+1)] = model_car(Vel, pos(k,:), theta(k), phi(k), dt);

    if k > 1 && k<length(dist)-1
        E = energy(V(k,1), V(k-1,1), E);
        total_time(k) = total_time(k-1)+abs(dist(k)/V(k,1));
    end

end


figure(2)
subplot(121)
imshow(I_color); hold on
plot([x_ref(1),x_ref(end)],[y_ref(1),y_ref(end)],'bo','MarkerSize',7,'LineWidth',2);
txt = ["Start","Final"];
text([x_ref(1),x_ref(end)],[y_ref(1),y_ref(end)],txt)
plot(x_ref,y_ref,'b-', 'MarkerSize',3);
title('Ideal trajectory')

subplot(122)
imshow(I_color); hold on
plot(x_ref,y_ref,'b-', 'MarkerSize',3);
title('Ongoing car')


for k= 1:20:length(pos)-1
    
    subplot(121)
    plot(pos(k,1),pos(k,2),'ro','MarkerSize',2,'LineWidth',1); hold on

    subplot(122)
    plot(pos(k,1),pos(k,2),'go'); hold on
    quiver(pos(k,1),pos(k,2),10*cos(theta(k)), 10*sin(theta(k)),'LineWidth',2, 'Color', 'r', ...
        'AutoScaleFactor', 1, 'MaxHeadSize', .8); hold on
    xlim([pos(k,1)-100 pos(k,1)+100]);
    ylim([pos(k,2)-100 pos(k,2)+100]);
    pause(.5)

end

T = total_time(end);
P0=500;
E = E + P0*T(end);
total_time = [0,total_time,T+dt]; 


Energy = strcat('Energy consumed: ', num2str(E),' J');
Distance = strcat('Distance traveled: ', num2str(tot_dist),' m');
Time = strcat('Total time of travel: ', num2str(T),' s');

uiwait(msgbox({Energy;Distance;Time}, 'Info','help'));


figure(3)
plot(total_time,V(:,1)*3.6,'r-'); grid on
xlabel('Time, s');
ylabel('Velocity, km/h')
title('Velocity');
