
close all
clear all
clc


%% Récupération des données du signal 

load ('a01m.mat');
signal = val(1,:); 
Fe = 100; 
Te = 1/Fe; 

t=(0:length(signal)-1)'./Fe;

% Affichage temps/amplitude

figure(1),

plot(t,signal); 
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
grid on 
title('Visualisation du signal original ECG à 100 Hz')

%% Transformée de Fourrier 
NFFT = length(signal); 
F= Fe.*(0:NFFT-1)./NFFT; 
SIGNAL = fft(signal, NFFT)

% figure(2) 
% 
% semilogx(F,20*log10(abs(SIGNAL)))
% grid on
% xlabel('Temps [s]'); 
% ylabel('Amplitude [V]');
% title ('Transformée de Fourrier du signal ECG')

%% Echantillonage du signal 

Fe2 = 2000; 
F_ech =  Fe2.*(0:NFFT-1)./NFFT; 
T_ech = (0:20*length(signal)-1)'./Fe2;
N = 10000; % Nombre de points du signal

signal_ech = interp1(t, signal, T_ech);

figure(3)
plot(T_ech, signal_ech); 
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
title('Signal ECG Echantilloné à 2000Hz')

%Transformée de Fourrier
F= Fe2.*(0:NFFT-1)./NFFT; 
SIGNAL2 = fft(signal_ech, NFFT);

figure(4) 

semilogx(F,20*log10(abs(SIGNAL2)))
xlabel('Fréquence [Hz]'); 
ylabel('Amplitude [V]');
grid on
title('Transformée de Fourrier du signal ECG échantilloné à 2000Hz')



%% Coefficient d'amplitude 

coeff_amp = 0.00001; 
signal_amp = signal_ech * coeff_amp;
figure(5) 
plot(T_ech, signal_amp); 
title('Signal amplifié à 5mV')

%Transformée de Fourrier
F= Fe2.*(0:NFFT-1)./NFFT; 
SIGNAL3 = fft(signal_amp, NFFT);

figure 

semilogx(F,20*log10(abs(SIGNAL3)))
xlabel('Fréquence [Hz]'); 
ylabel('Amplitude [V]');
grid on
title('Transformée de Fourrier du signal ECG amplifié')


%% Ajout d'un bruit additif à 50 Hz 


bruit_50Hz = 1*sin(2*pi*50*T_ech)*coeff_amp;

figure(6)
plot(T_ech, bruit_50Hz), title ('Bruit 50Hz');
xlim([0 0.1]);
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
grid on
title('Visualisation du bruit à 50Hz')


%Bruitage du signal 
signal_bruite = bruit_50Hz + signal_amp   ;
figure(7)
clc
plot(T_ech, signal_bruite);
grid on
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
title('Signal ECG bruité à 50Hz')

%xlim ([5.1 5.4]);

% %Transformée de Fourrier
% F= Fe2.*(0:NFFT-1)./NFFT; 
% SIGNAL4 = fft(signal_bruite, NFFT);
% ds4 = 20*log10(abs(SIGNAL4)); 
% ds_amp = 20*log10(abs(SIGNAL3));
% 
% figure 
% 
% semilogx(F,[ds_amp ds4])
% xlabel('Fréquence [Hz]');  ylabel('Amplitude [V]');
% grid on ; title('Transformée de Fourrier du signal + bruit')


%% Signal bruité à 50 Hz avec harmoniques

% %Création des harmoniques
% H1 = 0.01 * sin(2*pi*150*T_ech); 
% H2 = 0.01 * sin(2*pi*250*T_ech);
% H3 = 0.01 * sin(2*pi*350*T_ech);
% 
% 
% %Bruitage du signal 
% signal_bruite_harm = 1*(signal_bruite + (H1+H2+H3)*coeff_amp) ;
% 
% 
% figure(8)
%  plot(T_ech, signal_bruite_harm);grid on;
% xlabel('Temps [s]'); 
% ylabel('Amplitude [V]');
% title('Signal ECG bruité + harmoniques');
% %xlim ([5 7]);
% xlim ([5.2 5.3]);


%% Ajout d'un bruit blanc
% variance = 1/50; 
% moyenne = 0; 
% bruit_blanc = moyenne + variance*randn(1,NFFT)*coeff_amp;

sigma = 0.003;   % Variance du bruit
moy = 0;         % Moyenne -> Centrer bruit autour de 0
bruit_blanc = (moy + sigma*randn(1,N))*coeff_amp; 

signal_blanc = signal_bruite + bruit_blanc; 

figure(9)
plot(T_ech, signal_blanc);grid on;
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
title('Signal ECG bruité + harmoniques + bruit blanc')
xlim ([5 6]);

% %Transformée de Fourrier
% F= Fe2.*(0:NFFT-1)./NFFT; 
% SIGNAL5 = fft(signal_blanc, NFFT);
% ds5 = 20*log10(abs(SIGNAL5)); 
% 
% 
% figure 
% 
% semilogx(F,[ds_amp ds5])
% xlabel('Fréquence [Hz]');  ylabel('Amplitude [V]');
% grid on ; title('Transformée de Fourrier du signal + bruit 50 + bruit blanc')

%% Ajout d'un bruit electromyographique
bruit_EMG = 0.02*sin(2*pi*25*T_ech)*coeff_amp;
signal_bruite_EMG = signal_blanc + bruit_EMG; 
figure(10)
plot(T_ech, signal_bruite_EMG);grid on;
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
title('Signal ECG bruité + harmoniques + bruit blanc +EMG')
xlim ([5 6]);

% %Transformée de Fourrier
% F= Fe2.*(0:NFFT-1)./NFFT; 
% SIGNAL5 = fft(signal_blanc, NFFT);
% ds5 = 20*log10(abs(SIGNAL5)); 
% 
% 
% figure 
% 
% semilogx(F,[ds_amp ds5])
% xlabel('Fréquence [Hz]');  ylabel('Amplitude [V]');
% grid on ; title('Transformée de Fourrier du signal + bruit 50 + bruit blanc')

%% Ligne de base 
T_base = (1/500)*(0:(NFFT)-1)';
ligne_de_base = sin(2*pi*0.1*T_ech)*coeff_amp;
signal_final = signal_bruite_EMG + ligne_de_base; 
figure(11)
plot(T_ech, signal_final);grid on;
xlabel('Temps [s]'); 
ylabel('Amplitude [V]');
title('Signal ECG bruité + ligne de base')



% %Transformée de Fourrier
% F= Fe2.*(0:NFFT-1)./NFFT; 
% SIGNAL6 = fft(signal_final, NFFT);
% ds6 = 20*log10(abs(SIGNAL6)); 
% 
% 
% figure 
% 
% semilogx(F,[ds_amp ds6])
% xlabel('Fréquence [Hz]');  ylabel('Amplitude [V]');
% grid on ; title('Transformée de Fourrier du signal + bruit 50 + bruit blanc')







