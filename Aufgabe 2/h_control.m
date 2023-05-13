% MODSIM Laborpraktikum LP-Aufgabe1, 2. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% 
% Schrittweitensteuerung

function [h, nextStep] = h_control(h_alt, d, e_ldf)

% Eingabe-Parameter:
% h_alt     - letzte Schrittweite
% d         - letzter LDF
% e_ldf     - Toleranz Epsilon des LDF

% Rückgabe-Parameter
% h         - nächste zu nutzende Schrittweite
% nextStep  - Bool - letzten Schritt wiederholen oder nächsten Schritt ausführen

% Definition von Variablen

Tm = 10;
u0 = 5;
% Berechnung von h_min und h_max per Hand
h_min = 6*Tm*e_ldf/u0;
h_max = 2*Tm;

h = h_alt;
nextStep = true;

if d            % d darf nicht 0 sein, da Berechnung von h_new sonst nicht möglich
     h_new = nthroot(e_ldf/abs(d), 3)*h_alt;     % h_new - Zwischenberechnung von neuem h
     
     % h_new auf Grenzüberschreitung überprüfen
     if (h_new >= h_max)
        h_new = 0.99 * h_max;       % Gewährleisten, dass h_new sicher < h_max
     elseif (h_new < h_min)
        h_new = h_min;
     end
     
     % Setzen von h gemäß Algorithmus aus Skript MODSIM-3, Abs. 3.4
     if(h_new <= h_alt)      % d > e_ldf --> Unterziel verfehlt, aktuellen Schritt wiederholen
         h = 0.75 * h_new;
         nextStep = false;
     elseif (h_new > 2*h_alt)   % d < e_ldf: nächsten Schritt mit neuem h ausführen
         h = h_new;
     else                   % h nicht verändern
         h = h_alt;
     end
end

end