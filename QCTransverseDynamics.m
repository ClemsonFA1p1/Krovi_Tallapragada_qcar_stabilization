function NewStates = QCTransverseDynamics(X0,U_vel,timestep,H,mu)

    % Model Parameters (see diagram)
    b.L1 = 0.128;
    b.L2 = 0.128;
    b.k1 = 19000;
    b.k2 = 19000;
    b.c1 = 100;
    b.c2 = 100;
    % b.T = 0.1;
    % b.u = 1;
    b.m = 1.391;
    b.I = 0.001897;
    %b.ux = 0.4;
    b.ux = U_vel;
    b.dt = timestep;

    b.tau = 0.5;        % time constant for velocity command

    tspan = (0:0.001:timestep);
%     X0 = [0;    % x
%           0;    % dx/dt
%           0;    % z
%           0;    % dz/dt
%           0;    % theta
%           0];   % d theta/dt

    b.H = H;     % bump height
    b.H2 = 0.004;
    
    b.mu = mu;       % bump location (x) 
    b.sigma = 0.005;       % bump spread (standard deviation)
    
    nos1 = 1;
    nos2 = 4;

    % Gaussian equation for bump 
    b.zr = @(x) b.H*exp(-0.5*(x-b.mu).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+0.05)).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+2)).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+2.05)).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+2.1)).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+2.15)).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+2.2)).^2/b.sigma^2)...
    +b.H*exp(-0.5*(x-(b.mu+2.25)).^2/b.sigma^2);

    % dz/dx
    b.dzrx = @(x) b.H*(x-b.mu)/b.sigma^2*exp(-0.5*(x-b.mu)^2/b.sigma^2)...
    +b.H*(x-(b.mu+0.05))/b.sigma^2*exp(-0.5*(x-(b.mu+0.05))^2/b.sigma^2)...
    +b.H*(x-(b.mu+2))/b.sigma^2*exp(-0.5*(x-(b.mu+2))^2/b.sigma^2)...
    +b.H*(x-(b.mu+2.05))/b.sigma^2*exp(-0.5*(x-(b.mu+2.05))^2/b.sigma^2)...
    +b.H*(x-(b.mu+2.1))/b.sigma^2*exp(-0.5*(x-(b.mu+2.1))^2/b.sigma^2)...
    +b.H*(x-(b.mu+2.15))/b.sigma^2*exp(-0.5*(x-(b.mu+2.15))^2/b.sigma^2)...
    +b.H*(x-(b.mu+2.2))/b.sigma^2*exp(-0.5*(x-(b.mu+2.2))^2/b.sigma^2)...
    +b.H*(x-(b.mu+2.25))/b.sigma^2*exp(-0.5*(x-(b.mu+2.25))^2/b.sigma^2);

    %X0 = [0;0;0;0.15;0;0.033;0;0.033;0;0];

    opt = odeset('RelTol',1e-8,'AbsTol',1e-10);

    %[t,X] = ode45(@(t,X)HalfCarDynamics(t,X,b),tspan,X0,opt);

    [~,X] = ode45(@(t,X)HalfCar(t,X,b),tspan,X0,opt);
    
%      for i = 1:length(X)
%          preview2(:,i) = CameraPreview(X(i,1),mu);
%      end
    
    x = X(end,1);
    
    previewA = CameraPreview(X(end,1),mu);
    previewB = CameraPreview(X(end,1),mu+2);
    preview = previewA + previewB;
    preview = preview_randomness(preview);

    
    
    areaA = CamBumpArea(mu,x,nos1);
    areaB = CamBumpArea(mu+2,x,nos2);
    area = areaA + areaB - 0.01;
    area = area + 0.015 - 0.03*randi(1);

    
     %preview = [b.zr(X(end,1)+1),b.zr(X(end,1)+1.001),b.zr(X(end,1)+1.002),b.zr(X(end,1)+1.003),b.zr(X(end,1)+1.004),b.zr(X(end,1)+1.005),...
      %   b.zr(X(end,1)+1.006),b.zr(X(end,1)+1.007),b.zr(X(end,1)+1.008),b.zr(X(end,1)+1.009),b.zr(X(end,1)+1.010)];


    
    NewStates = [preview',area,X(end,1),X(end,2),X(end,3),X(end,4),X(end,5),X(end,6)];
    %NewStates = X ;
    %save('States.mat')
end


