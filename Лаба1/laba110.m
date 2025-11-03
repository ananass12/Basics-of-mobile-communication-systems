clear; clc; close all;

[y1,Fs1] = audioread('Голос.wav');
y1 = mean(y1, 2);  %среднее двух каналов
fprintf('Размер y1: %dx%d\n', size(y1));

f = fopen('sample.txt', 'r');
if f == -1
    error('Не получается открыть sample.txt');
end

try
    lines = {};
    while ~feof(f)
        line = fgetl(f);
        lines{end+1} = line;
    end
    fclose(f);

    fprintf('Прочитано %d строк\n', length(lines));

    real1 = [];
    imag1 = [];
    real2 = [];
    imag2 = [];
        
    for i = 1:length(lines)
        line = lines{i};
        parts = strsplit(line); %делим по пробелам
        numbers = [];

        for j = 1:length(parts)
            part = strtrim(parts{j});
            if ~isempty(part)
                clean_part = strrep(part, 'i', '');  %удаляем 'i' и '+' 
                clean_part = strrep(clean_part, '+', '');
                num = str2double(clean_part); %строку в число
                if ~isnan(num)
                    numbers(end+1) = num;
                end
            end
        end

        if length(numbers) >= 4
            real1(end+1) = numbers(1);
            imag1(end+1) = numbers(2);
            real2(end+1) = numbers(3);
            imag2(end+1) = numbers(4);
        end
    end

     %комплексные массивы
    left = real1(:) + 1i * imag1(:);
    right = real2(:) + 1i * imag2(:);

catch ME
    fclose(f);
    error('Не получается прочитать данные из sample.txt');
end

y2 = left;
fprintf('Размер y2 изначально: %dx%d\n', size(y2));
y2 = real(ifft(y2)); 
y2 = [y2; y2]; %удваиваем сигнал
y2 = 2* y2;
y2 = y2/max(abs(y2));

fprintf('Размер y2 после удваивания: %dx%d\n', size(y2));

N = min(length(y1), length(y2));

if N == 0
    error('Один из сигналов пустой');
end

y1 = y1(1:N);
y2 = y2(1:N);

Y1 = fft(y1);
Y2 = fft(y2);
Y3 = Y2 + Y1;

y3 = real(ifft(Y3));  %убираем мнимую часть
y3 = y3 / max(abs(y3));  %нормализация

fprintf('Размер y3: %dx%d\n', size(y3));

zvuk = audioplayer(y3, Fs1);
play(zvuk);


figure;

subplot(3,1,1);
t = (0:N-1)/Fs1;
plot(t,y1);
title('Исходный 1 сигнал');
xlabel('Время');
ylabel('Амплитуда');
grid on;

subplot(3,1,2);
t = (0:N-1)/Fs1;
plot(t,y2);
title('Исходный 2 сигнал');
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
title('Спектр 1 сигнала');
xlabel('Частота, Гц'); 
ylabel('Амплитуда, дБ');
grid on;

subplot(3,1,2);
F = (0:N-1)*Fs1/N;
P2 = abs(Y2)/N;
plot(F(1:floor(N/2)), 20*log10(P2(1:floor(N/2))));
title('Спектр 2 сигнала');
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