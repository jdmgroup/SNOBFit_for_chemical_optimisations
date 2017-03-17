function [xout,yout] = TrapezoidToSquare(trap)

[~,t0_i] = min(trap(1,:));
[~,t1_i] = min(trap(2,:));
[~,t2_i] = max(trap(1,:));
[~,t3_i] = max(trap(2,:));

t0 = trap(:,t0_i);
t1 = trap(:,t1_i);
t2 = trap(:,t2_i);
t3 = trap(:,t3_i);

[xi,yi] = snobfitclass.LinesIntersect(t0(1),t0(2),t3(1),t3(2),t1(1),t1(2),t2(1),t2(2));
i = [xi; yi; 0; 1];

%determine matrices
u = (t2 + t3)/2;
T_1 = [1 0 0 -u(1); 0 1 0 -u(2); 0 0 1 0; 0 0 0 1];
u = (t2-t3)./norm(t2-t3);
R = [u(1) u(2) 0 0; u(2) -u(1) 0 0; 0 0 1 0; 0 0 0 1];
u = R*(T_1*i);
T_2 = [1 0 0 -u(1); 0 1 0 -u(2); 0 0 1 0; 0 0 0 1];
u = T_2*R*T_1*[(t2 + t3)/2; 0; 1];
H = [1 -u(1)/u(2) 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
u = H*T_2*R*T_1*[t2; 0; 1];
S_1 = [1/u(1) 0 0 0; 0 1/u(2) 0 0; 0 0 1 0; 0 0 0 1];
TransformMatrix = S_1*H*T_2*R*T_1;
X0 = TransformMatrix*[t1; 0; 1];
X0 = X0(1);

%perform transformation
M = [trap; zeros(1,4); ones(1,4)];
Y = TransformMatrix*M;
Y(1,:) = 2*X0*Y(1,:)./Y(2,:);

xout = Y(1,:);
yout = Y(2,:);