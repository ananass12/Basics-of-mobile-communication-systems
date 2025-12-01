clear, close all

function gold = generate_gold(x, y)
    N = 31;
    gold = zeros(1, N);
    x = x(:)'; % убедимся, что вектор-строка
    y = y(:)';
    
    for i = 1:N
        gold(i) = xor(x(5), y(5));          % выход = x5 XOR y5
        
        new_x1 = xor(x(4), x(5));           % x1 = x4 XOR x5
        new_y1 = xor(y(2), y(5));           % y1 = y2 XOR y5
        
        x = [new_x1, x(1:4)];
        y = [new_y1, y(1:4)];
    end
end

function znach = norm_corr(x, y)
    sum_x = 0;
    sum_y = 0;
    for i = 1:length(x)
        sum_x = sum_x + x(i)^2; 
        sum_y = sum_y + y(i)^2;
    end
    c = sum(x .* y);
    znach = c / sqrt(sum_x * sum_y);
end

N = 31; % 2^5 - 1
num_samples = 500; 

x1 = [1, 0, 0, 1, 1]; 
y1 = [1, 1, 0, 1, 0]; 
gold1 = generate_gold(x1, y1);
original = gold1; 

fprintf('Последовательность Голда изначальная: ');
fprintf('%d ', gold1);
%fprintf('\nПоследовательность Голда сдвинутая : ');
%fprintf('%d ', gold2);
fprintf('\n\n');


avg_corr = zeros(1, N); 

for k = 1:N
    corrs = zeros(1, num_samples);
    for s = 1:num_samples
        broken = original;
        idx = randperm(N, k);  %возвращает строку из k чисел, случайно выбранных из диапазона от 1 до n
        broken(idx) = 1 - broken(idx);
        corrs(s) = norm_corr(original, broken);
    end
    avg_corr(k) = mean(corrs);
    fprintf('Искажено битов: %2d, средняя корреляция: %.4f\n', k, avg_corr(k));
end

figure;
plot(1:N, avg_corr, '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
title('Зависимость корреляции от числа искаженных битов');
xlabel('Число инвертированных битов');
ylabel('Средняя корреляция');
grid on;
xlim([0, N+1]);
ylim([-0.2, 1.1]);

fprintf('\n\nИскажение по порядку');

for k = 1:N
    %corrs = zeros(1, N);
    broken = original;  %возвращает строку из k чисел, случайно выбранных из диапазона от 1 до n
    %for s = 1:k
    %    broken(s) = 1 - broken(s);
        %corrs(s) = norm_corr(original, broken);
    %end
    broken(1:k) = 1 - broken(1:k);
    avg_corr(k) = norm_corr(original, broken);
    fprintf('Искажено битов: %2d, средняя корреляция: %.4f\n', k, avg_corr(k));
end


figure;
plot(1:N, avg_corr, '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
title('Зависимость корреляции от числа искаженных битов 2');
xlabel('Число инвертированных битов');
ylabel('Средняя корреляция');
grid on;
xlim([0, N+1]);
ylim([-0.2, 1.1]);
