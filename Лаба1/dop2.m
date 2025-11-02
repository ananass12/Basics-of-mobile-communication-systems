clear; clc; close all;

[y1,Fs1] = audioread('Голос.wav');
y1 = mean(y1,2); %моно
fprintf('Размер y1: %dx%d\n', size(y1));

[y2,Fs1] = audioread('voice.wav');
y2 = mean(y2,2); %моно
fprintf('Размер y2: %dx%d\n', size(y2));

N = min(length(y1), length(y2));

y1 = y1(1:N);
y2 = y2(1:N);

Y1 = fft(y1);
Y2 = fft(y2);
Y3 = Y2 + Y1;

y3 = real(ifft(Y3));  %убираем мнимую часть

fprintf('Размер y3: %dx%d\n', size(y3));

zvuk = audioplayer(y3, Fs1);
play(zvuk);

figure;

subplot(3,1,1);
t = (0:N-1)/Fs1;
plot(t,y1);
title('Исходный сигнал 1');
xlabel('Время');
ylabel('Амплитуда');
grid on;

subplot(3,1,2);
t = (0:N-1)/Fs1;
plot(t,y2);
title('Исходный сигнал 2');
xlabel('Время');
ylabel('Амплитуда');
grid on;

subplot(3,1,3);
plot(t,y3);
title('Полученный сигнал');
xlabel('Время');
ylabel('Амплитуда');
grid on;


figure;

subplot(3,1,1);
F = (0:N-1)*Fs1/N;
P1 = abs(Y1)/N;
plot(F(1:floor(N/2)),  20*log10(P1(1:floor(N/2))));
title('Спектр исходного 1 сигнала');
xlabel('Частота, Гц'); 
ylabel('Амплитуда, дБ');
grid on;

subplot(3,1,2);
F = (0:N-1)*Fs1/N;
P2 = abs(Y2)/N;
plot(F(1:floor(N/2)), 20*log10(P2(1:floor(N/2))));
title('Спектр исходного 2 сигнала');
xlabel('Частота, Гц'); 
ylabel('Амплитуда, дБ');
grid on;

subplot(3,1,3);
F = (0:N-1)*Fs1/N;
P3 = abs(Y3)/N;
plot(F(1:floor(N/2)), 20*log10(P3(1:floor(N/2))));
title('Спектр результирующего сигнала');
xlabel('Частота, Гц'); 
ylabel('Амплитуда, дБ');
grid on;