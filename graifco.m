%% Curva binário-velocidade da máquina de indução (circuito equivalente por fase)
clear; clc; close all;

%% Parâmetros da máquina  (SUBSTITUIR pelos valores do enunciado)
U   = 690;          % tensão composta [V]
V1  = U/sqrt(3);    % tensão de fase (ligação em estrela) [V]
f   = 50;           % frequência [Hz]
p   = 6;            % número de PARES de polos

Rs  = 17.7e-3;          % resistência do estator [Ohm]
Rr  = 8.05e-3;          % resistência do rotor (referida ao estator) [Ohm]
Lls = 17.7e-3;         % indutância de fugas do estator [H]
Llr = 3.41e-4;         % indutância de fugas do rotor [H]
Lm  = 5.12e-3;        % indutância de magnetização [H]

%% Grandezas derivadas
w   = 2*pi*f;       % pulsação elétrica [rad/s]
ws  = w/p;          % velocidade de sincronismo [rad/s]
ns  = 60*f/p;       % velocidade de sincronismo [rpm]
 
Xls = w*Lls;
Xlr = w*Llr;
Xm  = w*Lm;
 
%% Escorregamento (1000 pontos, evitando s = 0)
s = linspace(1, 0.001, 1000);
 
%% Circuito equivalente
Zr  = Rr./s + 1j*Xlr;                  % ramo do rotor
Zp  = (1j*Xm .* Zr) ./ (1j*Xm + Zr);   % paralelo com a magnetização
Zeq = Rs + 1j*Xls + Zp;                % série com o estator
 
Is  = V1 ./ Zeq;                       % corrente do estator
Ir  = Is .* (1j*Xm) ./ (1j*Xm + Zr);   % divisor de corrente -> corrente do rotor
 
%% Binário e velocidade
T = 3*abs(Ir).^2 .* (Rr./s) / ws;      % [N.m]
n = ns*(1 - s);                        % [rpm]
 
%% Gráfico
figure;
plot(n, T, 'LineWidth', 1.5); grid on;
xlabel('Velocidade (rpm)');
ylabel('Binário (N\cdotm)');
title('Característica binário-velocidade');
 
%% Pontos notáveis (verificação)
[Tmax, k] = max(T);
fprintf('Binário de arranque: %.2f N.m\n', T(1));
fprintf('Binário máximo:      %.2f N.m a %.1f rpm (s = %.4f)\n', Tmax, n(k), s(k));

% Binário máximo
[Tmax, k] = max(T);
fprintf('Tmax = %.2f N.m a %.1f rpm\n', Tmax, n(k));

% Binário nominal (nN = velocidade nominal da chapa)
nN = 1450;
Tn = interp1(n, T, nN);
fprintf('Tn = %.2f N.m a %.1f rpm\n', Tn, nN);

% Binário de 0 a 1000 rpm, de 200 em 200
n_pts = 0:200:1000;
T_pts = interp1(n, T, n_pts);
disp(table(n_pts', T_pts', 'VariableNames', {'n_rpm', 'T_Nm'}))