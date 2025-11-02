clear; clc; close all;

[y, Fs] = audioread('Голос.wav');
if size(y,2) > 1, y = y(:,1); end
y = y(:);

% Прореживание 
M = 10;
y1 = downsample(y, M);
Fs1 = Fs / M;

% ДПФ
Y = fft(y);        Y1 = fft(y1);
N = length(y);     N1 = length(y1);

% Амплитудные спектры (односторонние)
P = abs(Y(1:N/2+1)) / N;      P1 = abs(Y1(1:N1/2+1)) / N1;
P(2:end-1) = 2*P(2:end-1);    P1(2:end-1) = 2*P1(2:end-1);

% Частотные оси
f = (0:N/2) * Fs/N;
f1 = (0:N1/2) * Fs1/N1;

% Графики
figure;
subplot(2,1,1); plot(f, 20*log10(P + eps)); 
xlabel('Частота (Гц)'); ylabel('Амплитуда (дБ)'); title('Оригинал'); grid on;

subplot(2,1,2); plot(f1, 20*log10(P1 + eps)); 
xlabel('Частота (Гц)'); ylabel('Амплитуда (дБ)'); title('Прореженный'); grid on;

thr = -200;
db = 20*log10(P + eps);
db1 = 20*log10(P1 + eps);
  

% Оригинал
idx = db >= thr;
w_orig = idx(end) * f(find(idx,1,'last')) - idx(1) * f(find(idx,1,'first'));
if ~any(idx), w_orig = f(db == max(db)); end

% Прореженный
idx1 = db1 >= thr;
w_down = idx1(end) * f1(find(idx1,1,'last')) - idx1(1) * f1(find(idx1,1,'first'));
if ~any(idx1), w_down = f1(db1 == max(db1)); end

% Вывод
fprintf('Ширина спектра (оригинал): %.1f Гц\n', w_orig);
fprintf('Ширина спектра (прореженный): %.1f Гц\n', w_down);