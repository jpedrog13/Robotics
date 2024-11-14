function closest_edge = dist_to_edge(edges,x_node,y_node,x_query, y_query)
%v1, v2 and pt are vectors with the coordinates of the points of edges and
%query

d = 10^5; %initial threshold

for i=1: size(edges,1)
    
    %selecting x of the first and second node
    x1 = x_node(edges(i,1));
    x2 = x_node(edges(i,2));
    %selecting y of the first and second node
    y1 = y_node(edges(i,1));
    y2 = y_node(edges(i,2));
    
    v1 = [x1, y1];
    v2 = [x2, y2];
    pt = [x_query, y_query];
    
    d_v1v2 = norm(v1-v2);
    d_v1pt = norm(v1-pt);
    d_v2pt = norm(v2-pt);
    
    if dot(v1-v2,pt-v2)*dot(v2-v1,pt-v1)>=0
        A = [v1,1;v2,1;pt,1];
        dist = abs(det(A))/d_v1v2;
    else
        dist = min(d_v1pt, d_v2pt);
    end
    
    %save the new distance just if it's lower compared to the previous
    if dist<d
        d = dist;
        closest_edge = i;
    end
    
end
end