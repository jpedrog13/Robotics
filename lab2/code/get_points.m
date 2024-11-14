function [x,y] = get_points(img,occu_mat)

figure(1)
imshow(img); hold on
x = [];
y= [];

both_in =0;
point = 0;
txt = ["Start","End"];

while both_in ~=1
 
    [u1,v1] = ginput(1);
    in_border= improfile(occu_mat,u1,v1);
    
    %if the poin it's inside the road, then it'll be saved
    if in_border == 0 
        point = point+1;
        x = [x;u1];
        y = [y;v1];
        hold on
        plot(u1,v1,'b.')
        text(u1,v1,txt(point))
    else
        if point ==0
            uiwait(msgbox({'Staring point outside roads boundaries.';'Please choose another one.'}, 'Error','error'));
        else
            uiwait(msgbox({'Final point outside roads boundaries.';'Please choose another one.'}, 'Error','error'));
        end
    end
    
    if point == 2
        both_in = 1;
    end
end


end