clear; clc; close all;

[y, Fs] = audioread('Голос.wav');   % y - массив отсчетов, Fs - частота дискретизации
N = size(y, 1);                % количество отсчетов 
T = N / Fs;               % длительность записи в секундах

y1 = downsample(y, 10);
Fs_new = Fs / 10; 

zvuk = audioplayer(y1, Fs_new);
play(zvuk);

figure;
plot((0:length(y1)-1)/Fs_new, y1);
xlabel('Время (с)');
ylabel('Амплитуда');
title('Прореженный сигнал');
grid on;
