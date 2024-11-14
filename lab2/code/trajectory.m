function [final_posx,final_posy,distances,theta,I_color,total_distance] = trajectory(turn, straight)
% Loading maps and variables
load('occupancy_matrix.mat');
load('map.mat');


figure(1)
imshow(I_color); hold on
title('IST campus map')
uiwait(msgbox({'In the map the user can choose';'the starting and final point of the path'}, 'Info','help'));
   

load('x.mat'); 
load('y.mat'); 
load('s.mat'); 
load('t.mat'); 
load('weight.mat'); 

G = digraph(s,t,weight); 

figure(4)
subplot(121)
imshow(I_color); hold on
p= plot(G,'XData',x,'YData',y);hold on
title('Original graph')
set(gcf,'WindowState','minimize')

way =0;

while way~=1
    [x_query,y_query] = get_points(I_color,I);
    
    for i = 1:2
        edge_start = dist_to_edge(table2array(G.Edges),x,y,x_query(i),y_query(i));
        
        [sOut,tOut] = findedge(G,edge_start);
        
        [x,y,s,t,weight] = add_node(x,y,s,t,sOut,tOut,x_query(i),y_query(i));
    end
    
    G = digraph(s,t,weight); 
    
    [path,~] = shortestpath(G,numel(x)-1,numel(x));
    
    if isempty(path)
        uiwait(msgbox({'Impossible to find a path between the points selected.';'Please choose another pair of points.'}, 'Error','error'));
    else
        way =1;
    end
end

figure(4)
subplot(122)
imshow(I_color); hold on
p= plot(G,'XData',x,'YData',y);hold on
title('Graph with the new nodes')

[xx,yy,dist] = interpolation(x(path),y(path),length(path)*500);

figure(1)
subplot(121)
imshow(I_color); hold on
p= plot(G,'XData',x,'YData',y);hold on
highlight(p,path,'EdgeColor','r','LineWidth',2); hold on;
title('Shortest path')

subplot(122)
imshow(I_color); hold on
plot(x_query,y_query,'bo','MarkerSize',7,'LineWidth',2);
txt = ["Start","Final"];
text(x_query,y_query,txt)
plot(xx,yy,'b-', 'MarkerSize',3);
title('Ideal trajectory')
pause(1)

set(gcf,'WindowState','minimize')

total_distance=0;
for i = 1:length(dist)
    total_distance=total_distance+dist(i);
end

treshold = (min(dist)+max(dist))/2;

k=2;
current_dist=0;
spacing=0;
used_dist=0;
final_posx=[];
final_posy=[];
final_posx(1)=xx(1);
final_posy(1)=yy(1);
status=[];
for i = 2:length(xx)
    current_dist=current_dist+dist(i-1);
    used_dist=used_dist+dist(i-1);
    if current_dist<10
        status(k-1)=1;
        spacing=spacing+dist(i-1);
        if spacing>=turn           
            final_posx(k)=xx(i);
            final_posy(k)=yy(i);
            distances(k)=used_dist;
            used_dist=0;
            spacing=0;
            k=k+1;
        end
    elseif current_dist>total_distance-10
        status(k-1)=0;
        spacing=spacing+dist(i-1);
        if spacing>=turn           
            final_posx(k)=xx(i);
            final_posy(k)=yy(i);
            distances(k)=used_dist;
            used_dist=0;
            spacing=0;
            k=k+1;
        end
    elseif dist(i)<treshold
        status(k-1)=2;
        spacing=spacing+dist(i-1);
        if spacing>=turn          
            final_posx(k)=xx(i);
            final_posy(k)=yy(i);
            distances(k)=used_dist;
            used_dist=0;
            spacing=0;
            k=k+1;
        end
    else
        status(k-1)=3;
        spacing=spacing+dist(i-1);
        if spacing>=straight           
            final_posx(k)=xx(i);
            final_posy(k)=yy(i);
            distances(k)=used_dist;
            used_dist=0;
            spacing=0;
            k=k+1;
        end
    end      
end


theta=zeros(size(final_posx));
tp = length(final_posx);
for k=1:tp
    if k+1<=tp
        theta(k) = atan2(final_posy(k+1)-final_posy(k), final_posx(k+1)-final_posx(k));
    else
        theta(k) = atan2(final_posy(k)-final_posy(k-1), final_posx(k)-final_posx(k-1));
    end
end


end
