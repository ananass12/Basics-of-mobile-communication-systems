clear; clc; close all;

[y1, Fs1] = audioread('Голос.wav');   % y - массив отсчетов, Fs - частота дискретизации
[y2, Fs2] = audioread('voice.wav');   

N = min(length(y1), length(y2)); 
t = (0:N-1) / Fs1;  
y1 = y1(1:N);
y2 = y2(1:N);

y3 = y1 + y2;

zvuk = audioplayer(y3, Fs1);
play(zvuk);

figure;

subplot(3,1,1);
plot(t, y1);
xlabel('Время');
ylabel('Амплитуда');
title('1 сигнал');
grid on;

subplot(3,1,2);
plot(t, y2);
xlabel('Время');
ylabel('Амплитуда');
title('2 сигнал');
grid on;

subplot(3,1,3);
plot(t, y3);
xlabel('Время');
ylabel('Амплитуда');
title('Итоговый сигнал');
grid on;