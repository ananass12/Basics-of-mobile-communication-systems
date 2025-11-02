f = 20;       %частота
A = 7;       %амплитуда
phi = pi/3;     %фаза
fs = 40;
T = 1;   
%Fs = 41; 
Fs = 164;

t_1 = 0:0.001:T;  
y_1 = A * cos(2 * pi * f * t_1 + phi);

t_dig = 0:1/Fs:T-1/Fs;  %моменты дискретизации
y_dig = 7 * cos(2 * pi * f * t_dig + pi/3);

N = length(y_dig);   %матрица ДПФ
Y_dft = zeros(1, N);

for k = 1:N
    for n = 1:N
        Y_dft(k) = Y_dft(k) + y_dig(n) * exp(-1j*2*pi*(k-1)*(n-1)/N);
    end
end

figure;
plot(t_dig, y_dig, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
plot(t_1, y_1, 'r--', 'LineWidth', 1);
xlabel('Время, с');
ylabel('Амплитуда');
title('Восстановленный сигнал');
legend('Восстановленный', 'Оригинальный');
grid on;