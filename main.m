% Projeto Filtro IIR
% Programa principal
% 
% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

clc;clear;close;

%% Parametros %
bits = 0;                   % Numero de bits (0 - sem quantizacao)
filterType = 0;             % Tipo do filtro (0 - bw, 1 - cb1, 2 - cb2, 3 - elp)
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

% Fatores de escalonamento
a0Escal = 6;
gEscal = 20.5;

% Pre distorcao das frequencias
WpDist = 2*ft*tan(Wp/2);
WsDist = 2*ft*tan(Ws/2);

% Modifica Ws para que fique simetrico em relacao a Wp
[WpDist, WsDist] = ajusteSimetria(WpDist, WsDist);   

% Otimiza a especificacao do filtro p/ ter o menor Ap possivel com mesma ordem
[n,Wn,ApMin] = preOtimizacao(WpDist,WsDist,Ap,As,filterType);
% -------- %

%% Nao Quantizado - Impulsos %
if (bits == 0)
    %Retorna zeros, polos e ganho do filtro especificado
    [z, p, k] = criarFiltro(n,Wn,filterType);
    %Mapeia o plano analogico (s) no plano digital (z)
    [zd, pd, kd] = bilinear(z,p,k,ft);
    %Converte a representacao zero-polo-ganho de tempo discreto na
    %representacao equivalente de segunda ordem
    [sos,g] = zp2sos(zd,pd,kd,'up','two');
    %Ajusta sos para evitar a saturacao de quantizacao
    sos = sos/a0Escal;
    %Preenche x com a quantidade lengthx de zeros
    lengthx = 345;
    x = [g, zeros(1,k)];
    %Implementa o filtro na forma direta II
    [y,w] = implementaIIR(n,k,x,sos,a0Escal,bits);
    %Ajusta a entrada com o intuito de evitar a quantizacao de saturacao
    y = y*gEscal;
    
    figure
    freqz(y(Ordempb,1:k)); %Resolucao da dtft eh de 512
    % freqz ftw!
    axis([0 1 -40 10]) % Ajustar eixos
end