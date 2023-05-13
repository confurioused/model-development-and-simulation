% MODSIM Laborpraktikum LP-Aufgabe1, 2. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% main_a2.m - Ergänzung um Schrittweitensteuerung
% für PT1-Glied

clear all  % Lösche Arbeitsspeicher
Tm = 10;                        % Konstante des PT1, [s]
u0 = 5;                         % Sprunghöhe von u
ts = 1;                  % Zeitpunkt des Sprungs --> Zahl etwas kleiner als 1, da sonst if/else nicht funktionierte
h = 0.1;                        % aktuelle Schrittweite, (s)
t0 = 0;                         % Integrationsbeginn, [s]
tf = 300;                       % Integrationsende, [s]
h_plot = [];                    % Array zum Speichern der Schrittweite
t = [];                         % Zeitwerte für Plot [s]
d = [];                         % Fehler-Schätzwerte
u = [];                         % Stellwerte u(t)
y = [];                         % Ausgangswerte y(t)
ys = [];                        % Soll-Ausgangswerte y_soll(t)
e_ldf = 1e-5;                   % Epsilon LDF

% Initialisierung
[dum,x(1)] = system_pt1([],[],[],0);
d(1) = 0;

% Integration nach VPG-Methode
ti = t0;
i = 1;

while ti <= tf
    % Fallunterscheidung für Zeitpunkt vor und nach dem Sprung
    % Berechnung des Soll-Ausgangswertes analytisch ys(t)
    % Berechnung des Stellwertes u(t)
    
    u(i) = u_step_func(ti, ts, u0);

    if(ti < ts)         % vor dem Sprung
        ys(i) = 0;        
    else                % ti >= ts --> nach dem Sprung
        ys(i) = u0*(1-exp(-(ti-ts)/Tm));    % analytische Funktion für ys(t), berechnet über Laplace-Rücktransformation mit u(t) als Sprung
    end

    % Berechnung des Ausgangswertes
    y(i) = system_pt1( ti , x(i) , u(i) , 3); %die Parameter einsetzen

    % Berechnung der Koeffizienten für VPG-Methode
    k1 = system_pt1( ti, x(i) , u(i) , 1);                      %die Parameter einsetzen
    k2 = system_pt1( ti + h/2 , x(i) + k1*h/2 , u_step_func(ti+h/2, ts, u0), 1);        %die Parameter einsetzen  
    k3 = system_pt1( ti+h , x(i) - h*k1 + 2*h*k2 , u_step_func(ti+h, ts, u0) , 1);      %die Parameter einsetzen
    % Wichtiger Hinweis: Die Parameter bei den Aufrufen von system_pt1(...)
    % müssen unter Beachtung von jeweiligen Zeitpunkten bestimmt werden!

    % Berechnung des Zustands-Schätzwertes x(ti+h)
    x(i+1) = x(i) + h*k2;

    % Berechnung der LDF Fehlerabschätzung d(ti+h)
    d(i+1) = (h/6)*(k1 - 2*k2 + k3);        % LDF unter verwendung der RK3 koeffizienten

    % Aufrufen der Schrittweitensteuerung
    [h_new, nextStep] = h_control(h, d(i+1), e_ldf);
    h = h_new;

    if (nextStep)       % Wenn d < e_ldf wird nächster Schritt ausgeführt
        h_plot(i) = h;  % tatsächlich genutztes h für Graphen speichern
        t(i) = ti;      % Zeitwert für Plot speichern
        ti = ti + h;    % Zeitvariable um einen Schritt erhöhen
        i = i + 1;      % Index inkrementieren
    end                 % Wenn d >= e_ldf muss aktueller Schritt wiederholt werden
end

d = d(1:end-1);
result = [t;d];
% Anzeige der Ergebnisse
figure(1);
subplot(2,1,1); plot(t,u); title('Eingang PT1-Glied');zoom on;grid on;
subplot(2,1,2); plot(t,y); title('Ausgang PT1-Glied');zoom on;grid on;
xlabel('Zeit, s');
figure(2);
subplot(2,1,1); plot(t,y-ys,'.-'); title('GDF berechnet');zoom on;grid on;
tit=sprintf('LDF geschätzt: max. Betrag = %g',max(abs(d)));
subplot(2,1,2); plot(t,d,'.-'); title(tit);zoom on;grid on;
xlabel('Zeit, s');
figure(3);
plot(t,h_plot, '.-'); title('Schrittweite h'); zoom on; grid on;
xlabel('Zeit, s');