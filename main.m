% Projeto Filtro IIR
% Programa principal
% 
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

clc;clear;close;

%% Parametros %
bits = 12;                  % Numero de bits
filterType = 0;             % Tipo do filtro (0 - bw, 1 - cb1, 2 - cb2, 3 - elp)
quantizar = 1;              % Flag p/ quantizacao
% -------- %

%% Especificacoes %
fp = [0.6 1.6]*10^3;        % Limites da banda passante
fs = [0.25 2.4]*10^3;       % Limites da banda de rejeicao
ft = 8*10^3;                % Frequencia de amostragem
Ap = 1;                     % Ripple na banda passante
As = 35;                    % Atenuacao minima da banda de rejeicao
% -------- %

%% Pre ajustes %
Wp = 2*pi*(fp/ft);          % Frequencias limite da banda passante normalizadas
Ws = 2*pi*(fs/ft);          % Frequencias limite da banda de rejeicao normalizadas

% Pre distorcao das frequencias
WpDist = 2*ft*tan(Wp/2);
WsDist = 2*ft*tan(Ws/2);

% Modifica Ws para que fique simetrico em relacao a Wp
[WpDist, WsDist] = ajusteSimetria(WpDist, WsDist);   

% Otimiza a especificacao do filtro p/ ter o menor Ap possivel com mesma ordem
[n,Wn,ApMin] = preOtimizacao(WpDist,WsDist,Ap,As,filterType);

case 
