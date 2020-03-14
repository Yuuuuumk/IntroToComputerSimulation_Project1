clear all
close all
initW
mdl='Ares3mission_simMechanics';
load_system(mdl);
set_param(mdl,'FastRestart','off')
set_param(mdl,'FastRestart','on')
fun = @costFcn;

t=24*60*60*[0:10:899]'; %size 54x1

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
x0 = [x1;x2;x3;x4;x5;x6;x7;x8;x9;x10;x11;x12;x13;x14;x15;16;x17;x18;x19;x20;...
    x21;x22;x23;x24;x25;x26;x27]./360;

options = optimoptions('fmincon','Display','iter','MaxFunEvals',10000,'MaxIter',1000);
lb = 0*ones(size(x0)); % limit output between 0 to 1
ub = ones(size(x0));
x_opt_tot = fmincon(fun,x0,[],[],[],[],lb,ub,[],options); %gives optimized x
set_param(mdl,'FastRestart','off')
save x_tot x_tot t