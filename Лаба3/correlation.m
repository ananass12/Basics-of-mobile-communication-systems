clear, close all

function result = corr(x, y)
    result = sum(x .* y);
end

function znach = norm_corr(x, y)
    sum_x = 0;
    sum_y = 0;
    for i = 1:length(x)
        sum_x = sum_x + x(i)^2; 
        sum_y = sum_y + y(i)^2;
    end
    c = corr(x, y);
    znach = c / sqrt(sum_x * sum_y);
end

t = [0:100-1]/100;
f1 = 19;
f2 = 23;
f3 = 39;

s1 = cos(2*pi*f1*t);
s2 = cos(2*pi*f2*t);
s3 = cos(2*pi*f3*t);

a = 5*s1 + 4*s2 + s3;
b = 2*s1 + s2;

sa_corr = corr(s1, a);
sb_corr = corr(s1, b);
sa_norm_corr = norm_corr(s1, a);
sb_norm_corr = norm_corr(s1, b);

fprintf('Корреляция\n');
fprintf('s1(t) и a = %.2f\n', sa_corr);
fprintf('s1(t) и b = %.2f\n', sb_corr);

fprintf('Нормализованная корреляция\n');
fprintf('s1(t) и a = %.3f\n', sa_norm_corr);
fprintf('s1(t) и b = %.3f\n', sb_norm_corr);

a1 = [0.3,0.2,-0.1,4.2,-2,1.5,0];
b1 = [0.3,4,-2.2,1.6,0.1,0.1,0.2];

a1b1_corr = corr(a1,b1);
a1b1_norm_corr = norm_corr(a1,b1);

N = length(a1);
znach_corr = zeros(1, N);

for i = 0:N-1
    b_sdvig = circshift(b1, [0, i]);
    znach_corr(i + 1) = sum(a1 .* b_sdvig);
end

sdvig = find(znach_corr == max(znach_corr), 1) - 1;
b_opt = circshift(b1, [0,sdvig]);

fprintf('\n\nКорреляция\n');
fprintf('a и b = %.2f\n', a1b1_corr);

fprintf('Нормализованная корреляция\n');
fprintf('a и b = %.3f\n', a1b1_norm_corr);

fprintf('Оптимальный сдвиг = %d\n', sdvig);

figure;
subplot(2,1,1);
plot(a1, 'o-');
title('Массив значений a');
xlabel('Номер отсчёта');
ylabel('Значение');
grid on;

subplot(2,1,2);
plot(b1, 'o-');
title('Массив значений b');
xlabel('Номер отсчёта');
ylabel('Значение');
grid on;

figure;
plot(0:N-1, znach_corr, '-o');
xlabel('Циклический сдвиг');
ylabel('Корреляция');
title('Зависимость корреляции от сдвига');
grid on;

figure;
plot(a1, 'b', 'LineWidth', 1.2); 
hold on;
plot(b_opt, 'r--', 'LineWidth', 1.2);
title(sprintf('Оптимальный сдвиг = %d', sdvig));
legend('a', 'b (сдвинутая)');
xlabel('Номер отсчёта');
ylabel('Значение');
grid on;