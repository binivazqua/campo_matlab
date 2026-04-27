% ---- ENTRADAS DEL USUARIO ----
d = input('Separación entre placas (m): ');
L = input('Altura de las placas (m): ');
V_voltaje = input('Voltaje (V): ');
q = input('Carga de la partícula (C, ej. -1e-6): '); 
m = input('Masa de la partícula (kg, ej. 1e-9): ');

% ---- CÁLCULOS ----
E = V_voltaje / d; % Campo apunta de roja (+) a azul (-)
ancho_placa = 0.5;
x_placa_roja = ancho_placa;
x_placa_azul = d + ancho_placa;

% ---- FÍSICA DEL MOVIMIENTO ----
% F = q * E. Si q es (-), la fuerza es opuesta al campo.
aceleracion_x = (q * E) / m;

% Decidimos el tiempo de simulación basado en la distancia a la placa más cercana
% Si a > 0 va a la azul, si a < 0 va a la roja
distancia_a_recorrer = d/2; 
t_final = sqrt(2 * distancia_a_recorrer / abs(aceleracion_x));
t = linspace(0, t_final, 100);

% Posición inicial: Justo en el centro del espacio entre placas
x0 = ancho_placa + (d/2);
y0 = L/2;

% Ecuaciones de movimiento
x_particula = x0 + 0.5 * aceleracion_x * t.^2;
y_particula = ones(size(t)) * y0;

% ---- GRÁFICA ----
figure('Color', 'w'); hold on;

% Dibujar Placas
rectangle('Position', [0, 0, ancho_placa, L], 'FaceColor', 'r'); % Positiva
rectangle('Position', [x_placa_azul, 0, ancho_placa, L], 'FaceColor', 'b'); % Negativa

% Dibujar Campo (Flechitas de + a -)
[X, Y] = meshgrid(linspace(x_placa_roja, x_placa_azul, 10), linspace(0.1, L-0.1, 10));
quiver(X, Y, ones(size(X)), zeros(size(Y)), 0.4, 'Color', [0.8 0.8 0.8]);

% Graficar Trayectoria
plot(x_particula, y_particula, 'g--', 'LineWidth', 2);
plot(x_particula(end), y_particula(end), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 10);

% Etiquetas dinámicas según la carga
if q < 0
    text(x_particula(1), y0 + 0.2, 'Carga (-)', 'HorizontalAlignment', 'center');
    title('Movimiento de Carga Negativa hacia Placa (+) Roja');
else
    text(x_particula(1), y0 + 0.2, 'Carga (+)', 'HorizontalAlignment', 'center');
    title('Movimiento de Carga Positiva hacia Placa (-) Azul');
end

axis([-1, x_placa_azul + 1, -1, L + 1]);
grid on; hold off;
