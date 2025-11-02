function adc_analysis_full()
    clear; clc; close all;

    fs = 1000;          
    t = 0:1/fs:1-1/fs;  % ровно 1 секунда
    f0 = 20.37;         % нецелая частота - шум квантования
    x = 7 * cos(2*pi*f0*t + pi/3);
    
    bit_depths = [3, 4, 5, 6];
    
    [f_orig, X_orig] = calculate_spectrum(x, fs);
    errors = zeros(size(bit_depths));
    x_quantized_all = cell(1, length(bit_depths));  % для хранения сигналов

    figure('Name', 'Спектры квантованного сигнала', 'Position', [100, 100, 1000, 800]);
    for i = 1:length(bit_depths)
        bits = bit_depths(i);
        
        % Квантование
        x_quantized = quantize_signal(x, bits);
        x_quantized_all{i} = x_quantized;
        
        % Ошибка
        errors(i) = mean(abs(x - x_quantized));
        
        % Спектр
        [f_quant, X_quant] = calculate_spectrum(x_quantized, fs);
        
        % График спектра
        subplot(2, 2, i);
        plot(f_orig, 20*log10(abs(X_orig) + eps), 'b-', 'LineWidth', 1.5); hold on;
        plot(f_quant, 20*log10(abs(X_quant) + eps), 'r--', 'LineWidth', 1);
        xlim([0, 200]);
        ylim([-120, 5]);
        title(['Спектр – ', num2str(bits), ' бит'], 'FontSize', 11);
        xlabel('Частота, Гц');
        ylabel('Амплитуда (дБ)');
        legend('Исходный', 'Квантованный', 'Location', 'southwest');
        grid on;
    end

    fprintf('Средние абсолютные ошибки квантования:\n');
    for i = 1:length(bit_depths)
        fprintf('  %d бит: %.6f\n', bit_depths(i), errors(i));
    end

    figure('Name', 'Сигналы после квантования (временная область)', ...
       'Position', [100, 100, 1000, 800]);
for i = 1:length(bit_depths)
    bits = bit_depths(i);
    subplot(2, 2, i);  % <-- теперь 2x2
    plot(t, x_quantized_all{i}, 'r-', 'LineWidth', 1.5);
    title(['Сигнал после квантования, ', num2str(bits), ' бит'], 'FontSize', 11);
    xlabel('Время, с');
    ylabel('Амплитуда');
    grid on;
    xlim([0, 1]);  % показываем всю секунду
end
end

function x_quantized = quantize_signal(x, bits)
    max_level = 2^bits - 1;
    x_min = min(x);
    x_max = max(x);
    x_scaled = (x - x_min) / (x_max - x_min) * max_level;
    x_quantized = round(x_scaled);
    x_quantized = max(0, min(max_level, x_quantized));
    x_quantized = x_quantized / max_level * (x_max - x_min) + x_min;
end

function [f, X] = calculate_spectrum(x, fs)
    N = length(x);
    X = fft(x);
    X = X / N;
    if mod(N, 2) == 0
        X(2:end-1) = 2 * X(2:end-1);
    else
        X(2:end) = 2 * X(2:end);
    end
    f = (0:N-1) * fs / N;
    if mod(N, 2) == 0
        X = X(1:N/2+1);
        f = f(1:N/2+1);
    else
        X = X(1:(N+1)/2);
        f = f(1:(N+1)/2);
    end
end

adc_analysis_full();