function [E] = energy(v, v_old,E)
    M = 810;
    P0 = 300;
   
    deltaE = M*v*(v-v_old);
    E = E + deltaE;
    % at every output of the controller we compute the energy consumption
 
end