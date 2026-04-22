%Valor de X y Y(cuantas flechas se dibujaran)
[X,Y] = meshgrid(0.7:0.7,0:0.5:4); 


U = 7.5*X; 
V = 0*Y; 

%Graficar las flechas por medio del origen del vector y hacia donde va el
%campo, el 0 desactiva el factor escala 
quiver(X,Y,U,V,0);

%Se mantiene en el mismo grafico
hold on; 
rectangle('Position', [0 -0.5 0.5 5] ,'Facecolor' , 'r'); 
rectangle('Position', [6 -0.5 0.5 5] ,'Facecolor' , 'b'); 

%Signos positivos de la placa izquierda 

for y_pos = 0:0.5:4
    % Se escribe texto en la posicion (0.25, Y). 'Y' va de 0 a 4 en paso de
    % 0.5
    text(0.25, y_pos, '+', 'FontSize',16, 'Color', 'white', 'HorizontalAlignment','center', 'FontWeight','bold'); 

end 


%Signos negativos de la placa derecha 
for y_pos = 0:0.5:4
    text(6.25, y_pos, '-', 'FontSize',16, 'Color', 'white', 'HorizontalAlignment','center', 'FontWeight','bold'); 
end

title('Campo electrico producido por dos electrodos con forma de placas planas');

hold off; 