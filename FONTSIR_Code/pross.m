function y=pross(x)

x=((double(x)-0.2)/0.2)*1000;
Left=-160;
right=240;
x(x<(Left))=Left;
x(x>(right))=right;
dfactor=255/double(right-Left);
x=((x-Left)*dfactor);
% x(find(x<(-160+500+1024)/3000))=(-160+500+1024)/3000;
% x(find(x>(240+500+1024)/3000))=(240+500+1024)/3000;
% x = (x-min(min(x)))/(max(max(x))-min(min(x)))*255;
y1 = x;
y2 = x;
y3 = x;
y = cat(3,y1,y2,y3);
y = uint8(y);