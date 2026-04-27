% CONCEPTOS MATEMATICOS - SIM_PARTICLE.M
% =======================================
% Principios matematicos del codigo original de sim_particle.m

% PARAMETROS DE ENTRADA
% ======================
% d: Separacion entre placas [metros]
% L: Altura de las placas [metros]
% V_voltaje: Diferencia de potencial [voltios]
% q: Carga de la particula [coulombs]
% m: Masa de la particula [kilogramos]

% CAMPO ELECTRICO
% ================
% Formula: E = V / d
% Unidades: [V/m] = [N/C]
% Significado: Campo escalar uniforme entre placas paralelas
% Direccion: De placa roja (+) a placa azul (-)
% Calculo en codigo: E = V_voltaje / d

% FUERZA ELECTRICA
% =================
% Formula: F = q * E
% Calculo completo: F = q * (V/d)
% Si q < 0: Fuerza hacia placa positiva (roja)
% Si q > 0: Fuerza hacia placa negativa (azul)
% Tipo: Fuerza conservativa

% SEGUNDA LEY DE NEWTON
% ======================
% Formula: F = m * a
% Despejando aceleracion: a = F/m
% Sustitucion: a = (q * E) / m = (q * V) / (m * d)
% Calculo en codigo: aceleracion_x = (q * E) / m
% Resultado: Aceleracion constante

% CINEMATICA 1D - MOVIMIENTO UNIFORMEMENTE ACELERADO
% ====================================================
% Posicion inicial: x0 = ancho_placa + (d/2) = centro entre placas
% Velocidad inicial: v0 = 0 (reposo)
% Aceleracion: a = constante = (q*V)/(m*d)

% Ecuacion de posicion: x(t) = x0 + (1/2)*a*t^2
% En codigo: x_particula = x0 + 0.5 * aceleracion_x * t.^2

% Ecuacion de velocidad: v(t) = v0 + a*t = a*t
% (No explicitamente calculada en el codigo)

% TIEMPO CARACTERISTICO
% =======================
% Distancia a recorrer: distancia = d/2 (del centro a la placa)
% Formula cimatica: distancia = (1/2) * |a| * t_final^2
% Despejando: t_final = sqrt(2 * distancia / |a|)
% Sustitucion: t_final = sqrt(2 * (d/2) / |a|) = sqrt(d/|a|)
% Expansion: t_final = sqrt(m*d^2 / (|q|*V))
% Calculo en codigo: t_final = sqrt(2 * distancia_a_recorrer / abs(aceleracion_x))

% TRAYECTORIA
% ============
% Movimiento 1D en X: x(t) = x0 + (1/2)*a*t^2 (parabola)
% Movimiento 0D en Y: y(t) = L/2 = constante (linea horizontal)
% Vector de posicion: r(t) = (x(t), y0) en 2D

% En codigo:
% x_particula = x0 + 0.5 * aceleracion_x * t.^2
% y_particula = ones(size(t)) * y0

% DETERMINACION DE DIRECCION
% ============================
% Si q < 0:
%   aceleracion_x < 0
%   Particula se mueve hacia x = 0 (placa roja positiva)
%   Carga negativa atrae hacia positiva

% Si q > 0:
%   aceleracion_x > 0
%   Particula se mueve hacia x = d (placa azul negativa)
%   Carga positiva atrae hacia negativa

% En codigo: evaluacion condicional if q < 0 / else

% DISCRETIZACION
% ===============
% Muestreo temporal: t = linspace(0, t_final, 100)
% Cantidad de puntos: 100
% Intervalo: Desde t=0 hasta t=t_final
% Paso temporal: Delta_t = t_final / 99

% Vector de posiciones X: 100 valores discretos
% Vector de posiciones Y: 100 valores identicos = y0

% MALLA PARA VISUALIZACION DEL CAMPO
% ====================================
% Malla 2D del campo electrico:
% X_grid: linspace(x_placa_roja, x_placa_azul, 10)
% Y_grid: linspace(0.1, L-0.1, 10)
% Componente horizontal: ones(size(X))
% Componente vertical: zeros(size(Y))
% Campo vectorial: (1, 0) normalizado

% ANALISIS DIMENSIONAL
% ======================
% [V] = Voltio = Joule/Coulomb = kg*m^2/(s^2*C)
% [d] = metro = m
% [E] = V/m = kg*m/(s^2*C)
% [q] = Coulomb = A*s = C
% [m] = kilogramo = kg
% [a] = (C/kg) * (kg*m/(s^2*C)) = m/s^2
% [t] = segundos = s
% [x] = metro = m

% RELACIONES ADIMENSIONALES
% ===========================
% Parametro 1: (q*V)/(m*d^2) con unidades [1/s^2]
% Parametro 2: sqrt((|q|*V)/(m*d^2)) con unidades [1/s]
% Escala de tiempo natural: tau = sqrt(m*d^2/(|q|*V))
% Velocidad caracteristica: v_char = d / tau = sqrt((|q|*V)/m)

% CASOS LIMITE
% =============
% Si q = 0: a = 0, t_final = infinito (particula neutra, sin movimiento)
% Si m -> infinito: a -> 0, t_final -> infinito (masa muy grande)
% Si m -> 0: a -> infinito, t_final -> 0 (masa muy pequena)
% Si V = 0: E = 0, a = 0, t_final = infinito (sin voltaje)
% Si d -> 0: E -> infinito, a -> infinito (caso no fisico)

% ENERGIA Y TRABAJO
% ==================
% Velocidad final: v_f = a * t_final
% Energia cinetica final: KE = (1/2) * m * v_f^2
% Trabajo del campo: W = q * V
% Relacion: W = Delta_KE (teorema trabajo-energia)
% Verificacion: |q*V| = KE_final

% COMPARATIVA ENTRE PARTICULAS (CON MISMO CAMPO)
% ================================================
% Razon de aceleraciones: a1/a2 = (q1/m1) / (q2/m2) = (q1*m2) / (q2*m1)
% Razon de tiempos: t1/t2 = sqrt(a2/a1)
% Razon de velocidades finales: v1/v2 = sqrt(a1/a2)
% Separacion espacial: Delta_x = (1/2) * (a1 - a2) * t^2

fprintf('\nCONCEPTOS MATEMATICOS DE SIM_PARTICLE.M\n');
fprintf('====================================\n');
fprintf('Ver comentarios en este archivo para:\n');
fprintf('- Ecuaciones fundamentales\n');
fprintf('- Derivaciones\n');
fprintf('- Analisis dimensional\n');
fprintf('- Casos limite\n');
fprintf('- Comparativas entre particulas\n\n');
