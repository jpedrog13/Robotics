function [x,y,s,t,weight] = add_node(x,y,s,t,sOut, tOut,x_query,y_query)

pos = find(s==sOut & t==tOut | s==tOut & t==sOut);
x=[x,x_query]; y=[y,y_query];

if numel(pos) ==2
    %adding the new node in the right positon
    %[---21---]->[---21 N---] where N is the value of the new node
    s = [s(1:pos(1)),numel(x),s(pos(1)+1:end)];
    %adding the new node in the right position 
    %[---21---]->[---N 21---] where N is the value of the new node
    t = [t(1:pos(1)-1),numel(x),t(pos(1):end)];
    
    %Considering a poissible edge in the opposite direction
    %es: s=[--21---3], t=[--3---21] adgjusta the values also for the second
    %edge
    s = [s(1:pos(2)+1),numel(x),s(pos(2)+2:end)];
    t = [t(1:pos(2)),numel(x),t(pos(2)+1:end)];
else
    %is there is just one edge
    s = [s(1:pos),numel(x),s(pos+1:end)];
    t = [t(1:pos-1),numel(x),t(pos:end)];
end

%computing new weights with the right scale
x_s = x(s)'*0.1897;

y_s = y(s)'*0.2389;

ss = [x_s,y_s];

x_t = x(t)'*0.1897;

y_t = y(t)'*0.2389;

tt = [x_t,y_t];

for i=1:length(tt)
    weight(i)=norm(tt(i,:)-ss(i,:));
end

clear x_s y_s ss tt x_t y_t

end