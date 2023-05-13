close all; clear all; clc;

% given constants
E = 200e9;          % in units Pa
rho = 7850;         % in units kg * m^(-3)
sigma_y = 250e6;    % in units Pa
A = 4e-4;           % in units m^2

% elements' lengths
L1 = 4;             % in units m
L2 = sqrt(8);       % in units m
L3 = sqrt(8);       % in units m
L4 = 2;             % in units m

% elements' angles wrt. global coordinate system, being the positive x-axis
theta1 = 0;  % in degrees
theta2 = 45;
theta3 = 135;
theta4 = 0;

% cosines and sines for elements's angles
c1 = cosd(theta1); s1 = sind(theta1);
c2 = cosd(theta2); s2 = sind(theta2);
c3 = cosd(theta3); s3 = sind(theta3);
c4 = cosd(theta4); s4 = sind(theta4);

% elements' stiffness matrices
% u_1 v_1 u_2 v_2
stiffness1 = A*E/L1 .* [ c1^2    c1*s1   -c1^2   -c1*s1;
                        c1*s1   s1^2    -c1*s1  -s1^2;
                        -c1^2   -c1*s1  c1^2    c1*s1;
                        -c1*s1  -s1^2    c1*s1    s1^2    ];
% u_2 v_2 u_3 v_3
stiffness2 = A*E/L2 .* [ c2^2    c2*s2   -c2^2   -c2*s2;
                        c2*s2   s2^2    -c2*s2  -s2^2;
                        -c2^2   -c2*s2  c2^2    c2*s2;
                        -c2*s2  -s2^2    c2*s2    s2^2    ];
% u_1 v_1 u_3 v_3
stiffness3 = A*E/L3 .* [ c3^2    c3*s3   -c3^2   -c3*s3;
                        c3*s3   s3^2    -c3*s3  -s3^2;
                        -c3^2   -c3*s3  c3^2    c3*s3;
                        -c3*s3  -s3^2    c3*s3    s3^2    ];
% u_3 v_3 u_4 v_4
stiffness4 = A*E/L4 .* [ c4^2    c4*s4   -c4^2   -c4*s4;
                        c4*s4   s4^2    -c4*s4  -s4^2;
                        -c4^2   -c4*s4  c4^2    c4*s4;
                        -c4*s4  -s4^2    c4*s4    s4^2    ];

% final expression for stiffness in the global system with BCs applied
globe = 1e6 .* [34.14   14.14   -14.14  -14.14
                14.14   14.14   -14.14  -14.14
                -14.14  -14.14  68.28  0
                -14.14  -14.14  0       28.28];

% external force, applied on node B
external = [0; -50e3; 0; 0];

% obtaining displacements using linsolve
deltas = globe \ external;
u_B = deltas(1);
v_B = deltas(2);
u_C = deltas(3);
v_C = deltas(4);
disp("Displacement (mm)");
disp("u_B = " + u_B * 1e3);
disp("v_B = " + v_B * 1e3);
disp("u_C = " + u_C * 1e3);
disp("v_C = " + v_C * 1e3);

% obtaining stresses in Pa using formula from 7.3_FEM_Truss_Elements_v5.xlsx
fprintf("\nStresses (MPa)\n");
stress1 = E/L1 * [-cosd(theta1) -sind(theta1) cosd(theta1) sind(theta1)] * ...
            [0; 0; u_B; v_B];

stress2 = E/L2 * [-cosd(theta2) -sind(theta2) cosd(theta2) sind(theta2)] * ...
            [u_C; v_C; u_B; v_B];

stress3 = E/L3 * [-cosd(theta3) -sind(theta3) cosd(theta3) sind(theta3)] * ...
            [u_C; v_C; 0; 0];

stress4 = E/L4 * [-cosd(theta4) -sind(theta4) cosd(theta4) sind(theta4)] * ...
            [0; 0; u_C; v_C];
disp("Element 1: " + stress1 / 1e6);
disp("Element 2: " + stress2 / 1e6);
disp("Element 3: " + stress3 / 1e6);
disp("Element 4: " + stress4 / 1e6);

% obtaining forces in kN within each element
fprintf("\nInternal Forces (kN)\n");
force1 = stress1 * A;
force2 = stress2 * A;
force3 = stress3 * A;
force4 = stress4 * A;
disp("Element 1: " + force1 / 1e3);
disp("Element 2: " + force2 / 1e3);
disp("Element 3: " + force3 / 1e3);
disp("Element 4: " + force4 / 1e3);

% obtaining changes in length in mm using l_change = (FL)/(EA)
fprintf("\nChanges in Length (mm)\n");
l_change1 = (force1*L1) / (E*A);
l_change2 = (force2*L2) / (E*A);
l_change3 = (force3*L3) / (E*A);
l_change4 = (force4*L4) / (E*A);
disp("Element 1: " + l_change1 * 1e3);
disp("Element 2: " + l_change2 * 1e3);
disp("Element 3: " + l_change3 * 1e3);
disp("Element 4: " + l_change4 * 1e3);

% obtaining engineering strain
fprintf("\nEngineering Strain\n");
strain1 = l_change1 / L1;
strain2 = l_change2 / L2;
strain3 = l_change3 / L3;
strain4 = l_change4 / L4;
disp("Element 1: " + strain1);
disp("Element 2: " + strain2);
disp("Element 3: " + strain3);
disp("Element 4: " + strain4);

% obtaining factor of safety for original setup
fprintf("\nFactor of Safety\n");
fs1 = stress1 / sigma_y;
fs2 = stress2 / sigma_y;
fs3 = stress3 / sigma_y;
fs4 = stress4 / sigma_y;
disp("Element 1: " + abs(fs1));
disp("Element 2: " + abs(fs2));
disp("Element 3: " + abs(fs3));
disp("Element 4: " + abs(fs4));