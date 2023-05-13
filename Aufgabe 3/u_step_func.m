% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
%
% Sprungfunktion, Bestimmung von u

function [u] = u_step_func (u0, t, ts)

if(t < ts - 1e-9)
    u = 0;
else
    u = u0;
end

end