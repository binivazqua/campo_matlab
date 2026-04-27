% Calculador de Parámetros Cinemáticos para Electrofóresis
% Basado en la lógica de sim_particle.m
% Calcula SOLO parámetros sin visualización

clear; clc;

% ---- ENTRADAS DEL USUARIO ----
fprintf('\n=== CALCULADOR CINEMÁTICO DE ELECTROFÓRESIS ===\n\n');

d = input('Separación entre placas (m): ');
L = input('Altura de las placas (m): ');
V_voltaje = input('Voltaje (V): ');
q = input('Carga de la partícula (C, ej. -1e-6): ');
m = input('Masa de la partícula (kg, ej. 1e-9): ');

% ---- CÁLCULOS CINEMÁTICOS ----
E = V_voltaje / d;  % Campo eléctrico
a = (q * E) / m;    % Aceleración (a = F/m = qE/m)

% Distancia a recorrer: desde el centro hasta la placa más cercana
x0 = d / 2;          % Posición inicial (centro)
distancia_recorrer = x0;

% Tiempo para alcanzar la placa
% Usando: x = x0 + 0.5*a*t^2
% En la placa: x = 0 o x = d (distancia recorrida = x0 o d-x0)
% Resolviendo: distancia = 0.5*|a|*t^2 → t = sqrt(2*distancia/|a|)

if abs(a) > 0
    t_final = sqrt(2 * distancia_recorrer / abs(a));
else
    t_final = inf;
    fprintf('\nADVERTENCIA: Aceleración nula. La partícula no se moverá.\n');
end

% Velocidad final
v_final = a * t_final;

% Distancia total recorrida
distancia_total = distancia_recorrer;

% Energía cinética final
KE_final = 0.5 * m * v_final^2;

% Trabajo realizado por el campo
W = q * E * distancia_total;

% ---- DETERMINACIÓN DE DIRECCIÓN ----
if q < 0
    destino = 'Placa POSITIVA (Roja)';
    sentido = 'izquierda';
elseif q > 0
    destino = 'Placa NEGATIVA (Azul)';
    sentido = 'derecha';
else
    destino = 'Sin movimiento';
    sentido = 'ninguno';
end

% ---- SALIDA FORMATEADA ----
fprintf('\n╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║            PARÁMETROS CINEMÁTICOS CALCULADOS               ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('CONDICIONES INICIALES:\n');
fprintf('├─ Carga (q): %.3e C\n', q);
fprintf('├─ Masa (m): %.3e kg\n', m);
fprintf('├─ Posición inicial: %.4f m (centro)\n', x0);
fprintf('└─ Razón q/m: %.3e C/kg\n\n', q/m);

fprintf('CAMPO ELÉCTRICO:\n');
fprintf('├─ Voltaje (V): %.2f V\n', V_voltaje);
fprintf('├─ Separación (d): %.4f m\n', d);
fprintf('├─ Campo (E): %.4f V/m\n', E);
fprintf('└─ Dirección: De ROJA (+) a AZUL (-)\n\n');

fprintf('DINÁMICA DEL MOVIMIENTO:\n');
fprintf('├─ Aceleración (a): %.6f m/s²\n', a);
fprintf('├─ Dirección: Hacia %s\n', destino);
fprintf('├─ Sentido: %s\n', sentido);
fprintf('├─ Distancia a recorrer: %.4f m\n', distancia_total);
fprintf('└─ Tiempo para alcanzar placa: %.6f s\n\n', t_final);

fprintf('PARÁMETROS FINALES:\n');
fprintf('├─ Velocidad final (v): %.6f m/s\n', v_final);
fprintf('├─ Velocidad final (|v|): %.6f m/s\n', abs(v_final));
fprintf('├─ Energía cinética final: %.6e J\n', KE_final);
fprintf('├─ Trabajo realizado (W): %.6e J\n', W);
fprintf('└─ Verificación (W = KE): %.6e J\n\n', KE_final);

fprintf('RESUMEN:\n');
fprintf('├─ Destino: %s\n', destino);
fprintf('├─ Tiempo de viaje: %.6f s\n', t_final);
fprintf('└─ Velocidad de impacto: %.6f m/s\n\n', abs(v_final));

fprintf('═══════════════════════════════════════════════════════════════\n\n');

% ---- ANÁLISIS ADICIONAL ----
fprintf('ANÁLISIS ADICIONAL:\n\n');

% Comparación con otras partículas
fprintf('Comparativa con otras partículas (mismo campo):\n');

% Partícula con carga 2x
q2 = q * 2;
a2 = (q2 * E) / m;
if abs(a2) > 0
    t_final2 = sqrt(2 * distancia_recorrer / abs(a2));
    v_final2 = a2 * t_final2;
else
    t_final2 = inf;
    v_final2 = 0;
end
fprintf('├─ Carga 2x (q=%.3e C): t=%.6f s, v=%.6f m/s\n', q2, t_final2, abs(v_final2));

% Partícula con masa 2x
m2 = m * 2;
a_half = (q * E) / m2;
if abs(a_half) > 0
    t_final_half = sqrt(2 * distancia_recorrer / abs(a_half));
    v_final_half = a_half * t_final_half;
else
    t_final_half = inf;
    v_final_half = 0;
end
fprintf('└─ Masa 2x (m=%.3e kg): t=%.6f s, v=%.6f m/s\n\n', m2, t_final_half, abs(v_final_half));

% Razón de cambios
if t_final ~= inf && t_final2 ~= inf
    ratio_tiempo = t_final2 / t_final;
    fprintf('Relación de tiempos (carga 2x): %.4f x (razón q/m 2x → tiempo %.4f x)\n\n', ratio_tiempo, ratio_tiempo);
end

fprintf('═══════════════════════════════════════════════════════════════\n\n');
