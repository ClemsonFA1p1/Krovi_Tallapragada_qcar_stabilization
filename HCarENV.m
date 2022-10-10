classdef HCarENV < rl.env.MATLABEnvironment
    
    
    %% Properties (set properties' attributes accordingly)
    properties
        % Initialize system state [x,dx,theta,dtheta]'
        State = [0;0;0;0;0;0];
        Reward = 0;
        steps = 1;
        episodes = 1;
        
        
        HorVel;
        VerAcc;
        Pitch;
        y_d = 0;
        VelError = 0;
        H = 0.008;
        mu = 2;
        
        
    end
    
    properties(Access = protected)
        % Initialize internal flag to indicate episode termination
        IsDone = false        
    end

    %% Necessary Methods
    methods              
        % Contructor method creates an instance of the environment
        % Change class name and constructor name accordingly
        function this = HCarENV()
            % Initialize Observation settings
            ObservationInfo = rlNumericSpec([13,1]);
            ObservationInfo.Name = 'Observations for Agent';
            ObservationInfo.Description = 'h_X (pixel area),dx, ddy';
            
            % Initialize Action settings   
            ActionInfo = rlNumericSpec(1,'LowerLimit',0.1 ,'UpperLimit',1);
            %ActionInfo = rlNumericSpec(1,'LowerLimit',1 ,'UpperLimit',1);
            ActionInfo.Name = 'Command Velocity';
            ActionInfo.Description = 'V';
            
            
            % The following line implements built-in functions of RL env
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
            
            % Initialize property values and pre-compute necessary values
            %updateActionInfo(this);
        end
        
        % Apply system dynamics and simulates the environment with the 
        % given action for one step.
        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)
            LoggedSignals = [];
            
            
            % Get action
            Cmd_Vel = double(Action);
            U_vel = Cmd_Vel;
            timestep = 0.01;
            new_states=QCTransverseDynamics(this.State,U_vel,timestep,this.H,this.mu);
            this.steps =this.steps +1;
            new_states=real(new_states);
            
            h = new_states(1:10);
            area = new_states(11);
            x = new_states(12);
            x_dot = new_states(13);
            y = new_states(14);
            y_dot = new_states(15);
            y_ddot = ((y_dot - this.y_d) /timestep);
            %y_ddot = ((y_dot - this.y_d) /timestep);
            y_ddot = y_ddot +9.8+ 0.1 - 0.2*randi(1);
            this.y_d = y_dot;
            th = new_states(16);
            th_dot = new_states(17);
            this.HorVel = x_dot;
            this.VerAcc = y_ddot;
            this.Pitch = th_dot;
    
            %this.TrackHorizontalVel = 0.4;
            %this.VelError = abs(this.TrackHorizontalVel -x_dot);
            
          
            Observation = [h';area;x_dot;y_ddot];

            % Update system states
            this.State = [x;x_dot;y;y_dot;th;th_dot];
            
            % Get reward
            Reward = getReward(this);
            
            %fprintf('x_dot = %0.2f \tx_dot_track = %0.2f \ty_e = %0.2f \tT = %0.2f \tK = %0.2f \n',x_dot,this.TrackHorizontalVel,this.OscError,Torque,Stiffness)
            
            % Check terminal condition
            
            IsDone = this.steps > 1000;
            this.IsDone = IsDone;

        end
        
        % Reset environment to initial state and output initial observation
        function InitialObservation = reset(this)
            
            x =0;
            x_dot = 0;
            y = 0;
            y_dot = 0;
            y_ddot = 0;
            %this.VelError = this.TrackHorizontalVel -x_dot;
            h = zeros(10,1);
            th = 0;
            th_dot = 0;
            area =0;
            
            Observation = [h;area;x_dot;y_ddot];
            InitialObservation = Observation;
            this.State = [x;x_dot;y;y_dot;th;th_dot];
            this.Reward = 0;
            this.steps = 1;
            this.episodes = this.episodes +1;
            this.H = 0.008;
            this.mu = 2;
            
            
        end
    end
    %% Optional Methods (set methods' attributes accordingly)
    methods               
        % Reward function
        function Reward = getReward(this)
            
            %reward = -0.01*((this.torqueerror).^2 + (this.track_error).^2);
            reward = -75*(abs(1 - this.HorVel)).^2 - (abs(this.VerAcc -9.8)).^2 ;
            this.Reward = reward;
            Reward = this.Reward;
        end   
    end
    
    methods (Access = protected)
        end
    end