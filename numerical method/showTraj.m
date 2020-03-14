clear all
load('cordinates.mat');
load('constants.mat');
load('theta_degree.mat');
theta=theta*pi/180;
x=0;y=0;
h = figure(1);
h.Color = [1 1 1];
ax = gca;
cla;
axis([-2e11 2.5e11 -2e11 2e11]);
ax.DataAspectRatio = [1 1 1];
ax.XColor = [1 1 1];
ax.YColor = [1 1 1];
axis manual
cla
% hold on
ht = title('Ares 3 Trajectory - Day 1');
hl_earth = line('lineStyle','--','color','blue');
hl_mars = line('lineStyle','--','color','red');
hl_venus = line('lineStyle','--','color','green');
hl_ship = line('lineStyle','--','color','black');
%hl_thrust = line('lineStyle','-','color','black');
h_earth = rectangle('Position',[x-Earth.Rviz,y-Earth.Rviz, 2*Earth.Rviz, 2*Earth.Rviz],'Curvature',1,'FaceColor',Earth.RGB);
h_mars = rectangle('Position',[x-Mars.Rviz,y-Mars.Rviz, 2*Mars.Rviz, 2*Mars.Rviz],'Curvature',1,'FaceColor',Mars.RGB);
h_venus = rectangle('Position',[x-Venus.Rviz,y-Venus.Rviz, 2*Venus.Rviz, 2*Venus.Rviz],'Curvature',1,'FaceColor',Venus.RGB);
h_ship = rectangle('Position',[x-ship.R,y-ship.R, 2*ship.R, 2*ship.R],'Curvature',0,'FaceColor',ship.RGB);
i=1;
    h_earth.Position = [earth_cor_rot(i,1)-Earth.Rviz,earth_cor_rot(i,2)-Earth.Rviz 2*Earth.Rviz, 2*Earth.Rviz];
    h_mars.Position = [mars_cor_rot(i,1)-Mars.Rviz,mars_cor_rot(i,2)-Mars.Rviz 2*Mars.Rviz, 2*Mars.Rviz];
    h_venus.Position = [venus_cor_rot(i,1)-Venus.Rviz,venus_cor_rot(i,2)-Venus.Rviz 2*Venus.Rviz, 2*Venus.Rviz];
    h_ship.Position = [pos(i,1)-ship.R,pos(i,2)-ship.R 2*ship.R, 2*ship.R];

for i = 1:length(theta)
    hl_earth.XData = earth_cor_rot(1:i,1);
    hl_earth.YData = earth_cor_rot(1:i,2);
    hl_mars.XData = mars_cor_rot(1:i,1);
    hl_mars.YData = mars_cor_rot(1:i,2);
    hl_venus.XData = venus_cor_rot(1:i,1);
    hl_venus.YData = venus_cor_rot(1:i,2);
    hl_ship.XData = pos(1:i,1);
    hl_ship.YData = pos(1:i,2);
    hl_thrust.XData = [ pos(1:i,1) pos(1:i,1)+5*ship.R*cos(theta(1:i)) ];
    hl_thrust.YData = [ pos(1:i,2) pos(1:i,2)+5*ship.R*sin(theta(1:i)) ];    
    h_earth.Position = [earth_cor_rot(i,1)-Earth.Rviz,earth_cor_rot(i,2)-Earth.Rviz 2*Earth.Rviz, 2*Earth.Rviz];
    h_mars.Position = [mars_cor_rot(i,1)-Mars.Rviz,mars_cor_rot(i,2)-Mars.Rviz 2*Mars.Rviz, 2*Mars.Rviz];
    h_venus.Position = [venus_cor_rot(i,1)-Venus.Rviz,venus_cor_rot(i,2)-Venus.Rviz 2*Venus.Rviz, 2*Venus.Rviz];
    h_ship.Position = [pos(i,1)-ship.R,pos(i,2)-ship.R 2*ship.R, 2*ship.R];
    ht.String = ['Ares 3 Trajectory - Day ' num2str(i)];
    pause(.03);
    movieFrames(i)=getframe
end
%%
%save the movie
videowriter=VideoWriter('ship');
videowriter.FrameRate=20

open(videowriter);
writeVideo(videowriter,movieFrames);
close(videowriter);