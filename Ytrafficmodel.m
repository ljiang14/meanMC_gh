% this is the Nagel-Schreckenberg traffic model 
% input : replication number; 
% output: the average velocity of all the cars during the given period of time
function b=Ytrafficmodel(R) %input replication number and output average velocity
vmax=7;% max velocity
N=100;% number of cars
M=1000;% number of spaces
T=2500; % total number of time steps
T0=1500; % the number of time steps that NOT count
p=1/3;% random stop probability
v = zeros(R,N); % initial velocity for all cars, set as zero
%v = round(vmax*rand(R,N)); % initial velocity for all cars, set as random,
%uniformly distributed from zero to vmax
x = zeros(R,N);
for j=1:R
    x(j,:)=sort(randsample(M,N))-1;% initial positions for all cars
end
param.x0=x;
for t=1:T
    d=[diff(x,1,2) x(:,1)+M-x(:,N)]; % update distances between vehicles
    v=min(v+1,vmax); % speed up if below the speed limit
    v=min(v,d-1); % not bump into the vehicle in front
    z=rand(R,N)<p;
    v=max((v-z),0);% random slow down with probability p
    x=x+v; % position updated
    if t==T0
        param.x0=x; % when time steps t=T0,take the positive x0
            % as the initial position 
    end
end
param.xT=x;
b=mean(param.xT-param.x0,2)/(T-T0);% calculate the average velocity
