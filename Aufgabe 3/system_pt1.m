% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
%
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% Berechnung des Systems "PT1-Glied"

function [xdot, y] = system_pt1 ( t, x, u )

% Eingabe-Parameter:
% t - Zeit
% x - x(t) Zustandsvektor zum Zeitpunkt t
% u - u(t) Vektor der Eingangssignale zum Zeitpnukt t

global Tm                           % Zeitkonstante des PT1-Gliedes

xdot =  -x/Tm + u/Tm;
y = x;    

end