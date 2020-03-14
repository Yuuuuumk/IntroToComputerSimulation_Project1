%% Sun Parameters
% Scale sun size for visualization purposes
SunScaling = 4e1;

% Specify the solid properties of the sun
Sun.M = 1.99e30;
Sun.Rviz = 6.96e8*SunScaling; 
Sun.RGB = [1, 0.6, 0];

%% Earth Parameters
% Scale Earth size for visualization purposes
TerrestrialPlanetScaling = 1.2e3; % Scale the size of Earth

% Specify the solid properties of Earth
Earth.M = 5.97e24;
Earth.R = 6.05e6;
Earth.Rviz = Earth.R*TerrestrialPlanetScaling;
Earth.RGB = [0.5, 0.8, 1];

launchDate = datetime(2035,7,7);
t = juliandate(launchDate + days(1:899)');
[ earth_pos, earth_vel] = planetEphemeris(t,'SolarSystem','Earth');

earth_pos = earth_pos*1e3; %km -> m
earth_vel = earth_vel*1e3; %km -> m

% Axis of rotation, using to point at 90 deg
d = cross(earth_pos(1,:),earth_pos(92,:));
% Get inclination angle
incl_earth = acos(d(3)/norm(d));
% Rotation Matrix
M = axang2rotm([1 0 0 -incl_earth ]);
% Rotate
earth_pos = (M*earth_pos')';
earth_vel = (M*earth_vel')';

% Get data of earth
% earth = getdata('earth','m');
% Specify initial position and velocity of Earth
Earth.Px = earth_pos(1,1); 
Earth.Py = earth_pos(1,2);
Earth.Pz = earth_pos(1,3);
Earth.Vx = earth_vel(1,1); 
Earth.Vy = earth_vel(1,2);
Earth.Vz = earth_vel(1,3);

Earth.direction = earth_vel(1,:)./norm(earth_vel(1,:));

ship.M = 110000;
ship.altitude = 400e3;%m, assume similar to ISS
ship.velocity =  earth_vel(1,:);
ship.position =  earth_pos(1,:) + (Earth.Rviz + ship.altitude) * Earth.direction;
ship.RGB = [0 .8 0];
ship.R = 5e9;

%% Mars Parameters
% Scale Mars size for visualization purposes
TerrestrialPlanetScaling = 1.2e3; % Scale the size of Mars

% Specify the solid properties of Mars
Mars.M = 6.42e23;
Mars.Rviz = 3.39e6*TerrestrialPlanetScaling;
Mars.RGB = [1, 0, 0];

% Get data of Mars
[ mars_pos, mars_vel] = planetEphemeris(t,'SolarSystem','Mars');

mars_pos = mars_pos*1e3; %km -> m
mars_vel = mars_vel*1e3; %km -> m

% Axis of rotation, using to point at 90 deg
d = cross(mars_pos(1,:),mars_pos(92,:));
% Get inclination angle
incl_mars = acos(d(3)/norm(d));
% Rotation Matrix
M = axang2rotm([1 0 0 -incl_mars ]);
% Rotate
mars_pos = (M*mars_pos')';
mars_vel = (M*mars_vel')';

% Get data of mars
% mars = getdata('mars','m');
% Specify initial position and velocity of Earth
Mars.Px = mars_pos(1,1); 
Mars.Py = mars_pos(1,2);
Mars.Pz = mars_pos(1,3);
Mars.Vx = mars_vel(1,1); 
Mars.Vy = mars_vel(1,2);
Mars.Vz = mars_vel(1,3);

%% Venus Parameters
% Scale Venus size for visualization purposes
TerrestrialPlanetScaling = 1.2e3; % Scale the size of Venus

% Specify the solid properties of Venus
Venus.M = 4.867e24;
Venus.Rviz = 6051133*TerrestrialPlanetScaling;
Venus.RGB = [.6 .6 0];

% Get data of Mars
[ venus_pos, venus_vel] = planetEphemeris(t,'SolarSystem','Venus');

venus_pos = venus_pos*1e3; %km -> m
venus_vel = venus_vel*1e3; %km -> m

% Axis of rotation, using to point at 90 deg
d = cross(venus_pos(1,:),venus_pos(92,:));
d_norm = d./norm(d)*.8e11;
% Get inclination angle
incl_venus = acos(d(3)/norm(d));
% Rotation Matrix
M = axang2rotm([1 0 0 -incl_venus ]);
% Rotate
venus_pos = (M*venus_pos')';
venus_vel = (M*venus_vel')';

% Get data of venus
% venus = getdata('venus','m');
% Specify initial position and velocity of Earth
Venus.Px = venus_pos(1,1); 
Venus.Py = venus_pos(1,2);
Venus.Pz = venus_pos(1,3);
Venus.Vx = venus_vel(1,1); 
Venus.Vy = venus_vel(1,2);
Venus.Vz = venus_vel(1,3);

% Trajectory I came up with by trial and error
load x_1.mat
load x_2.mat
t = 24*60*60*[0:10:899]';
enable = ones(size(t));
x1 = 335*ones(5,1);
x2 = 144*ones(5,1);
x3 = 180*ones(3,1);
x4 = 210;
x5 = 240*ones(2,1);
x6 = 300*ones(5,1);
x7 = 279*ones(6,1);
x8 = 90*ones(5,1);
x9 = 135*ones(5,1);
x10 = 335*ones(3,1);
x11 = 144*ones(3,1);
x12 = 120*ones(3,1);
x13 = 120*ones(3,1);
x14 = 240*ones(3,1);
x15 = 290*ones(3,1);
x16 = 45*ones(3,1);
x17 = 90*ones(3,1);
x18 = 300*ones(3,1);
x19 = 300*ones(3,1);
x20 = 20*ones(3,1);
x21 = 5*ones(3,1);
x22 = 5*ones(3,1);
x23 = 5*ones(3,1);
x24 = 2*ones(3,1);
x25 = 5*ones(3,1);
x26 = 350*ones(3,1);
x27 = 350*ones(2,1);
theta = [x1;x2;x3;x4;x5;x6;x7;x8;x9;x10;x11;x12;x13;x14;x15;16;x17;x18;x19;x20;...
    x21;x22;x23;x24;x25;x26;x27];
% use theta=[x_1;x_2]*360; for the optimized simulation
stopDay = 899;

%% Bus objects for referenced model

% Bus object: slBus1_venus 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'px';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).SamplingMode = 'Sample based';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'vx';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).SamplingMode = 'Sample based';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'py';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).SamplingMode = 'Sample based';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'vy';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).SamplingMode = 'Sample based';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

slBus1_venus = Simulink.Bus;
slBus1_venus.HeaderFile = '';
slBus1_venus.Description = '';
slBus1_venus.DataScope = 'Auto';
slBus1_venus.Alignment = -1;
slBus1_venus.Elements = elems;
clear elems;
assignin('base','slBus1_venus', slBus1_venus);

% Bus object: slBus2_mars 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'px';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).SamplingMode = 'Sample based';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'vx';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).SamplingMode = 'Sample based';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'py';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).SamplingMode = 'Sample based';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'vy';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).SamplingMode = 'Sample based';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

slBus2_mars = Simulink.Bus;
slBus2_mars.HeaderFile = '';
slBus2_mars.Description = '';
slBus2_mars.DataScope = 'Auto';
slBus2_mars.Alignment = -1;
slBus2_mars.Elements = elems;
clear elems;
assignin('base','slBus2_mars', slBus2_mars);

% Bus object: slBus3_earth 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'px';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).SamplingMode = 'Sample based';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'vx';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).SamplingMode = 'Sample based';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'py';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).SamplingMode = 'Sample based';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'vy';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).SamplingMode = 'Sample based';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

slBus3_earth = Simulink.Bus;
slBus3_earth.HeaderFile = '';
slBus3_earth.Description = '';
slBus3_earth.DataScope = 'Auto';
slBus3_earth.Alignment = -1;
slBus3_earth.Elements = elems;
clear elems;
assignin('base','slBus3_earth', slBus3_earth);

% Bus object: slBus4_ship 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'px';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).SamplingMode = 'Sample based';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'vx';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).SamplingMode = 'Sample based';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'py';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).SamplingMode = 'Sample based';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'vy';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).SamplingMode = 'Sample based';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

slBus4_ship = Simulink.Bus;
slBus4_ship.HeaderFile = '';
slBus4_ship.Description = '';
slBus4_ship.DataScope = 'Auto';
slBus4_ship.Alignment = -1;
slBus4_ship.Elements = elems;
clear elems;
assignin('base','slBus4_ship', slBus4_ship);

% Bus object: slBus5 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'venus';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'slBus1_venus';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).SamplingMode = 'Sample based';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'mars';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'slBus2_mars';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).SamplingMode = 'Sample based';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'earth';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'slBus3_earth';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).SamplingMode = 'Sample based';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'ship';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'slBus4_ship';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).SamplingMode = 'Sample based';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

slBus5 = Simulink.Bus;
slBus5.HeaderFile = '';
slBus5.Description = '';
slBus5.DataScope = 'Auto';
slBus5.Alignment = -1;
slBus5.Elements = elems;
clear elems;
assignin('base','slBus5', slBus5);

