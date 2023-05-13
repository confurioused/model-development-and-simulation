% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% SUBSYSTEM HYSTERESE

%   x       - Zustand, skalar
%   u       - Eingangsvektor u = [ u1 u2 ] , u1=u_input , u2=y3 (Ausgang PT1-Glied)
%   t       - aktueller Zeitpunkt

function  [xdot,y] = system_hysterese (x,u,t)

% interne Variablen
 h_e = 0.085;
 h_a = 0.065;

 xdot = x;                  % für den Fall, dass der Zustand der Hysterese gleich bleibt
 
 if (x == 0)                % Zustand ändert sich nur, wenn |u| > h_e
     if( u >= h_e)
         xdot = 1;
     elseif ( u <= -h_e)
         xdot = -1;
     end
 elseif (x == 1)            % Zustand änder sich nur, wenn u < h_a
     if( u <= h_a && u > - h_e)
         xdot = 0;
     elseif ( u <= - h_e)   % Beide Schwellen überschritten
         xdot = -1;
     end
 else                       % Zustand änder sich nur, wenn u > - h_a
     if( u >= -h_a && u < h_e)         
         xdot = 0;
     elseif( u >= h_e)      % beide Schwellen überschritten
         xdot = 1;
     end
 end
 y = xdot;
end