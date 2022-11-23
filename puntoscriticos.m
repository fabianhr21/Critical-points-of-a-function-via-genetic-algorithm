close all; close all; clc;
% CRITICAL POINTS OF A FUNCTION VIA GENETIC ALGORITHM %
% CODED BY: fabianxd
% LAST MODIFICATION: 08/11/2022

%%% CONFIGURACIÓN
f = @(x) sin(20*x) + cos(50*x);     %Funcion
%f = @(x) 3*x.^4 + 4*x.^3 - 12*x.^2 + 7;
a =  -1;              %Valor inicial
b = 1;              %Valor final
p_c = 100;          %Número de veces a correr el algoritmo genético
muestras = 1000000;              %Numero de muestras
%%%
figure(1)
fplot(f,[a,b]);
hold on
dom = [a,b];        % DOminio de la funcion
poblacion = ones(1,2,muestras);         %Poblacion
aptitud = zeros(1,muestras);    
Niter = 1000;         %Numero de iteraciones
Pmut = 1;               %Probabilidad de mutar
SEARCH = zeros(1,p_c);        %Puntos críticos
tic

for l = 1:length(SEARCH)        %Se ejecutá varias veces para encontrar varios puntos críticos
    %Generación de población inicial
    for i = 1:muestras
        poblacion(1,:,i) = ones(1,2);
        poblacion(1,:,i) = poblacion(1,:,i).*((dom(2)-dom(1)).*rand(1,2) + dom(1)); %Randomiza los pares de puntos
        aptitud(i) = apt(i,poblacion,f);
    end

    %%% Algoritmo genético %%%
    for i = 1:Niter
        %   Selección
        [~,ind] = mink(aptitud,2);          %Par de individuos óptimos para reproducirse 
        padre1 = poblacion(:,:,ind(1));
        padre2 = poblacion(:,:,ind(2));
        %   Reproducción y mutacion
        x = randperm(2);        %Punto random de cruzamiento
        hijo1 = [padre1(x(1)), padre2(x(2))];    %Hijo1
        hijo1 = mutacion(hijo1,Pmut,dom);                             %Mutacion hijo 1
        hijo2 = [padre2(x(1)), padre1(x(2))];    %Hijo2
        hijo2 = mutacion(hijo2,Pmut,dom);                             %Mutacion Hijo 2
        % Reemplazo 
        [~,indm] = maxk(aptitud,2);
        poblacion(:,:,indm(1)) = hijo1;
        poblacion(:,:,indm(2)) = hijo2;
        aptitud(indm(1)) = apt(indm(1),poblacion, f);
        aptitud(indm(2)) = apt(indm(2),poblacion, f);
        if min(aptitud) == 0
            break
        end    
    end
    [~,ind] = min(aptitud);

    for j = 1:2
        scatter(poblacion(1,j,ind), f(poblacion(1,j,ind)))
        hold on
    end
SEARCH(l) = poblacion(1,1,ind);
end
toc
%%%%%%%%%% Funciones trucutru %%%%%%%%%%%%%%%%%
function apt = apt(i,poblacion,f)
    deltax = abs(poblacion(1,1,i) -  poblacion(1,2,i));
    d_f = abs(f(poblacion(1,1,i)) -  f(poblacion(1,2,i)));
    dx = d_f / deltax;
    apt = dx + deltax;          %Suma la derivada y la diferencia en x y busca que sea cero
end


function hijo = mutacion(hijo, Pmut,dom)
    p_mutacion = rand();
    if p_mutacion <= Pmut
        g_mutado = randi(2);
        hijo(g_mutado) = ((dom(2)-dom(1)).*rand() + dom(1));
    end
end