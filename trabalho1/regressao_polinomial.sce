clear all;
clc;

aerogerador = fscanfMat('aerogerador.dat');

//Chamamos a variável dependente/explicativa de X
X = aerogerador(:, 1);

//Chamamos a variável independente/resposta de y
y = aerogerador(:, 2);

plot(X, y, 'b*');

/*Na regressão, existem basicamente duas formas de calcular os coeficientes.
Pode-se calcular cada um separadamente, ou utilizar a abordagem matricial para
generalizar o cálculo no caso de regressões múltiplas, com várias variáveis.

Nesse caso, o resultado é um vetor de coeficientes (betas)

Para utilizar essa abordagem, precisamos ter uma coluna com valores 1, 
depois os valores dos atributos. No aerogerador, temos apenas 1 atributo.
*/

//---------                  CONSTRUINDO OS MODELOS                  ---------

//MATRIZ PARA REGRESSÃO SIMPLES
X_mat = [ones(length(X), 1) X]

//REGRESSÃO POLINOMIAL DE GRAU 2
X_mat_g2 = [X_mat X.^2]
vetor_beta_g2 = (X_mat_g2'*X_mat_g2)^(-1)*X_mat_g2'*y;
y_chap_g2 = vetor_beta_g2(1) + (vetor_beta_g2(2)*X) + (vetor_beta_g2(3) * (X.^2));
//plot(X, y_chap_g2, 'k-')
//title('Regressão polinomial de grau 2')

//REGRESSÃO POLINOMIAL DE GRAU 3
X_mat_g3 = [X_mat_g2 X.^3]
vetor_beta_g3 = (X_mat_g3'*X_mat_g3)^(-1)*X_mat_g3'*y;
y_chap_g3 = vetor_beta_g3(1) + (vetor_beta_g3(2)*X) + (vetor_beta_g3(3) * (X.^2)) + (vetor_beta_g3(4) * (X.^3));
//plot(X, y_chap_g3, 'k-')
//title('Regressão polinomial de grau 3')

//REGRESSÃO POLINOMIAL DE GRAU 4
X_mat_g4 = [X_mat_g3 X.^4]
vetor_beta_g4 = (X_mat_g4'*X_mat_g4)^(-1)*X_mat_g4'*y;
y_chap_g4 = vetor_beta_g4(1) + (vetor_beta_g4(2)*X) + (vetor_beta_g4(3) * (X.^2)) + (vetor_beta_g4(4) * (X.^3)) + (vetor_beta_g4(5) * (X.^4));
//plot(X, y_chap_g4, 'k-')
//title('Regressão polinomial de grau 4')

//REGRESSÃO POLINOMIAL DE GRAU 5
X_mat_g5 = [X_mat_g4 X.^5]
vetor_beta_g5 = (X_mat_g5'*X_mat_g5)^(-1)*X_mat_g5'*y;
y_chap_g5 = vetor_beta_g5(1) + (vetor_beta_g5(2)*X) + (vetor_beta_g5(3) * (X.^2)) + (vetor_beta_g5(4) * (X.^3)) + (vetor_beta_g5(5) * (X.^4)) + (vetor_beta_g5(6) * (X.^5));
//plot(X, y_chap_g5, 'k-')
//title('Regressão polinomial de grau 5')

//REGRESSÃO POLINOMIAL DE GRAU 6
X_mat_g6 = [X_mat_g5 X.^6]
vetor_beta_g6 = (X_mat_g6'*X_mat_g6)^(-1)*X_mat_g6'*y;
y_chap_g6 = vetor_beta_g6(1) + (vetor_beta_g6(2)*X) + (vetor_beta_g6(3) * (X.^2)) + (vetor_beta_g6(4) * (X.^3)) + (vetor_beta_g6(5) * (X.^4)) + (vetor_beta_g6(6) * (X.^5)) + (vetor_beta_g6(7) * (X.^6));
//plot(X, y_chap_g6, 'k-')
//title('Regressão polinomial de grau 6')

//REGRESSÃO POLINOMIAL DE GRAU 7
X_mat_g7 = [X_mat_g6 X.^7]
vetor_beta_g7 = (X_mat_g7'*X_mat_g7)^(-1)*X_mat_g7'*y;
y_chap_g7 = vetor_beta_g7(1) + (vetor_beta_g7(2)*X) + (vetor_beta_g7(3) * (X.^2)) + (vetor_beta_g7(4) * (X.^3)) + (vetor_beta_g7(5) * (X.^4)) + (vetor_beta_g7(6) * (X.^5)) + (vetor_beta_g7(7) * (X.^6)) + (vetor_beta_g7(8) * (X.^7));
plot(X, y_chap_g7, 'k-')
title('Regressão polinomial de grau 7')

/*----------                  AVALIANDO OS MODELOS                  ----------

Uma forma de avaliar um modelo de regressão é calcular o seu coeficiente de determinação R².
Esse coeficiente nos diz o quão bem o modelo "se encaixa" ou descreve a variabilidade dos dados.

Para regressões múltiplas, o acréscimo de uma nova variável sempre vai melhorar o R².
Para ter uma visão menos enviesada do modelo, utilizamos o R² ajustado.
Ele tem uma relação com o R², e uma fórmula para calculá-lo é 
R²aj = 1 - (1-R²)*(n-1/n-k), 
onde n é o número de amostras e k é o número total de variáveis, contando com a variável independente.
*/

//grau 2 (nº de variáveis = 3):
r2_g2 = 1 - (sum((y - y_chap_g2).^2)/sum((y - mean(y)).^2));
r2_ajustado_g2 = 1 - ((1 - r2_g2) * (length(X)-1)/(length(X) - 3));
mprintf('\nR2 da regressão de grau 2: %.7f', r2_g2)
mprintf('\nR2 ajustado da regressão de grau 2: %.7f\n', r2_ajustado_g2)

//grau 3 (nº de variáveis = 4):
r2_g3 = 1 - (sum((y - y_chap_g3).^2)/sum((y - mean(y)).^2));
r2_ajustado_g3 = 1 - ((1 - r2_g3) * (length(X)-1)/(length(X) - 4));
mprintf('\nR2 da regressão de grau 3: %.7f', r2_g3)
mprintf('\nR2 ajustado da regressão de grau 3: %.7f\n', r2_ajustado_g3)

//grau 4 (nº de variáveis = 5):
r2_g4 = 1 - (sum((y - y_chap_g4).^2)/sum((y - mean(y)).^2));
r2_ajustado_g4 = 1 - ((1 - r2_g4) * (length(X)-1)/(length(X) - 5));
mprintf('\nR2 da regressão de grau 4: %.7f', r2_g4)
mprintf('\nR2 ajustado da regressão de grau 4: %.7f\n', r2_ajustado_g4)

//grau 5 (nº de variáveis = 6):
r2_g5 = 1 - (sum((y - y_chap_g5).^2)/sum((y - mean(y)).^2));
r2_ajustado_g5 = 1 - ((1 - r2_g5) * (length(X)-1)/(length(X) - 6));
mprintf('\nR2 da regressão de grau 5: %.7f', r2_g5)
mprintf('\nR2 ajustado da regressão de grau 5: %.7f\n', r2_ajustado_g5)

//grau 6 (nº de variáveis = 7):
r2_g6 = 1 - (sum((y - y_chap_g6).^2)/sum((y - mean(y)).^2));
r2_ajustado_g6 = 1 - ((1 - r2_g6) * (length(X)-1)/(length(X) - 7));
mprintf('\nR2 da regressão de grau 6: %.7f', r2_g6)
mprintf('\nR2 ajustado da regressão de grau 6: %.7f\n', r2_ajustado_g6)

//grau 7 (nº de variáveis = 8):
r2_g7 = 1 - (sum((y - y_chap_g7).^2)/sum((y - mean(y)).^2));
r2_ajustado_g7 = 1 - ((1 - r2_g7) * (length(X)-1)/(length(X) - 8));
mprintf('\nR2 da regressão de grau 7: %.7f', r2_g7)
mprintf('\nR2 ajustado da regressão de grau 7: %.7f\n', r2_ajustado_g7)
