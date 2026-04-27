% Simulación 3D de partícula en campo eléctrico no uniforme
% Combina el campo variable de sim_slider.m con la dinámica de sim_particle.m

% ---- SELECCIÓN DE PARÁMETROS ----
fprintf('\n=== SIMULADOR DE ELECTROFÓRESIS 3D ===\n');
fprintf('Presets de parámetros biológicos recomendados:\n');
fprintf('1. DNA/RNA (carga típica de ácidos nucleicos)\n');
fprintf('2. Proteína (carga típica de proteínas)\n');
fprintf('3. Célula de sangre (glóbulo rojo)\n');
fprintf('4. Parámetros personalizados\n\n');

preset = input('Seleccionar preset (1-4): ');

% Parámetros del campo eléctrico
d = input('Separación entre placas (m): ');
L1 = input('Altura de placa izquierda (m): ');
L2 = input('Altura de placa derecha (m): ');
V_voltaje = input('Voltaje (V): ');

% Parámetros de la partícula según preset
switch preset
    case 1
        % DNA/RNA: carga muy negativa, masa muy pequeña
        q = -1e-15;  % Coulombs (carga de una base de ADN)
        m = 3.3e-26; % kg (peso molecular ~330 Da)
        particula_nombre = 'ADN/ARN';
        fprintf('\n>>> Preset: %s (q=%.2e C, m=%.2e kg)\n\n', particula_nombre, q, m);
    case 2
        % Proteína típica: carga negativa moderada, masa pequeña
        q = -1e-18;  % Coulombs (carga típica de proteína pequeña)
        m = 6.6e-23; % kg (peso molecular ~40 kDa)
        particula_nombre = 'Proteína';
        fprintf('\n>>> Preset: %s (q=%.2e C, m=%.2e kg)\n\n', particula_nombre, q, m);
    case 3
        % Célula de sangre: carga muy negativa, masa grande
        q = -1e-12;  % Coulombs (glóbulo rojo típico)
        m = 9e-14;   % kg (masa de GR ~90 picogramos)
        particula_nombre = 'Glóbulo rojo';
        fprintf('\n>>> Preset: %s (q=%.2e C, m=%.2e kg)\n\n', particula_nombre, q, m);
    case 4
        % Parámetros personalizados
        q = input('Carga de la partícula (C, ej. -1e-15): ');
        m = input('Masa de la partícula (kg, ej. 3.3e-26): ');
        particula_nombre = 'Personalizado';
        fprintf('\n>>> Parámetros personalizados (q=%.2e C, m=%.2e kg)\n\n', q, m);
    otherwise
        error('Opción inválida. Seleccione 1-4.');
end

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
% Figure 1: Trayectoria 2D - SIMULACIÓN DE PARTÍCULA
figure('Color', 'w', 'Position', [100, 100, 750, 650]);
hold on;

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
plot(x(1), y(1), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 10, 'DisplayName', 'Inicio', 'LineWidth', 2);
plot(x(end), y(end), 'r*', 'MarkerSize', 18, 'DisplayName', 'Final', 'LineWidth', 2);

axis equal;
axis([−1, d+1.5, −0.5, L_max+0.5]);
xlabel('Posición X (m)', 'FontSize', 11); ylabel('Altura Y (m)', 'FontSize', 11);
title(sprintf('Trayectoria de %s en Campo No Uniforme', particula_nombre), 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);
grid on; hold off;

% Figure 2: Campo local y aceleración vs posición X - ANÁLISIS CINEMÁTICO INDEPENDIENTE
figure('Color', 'w', 'Position', [900, 100, 750, 650]);
hold on;

yyaxis left
plot(x, E_local, 'b-', 'LineWidth', 2.5, 'DisplayName', 'Campo E');
ylabel('Campo eléctrico E (V/m)', 'Color', 'b', 'FontSize', 11);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(1).FontSize = 10;

yyaxis right
plot(x, a_x, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Aceleración a_x');
ylabel('Aceleración a_x (m/s²)', 'Color', 'r', 'FontSize', 11);
ax = gca;
ax.YAxis(2).Color = 'r';
ax.YAxis(2).FontSize = 10;

xlabel('Posición X (m)', 'FontSize', 11);
title(sprintf('Análisis Cinemático: Campo y Aceleración (%s)', particula_nombre), 'FontSize', 12, 'FontWeight', 'bold');
grid on;
hold off;

% ---- ESTADÍSTICAS ----
fprintf('\n╔════════════════════════════════════════════════════════════╗\n');
fprintf('║       RESULTADOS DE SIMULACIÓN 3D - ELECTROFÓRESIS        ║\n');
fprintf('╚════════════════════════════════════════════════════════════╝\n\n');
fprintf('PARTÍCULA: %s\n', upper(particula_nombre));
fprintf('├─ Carga (q): %.3e C\n', q);
fprintf('├─ Masa (m): %.3e kg\n', m);
fprintf('└─ Relación q/m: %.3e C/kg\n\n', q/m);

fprintf('CAMPO Y PARÁMETROS:\n');
fprintf('├─ Separación placas: %.4f m\n', d);
fprintf('├─ Altura placa izquierda (L1): %.4f m\n', L1);
fprintf('├─ Altura placa derecha (L2): %.4f m\n', L2);
fprintf('├─ Voltaje aplicado: %.2f V\n', V_voltaje);
fprintf('└─ Campo máximo: %.4f V/m\n\n', max(E_local));

fprintf('TRAYECTORIA:\n');
fprintf('├─ Posición inicial: (%.4f, %.4f) m\n', x(1), y(1));
fprintf('├─ Posición final: (%.4f, %.4f) m\n', x(end), y(end));
fprintf('├─ Desplazamiento X: %.4f m\n', x(end)-x(1));
fprintf('├─ Desplazamiento Y: %.4f m\n', y(end)-y(1));
fprintf('└─ Distancia total: %.4f m\n\n', sqrt((x(end)-x(1))^2 + (y(end)-y(1))^2));

fprintf('DINÁMICA:\n');
fprintf('├─ Velocidad final X: %.6f m/s\n', vx(end));
fprintf('├─ Velocidad final Y: %.6f m/s\n', vy(end));
fprintf('├─ Velocidad total: %.6f m/s\n', sqrt(vx(end)^2 + vy(end)^2));
fprintf('├─ Aceleración máxima: %.6f m/s²\n', max(abs(a_x)));
fprintf('└─ Tiempo de simulación: %.4f s\n\n', t_max);

fprintf('═════════════════════════════════════════════════════════════\n\n');
