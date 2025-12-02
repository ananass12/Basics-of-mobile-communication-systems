clear; clc;

data_sizes = [1000, 5000, 10000];
crc_lengths = 3:16;
num_runs = 1000;   %количество повторов для усреднения времени

function rem = calc_crc(input, len, poly)
    crc_len = length(poly) - 1;
    tmp = [input(:)', zeros(1, crc_len)];
    for i = 1:len
        if tmp(i) == 1
            for j = 1:(crc_len + 1)
                idx = i + j - 1;
                if idx <= length(tmp)
                    tmp(idx) = xor(tmp(idx), poly(j));
                end
            end
        end
    end
    rem = tmp(len + 1 : len + crc_len);
end

%x^L + x + 1  [1, 0, ..., 0, 1, 1]
polys = cell(1, 17); 
for L = 3:16
    poly = zeros(1, L + 1);
    poly(1) = 1;        % x^L
    poly(end - 1) = 1;  % x^1
    poly(end) = 1;      % x^0
    polys{L} = poly;
end

avg_times = zeros(length(data_sizes), length(crc_lengths));  %матрица 3 на 14 с нулями

fprintf('Начинаем замер времени...\n');
for s = 1:length(data_sizes)
    N_data = data_sizes(s);
    fprintf('  Размер данных: %d\n', N_data);
    
    fixed_data = randi([0, 1], 1, N_data);   %блок данных этого размера 
    
    for k = 1:length(crc_lengths)
        L = crc_lengths(k);
        poly = polys{L};
        total_time = 0;
        
        for r = 1:num_runs  %1000 прогонов
            tic;
            calc_crc(fixed_data, N_data, poly);
            total_time = total_time + toc;
        end
        
        avg_times(s, k) = total_time / num_runs;  %среднее время одного вычисления CRC
    end
end

figure;
hold on; grid on;
plot(crc_lengths, avg_times.', '-o', 'LineWidth', 1.5);
xlabel('Длина CRC');
ylabel('Среднее время вычисления');
title('Зависимость времени вычисления CRC от длины CRC и размера данных');
legend(strcat("N = ", string(data_sizes)), 'Location', 'northwest');
xlim([3 16]);