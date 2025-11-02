clear; clc; close all;

%% Параметры сигнала
f = 20;       % частота
A = 7;       % амплитуда
phi = pi/3;     % фаза

%% 1. Построение непрерывного сигнала
t0 = 0; % начальное время
t1 = 1; % конечное время

t = linspace(t0, t1, 1000); 
y = A * cos(2*pi*f*t + phi);

figure;   
plot(t, y, 'b-', 'LineWidth', 2);
grid on;
title('y(t) = 7cos(2πft + π/3), f = 20 Гц');
xlabel('Время t, с');
ylabel('Амплитуда A');
xlim([t0, t1]);

%% 2. Дискретизация сигнала
T = 1;  
f_max = f;  
Fs = 2 * f_max; 
N = Fs * T;  % количество отсчетов
t_dig = 0:1/Fs:T-1/Fs;  % моменты дискретизации
y_dig = A * cos(2 * pi * f * t_dig + phi);

t_1 = 0:0.001:T;  % более частые точки для плавного графика
y_1 = A * cos(2 * pi * f * t_1 + phi);

fprintf('Количество отсчетов: %d\n', N);
fprintf('Первые 10 значений массива:\n');
disp(y_dig(1:10));

figure;
stem(t_dig, y_dig, 'filled', 'LineWidth', 1.5);
hold on;
plot(t_1, y_1, 'r-', 'LineWidth', 1);
xlabel('Время, с');
ylabel('Амплитуда');
title('Оцифрованный сигнал (Fs = 40 Гц)');
legend('Отсчеты', 'Непрерывный сигнал');
grid on;

%% 3. Дискретное преобразование Фурье (ДПФ)
N_dft = length(y_dig);   % матрица ДПФ
Y_dft = zeros(1, N_dft);

for k = 1:N_dft
    for n = 1:N_dft
        Y_dft(k) = Y_dft(k) + y_dig(n) * exp(-1j*2*pi*(k-1)*(n-1)/N_dft);
    end
end

figure;
plot(t_dig, y_dig, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
plot(t_1, y_1, 'r--', 'LineWidth', 1);
xlabel('Время, с');
ylabel('Амплитуда');
title('Сравнение дискретного и непрерывного сигналов');
legend('Дискретный', 'Непрерывный');
grid on;

%% 4. Анализ аудиофайла
try
    [y_audio, Fs_audio] = audioread('Голос.wav');   % y - массив отсчетов, Fs - частота дискретизации
    N_audio = size(y_audio, 1);                % количество отсчетов 
    T_audio = N_audio / Fs_audio;               % длительность записи в секундах

    t_audio = (0:N_audio-1)/Fs_audio;            % временная ось
    figure;
    plot(t_audio, y_audio);
    xlabel('Время (с)');
    ylabel('Амплитуда');
    title('Голосовой сигнал во временной области');
    grid on;

    Y_audio = fft(y_audio);         % БПФ сигнала
    L = length(Y_audio);                      
    f_audio = (0:L-1)*(Fs_audio/L);      % ось частот
    P = abs(Y_audio)/L;           % нормированный спектр

    figure;
    plot(f_audio(1:floor(L/2)), 20*log10(P(1:floor(L/2))));
    xlabel('Частота (Гц)');
    ylabel('Амплитуда (дБ)');
    title('Амплитудный спектр голосового сигнала');
    grid on;

    Fs_calc = N_audio / T_audio;     % пересчитанная частота дискретизации

    disp('=== Анализ аудиофайла ===');
    disp(['Количество отсчетов: ', num2str(N_audio)]);
    disp(['Длительность записи: ', num2str(T_audio), ' сек']);
    disp(['Частота дискретизации (из файла): ', num2str(Fs_audio), ' Гц']);
    disp(['Частота дискретизации (расчет): ', num2str(Fs_calc), ' Гц']);

    %% 5. Прореживание аудиосигнала
    y1 = downsample(y_audio, 30);
    Fs_new = Fs_audio / 30; 

    % Воспроизведение прореженного звука (закомментировано, чтобы избежать автоматического воспроизведения)
    % zvuk = audioplayer(y1, Fs_new);
    % play(zvuk);

    figure;
    plot((0:length(y1)-1)/Fs_new, y1);
    xlabel('Время (с)');
    ylabel('Амплитуда');
    title('Прореженный сигнал (downsample factor = 30)');
    grid on;
    
catch ME
    warning('Аудиофайл "Голос.wav" не найден. Пропущен анализ аудио.');
    disp('Для полной работы программы разместите файл "Голос.wav" в текущей директории.');
end

%% Итоговый вывод информации
disp('=== Итоги анализа сигнала ===');
disp(['Частота сигнала: ', num2str(f), ' Гц']);
disp(['Амплитуда сигнала: ', num2str(A)]);
disp(['Фаза сигнала: ', num2str(phi), ' рад']);
disp(['Частота дискретизации: ', num2str(Fs), ' Гц']);