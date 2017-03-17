function [x,y] = LinesIntersect(x1,y1,x2,y2,x3,y3,x4,y4)

%(x1,y1) & (x2,y2) from line 1 and (x3,y3) & (x4,y4) from line 2

a1 = y2-y1;
b1 = x1-x2;
c1 = x2*y1 - x1*y2;  %{ a1*x + b1*y + c1 = 0 is line 1 }

a2 = y4-y3;
b2 = x3-x4;
c2 = x4*y3 - x3*y4;  %{ a2*x + b2*y + c2 = 0 is line 2 }

denom = a1*b2 - a2*b1;
if denom == 0
	disp('Error!');
end

x =(b1*c2 - b2*c1)/denom;
y =(a2*c1 - a1*c2)/denom;