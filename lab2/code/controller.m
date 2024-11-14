function [V] = controller(x, y, theta, x_ref, y_ref, theta_ref)

%world frame error: we
we=[x_ref-x; y_ref-y; theta_ref-theta];

%body frame error: be
%  be=[xe, ye, tetae];

E=[cos(theta) sin(theta) 0; ...
    -sin(theta) cos(theta) 0;...
    0 0 1];

be=E*we;

Kv=0.5;
Ks=100; 
Kl=1;

v=Kv*be(1);

omegas=Ks*be(3)+Kl*be(2);

V = [v;omegas];
end