% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% STANDARD VERBESSERTE POLYGONZUGMETHODE

%   Eingabeparameter
%   model_name - benutztes Simulationsmodel
%   x       - Zustandsvektor x = [x1 x2], x1 = Zustand Hysterese, x2 = Zustand PT1
%   u0      - Eingang u (Sprunghöhe)
%   t       - aktueller Zeitpunkt
%   ts      - Zeitpunkt des Sprungs
%   h       - Simulationsschrittweite

function [x_VPG, y, d_VPG, h] = VPG(model_name,x,u0,t,ts,h)

global h_control_on
nextStep = false;

while(nextStep == false)
    [xdot, y] = feval(model_name,x,u_step_func(u0,t,ts),t);
    k1 = xdot(2);                   % Bestimmung von k1 für x(i+1)

    x_k2(1) = x(1);                 % Zustand der Hysterese bei ti
    x_k2(2) = x(2) + h*k1/2;        % Zustand PT1 = x(ti)+h*k1/2
    [xdot, ydum] = feval(model_name, x_k2, u_step_func(u0, t+h/2, ts), t+h/2);
    k2 = xdot(2);

    x_k3(1) = xdot(1);              % Zustand der Hysterese bei ti + h/2
    x_k3(2) = x(2)-h*k1 +2*h*k2;    % Zustand PT1 = x(ti)-h*k1+2*h*k2
    [xdot, ydum] = feval(model_name, x_k3, u_step_func(u0, t+h, ts), t+h);
    k3 = xdot(2);
    x_VPG(1) = xdot(1);             % Zustand der Hysterese im nächsten Schritt xdot(i+1)
    
    % Folgezustand des PT1-Glied
    x_VPG(2) = x(2) + h*k2;         % Zustand PT1 im nächsten Schritt xdot(i+1)
    
    % Lokaler Diskretisierungsfehler LDF nach RK3
    d_VPG = (h/6)*(k1 - 2*k2 + k3);

    if(h_control_on == true)   % Schrittweitensteuerung an
        [h, nextStep] = h_control(h, d_VPG, 2);    % h neu berechnen, Auchtung! Maximaler Sprung delta_U ist hier 2
    else
        nextStep = true;        % Ohne Schrittweitensteuerung kein neues h berechnen
    end
end
end