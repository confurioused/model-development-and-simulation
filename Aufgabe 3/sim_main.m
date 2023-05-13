% MODSIM Laborpraktikum LP-Aufgabe1, 3. Teilaufgabe
% Prof. K. Janschek, Dr.-Ing. Th. Range, Dr.-Ing. S. Dyblenko
% ___________________________________________________________
%
% LP-Gruppe 1
% Luca Linhsen
% Aaron Troll
% Zhi Wang
% ___________________________________________________________
% MAIN SIMULATION PROGRAMM: sim_main.m


clear all  % Lösche Arbeitsspeicher

% Globale Variablen
global Tm
global e_ldf
global h_control_on

% Systemparameter
I = 1;                          % Wahl der Eingangsgröße 1, 2 oder 3    <-- bitte auswählen


Tm = 10;                                % Konstante des PT1, [s]
model_name = 'sys_pseudorate_modulator';
u_input = [0.17, -0.25, 0.49];          % Eingangsgrößen 1,2 und 3
u0 = u_input(I);                        % Sprunghöhe von u

% Simulationsparameter
ts = 1;                         % Zeitpunkt des Sprungs --> Zahl etwas kleiner als 1, da sonst if/else nicht funktionierte
h = 0.01;                       % aktuelle Schrittweite, (s)
t0 = 0;                         % Integrationsbeginn, [s]
tf = 20;                        % Integrationsende, [s]
e_ldf = 1e-10;                  % Epsilon LDF
h_control_on = false;            % Schrittweitensteuerung ein/aus        <-- bitte Auswählen

u_plot = [];                    % Stellwerte u(t)
x_plot = [];                    % Zustandsvektor
y_plot = [];                    % Ausgangswerte y(t)
d_plot = [];                    % Fehler-Schätzwerte
h_plot = [];                    % Array zum Speichern der Schrittweite
t_plot = [];                    % Zeitwerte für Plot [s]

% Initialwerte
x = [0 0];      % x = [ x1 x2 ] , x1 = Zustand System Hysterese, x2 = Zustand System PT1

% Integration nach VPG-Methode
d = 0;
ti = t0;
i = 1;

while ti <= tf
    [x, y, d, h] = VPG(model_name, x, u0, ti, ts, h);
    u_plot(i) = u_step_func(u0, ti, ts);
    x_plot(i,:) = x;
    y_plot(i,:) = y;
    d_plot(i) = d;
    h_plot(i) = h;
    t_plot(i) = ti;
    ti = ti + h;    % Zeitvariable um einen Schritt erhöhen
    i = i + 1;      % Index inkrementieren
end

% Impulsbreite tauE und Impulsperiode tauP
h_e = 0.085;
h_a = 0.065;

tauE = -Tm*log(1-(h_e-h_a)/(1+h_e-abs(u0)))

tauP = Tm*(log((1-h_a/abs(u0))/(1-h_e/abs(u0)))-log(1-(h_e-h_a)/(1+h_e-abs(u0))))


%d_plot = d_plot(1:end-1);
% Anzeigen der Ergebnisse
figure(1);
tit=sprintf('Eingang u, u0 = %g', u0);
subplot(3,1,1); plot(t_plot, u_plot); grid on; zoom on; title(tit);
subplot(3,1,2); plot(t_plot, h_plot); grid on; zoom on; title('Schrittweite h');
tit=sprintf('LDF geschätzt: max. Betrag = %g',max(abs(d_plot)));
subplot(3,1,3); plot(t_plot, d_plot); grid on; zoom on; title(tit);

figure(2);
subplot(3,1,1); plot(t_plot, y_plot(:,1)); grid on; zoom on; title('Ausgang Subtrahierer');
subplot(3,1,2); plot(t_plot, y_plot(:,2)); grid on; zoom on; title('Ausgang Hysterese');
subplot(3,1,3); plot(t_plot, y_plot(:,3)); grid on; zoom on; title('Ausgang PT1');

figure(3);
subplot(2,1,1); plot(t_plot, x_plot(:,1)), grid on; zoom on; title('Zustand Hysterese');
subplot(2,1,2); plot(t_plot, x_plot(:,2)); grid on; zoom on; title('Zustand PT1');

