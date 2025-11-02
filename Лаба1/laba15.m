f = 20;       %частота
A = 7;       %амплитуда
phi = pi/3;     %фаза
T = 1;  
%Fs = 41; 
Fs = 164; 

t_d = 0:1/Fs:T-1/Fs;  %моменты дискретизации
y = 7 * cos(2 * pi * f * t_d + pi/3);

N = length(y);   %матрица ДПФ
Y_dft = zeros(1, N);

%ДПФ
for k = 1:N
    for n = 1:N
        Y_dft(k) = Y_dft(k) + y(n) * exp(-1j*2*pi*(k-1)*(n-1)/N);
    end
end

amplitude = 2*abs(Y_dft)/N; %модуль комплексных чисел
freq = (0:N-1) * Fs / N;  %преобразуем индексы в частоты в герцах
memory = N * 8;

fprintf('Объем памяти для массива %d байт\n', memory);

figure;
stem(freq, amplitude, 'filled');
xlabel('Частота, Гц');
ylabel('Амплитуда');
title('Амплитудный спектр');
grid on;