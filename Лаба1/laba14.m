f = 20;       %частота
A = 7;       %амплитуда
phi = pi/3;     %фаза
T = 1;  
%Fs = 41;
Fs = 164;

N = Fs * T;  %количество отсчетов
t_dig = 0:1/Fs:T-1/Fs;  %моменты дискретизации
y_dig = 7 * cos(2 * pi * f * t_dig + pi/3);

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
title('Оцифрованный сигнал (Fs = 164 Гц)');
legend('Отсчеты', 'Непрерывный сигнал');
grid on;