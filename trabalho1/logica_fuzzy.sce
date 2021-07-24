clear all;
clc;

//FUNÇÕES PARA CALCULAR AS PERTINÊNCIAS
//Calculamos as pertinências para cada subintervalo no intervalo [0, 100]

function [ppl, ppm, pph] = calcula_pertinencias_pedal(ppedal)
/*funções de pertinência da pressão no pedal:
L = {(0, 1), (50, 0)}
M = {(30, 0), (50, 1), (70, 0)}
H = {(50, 0), (100, 1)}
*/

    if(ppedal >= 0 && ppedal < 30)
        ppl = 1 - (1/50)*ppedal;
        ppm = 0;
        pph = 0;
        
    elseif(ppedal >= 30 && ppedal < 50)
        ppl = 1 - (1/50)*ppedal;
        ppm = (1/20)*(ppedal - 30);
        pph = 0;
        
    elseif(ppedal >= 50 && ppedal < 70)
        ppl = 0;
        ppm = (1/20)*(70 - ppedal); //a pertinencia começa a diminuir
        pph = (1/50)*(ppedal-50)
        
    elseif(ppedal >= 70 && ppedal <= 100)
        ppl = 0;
        ppm = 0;
        pph = (1/50)*(ppedal-50);
    end
endfunction


function [pvrs, pvrm, pvrf] = calcula_pertinencias_roda(v_roda)
/* funções de pertinência da velocidade da roda:
S = {(0,1), (60, 0)}
M = {(20, 0), (50, 1), (80, 0)}
F = {(40, 0), (100, 1)}
*/

    if(v_roda >= 0 && v_roda < 20)
        pvrs = 1 - (1/60)*v_roda;
        pvrm = 0;
        pvrf = 0;
        
    elseif(v_roda >= 20 && v_roda < 40)
        pvrs = 1 - (1/60)*v_roda;
        pvrm = (1/30)*(v_roda-20);
        pvrf = 0;
        
    elseif(v_roda >= 40 && v_roda < 50)
        pvrs = 1 - (1/60)*v_roda;
        pvrm = (1/30)*(v_roda-20);
        pvrf = (1/60)*(v_roda - 40);
        
    elseif(v_roda >= 50 && v_roda < 60)
        pvrs = 1 - (1/60)*v_roda;
        pvrm = (1/30)*(80 - v_roda); //a pertinencia começa a diminuir
        pvrf = (1/60)*(v_roda - 40);
        
    elseif(v_roda >= 60 && v_roda < 80)
        pvrs = 0;
        pvrm = (1/30)*(80 - v_roda);
        pvrf = (1/60)*(v_roda - 40);
        
    elseif(v_roda >= 80 && v_roda <= 100)
        pvrs = 0;
        pvrm = 0;
        pvrf = (1/60)*(v_roda - 40);
    end
endfunction

function [pvcs, pvcm, pvcf] = calcula_pertinencias_carro(v_carro)
// para o carro, temos as mesmas funções de pertinência da roda.

    if(v_carro >= 0 && v_carro < 20)
        pvcs = 1 - (1/60)*v_carro;
        pvcm = 0;
        pvcf = 0;
        
    elseif(v_carro >= 20 && v_carro < 40)
        pvcs = 1 - (1/60)*v_carro;
        pvcm = (1/30)*(v_carro - 20);
        pvcf = 0;
        
    elseif(v_carro >= 40 && v_carro < 50)
        pvcs = 1 - (1/60)*v_carro;
        pvcm = (1/30)*(v_carro - 20);
        pvcf = (1/60)*(v_carro - 40);
        
    elseif(v_carro >= 50 && v_carro < 60)
        pvcs = 1 - (1/60)*v_carro;
        pvcm = (1/30)*(80 - v_carro); //a pertinencia começa a diminuir
        pvcf = (1/60)*(v_carro - 40);
        
    elseif(v_carro >= 60 && v_carro < 80)
        pvcs = 0;
        pvcm = (1/30)*(80 - v_carro);
        pvcf = (1/60)*(v_carro - 40);
        
    elseif(v_carro >= 80 && v_carro <= 100)
        pvcs = 0;
        pvcm = 0;
        pvcf = (1/60)*(v_carro - 40);
    end
endfunction

//FUNÇÃO PARA CALCULAR A PRESSÃO NO FREIO
function p_freio = calcula_pressao_freio(interv, aperta_freio, libera_freio)
    temp1 = 0;
    temp2 = 0;
    i = 1;
    
    //lista para armazenar os valores de pressão
    p_freio = zeros(1, length(interv));
    
    while(i <= length(interv))
       v1 = (1/100) * i;
       
       if(v1 <= aperta_freio)
           temp1 = v1;
       else
           temp1 = aperta_freio;
       end
       
       v2 = (1/100)*(100 - i);
       
       if(v1 <= libera_freio)
           temp2 = v2;
       else
           temp2 = libera_freio;
       end
       
       p_freio(i) = max([temp1, temp2]);
       
       i = i+1; 
    end
endfunction

//FUNÇÃO PARA CALCULAR O CENTROIDE
function centroide = calcula_centroide(valor, interv)
    c = sum(valor.*interv)/sum(valor);
    
    //fazemos um pequeno tratamento para que retorne 0 em vez de NaN
    if isnan(c)
        c = 0;
    end
    
    centroide = c;
endfunction

//ENTRADA DOS VALORES
pressao_pedal = input("Insira o valor da pressão no pedal(entre 0 e 100): ");
vel_roda = input("Insira o valor da velocidade da roda(entre 0 e 100): ");
vel_carro = input("Insira o valor da velocidade do carro(entre 0 e 100): ");

//CALCULANDO TODAS AS PERTINÊNCIAS
[pplow, ppmed, pphigh] = calcula_pertinencias_pedal(pressao_pedal);
[pcslow, pcmed, pcfast] = calcula_pertinencias_carro(vel_carro);
[prslow, prmed, prfast] = calcula_pertinencias_roda(vel_roda);

//CONSTRUINDO AS REGRAS
//REGRA 1: pressão no pedal média
r1 = ppmed;

//REGRA 2: pressão no pedal alta E velocidade do carro alta E velocidade das rodas alta
//Na lógica fuzzy, utilizamos o valor mínimo entre os 3 para representar a conjunção/interseção
r2 = min([pphigh, pcfast, prfast]);

//REGRA 3: pressão no pedal alta E velocidade do carro alta E velocidade das rodas baixa
r3 = min([pphigh, pcfast, prslow]);

//REGRA 4: pressão no pedal baixa
r4 = pplow;

//COMBINANDO AS REGRAS PARA CALCULAR AS PERTINÊNCIAS DE APERTA FREIO E LIBERA FREIO
aperta_freio = r1 + r2;
libera_freio = r3 + r4;

//O intervalo no qual estamos trabalhando é [0, 100]
interv = 0:1:100;

//CALCULANDO A PRESSÃO
valor_funcao = calcula_pressao_freio(interv, aperta_freio, libera_freio);

//CALCULANDO O CENTRÓIDE
centroide_pres = calcula_centroide(valor_funcao, interv);

mprintf('A pressão ideal que deve ser aplicada no freio é: %.2f;\n', centroide_pres);
