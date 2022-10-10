% Cluster14

clc
clear all
env=HCarENV();
validateEnvironment(env);


observationInfo = getObservationInfo(env);
numObservations = observationInfo.Dimension(1);
actionInfo = getActionInfo(env);
numActions = actionInfo.Dimension(1);



%%

L = 50; % number of neurons
statePath = [
    featureInputLayer(numObservations,'Normalization','none','Name','observation')
    fullyConnectedLayer(L,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(30,'Name','fc2')
    additionLayer(2,'Name','add')
    reluLayer('Name','relu2')
    fullyConnectedLayer(20,'Name','fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(10,'Name','fc4')
    reluLayer('Name','relu4')
    fullyConnectedLayer(1,'Name','fc9')];

actionPath = [
    featureInputLayer(numActions,'Normalization','none','Name','action')
    fullyConnectedLayer(30,'Name','fc10')];

criticNetwork = layerGraph(statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
    
criticNetwork = connectLayers(criticNetwork,'fc10','add/in2');

%%

%figure
%plot(criticNetwork)

%%

criticOptions = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1,'L2RegularizationFactor',1e-4);

critic = rlQValueRepresentation(criticNetwork,observationInfo,actionInfo,...
    'Observation',{'observation'},'Action',{'action'},criticOptions);

%%

actorNetwork = [
    featureInputLayer(numObservations,'Normalization','none','Name','observation')
    fullyConnectedLayer(L,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(50,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(25,'Name','fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(10,'Name','fc4')
    reluLayer('Name','relu4')
    fullyConnectedLayer(numActions,'Name','fc8')
    tanhLayer('Name','tanh1')
    scalingLayer('Name','ActorScaling1','Scale',0.45,'Bias',0.55)];
%%
%figure
%plot(actorNetwork)
%%

actorOptions = rlRepresentationOptions('LearnRate',1e-4,'GradientThreshold',1,'L2RegularizationFactor',1e-4);
actor = rlDeterministicActorRepresentation(actorNetwork,observationInfo,actionInfo,...
    'Observation',{'observation'},'Action',{'ActorScaling1'},actorOptions);

%%

agentOptions = rlDDPGAgentOptions(...
    'SampleTime',0.01,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',10000,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',64);

agentOptions.NoiseOptions.Variance = 0.8; % sqrt(Var)*sqrt(Ts) = (10%) *(Range) 
agentOptions.NoiseOptions.VarianceDecayRate = 1e-4;
agentOptions.ResetExperienceBufferBeforeTraining = true;
%%
%agentOptions.ResetExperienceBufferBeforeTraining = false;

agent = rlDDPGAgent(actor,critic,agentOptions);
%%
maxepisodes = 500 ;
maxsteps = 750;
trainingOpts = rlTrainingOptions('MaxEpisodes',maxepisodes,'MaxStepsPerEpisode',maxsteps,'Verbose',true,'StopTrainingCriteria','EpisodeCount','StopTrainingValue',750,'Plots',"none");

%%
trainingStats = train(agent,env,trainingOpts);

%%
save("QCLM_WORK_AREA_2.mat",'agent')

simOpts = rlSimulationOptions('MaxSteps',750);
experience = sim(env,agent,simOpts);
%%
timeData = experience.Observation.ObservationsForAgent.Time;
stateData = experience.Observation.ObservationsForAgent.Data;
actionData = experience.Action.CommandVelocity.Data;  
actionTime = experience.Action.CommandVelocity.Time;

%Z = stateData(1:10,:,:);
x_dot = stateData(11,:,:);
y_ddot = stateData(12,:,:);
%th_dot = stateData(13,:,:);
t = timeData(:);
t_a = actionTime(:);
cmd_vel = actionData(:);

%%

FS = 16;

% f1 = figure('color','w');
% ax = gca;
% ax.FontName= 'Times New Roman';
% ax.FontSize = FS;
% plot(t,Z(:))
% title('Bump')
% xlabel('Time')
% ylabel('Bump Height')

f2 = figure('color','w');
ax = gca;
ax.FontName= 'Times New Roman';
ax.FontSize = FS;
plot(t,x_dot(:))
title('HorVel')
xlabel('Time')
ylabel('HorVel')

f3 = figure('color','w');
ax = gca;
ax.FontName= 'Times New Roman';
ax.FontSize = FS;
plot(t,y_ddot(:))
title('VertAcc')
xlabel('Time')
ylabel('VertAcc')

% f4 = figure('color','w');
% ax = gca;
% ax.FontName= 'Times New Roman';
% ax.FontSize = FS;
% plot(t,th_dot(:))
% title('Pitch')
% xlabel('Time')
% ylabel('Pitch')

f5 = figure('color','w');
ax = gca;
ax.FontName= 'Times New Roman';
ax.FontSize = FS;
plot(cmd_vel(:))
title('CommandVel')
xlabel('Time')
ylabel('CommandVel')


f6 = figure('color','w');
ax = gca;
ax.FontName= 'Times New Roman';
ax.FontSize = FS;
plot(t_a,cmd_vel(:))
title('CommandVel and HorVel')
hold on
plot(t,x_dot(:))
xlabel('Time')
ylabel('Velocity')
legend('Command Velocity','Realised Velocity')


f7 = figure('Position', [10 10 1500 750]);
% subplot(2,3,1);
% plot(t,Z(:));
% title('Bump');
% xlabel('Time');
% ylabel('Bump Height');

subplot(2,2,1);
plot(t,x_dot(:));
title('HorVel');
xlabel('Time');
ylabel('HorVel');

subplot(2,2,2);
plot(t,y_ddot(:));
title('VertAcc');
xlabel('Time');
ylabel('VertAcc');

% subplot(2,3,4);
% plot(t,th_dot(:));
% title('Pitch');
% xlabel('Time');
% ylabel('Pitch');

subplot(2,2,3);
plot(cmd_vel(:));
title('CommandVel');
xlabel('Time');
ylabel('CommandVel');

subplot(2,2,4);
plot(t_a,cmd_vel(:));
title('CommandVel and HorVel');
hold on;
plot(t,x_dot(:));
xlabel('Time');
ylabel('Velocity');
legend('Command Velocity','Realised Velocity');



%saveas(f1,'Bump.png')
saveas(f2,'HorVel.png')
saveas(f3,'VertAcc.png')
% saveas(f4,'Pitch.png')
saveas(f5,'CommandVel.png')
saveas(f6,'CommandVel and HorVel.png')
saveas(f7,'All.png')

%%
%save("sim_states.mat",'stateData')
%save("time.mat",'timeData')
%save("actionData.mat",'actionData')
%save("actionTime.mat",'actionData')
%}