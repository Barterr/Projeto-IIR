% Projeto Filtro IIR
% Implementa o filtro na forma direta II

% Autores: Lucas Fernandes e Giuseppe Battistella
% Data: 25/06/2016

%in:
% oderm = ordem do filtro
% k = quantidade de zeros em x
% sos = Second-order-sections (retornado pela funcao sos();)
% escal = escalar de a0
% bits = quantidade de bits a ser quantizado

%out:
% y = saida do filtro

function y = implementaIIR(ordem,k,x,sos,escal,bits)

y = zeros(ordem,k);
w = zeros(ordem,k);

for n=1:1:k
    for j=1:ordem
        a = [sos(j,4) sos(j,5) sos(j,6)];
        b = [sos(j,1) sos(j,2) sos(j,3)];

        if j==1
            yAnt = x(n);
        else
            if n~=1
                yAnt = y(j-1,n-1);
            else
                yAnt = 0;
            end
        end

        if n>=3
            m=3;
        else
            m=n;
        end
        for i=1:1:m
            if i == 1
                w(j,n) = w(j,n) + yAnt*escal;
            else
                w(j,n) = w(j,n) - a(i)*w(j,n-i+1)*escal;
            end
        end
        w(j,n) = quantizar(w(j,n),bits);

        for i=1:1:m
            y(j,n) = y(j,n) + b(i)*w(j,n-i+1);
        end
        y(j,n) = quantizar(y(j,n),bits);
    end
end

% function y = implementaIIR(ordem,k,x,sos,escal,bits)
% 
% y = zeros(ordem,k);
% w = zeros(ordem,k);
% 
% for n=1:1:k
%     for j=1:ordem
%         a = [quantizar(sos(j,4),bits) quantizar(sos(j,5),bits) quantizar(sos(j,6),bits)];
%         b = [quantizar(sos(j,1),bits) quantizar(sos(j,2),bits) quantizar(sos(j,3),bits)];
% 
%         if j==1
%             yAnt = quantizar(x(n),bits);
%         else
%             if n~=1
%                 yAnt = quantizar(y(j-1,n-1),bits);
%             else
%                 yAnt = 0;
%             end
%         end
% 
%         if n>=3
%             m=3;
%         else
%             m=n;
%         end
%         for i=1:1:m
%             if i == 1
%                 w(j,n) = quantizar(w(j,n) + yAnt,bits);
%             else
%                 w(j,n) = quantizar(w(j,n) - quantizar(a(i)*w(j,n-i+1),bits),bits);
%             end
%         end
%         w(j,n) = quantizar(w(j,n)*escal,bits);
% 
%         for i=1:1:m
%             y(j,n) = quantizar(y(j,n) + quantizar(b(i)*w(j,n-i+1),bits),bits);
%         end
%     end
% end
