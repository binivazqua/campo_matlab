% Simulación 3D de partícula en campo eléctrico no uniforme
% Combina el campo variable de sim_slider.m con la dinámica de sim_particle.m

% ---- ENTRADAS DEL USUARIO ----
d = input('Separación entre placas (m): ');
L1 = input('Altura de placa izquierda (m): ');
L2 = input('Altura de placa derecha (m): ');
V_voltaje = input('Voltaje (V): ');
q = input('Carga de la partícula (C, ej. -1e-6): ');
m = input('Masa de la partícula (kg, ej. 1e-9): ');

% ---- CONFIGURACIÓN ----
L_max = max(L1, L2);
ancho_placa = 0.5;
x0 = ancho_placa + (d/2);  % Centro entre placas
y0 = L_max / 2;             % Altura inicial

% ---- INTEGRACIÓN TEMPORAL ----
dt = 0.001;  % paso temporal
t_max = 0.1; % tiempo máximo
t = 0:dt:t_max;
N = length(t);

% Inicializar arrays para posición y velocidad
x = zeros(1, N);
y = zeros(1, N);
vx = zeros(1, N);
vy = zeros(1, N);
E_local = zeros(1, N);  % Campo en cada posición
a_x = zeros(1, N);      % Aceleración en X

x(1) = x0;
y(1) = y0;
vx(1) = 0;
vy(1) = 0;

% ---- SIMULACIÓN: Integración numérica ----
for i = 1:N-1
    y_pos = y(i);

    % Calcular campo local E(y)
    % E = V/d donde ambas placas cubren esa altura, E = 0 en otro caso
    if y_pos <= L1 && y_pos <= L2
        E_local(i) = V_voltaje / d;
    else
        E_local(i) = 0;
    end

    % Calcular aceleración: a = (q * E) / m
    a_x(i) = (q * E_local(i)) / m;

    % Movimiento Browniano simple en Y (difusión aleatoria)
    random_force_y = 0.5e-12 * randn();  % Ruido térmico
    a_y = random_force_y / m;

    % Actualizar velocidad (Euler)
    vx(i+1) = vx(i) + a_x(i) * dt;
    vy(i+1) = vy(i) + a_y * dt;

    % Actualizar posición
    x(i+1) = x(i) + vx(i) * dt;
    y(i+1) = y(i) + vy(i) * dt;

    % Condiciones de frontera: rebotar en placas
    if x(i+1) <= ancho_placa
        x(i+1) = ancho_placa + 0.01;
        vx(i+1) = abs(vx(i+1));  % Rebotar
    elseif x(i+1) >= d + ancho_placa
        x(i+1) = d + ancho_placa - 0.01;
        vx(i+1) = -abs(vx(i+1));  % Rebotar
    end

    % Límites en Y
    if y(i+1) < 0
        y(i+1) = 0.01;
        vy(i+1) = abs(vy(i+1));
    elseif y(i+1) > L_max
        y(i+1) = L_max - 0.01;
        vy(i+1) = -abs(vy(i+1));
    end
end

% Asignar valor final del campo
E_local(N) = E_local(N-1);
a_x(N) = a_x(N-1);

% ---- VISUALIZACIÓN 3D ----
figure('Color', 'w', 'Position', [100, 100, 1400, 600]);

% Subplot 1: Trayectoria en 2D con campo variable
subplot(1, 2, 1); hold on;

% Dibujar placas
rectangle('Position', [0, 0, ancho_placa, L1], 'FaceColor', 'r', 'EdgeColor', 'none');
rectangle('Position', [d+ancho_placa, 0, ancho_placa, L2], 'FaceColor', 'b', 'EdgeColor', 'none');

% Mostrar región de campo nulo (si existe)
if L1 ~= L2
    L_min = min(L1, L2);
    if L1 > L_min
        patch([0, ancho_placa, ancho_placa, 0], [L_min, L_min, L1, L1], [0.9 0.3 0.3], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end
    if L2 > L_min
        patch([d+ancho_placa, d+2*ancho_placa, d+2*ancho_placa, d+ancho_placa], [L_min, L_min, L2, L2], [0.3 0.3 0.9], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end
end

% Campo eléctrico (flechitas)
[X_grid, Y_grid] = meshgrid(linspace(ancho_placa+0.2, d+ancho_placa-0.2, 8), linspace(0.1, L_max-0.1, 10));
E_grid = zeros(size(X_grid));
for i = 1:numel(X_grid)
    if Y_grid(i) <= L1 && Y_grid(i) <= L2
        E_grid(i) = 1;  % Normalizado para visualización
    end
end
quiver(X_grid, Y_grid, E_grid, zeros(size(X_grid)), 0.3, 'Color', [0.7 0.7 0.7], 'LineWidth', 1);

% Trayectoria de la partícula con código de color según campo
for i = 1:(length(t)-1)
    if E_local(i) > 0
        color = [0 1 0];  % Verde en campo fuerte
        marker_size = 5;
    else
        color = [1 1 0];  % Amarillo en campo nulo
        marker_size = 3;
    end
    plot(x(i:i+1), y(i:i+1), 'Color', color, 'LineWidth', 2);
end

% Posición inicial y final
plot(x(1), y(1), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8, 'DisplayName', 'Inicio');
plot(x(end), y(end), 'r*', 'MarkerSize', 15, 'DisplayName', 'Final');

axis equal;
axis([−1, d+1.5, −0.5, L_max+0.5]);
xlabel('Posición X (m)'); ylabel('Altura Y (m)');
title(['Trayectoria: Campo variable (q=' num2str(q) ', m=' num2str(m) ')']);
legend('Location', 'best');
grid on; hold off;

% Subplot 2: Campo local y aceleración vs posición X
subplot(1, 2, 2); hold on;

yyaxis left
plot(x, E_local, 'b-', 'LineWidth', 2);
ylabel('Campo eléctrico E (V/m)', 'Color', 'b');
ax = gca;
ax.YAxis(1).Color = 'b';

yyaxis right
plot(x, a_x, 'r-', 'LineWidth', 2);
ylabel('Aceleración a_x (m/s²)', 'Color', 'r');
ax = gca;
ax.YAxis(2).Color = 'r';

xlabel('Posición X (m)');
title('Campo y Aceleración a lo largo de la trayectoria');
grid on; hold off;

% ---- ESTADÍSTICAS ----
fprintf('\n=== RESULTADOS DE SIMULACIÓN 3D ===\n');
fprintf('Posición inicial: (%.4f, %.4f)\n', x(1), y(1));
fprintf('Posición final: (%.4f, %.4f)\n', x(end), y(end));
fprintf('Distancia recorrida: %.4f m\n', sqrt((x(end)-x(1))^2 + (y(end)-y(1))^2));
fprintf('Velocidad final X: %.6f m/s\n', vx(end));
fprintf('Velocidad final Y: %.6f m/s\n', vy(end));
fprintf('Campo máximo: %.4f V/m\n', max(E_local));
fprintf('Aceleración máxima: %.6f m/s²\n', max(abs(a_x)));
fprintf('\n');
