function [x_int,y_int,dist] = interpolation(x_path,y_path,n_points)
z = linspace(0, 1, numel(x_path));

zz = linspace(0, 1, n_points);

x_int = pchip(z, x_path, zz);
y_int = pchip(z, y_path, zz);

for i=1:length(x_int)-1
    dist(i) = norm([x_int(i)*0.1897, y_int(i)*0.2389]-[x_int(i+1)*0.1897, y_int(i+1)*0.2389]);
end

max_dist = max(dist);

treshold = max(dist)*.1; 

index = 1;



while ~isempty(index)
    
    
    index = find(dist<treshold);
    if isempty(index)
        break
    end
    index=index(1); 
    
    if index == 1
        dist_succ = norm([x_int(index)*0.1897,y_int(index)*0.2389]-[x_int(index+2)*0.1897,y_int(index+2)*0.2389]);
        x_int(index+1) = []; %deleting the next point 
        y_int(index+1) = []; %deleting the next point 
        dist(index) = dist_succ; %updating the distance's vector 
        dist(index+1) = []; %deleting element from the distance's vector
        
    elseif index == length(dist)
        dist_prec = norm([x_int(index-1)*0.1897,y_int(index-1)*0.2389]-[x_int(index+1)*0.1897,y_int(index+1)*0.2389]); %calcolo distanza tra successivo e precedente, come se elimassi punto attuale
        x_int(index) = []; 
        y_int(index) = []; 
        dist(index-1) = dist_prec; 
        dist(index) = []; 
    else
        dist_succ = norm([x_int(index)*0.1897,y_int(index)*0.2389]-[x_int(index+2)*0.1897,y_int(index+2)*0.2389]); %calcolo distanza tra punto e due dopo (come se eliminassi punto intermedio)
        x_int(index+1) = []; 
        y_int(index+1) = []; 
        dist(index) = dist_succ; 
        dist(index+1) = []; 
    end
    
    if dist_succ > max_dist
        x_middle = mean(x_int(index),x_int(index+1));
        y_middle = mean(y_int(index),y_int(index+1));
        x_int = [x_int(1:index),x_middle,x_middle(index+1:end)];
        y_int = [y_int(1:index),y_middle,y_middle(index+1:end)];
    end
   
end

end