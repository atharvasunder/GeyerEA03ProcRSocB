clear all;
clc;
close all;
%% Params

% MTC properties 
l_ref_mtc = 0.5;    % m, original = 0.5
phi_ref_mtc = 110; % deg, joint angle when MTC length is 0.5 m
d = 0.04; % m, moment arm of MTC

% Leg properties
l_s = 0.5; % m, segment length
l_f = 0.99; % m, length of leg (called flight length)

% weight
m = 80; % Kg
g = 9.81;
yG = 0; % Ground height

% Force-length relationship
F_max = 22000;  % Newton
l_opt = 0.1;    % meters, optimum length of muscle where max force is produced
w = 0.4;  % Parameter for the gaussian shaped force-length curve (equivalent to variance), in paper: 0.4*l_opt
c = log(0.05);
% e_ref_pee = 0.04*l_opt; % No source for value, just using the same trend as in the see

% Force-velocity relationship
v_max = 12*l_opt;  % Max shortening veolcity original: -12*l_opt
N = 1.5;    % Eccentric force enhancement
K = 5;  % Curvature constant, original = 5

% Tendon properties
l_rest = 0.4;
e_ref_see = 0.04;    % Reference strain: original 0.04*l_rest

% Activation parameters
tau = 0.01; % seconds, called the excitation contraction coupling constant
delP = 0.015; % seconds, feedback time delay

% optimized parameters for feedback based stimulation
stim0 = 0.145; % constant stimulation from the brain to the muscle
% G = 125; % Gain for length feedback
G = 1.84/F_max; % Gain for force feedback
l_off = 0.08; % offset for length feedback

% Initial conditions
r0 = [0;1.12];
r_dot0 = [0;0];
attack_angle = 90; % in deg, 90 deg for hopping
phi_initial = 2*rad2deg(atan(l_f/(2*sqrt(l_s^2 - l_f^2/4))));