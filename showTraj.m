function showTraj(simout,Earth,Mars,Venus,ship)
logsout = simout.get('logsout')
data = logsout.getElement('telemetry').Values
theta = pi/180*logsout.getElement('theta').Values.Data;
x=0;y=0;
h = figure(1);
h.Color = [1 1 1];
ax = gca;
cla;
axis([-3e11 3e11 -3e11 3e11]);
ax.DataAspectRatio = [1 1 1];
ax.XColor = [1 1 1];
ax.YColor = [1 1 1];
axis manual
% pause(8);
cla
% hold on
ht = title('Ares 3 Trajectory - Day 1');
hl_earth = line('lineStyle','--','color','blue');
hl_mars = line('lineStyle','--','color','red');
hl_venus = line('lineStyle','--','color','green');
hl_ship = line('lineStyle','--','color','black');
hl_thrust = line('lineStyle','-','color','black');
h_earth = rectangle('Position',[x-Earth.Rviz,y-Earth.Rviz, 2*Earth.Rviz, 2*Earth.Rviz],'Curvature',1,'FaceColor',Earth.RGB);
h_mars = rectangle('Position',[x-Mars.Rviz,y-Mars.Rviz, 2*Mars.Rviz, 2*Mars.Rviz],'Curvature',1,'FaceColor',Mars.RGB);
h_venus = rectangle('Position',[x-Venus.Rviz,y-Venus.Rviz, 2*Venus.Rviz, 2*Venus.Rviz],'Curvature',1,'FaceColor',Venus.RGB);
h_ship = rectangle('Position',[x-ship.R,y-ship.R, 2*ship.R, 2*ship.R],'Curvature',0,'FaceColor',ship.RGB);
i=1;
    h_earth.Position = [data.earth.px.Data(i)-Earth.Rviz,data.earth.py.Data(i)-Earth.Rviz 2*Earth.Rviz, 2*Earth.Rviz];
    h_mars.Position = [data.mars.px.Data(i)-Mars.Rviz,data.mars.py.Data(i)-Mars.Rviz 2*Mars.Rviz, 2*Mars.Rviz];
    h_venus.Position = [data.venus.px.Data(i)-Venus.Rviz,data.venus.py.Data(i)-Venus.Rviz 2*Venus.Rviz, 2*Venus.Rviz];
    h_ship.Position = [data.ship.px.Data(i)-ship.R,data.ship.py.Data(i)-ship.R 2*ship.R, 2*ship.R];

for i = 1:length(data.earth.px.Data)
    hl_earth.XData = data.earth.px.Data(1:i);
    hl_earth.YData = data.earth.py.Data(1:i);
    hl_mars.XData = data.mars.px.Data(1:i);
    hl_mars.YData = data.mars.py.Data(1:i);
    hl_venus.XData = data.venus.px.Data(1:i);
    hl_venus.YData = data.venus.py.Data(1:i);
    hl_ship.XData = data.ship.px.Data(1:i);
    hl_ship.YData = data.ship.py.Data(1:i);
    hl_thrust.XData = [ data.ship.px.Data(i) data.ship.px.Data(i)+5*ship.R*cos(theta(i)) ];
    hl_thrust.YData = [ data.ship.py.Data(i) data.ship.py.Data(i)+5*ship.R*sin(theta(i)) ];    
    h_earth.Position = [data.earth.px.Data(i)-Earth.Rviz,data.earth.py.Data(i)-Earth.Rviz 2*Earth.Rviz, 2*Earth.Rviz];
    h_mars.Position = [data.mars.px.Data(i)-Mars.Rviz,data.mars.py.Data(i)-Mars.Rviz 2*Mars.Rviz, 2*Mars.Rviz];
    h_venus.Position = [data.venus.px.Data(i)-Venus.Rviz,data.venus.py.Data(i)-Venus.Rviz 2*Venus.Rviz, 2*Venus.Rviz];
    h_ship.Position = [data.ship.px.Data(i)-ship.R,data.ship.py.Data(i)-ship.R 2*ship.R, 2*ship.R];
    ht.String = ['Ares 3 Trajectory - Day ' num2str(i)];
    pause(.03);
end