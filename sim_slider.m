% Campo con geometría variable.

% ---- INPUTS DEL USUARIO ----
d = input('Separación entre placas (m): ');
L = input('Altura de las placas (m): ');
V_voltaje = input('Voltaje (V): ');

% ---- CAMPO ELÉCTRICO ----
E = V_voltaje / d;

% ---- GRILLA DE FLECHAS ----
% Llena el espacio entre placas en X, y la altura L en Y
[X, Y] = meshgrid(linspace(0.5, d-0.5, 12), linspace(0, L, 50));

hold on;

% ---- COMPONENTES DEL CAMPO (uniforme) ----
U = ones(size(X)) * E;   % horizontal, constante en todo punto
V = zeros(size(Y));      % sin componente vertical


% Placas
rectangle('Position', [0,    -0.5, 0.5, L+1], 'FaceColor', 'r');
rectangle('Position', [d,    -0.5, 0.5, L+1], 'FaceColor', 'b');

% ---- GRAFICADO ----
quiver(X, Y, U, V, 0.1);

% Signos sobre las placas
for y_pos = 0:0.5:L
    text(0.25, y_pos, '+', 'FontSize', 16, 'Color', 'white', ...
        'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    text(d+0.25, y_pos, '-', 'FontSize', 16, 'Color', 'white', ...
        'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end

title('Campo eléctrico entre placas paralelas');
hold off;
