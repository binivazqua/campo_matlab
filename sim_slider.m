%Valor de X y Y(cuantas flechas se dibujaran)
[X,Y] = meshgrid(0.7:0.7,0:0.5:4); 

% odas las flechas están en la misma columna x = 0.7. 
% Para que el campo llene el espacio entre placas necesitamos un rango, 
% por ejemplo 0.7:0.5:5.5.

% Componentes de un campo eléctrico uniforme.

% IMPORTANTE: Sobre 7.5 
% El 7.5 es una constante arbitraria de magnitud.
U = 7.5*X; % Componente X (U): horizontal, constante. Representa E apuntando de + hacia −
V = 0*Y; Componente %Y (V): cero, porque el campo no tiene componente vertical en un capacitor ideal

% HACERLO UNIFORME de acuerdo a la teoría:
% E_real = voltaje / d;          % física
% E = E_real / max_E * flecha_max;  % normalizado para quiver
% U = ones(size(X)) * E;   % E = voltaje / d
% V = zeros(size(Y));


% Los primeros 4 argumentos son origen (X,Y) y dirección (U,V). 
% El 0 desactiva el autoescalado. 
% sin él MATLAB normaliza todas las flechas a un tamaño similar, 
% perdiendo la información de magnitud relativa.

quiver(X,Y,U,V,0);

% Se mantiene en el mismo grafico
hold on; 

% placas
rectangle('Position', [0 -0.5 0.5 5] ,'Facecolor' , 'r'); 
rectangle('Position', [6 -0.5 0.5 5] ,'Facecolor' , 'b'); 

% Signos positivos de la placa izquierda 

for y_pos = 0:0.5:4
    % Se escribe texto en la posicion (0.25, Y). 'Y' va de 0 a 4 en paso de
    % 0.5
    text(0.25, y_pos, '+', 'FontSize',16, 'Color', 'white', 'HorizontalAlignment','center', 'FontWeight','bold'); 

end 


%Signos negativos de la placa derecha 
for y_pos = 0:0.5:4
    text(6.25, y_pos, '-', 'FontSize',16, 'Color', 'white', 'HorizontalAlignment','center', 'FontWeight','bold'); 
end

% Coloca un + cada 0.5 unidades a lo largo de la placa. 
% El x=0.25 es el centro del ancho de la placa (0 a 0.5). 
% El rango 0:0.5:4 debería coincidir con la altura de la placa.

title('Campo electrico producido por dos electrodos con forma de placas planas');

hold off; 

% Libera el gráfico. 
% Cualquier plot posterior lo reemplazaría en lugar de superponerse.

% ----------- INTEGRAR SLIDER --------------- %
% OPCION 1: UICONTROL
function actualizar(src, ~)
    d = src.Value;  % valor del slider
    
    cla;  % limpiar antes de redibujar
    
    E = voltaje / d;
    [X, Y] = meshgrid(linspace(0.5, d-0.5, 8), 0:0.5:4);
    U = ones(size(X)) * E;
    V = zeros(size(Y));
    
    quiver(X, Y, U, V, 0);
    hold on;
    rectangle('Position', [0 -0.5 0.5 5], 'FaceColor', 'r');
    rectangle('Position', [d -0.5 0.5 5], 'FaceColor', 'b');
    % ... signos, title
    hold off;
end

% OPCION 2: APP DESIGNER
function SliderValueChanged(app, event)
    d = app.Slider.Value;
    
    cla(app.UIAxes);
    
    E = app.Voltaje / d;
    % ... mismo bloque de graficado pero sobre app.UIAxes
    quiver(app.UIAxes, X, Y, U, V, 0);
end
