f = 20;       %частота
A = 7;       %амплитуда
phi = pi/3;     %фаза

t0 = 0; %начальное время
t1 = 1; %конечное время

t = linspace(t0, t1, 1000); 

y = A * cos(2*pi*f*t + phi);

figure;   
plot(t, y, 'b-', 'LineWidth', 2);
grid on;
title('y(t) = 7cos(2πft + π/3), f = 20 Гц');
xlabel('Время t, с');
ylabel('Амплитуда A');
xlim([t0, t1]);