% MODSIM Laborpraktikum LP-Aufgabe1, 1. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% main_a1.m - Realisierung der VPG-Methode mit Fehlerschätzung
% für PT1-Glied

clear all  % Lösche Arbeitsspeicher
Tm = 10;                        % Konstante des PT1, [s]
u0 = 5;                         % Sprunghöhe von u
ts = 1 - 1e-9;                  % Zeitpunkt des Sprungs --> Zahl etwas kleiner als 1, da sonst if/else nicht funktionierte
h = 0.1;                        % Schrittweite, (s)
t0 = 0;                         % Integrationsbeginn, [s]
tf = 300;                       % Integrationsende, [s]
t = [];                         % Zeitwerte für Plot [s]
d = [];                         % Fehler-Schätzwerte
d_exakt = [];                   % exakter LDF
phi_exakt = [];                 % Zuwacchsfunktion auf exaktes x(i)
g = [];                         % GDL für kontrollzwecke g(i+1) = g(i) + d(i+1)+ e(i+1)
e = [];                         % Fortpflanzungsfehler FPF
u = [];                         % Stellwerte u(t)
y = [];                         % Ausgangswerte y(t)
ys = [];                        % Soll-Ausgangswerte y_soll(t)

% Initialisierung
[dum,x(1)] = system_pt1([],[],[],0);
d(1) = 0;
e(1) = 0;
d_exakt(1) = 0;
g(1) = 0;

% Integration nach VPG-Methode
ti = t0;
i = 1;

while ti <= tf
    % Fallunterscheidung für Zeitpunkt vor und nach dem Sprung
    % Berechnung des Soll-Ausgangswertes analytisch ys(t)
    % Berechnung des Stellwertes u(t)

    if(ti < ts)         % vor dem Sprung
        u(i) = 0;
        ys(i) = 0;
        if( (ti+h) >= ts)
            u_k3 = u0;
        else
            u_k3 = 0;
        end
        
    else                % ti >= ts --> nach dem Sprung
        u(i) =  u0;
        u_k3 = u0;
        ys(i) = u0*(1-exp(-(ti-ts)/Tm));    % analytische Funktion für ys(t), berechnet über Laplace-Rücktransformation mit u(t) als Sprung
    end

    % Berechnung des Ausgangswertes
    y(i) = system_pt1( ti , x(i) , u(i) , 3); %die Parameter einsetzen

    % Berechnung der Koeffizienten für VPG-Methode
    k1 = system_pt1( ti, x(i) , u(i) , 1);                      % f(x(ti), u(ti), ti)
    k2 = system_pt1( ti + h/2 , x(i) + k1*h/2 , u(i), 1);       % f(x(ti) + k1*h/2, u(ti+h/2), ti+h/2)
    k3 = system_pt1( ti+h , x(i) - h*k1 + 2*h*k2 , u_k3 , 1);   % f(x(ti)-h*k1+2*h*k2, u(ti+h), ti+h)

    % Berechnung des Zustands-Schätzwertes x(ti+h)
    x(i+1) = x(i) + h*k2;

    % Berechnung der LDF Fehlerabschätzung d(ti+h)
    d(i+1) = (h/6)*(k1 - 2*k2 + k3);        % LDF unter verwendung der RK3 koeffizienten

    % ______________________________________________________________________Eigene Berechnungen aus Interesse
    k1_exakt = system_pt1( ti, ys(i), u(i), 1);
    phi_exakt(i) = system_pt1( ti + h/2, ys(i) + k1_exakt*h/2, u(i), 1);    % Bestimmung von phi(x(i), ti, h ) exakt

    % Berechnung des FPF
    e(i+1) = h*(phi_exakt(i) - k2);

    % Berechnen des exakten LDF nach VPG
    if(i > 1)
        d_exakt(i) = ys(i) - ys(i-1) - h*phi_exakt(i-1);
        g(i) = g(i-1) + d_exakt(i) + e(i);
    end
    % ______________________________________________________________________Ende
    
    t(i) = ti;      % Zeitwert für Plot speichern
    ti = ti + h;    % Zeitvariable um einen Schritt erhöhen
    i = i + 1;      % Index inkrementieren
end

d = d(1:end-1);
e = e(1:end-1);
result = [t;d];

gdl = ys - y;

% Anzeige der Ergebnisse
figure(1);
subplot(2,1,1); plot(t,u); title('Eingang PT1-Glied');zoom on;grid on;
subplot(2,1,2); plot(t,y); title('Ausgang PT1-Glied');zoom on;grid on;
xlabel('Zeit, s');
figure(2);
subplot(2,1,1); plot(t,y-ys,'.-'); title('GDF berechnet (y-ys)');zoom on;grid on;
tit=sprintf('LDF geschätzt: max. Betrag = %g',max(abs(d)));
subplot(2,1,2); plot(t,d,'.-'); title(tit);zoom on;grid on;
xlabel('Zeit, s');

%_____________________________________Auskommentieren, wenn eigene Versuche angezeigt werden sollen
%figure(3);
%tit=sprintf('LDF exakt: max. Betrag = %g',max(abs(d_exakt)));
%subplot(2,1,1); plot(t,d_exakt,'.-'); title(tit); zoom on; grid on;
%subplot(2,1,2); plot(t,e, '.-'); title('FPF exakt'); zoom on; grid on;

%figure(4);
%subplot(2,1,1); plot(t,g); title('GDL als Summe der Fehler'); zoom on; grid on;
%subplot(2,1,2); plot(t,gdl); title('GDF exakt (ys-y)'); zoom on; grid on;