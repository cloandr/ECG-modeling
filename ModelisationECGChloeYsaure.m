close all
clear
clc


%% Récupération des données
load a01m.mat

signal = val(1,:)'; %Amplitude

Fe = 100; %Fréquence
t =(0:length(signal)-1)'./Fe; %Vecteur temps

figure ; clf ; plot(t,signal) ; title('Signal ECG Utile '); grid on
xlabel('Temps [s]');  ylabel('Amplitude [V]')

%Transformée de Fourrier
NFFT=length(signal);
F=Fe.*(0:NFFT-1)'./NFFT;
SIGNAL = fft(signal, NFFT);


figure ; clf ; semilogx(F,20*log10(abs(SIGNAL)))
grid on ;  xlim([0 Fe/2]) ; xlabel('Fréquence [Hz]'); ylabel('|F(f)|');
title('Transformée de Fourrier du signal utile'); 


%% Redimensionnement du signal 
% Amplification du signal
 
coeff_amp = 0.00001/2; 0 
signal_ampli = signal*coeff_amp;


%Rééchantillonnage à une féquence de 2000 Hz

FeNew = 2000;
tNew =(0:20*length(signal_ampli)-1)'./FeNew;
signal_ech = interp1(t,signal_ampli,tNew);

% POUR LE RESTE DE LA MODELISATION : LE SIGNAL DE REFERENCE ET SIGNAL AMP 
signal_amp = signal_ech;

%FFT 

% affichage du redimensionnement

figure; plot(t,signal,'o'); title('Signal ECG utile');
grid on ; xlabel('Temps [s]') ; ylabel('Amplitude [V]'); xlim([0 4])

figure ; subplot 211 ; plot(t,signal_ampli,'o'); grid on
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; title('Signal ECG amplifié');
xlim([0 4])
subplot 212 ; plot(t,signal_ampli); grid on
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; title('Signal ECG amplifié');
xlim([0 4])

figure ; subplot 211; plot(tNew,signal_amp,'o'); grid on ; title('Signal ECG échantiollinné');
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; xlim([0 4])

subplot 212 ; plot(tNew,signal_amp); grid on ; title('Signal ECG échantiollinné');
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; xlim([0 4])
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



%% Etude d'Impacts individuels de chaque bruit sur le signal

% Bruit 50
figure
clf

subplot(211) ; plot(tNew, signal_amp) ; grid on ; title('Signal initial')
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; xlim([0 4])



subplot(212) ; plot(tNew, signal_bruite50); grid on ; title('Signal bruité à 50 Hz')
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; xlim([0 4])

%Ligne de base
figure

subplot(311) ; plot(tNew, signal_LDB) ; title('Bruit LDB') ; grid on
xlabel('Temps [s]') ; ylabel('Amplitude [V]')
%xlim([0 4])

% Bruit blanc
subplot(312) ; plot(tNew, signal_blanc) ; grid on ; title('Bruit blanc'); 
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ;xlim([0.8 3.8])

%Signal total
subplot(313) ; plot(tNew, signal_final); title('Bruit total') ; grid on
xlabel('Temps [s]'); ylabel('Amplitude [V]'); xlim([0 4])

%% Bruitage progressif : superpposition des étages 

%P = étage

signal_P1 = signal_amp + bruit50; 
signal_P2 = signal_amp + bruit50 +bruit50Harm1 + ...
    bruit50Harm2 + bruit50Harm3;
signal_P3 = signal_amp + bruit50 +bruit50Harm1 + ...
    bruit50Harm2 + bruit50Harm3 +  bruitBlanc ;
signal_P4 = signal_amp + bruit50 +bruit50Harm1 + ...
    bruit50Harm2 + bruit50Harm3 +  bruitLDB + bruitBlanc;


%Affichage étage cumulé


% figure
% subplot (121) ; plot(tNew, signal_bruite50); grid on ; title('Signal bruité à 50 Hz')
% xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; xlim([0 4])

figure ; plot(tNew, signal_P1); grid on ; title('Signal initial + bruit 50Hz')
xlabel('Temps [s]');  ylabel('Amplitude [V]'); xlim([4 4.1])

figure 
title('Signal initial + bruit 50 + bruit Harmo'); plot(tNew, signal_P2); grid on ;
xlabel('Temps [s]') ; ylabel('Amplitude [V]'); xlim([4 4.1]) %xlim([0 1])
title('Signal initial + bruit 50Hz + harmoniques')



figure
plot(tNew, signal_blanc) ; grid on ; title('Impact Bruit blanc'); 
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ;xlim([0.8 3.8])
figure; plot(tNew, signal_P3) ; title('Signal + bruit 50 + bruit Harmo + EMG (blanc)'); grid on
xlabel('Temps [s]'); ylabel('Amplitude [V]'); xlim([4 4.1]) %xlim([0 1])

figure 
plot(tNew, signal_P4) ; grid on ; title('Signal bruité final')
xlabel('Temps [s]') ; ylabel('Amplitude [V]') ; xlim([4 4.1])




%% Récupération des signaux en format txt

%Génération des signaux de chaque patch
ecg_d = signal_amp
ecg_d_signalFinal = signal_final; 

ecg_g = - signal_amp;

ecg_g_signalFinal = ecg_g + bruits
%ecg_g_signalFinal = - ecg_d_signalFinal;

%Affichage signaux patch
figure
subplot(211) ;  plot(tNew, ecg_d_signalFinal); grid on ; title('ECG droit')
xlabel('Temps [s]'); ylabel('Amplitude [V]'); xlim([4 4.3])


subplot(212); plot(tNew, ecg_g_signalFinal); grid on ; title('ECG gauche'); 
xlabel('Temps [s]'); ylabel('Amplitude [V]'); xlim([4 4.3])


figure;  plot(tNew, ecg_d_signalFinal-ecg_g_signalFinal)
grid on; xlabel('Temps [s]'); ylabel('Amplitude [V]')
%xlim([4 4.3])
title('Vérification de la modélisation')

%Patch gauche
ecg_datag = zeros(length(ecg_g_signalFinal),2); 
ecg_datag (:,1) = tNew;
ecg_datag (:,2) = ecg_g_signalFinal;

fileID = fopen('ecg_gaucheBruite.txt','w');
fprintf(fileID, '%6.3f  %6.8f\n', ecg_datag');
fclose(fileID);

%Patch droit
ecg_datad = zeros(length(ecg_d_signalFinal),2); 
ecg_datad (:,1) = tNew;
ecg_datad (:,2) = ecg_d_signalFinal;

fileID = fopen('ecg_droitBruite.txt','w');
fprintf(fileID, '%6.3f  %6.8f\n', ecg_datad');
fclose(fileID);


%% Calculs des FFT final
SIGNAL_AMP = fft(signal_amp,NFFT) ; 
SIGNAL_P4 = fft(signal_P4,NFFT) ; 


NFFT=length(signal);
F=FeNew.*(0:NFFT-1)'./NFFT;



%Affichage
figure ; clf
semilogx(F,20*log10(abs([SIGNAL_AMP SIGNAL_P4])))
grid on ; xlim([0 20*Fe])
title('Transformée de Fourrier du signal bruité'); 
xlabel('Fréquence [Hz]'); ylabel('|F(f)|'); xlim([0 3000])
legend('Signal utile amplifié avant bruitage','Signal utile amplifié après bruitage')