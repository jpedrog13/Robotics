function [pos_next,theta_next,phi_next] = model_car(V,pos,theta,phi,dt)

L = 2.2;

%pos(3) = teta; pos(4) = phi. 
M = [cos(theta) 0; ...
    sin(theta) 0; ...
    tan(phi)/L 0; ...
    0 1];
% F = [vel_x; vel_y; vel_teta; vel_phi] ... V = [v;omega]
F = M*V; 

pos_next = pos + dt*F(1:2)';

theta_next = theta + dt*F(3);
phi_next = phi + dt*F(4);

if phi_next > pi/4
    phi_next = pi/4;
elseif phi_next < -pi/4
    phi_next=-pi/4;
end

end