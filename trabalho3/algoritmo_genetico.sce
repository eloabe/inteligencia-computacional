clc;
clear;

//função de rosenbrock
function f = rosenbrock (x, y)
    f = (1 - x).^2 + 100*(y - x.^2).^2;
endfunction

//método de seleção de pais escolhido: torneio
function pais = torneio(v, notas, n_individuos)
    pais = zeros(30, n_individuos);
    
    for i = 1:length(notas)
        //seleciona dois indivíduos aleatoriamente
        ind1 = ceil(rand(1, 1) * n_individuos);
        ind2 = ceil(rand(1, 1) * n_individuos);
        
        //o indivíduo que ganha o torneio é aquele que tem menor avaliação
        if notas(ind1) < notas(ind2) then
            pais(:, i) = v(:, ind1)
        else
            pais(:, i) = v(:, ind2)
        end

    end
endfunction

//método de cruzamento: crossover de 1 ponto
function filhos = crossover_1ponto(pais, n_individuos)
    
    //cada par de pais gera dois filhos
    for i = 1:2:n_individuos 
        ponto_corte = ceil(rand(1, 1) * 29);
        
        //primeiro filho: parte esquerda do pai 1 + parte direita do pai 2
        filhos(:, i) = [pais(1:ponto_corte, i) ; pais(ponto_corte+1:30, i+1)];
        
        //segundo filho: parte esquerda do pai 2 + parte direita do pai 1
        filhos(:, i+1) = [pais(1:ponto_corte, i+1) ; pais(ponto_corte+1:30, i)];
    end
    
endfunction

//método de cruzamento: crossover uniforme
function filhos = crossover_uniforme(pais, n_individuos)
    //vetor de combinação
    combinacao = rand(30, 1);
    
    //convertendo para um vetor binário
    for i = 1:length(combinacao)
        if combinacao(i) < 0.5 then
            combinacao(i) = 0
        else
            combinacao(i) = 1
        end
    end
    
    //cada par de pais gera dois filhos
    for i = 1:2:n_individuos 
        for j = 1:30
            if combinacao(j) == 1 then
                //primeiro filho recebe o dado do primeiro pai
                filhos(j, i) = pais(j, i);
                
                //segundo filho recebe o dado do segundo pai
                filhos(j, i+1) = pais(j, i+1);
                
            else
                //primeiro filho recebe o dado do segundo pai
                filhos(j, i) = pais(j, i+1);
                
                //segundo filho recebe o dado do primeiro pai
                filhos(j, i+1) = pais(j, i);
            end
            
        end
    end
    
endfunction

function filhos_mutados = mutacao(filhos, taxa_mutacao, n_individuos)
    filhos_mutados = filhos;
    
    for i = 1:n_individuos
        for j = 1:30
            //número sorteado entre 0 e 1
            sorteado = rand(1, 1); 
            //verifica se o número sorteado é menor que a taxa de mutação, para saber se realiza ou não a troca
            if sorteado < taxa_mutacao then 
                if filhos_mutados(j, i) == 0 then
                    filhos_mutados(j, i) = 1;
                else
                    filhos_mutados(j, i) = 0;
                end
            end
        end
    end
    
endfunction

//população inicial com 50 indivíduos
n_individuos = 50;
v = rand(30, n_individuos, 'uniform');

//cada indivíduo contém 30 números reais entre 0 e 1. 
//para transformá-lo em um vetor binário, podemos fazer uma verificação simples
for i = 1:size(v)(1)
    for j = 1:size(v)(2)
        if v(i, j) < 0.5 then
            v(i, j) = 0
        else
            v(i, j) = 1
        end
    end
end

qtd_geracoes = 50;
tx_mutacao = input("Informe a taxa de mutação desejada: ")/100; //dividimos por 100 para ter o valor em porcentagem
tipo_cruzamento = input("Informe o tipo de cruzamento(1 para ponto de corte, 2 para uniforme): ");

//usaremos como critério de parada apenas o número de gerações
for k = 1:qtd_geracoes 
    
    //transformando o vetor em um único número binário para a coordenada x
    for i = 1:15
        for j = 1:size(v)(2)
            x(j) = strcat(string(v(1:15, j)))  
        end
    end
    
    //transformando o vetor em um único número binário para a coordenada y
    for i = 15:30
        for j = 1:size(v)(2)
            y(j) = strcat(string(v(15:30, j)))  
        end
    end
    
    //vetor x convertido para decimal
    x_decimal = bin2dec(x)
    
    //vetor y convertido para decimal
    y_decimal = bin2dec(y)
    
    //convertendo x para o intervalo (-5, 5)
    x_conv = (((x_decimal - min(x_decimal)) .* (5 - (-5))) ./ (max(x_decimal) - min(x_decimal))) + (-5)
    
    //convertendo y para o intervalo (-5, 5)
    y_conv = (((y_decimal - min(y_decimal)) .* (5 - (-5))) ./ (max(y_decimal) - min(y_decimal))) + (-5)
    
    //coletando as avaliações
    notas = rosenbrock(x_conv, y_conv)
    
    //selecionando os pais pelo método de torneio
    pais = torneio(v, notas, n_individuos);
    
    if tipo_cruzamento == 1 then
        v = crossover_1ponto(pais, n_individuos);
    else
        v = crossover_uniforme(pais, n_individuos);
    end
    
    //realizando a mutação da população
    v = mutacao(v, tx_mutacao, n_individuos);
end

//ÚLTIMA GERAÇÃO
//encontra o índice do indivíduo com menor avaliação
indice_min = find(notas == min(notas));

x_min = x_conv(indice_min);
y_min = y_conv(indice_min);
f_min = notas(indice_min);

mprintf("Coordenada x do melhor indivíduo: %f\n", x_min);
mprintf("\nCoordenada y do melhor indivíduo: %f\n", y_min);
mprintf("\nValor de f(x,y) do melhor indivíduo: %f\n", f_min);

//plotando a função
x=linspace(-5, 5, 30);
y=linspace(-5, 5, 30);

for k=1:30
    for m=1:30
        z(k,m)= rosenbrock(x(k),y(m))
    end    
end

graf3d = gcf();
graf3d.color_map = graycolormap(20);

plot3d(x,y,z);
title('População na geração ' + string(qtd_geracoes))

//plotando os pontos e as notas da última geração
s = 10;
c = 'red'
scatter3d(x_conv, y_conv, notas, s, c, "fill");
