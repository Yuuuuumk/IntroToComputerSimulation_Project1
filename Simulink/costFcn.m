function y=costFcn(x)
persistent h hl_earth hl_mars hl_ship
x = x*360;

r = 3389278;    % Mars radius
r2 = 17e6; %(wiki https://en.wikipedia.org/wiki/Areostationary_orbit)
mu = 1e9*42828;% km3s^2 (https://en.wikipedia.org/wiki/Standard_gravitational_parameter)

w = sqrt(mu*1/((r+r2)^3)); % Angular velocity to stay in constant orbit
v = w*(r+r2);   % linear velocity

% Desired position at Mars - May 24 2037, Day 688 from launch
launchDate = datetime(2035,7,7);
t = juliandate(launchDate + days(1:899)');


% Desired position and velocity at mars - Nov 7, 2035, Day 124 from launch
dp = [1.923234591894616 ;  0.892028444599501  ]*1e11;
dp = dp + (r+r2)*dp/norm(dp);   % add orbit altitude
% mas_pos(1:2) and mas_vel(1:2) are dp, dv which are already projected by
% the rotation matrix

v_rel = v* cross([0; 0; 1],[dp/norm(dp); 0]);   % velocity relative to mars
dv = 1e4*[ -0.934450238283348  ; 2.401560590024732 ] + v_rel(1:2) ; % desired velocity

r_earth = 6.371e6;
altitude = 35.786e3;

% Desired postion and velocity at earth - July 6 2036, Day 365 from launch
dp2 = 1e11*[0.366935876752106;  -1.486774374035419 ];
dp2 = dp2 + (r_earth+altitude)*dp2/norm(dp2);
dv2 = 1.0e4*[ 2.841943002784556  ; 0.710495164263552];

% Desired position and velocity at Mars - May 24 2037, Day 688 from launch
[ mars_pos, mars_vel] = planetEphemeris(t,'SolarSystem','Mars');
mars_pos = mars_pos*1e3; %km -> m
mars_vel = mars_vel*1e3; %km -> m
% Axis of rotation, using to point at 90 deg
d = cross(mars_pos(1,:),mars_pos(92,:));
% Get inclination angle
incl_mars = acos(d(3)/norm(d));
% Rotation Matrix
M_mars = axang2rotm([1 0 0 -incl_mars ]);
% Rotate
mars_pos = (M_mars*mars_pos')';
mars_vel = (M_mars*mars_vel')';
mar_pos_323 = mars_pos(323,1:2);
mar_vel_323 = mars_vel(323,1:2);
dp3 = mar_pos_323';
dp3 = dp3 + (r+r2)*dp3/norm(dp3);
v_rel2 = v.* cross([0; 0; 1],[dp3/norm(dp3); 0]);
dv3 = mar_vel_323' + v_rel2(1:2);


%Desired position at Earth - Dec 21 2037, Day 899 from launch
[ earth_pos, earth_vel] = planetEphemeris(t,'SolarSystem','Earth');
earth_pos = earth_pos*1e3; %km -> m
earth_vel = earth_vel*1e3; %km -> m 
% Axis of rotation, using to point at 90 deg
d = cross(earth_pos(1,:),earth_pos(92,:));
% Get inclination angle
incl_earth = acos(d(3)/norm(d));
% Rotation Matrix
M_earth = axang2rotm([1 0 0 -incl_earth ]);
% Rotate
earth_pos = (M_earth*earth_pos')';
earth_vel = (M_earth*earth_vel')';
earth_pos_899 = earth_pos(899,1:2);
earth_vel_899 = earth_vel(899,1:2);
dp4 = earth_pos_899';
dp4 = dp4 + (r_earth+altitude)*dp4/norm(dp4);
v_rel3 = v* cross([0; 0; 1],[dp4/norm(dp4); 0]);
dv4 = earth_vel_899' + v_rel3(1:2);

if isempty(h)
    h = figure(1);
    hl_earth = line('lineStyle','--','color','blue');
    hl_mars = line('lineStyle','--','color','red');
    hl_ship = line('lineStyle','--','color','black');
    rectangle('Position',[dp3(1)-5e9,dp3(2)-5e9, 1e10, 1e10],'Curvature',1,'FaceColor',[1 0 0]);
end

assignin('base','theta',x);
simout = sim('Ares3Mission_simMechanics');

% if ~exist()
p = [ simout.get('logsout').get('telemetry').Values.ship.px.Data...
    simout.get('logsout').get('telemetry').Values.ship.py.Data];

v = [simout.get('logsout').get('telemetry').Values.ship.vx.Data...
    simout.get('logsout').get('telemetry').Values.ship.vy.Data];

    hl_earth.XData = simout.get('logsout').get('telemetry').Values.earth.px.Data;
    hl_earth.YData = simout.get('logsout').get('telemetry').Values.earth.py.Data;
    hl_mars.XData = simout.get('logsout').get('telemetry').Values.mars.px.Data;
    hl_mars.YData = simout.get('logsout').get('telemetry').Values.mars.py.Data;
    hl_ship.XData = simout.get('logsout').get('telemetry').Values.ship.px.Data;
    hl_ship.YData = simout.get('logsout').get('telemetry').Values.ship.py.Data;
    drawnow  
y = sum(abs((dp-p(124,:)')./dp)) +...
    sum(abs((dv-v(124,:)')./dv)) +... 
    sum(abs((dp2-p(365,:)')./dp2)) +...
    sum(abs((dv2-v(365,:)')./dv2)) +...
    sum(abs((dp3-p(668,:)')./dp3)) + ...
    sum(abs((dv3-v(668,:)')./dv3)) + ...
    sum(abs((dp4-p(899,:)')./dp4)) + ...
    sum(abs((dv4-v(899,:)')./dv4));