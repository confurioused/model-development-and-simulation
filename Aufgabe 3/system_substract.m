% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% SUBSYSTEM SUBSTRACT

%   u       - Eingangsvektor u = [ u1 u2 ] , u1=u_input , u2=y3 (Ausgang PT1-Glied)
%   t       - aktueller Zeitpunkt

function  y = system_substract (u,t)

% Rückgabe der Regeldifferenz e
y = u(1) - u(2);

end