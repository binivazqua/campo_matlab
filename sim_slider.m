% Campo con geometría variable para electrofóresis.

% ---- INPUTS DEL USUARIO ----
d = input('Separación entre placas (m): ');
L1 = input('Altura de placa izquierda (m): ');
L2 = input('Altura de placa derecha (m): ');
V_voltaje = input('Voltaje (V): ');

% ---- DEFINIR ALTURA MÁXIMA Y GRILLA ----
L_max = max(L1, L2);
y_range = linspace(0, L_max, 50);
x_range = linspace(0.5, d-0.5, 12);
[X, Y] = meshgrid(x_range, y_range);

hold on;

% ---- COMPONENTES DEL CAMPO (no uniforme) ----
% E(y) = V / d(y), donde d(y) es la distancia local entre placas en cada posición Y
% d(y) = d cuando ambas placas cubren esa altura
% d(y) → ∞ cuando solo una placa la cubre (campo = 0)

U = zeros(size(X));
V = zeros(size(Y));

for i = 1:length(y_range)
    y = y_range(i);
    % Verificar si ambas placas cubren esta altura
    if y <= L1 && y <= L2
        % Ambas placas presente: campo normal
        U(i, :) = V_voltaje / d;
    else
        % Región de campo no uniforme: solo una placa o ninguna
        % No hay campo donde no hay placa (comportamiento ideal)
        U(i, :) = 0;
    end
end


% Placas con alturas individuales
rectangle('Position', [0,    -0.5, 0.5, L1+0.5], 'FaceColor', 'r');
rectangle('Position', [d,    -0.5, 0.5, L2+0.5], 'FaceColor', 'b');

% ---- GRAFICADO ----
quiver(X, Y, U, V, 0.5);

% Signos sobre placa izquierda (evitar solapamiento)
for y_pos = 0.25:1:L1
    text(0.25, y_pos, '+', 'FontSize', 14, 'Color', 'white', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'FontWeight', 'bold');
end

% Signos sobre placa derecha (evitar solapamiento)
for y_pos = 0.25:1:L2
    text(d+0.25, y_pos, '−', 'FontSize', 14, 'Color', 'white', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'FontWeight', 'bold');
end

title('Campo eléctrico no uniforme (electrofóresis)');
xlabel('Posición (m)');
ylabel('Altura (m)');
hold off;
