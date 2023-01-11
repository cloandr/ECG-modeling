clear all
close all 
clc 

%% Affichage du signal 
load ('a01m.mat');
signal = val(1,:)'; 
Fe = 100; 

t=(0:length(signal)-1)'./Fe;

%Echantillonage du signal
Fe2 = 2000; 
NFFT = length(signal); 
F_ech =  Fe2.*(0:NFFT-1)./NFFT; 
T_ech = (0:20*length(signal)-1)'./Fe2;
signal_ech = interp1(t, signal, T_ech);

%Création du vecteur temps
k_ecg = (1:length(signal_ech))';
t_ecg=k_ecg/2000;


%Mise en forme des signaux
coeff_amp = 0.00001; 
ecg_g = signal_ech*coeff_amp; 
ecg_d = - ecg_g; 



%Affichage
figure(1)
clf
plot(t_ecg, [ecg_g ecg_d]); 
title ('Visualisation des signaux ECG Droit et Gauche');
xlabel('Temps [s]') ; ylabel('Amplitude [V]');


%% Enregistrement en .txt 

%Patch gauche
ecg_datag = zeros(length(ecg_g),2); 
ecg_datag (:,1) = t_ecg;
ecg_datag (:,2) = ecg_g;

fileID = fopen('ecg_gauche.txt','w');
fprintf(fileID, '%6.3f  %6.8f\n', ecg_datag');
fclose(fileID);

%Patch droit
ecg_datad = zeros(length(ecg_d),2); 
ecg_datad (:,1) = t_ecg;
ecg_datad (:,2) = ecg_d;

fileID = fopen('ecg_droit.txt','w');
fprintf(fileID, '%6.3f  %6.8f\n', ecg_datad');
fclose(fileID);

