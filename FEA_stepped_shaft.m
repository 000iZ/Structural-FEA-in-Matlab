close all; clear all; clc;

% given constants
E = 69e9;           % in units Pa
density = 2700;     % in units kg * m^(-3)
P = 1600;           % in units N

% given dimensions of each shaft section, in units m
L1 = 0.08; d1 = 0.03;
L2 = 0.16; d2 = 0.02;
L3 = 0.24; d3 = 0.01;

% area of each shaft section
A1 = pi * (d1/2)^2;
A2 = pi * (d2/2)^2;
A3 = pi * (d3/2)^2;

% elements' stiffness matrices
% u_1 v_1 u_2 v_2
stiffness1 = A1*E/L1 .* [1   -1;
                        -1  1];
% u_2 v_2 u_3 v_3
stiffness2 = A2*E/L2 .* [1   -1;
                        -1  1];
% u_3 v_3 u_4 v_4
stiffness3 = A3*E/L3 .* [1   -1;
                        -1  1];

% external force, applied at node D
external = [0; 0; 1600;];

% final expression for stiffness in the global system with BCs applied
globe = 1e6 .* [74.51   -13.55  0
                -13.55  15.81   -22.58
                0       -22.58  22.58];
deltas = globe \ external;  % solving using linsolve
u_B = deltas(1);
u_C = deltas(2);
u_D = deltas(3);
disp("Displacement (mm)");
disp("u_B = " + u_B * 1e3);
disp("u_C = " + u_C * 1e3);
disp("u_D = " + u_D * 1e3);

% obtaining stresses in Pa
fprintf("\nStresses (MPa)\n");
stress1 = P / A1;
stress2 = P / A2;
stress3 = P / A3;
disp("Element 1: " + stress1 / 1e6);
disp("Element 2: " + stress2 / 1e6);
disp("Element 3: " + stress3 / 1e6);

% obtaining changes in length in mm using l_change = (FL)/(EA)
l_change1 = (P*L1) / (E*A1);
l_change2 = (P*L2) / (E*A2);
l_change3 = (P*L3) / (E*A3);

% obtaining engineering strain
fprintf("\nEngineering Strain\n");
strain1 = l_change1 / L1;
strain2 = l_change2 / L2;
strain3 = l_change3 / L3;
disp("Element 1: " + strain1);
disp("Element 2: " + strain2);
disp("Element 3: " + strain3);