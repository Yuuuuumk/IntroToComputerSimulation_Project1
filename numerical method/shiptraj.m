load('constants.mat')
load('cordinates.mat')
load('theta_degree.mat')
i=1;
G=6.6743e-11; %m^3/kg/s^2
p=ship.position;
v=ship.velocity;
pos(i,:)=p(1:2);
vel(i,:)=v(1:2);
a=0.002;
dt=24*60*60;
Ms=1.989e30; %kg
M=[Ms,Earth.M,Mars.M,Venus.M];
N=length(M);
theta=theta/360*(2*pi);
for i=2:length(earth_cor_rot)
    X=[0,earth_cor_rot(i,1),mars_cor_rot(i,1),venus_cor_rot(i,1)];
    Y=[0,earth_cor_rot(i,2),mars_cor_rot(i,2),venus_cor_rot(i,1)];
    vel(i,1)=vel(i-1,1);
    vel(i,2)=vel(i-1,2);
    for j=1:N
        DX=X(j)-pos(i-1,1);
        DY=Y(j)-pos(i-1,2);
        R=sqrt(DX^2+DY^2);
        vel(i,1)=vel(i,1)+dt*G*M(j)*DX/R^3;
        vel(i,2)=vel(i,2)+dt*G*M(j)*DY/R^3;
    end
    vel(i,1)=vel(i,1)+dt*a*cos(theta(i));
    vel(i,2)=vel(i,2)+dt*a*sin(theta(i));
    pos(i,:)=pos(i-1,:)+dt*vel(i,:);
end
%%
plot(earth_cor_rot(:,1),earth_cor_rot(:,2),mars_cor_rot(:,1),mars_cor_rot(:,2),venus_cor_rot(:,1),venus_cor_rot(:,2),pos(:,1),pos(:,2))
legend('Earth','Mars','Venus','Ship')e