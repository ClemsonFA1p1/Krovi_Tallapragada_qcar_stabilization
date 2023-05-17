# Krovi_Tallapragada_qcar_stabilization
## Stabilization of vertical motion of a vehicle on bumpy terrain using deep reinforcement learning

Description : This work was conducted on a scaled autonomous vehicle to minimize the vertical acceleration generated when going over a bump.
This work was published and presented at 2022 Modeling Estimation and Controls Conference, New Jersey.

Participants: Ameya Salvi, John Coleman, Jake Buzhardt, Venkat Krovi, Phanindra Tallapragada

## Overview : 
![alt text](https://github.com/ClemsonFA1p1/Krovi_Tallapragada_qcar_stabilization/blob/main/mecc_1.jpg)


### Important files : 
1. HalfCar_RL.m : This is the main file that will initiate the deep reinforcment learning training
2. HCarENV.m : This file is the defines the environment in the context of reinforcement learning training. The states, actions, reset function, step function and reward function are defined in the environment file. Different reward functions (mentioned in the paper) can be added by modifying these lines of code:
![alt text](https://github.com/ClemsonFA1p1/Krovi_Tallapragada_qcar_stabilization/blob/main/mecc_4.jpg)

3. HalfCar.m : This is the step function file which is called at every step of the training. The step function moves the simulation one timestep forward to generate the rollouts/ trajectories for RL training.
4. QCTransvereseDynamics.m : This function is called by the step function and simulates the motion of the quarter car over smooth (guassian) bump.
5. CamBumpArea.m : This function tries to mimic the bump preview as previewd during the deployment.

### Instructions :
Prerequisites : Matlab with RL Toolbox.

1. Download the repository and Run the HalfCar_RL.m file. This initiates the training process, saves agenet, validates trained agent and generates plots.
2. The environment file housed different reward functions which could be tried to realized different agent outputs.

![alt text](https://github.com/ClemsonFA1p1/Krovi_Tallapragada_qcar_stabilization/blob/main/mecc_3.jpg)
![alt text](https://github.com/ClemsonFA1p1/Krovi_Tallapragada_qcar_stabilization/blob/main/mecc_2.jpg)


## Deployment

The agent is validated with the deployment on Quanser Qcar. Bringiing up the QCAR, setting up the simulink framework can be follwed by refering the docs provided on Qunaser website. 
https://www.quanser.com/products/qcar/

Unfortunately, at the time of this work, the Quanser code generation tool chain did not support generating code for neural networks. As a result the control policy could not be deployped by code generation. The bypass suggested by Quanser was to use the wireless data transfer block set. This was enabled by running the policy on the host computer (which wirelessly recevies the state inputs and sends control singnals) and the rest of the control toolchain running on the Qcar.

![alt text](https://github.com/ClemsonFA1p1/Krovi_Tallapragada_qcar_stabilization/blob/main/mecc_5.jpg)


### Useful links:
Preprint : https://www.researchgate.net/publication/362889856_Stabilization_of_vertical_motion_of_a_vehicle_on_bumpy_terrain_using_deep_reinforcement_learning

