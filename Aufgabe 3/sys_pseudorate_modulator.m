% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% TOPOLOGIE: sys_pseudorate_modulator.m

%   Eingabeparameter
%   x       - Zustandsvektor x = [x1 x2], x1 = Zustand Hysterese, x2 = Zustand PT1
%   u       - Eingang u
%   t       - aktueller Zeitpunkt
%   h       - Simulationsschrittweite

%   Ausgabeparameter
%   xdot    - Folgezustandsvektor xdot = [xdot1 xdot2]
%   y       - Ausgangsvektor y = [y1 y2 y3], y1 = Ausgang Subtract, y2 = Ausgang Hysteres, y3 = Ausgang PT1

function [xdot,y] = sys_pseudorate_modulator(x,u,t)

% Ausgangswert y3 des PT1-Gliedes zu beginn bestimmen
% xdot ist noch nicht korrekt, da Eingang u3 noch nicht bekannt
[xdum, y3] = system_pt1(t,x(2), 0);

% Regeldifferenz e bestimmen
% Bei diesem System gibt es keinen Zustand
% Sollwert u ist Eingang u11 des Subtrahierers
% Ausgang des PT1-Glied ist Eingang u12 des Subtrahierers
y(1) = system_substract([u,y3], t);

% Berechnung der der Hysterese
% Ausgang y1 von Subtrahierer ist Eingang u2 von Hysterese
[xdot(1), y(2)] = system_hysterese(x(1), y(1), t);

% Berechnen des Folgezustandes x3 und des Ausgangs y3 des PT1-Glied
% Ausgang y2 der Hysterese ist Eingang u3 von PT1
[xdot(2), y(3)] = system_pt1(t, x(2), y(2));


end