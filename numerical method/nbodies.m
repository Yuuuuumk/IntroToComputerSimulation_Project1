clear all
%constant
start = juliandate(2035,07,07);
stop = juliandate(2036,07,07);
G=6.6743e-11; %m^3/kg/s^2
Ms=1.989e30; %kg
Me=5.972e24; %kg
Mm=6.41e23; %kg
Mv= 4.867e24; 
M=[Ms,Me,Mm,Mv];
N=length(M);
t=start;
%Simulation param
tmax=(stop-start)*24*60*60; %s
clockmax=365;
dt= tmax/clockmax;
%initialization
[earth_pos,earth_vel] = planetEphemeris(start,'Sun','Earth');
[mars_pos,mars_vel] = planetEphemeris(start,'Sun','Mars');
[venus_pos,venus_vel]= planetEphemeris(start,'Sun','Venus');
X=[0,earth_pos(1)*1000,mars_pos(1)*1000,venus_pos(1)*1000];
Y=[0,earth_pos(2)*1000,mars_pos(2)*1000,venus_pos(2)*1000];
Z=[0,earth_pos(3)*1000,mars_pos(3)*1000,venus_pos(3)*1000];
U=[0,earth_vel(1)*1000,mars_vel(1)*1000,venus_vel(1)*1000];
V=[0,earth_vel(2)*1000,mars_vel(2)*1000,venus_vel(2)*1000];
W=[0,earth_vel(3)*1000,mars_vel(3)*1000,venus_vel(3)*1000];
%initialization for plotting
des=norm(planetEphemeris(start,'Sun','Mars'))*1000;
set(gcf,'double','on');
subplot(2,2,1),hxy=plot(X,Y,'bx')
xlabel('x')
ylabel('y')
axis([-2*des 2*des -2*des 2*des])
axis equal
axis manual
subplot(2,2,2),hzy=plot(Z,Y,'bo')
ylabel('y')
zlabel('z')
axis([-2*des 2*des -2*des 2*des])
axis equal
axis manual
subplot(2,2,3),hxz=plot(X,Z,'bo')
xlabel('x')
zlabel('z')
axis([-2*des 2*des -2*des 2*des])
axis equal
axis manual
subplot(2,2,4),hxyz=plot3(X,Y,Z,'bo')
xlabel('x')
ylabel('y')
zlabel('z')
axis([-2*des 2*des -2*des 2*des -2*des 2*des])
axis manual

%computing
for clock=1:clockmax
    clock/clockmax
    t=t+dt/(24*60*60);
    for i=1:N
        for j=1:N
            if j~=i
                    DX=X(j)-X(i);
                    DY=Y(j)-Y(i);
                    DZ=Z(j)-Z(i);
                    R=sqrt(DX^2+DY^2+DZ^2);
                    U(i)=U(i)+dt*G*M(j)*DX/R^3;
                    V(i)=V(i)+dt*G*M(j)*DY/R^3;
                    W(i)=W(i)+dt*G*M(j)*DZ/R^3;
            end
        end
       
        X(i)=X(i)+dt*U(i);
        Y(i)=Y(i)+dt*V(i);
        Z(i)=Z(i)+dt*W(i);
        end
               
    earth_cor(clock,:)=[X(2),Y(2),Z(2)];
    mars_cor(clock,:)=[X(3),Y(3),Z(3)];
    venus_cor(clock,:)=[X(4),Y(4),Z(4)];
    pos=planetEphemeris(t,'Sun','earth');
    Xth(clock)=pos(1)*1000;
    Yth(clock)=pos(2)*1000;
    Zth(clock)=pos(3)*1000;
 
    set(hxy,'xdata',X,'ydata',Y);
    set(hzy,'xdata',Z,'ydata',Y);
    set(hxz,'xdata',X,'ydata',Z);
    set(hxyz,'xdata',X,'ydata',Y,'zdata',Z);
    drawnow
end
%%
deltaX=(earth_cor(:,1)-Xth')./Xth';
deltaY=(earth_cor(:,2)-Yth')./Yth';
deltaZ=(earth_cor(:,3)-Zth')./Zth';
error=mean(sqrt(deltaX.^2+deltaY.^2+deltaZ.^2));
%%
%rotate data in a 2D plan

% Axis of rotation, using to point at 90 deg
d = cross(earth_cor(1,:),earth_cor(92,:));
% Get inclination angle
incl_earth = acos(d(3)/norm(d));
% Rotation Matrix
Rot_earth = axang2rotm([1 0 0 -incl_earth ]);
% Rotate
earth_cor_rot = (Rot_earth*earth_cor')';

% Axis of rotation, using to point at 90 deg
d = cross(mars_cor(1,:),mars_cor(92,:));
% Get inclination angle
incl_mars = acos(d(3)/norm(d));
% Rotation Matrix
Rot_mars = axang2rotm([1 0 0 -incl_mars ]);
% Rotate
mars_cor_rot = (Rot_mars*mars_cor')';

% Axis of rotation, using to point at 90 deg
d = cross(venus_cor(1,:),venus_cor(92,:));
% Get inclination angle
incl_venus = acos(d(3)/norm(d));
% Rotation Matrix
Rot_venus = axang2rotm([1 0 0 -incl_venus ]);
% Rotate
venus_cor_rot = (Rot_venus*venus_cor')';
%%
plot3(earth_cor(:,1),earth_cor(:,2),earth_cor(:,3),earth_cor_rot(:,1),earth_cor_rot(:,2),earth_cor_rot(:,3))
legend('Earth 3-D orbit','Earth 2-D orbit')
xlabel('x')
ylabel('y')
zlabel('z')
axis([-0.9*des 0.9*des -0.9*des 0.9*des -0.9*des 0.9*des])
axis manual
%%
plot3(earth_cor(:,1),earth_cor(:,2),earth_cor(:,3),Xth,Yth,Zth)
legend('Simulated','planetEphemeris')
xlabel('x')
ylabel('y')
zlabel('z')
axis([-0.9*des 0.9*des -0.9*des 0.9*des -0.5*des 0.5*des])
axis manual