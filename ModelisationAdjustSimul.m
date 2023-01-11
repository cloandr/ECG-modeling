close all
clear
clc


%% Récupération des données
load a01m.mat

signal = val(1,:)';

Fe = 100;
t =(0:length(signal)-1)'./Fe;

figure(3)
clf
plot(t,signal)
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')

%Transformée de Fourrier
NFFT=length(signal);
F=Fe.*(0:NFFT-1)'./NFFT;

SIGNAL = fft(signal, NFFT);


figure
clf
semilogx(F,20*log10(abs(SIGNAL)))
grid on
%set(gca,'FontSize',20);
xlim([0 Fe/2])



%% Redimensionnement du signal 
% Amplification du signal
%coeff_amp = 0.000001/2; %Gain de 100 
coeff_amp = 0.00001/2; %Gain de 10 

signal_ampli = signal*coeff_amp;


%Rééchantillonnage à une féquence de 2000 Hz

FeNew = 2000;
tNew =(0:20*length(signal_ampli)-1)'./FeNew;
signal_ech = interp1(t,signal_ampli,tNew);

% POUR LE RESTE DE LA MODELISATION : LE SIGNAL DE REFERENCE ET SIGNAL AMP 
signal_amp = signal_ech;

%FFT 

% affichage du redimensionnement
figure
clf
subplot(311)
plot(t,signal,'o');
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')
title('Signal ECG');
xlim([0 4])
subplot(312)
plot(t,signal_ampli,'o');
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')
title('Signal ECG amplifié');
xlim([0 4])
subplot(313)
plot(tNew,signal_amp,'o');
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')
title('Signal ECG amplifié et échantiollinné');
xlim([0 4])

%% Ajout d'un Bruit de 50 Hz

bruit50 = sin(2*pi*50*tNew);
signal_bruite50 = signal_amp + bruit50;

% Harmoniques du 50 Hz
bruit50Harm1 = 0.05*sin(2*pi*150*tNew);
bruit50Harm2 = 0.05*sin(2*pi*250*tNew);
bruit50Harm3 = 0.05*sin(2*pi*350*tNew);


%% Ajout d'un bruit électrmyographique - Bruit blanc

bruitBlanc = 0.05*randn(1,20*length(signal))'; 
signal_blanc = signal_amp + bruitBlanc;
%% Ajout de la ligne de base 
bruitLDB = 1*sin(2*pi*0.1*tNew);
signal_LDB = signal_amp + bruitLDB;

%% Bruitage final
signal_final = signal_amp + bruit50 +bruit50Harm1 + ...
    bruit50Harm2 + bruit50Harm3 + bruitLDB + bruitBlanc;

bruits = bruit50 +bruit50Harm1 + ...
    bruit50Harm2 + bruit50Harm3 +  bruitLDB + bruitBlanc;




%% Récupération des signaux en format txt

ecg_d = signal_amp
ecg_d_signalFinal = signal_final; 

ecg_g = - signal_amp;

ecg_g_signalFinal = ecg_g + bruits
%ecg_g_signalFinal = - ecg_d_signalFinal;


figure
subplot(211)
plot(tNew, ecg_d_signalFinal)
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')
xlim([4 4.3])
title('ECG droit')

subplot(212)
plot(tNew, ecg_g_signalFinal)
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')
xlim([4 4.3])
title('ECG gauche')

figure
plot(tNew, ecg_d_signalFinal-ecg_g_signalFinal)
grid on
xlabel('Temps [s]')
ylabel('Amplitude [V]')
%xlim([4 4.3])
title('Vérification de la modélisation')

%Patch gauche
ecg_datag = zeros(length(ecg_g_signalFinal),2); 
ecg_datag (:,1) = tNew;
ecg_datag (:,2) = ecg_g_signalFinal;

fileID = fopen('simuGauche.txt','w');
fprintf(fileID, '%6.3f  %6.8f\n', ecg_datag');
fclose(fileID);

%Patch droit
ecg_datad = zeros(length(ecg_d_signalFinal),2); 
ecg_datad (:,1) = tNew;
ecg_datad (:,2) = ecg_d_signalFinal;

fileID = fopen('simuDroit.txt','w');
fprintf(fileID, '%6.3f  %6.8f\n', ecg_datad');
fclose(fileID);


