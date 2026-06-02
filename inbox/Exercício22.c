#include <stdio.h>
#include <math.h> // Biblioteca necessária para usar sqrt() e pow()

// Protótipo da função
float calculaDistancia(float x1, float y1, float x2, float y2);

int main() {
    float x1, y1, x2, y2, distancia;

    // Leitura das coordenadas do primeiro ponto
    printf("Digite as coordenadas do primeiro ponto (x1 y1): ");
    scanf("%f %f", &x1, &y1);

    // Leitura das coordenadas do segundo ponto
    printf("Digite as coordenadas do segundo ponto (x2 y2): ");
    scanf("%f %f", &x2, &y2);

    // Chamada da função que faz o cálculo
    distancia = calculaDistancia(x1, y1, x2, y2);

    // Exibição do resultado com duas casas decimais (.2)
    printf("A distancia entre os pontos eh: %.2f\n", distancia);

    return 0;
}

// Implementação da função que calcula a distância
float calculaDistancia(float x1, float y1, float x2, float y2) {
    float d;
    
    // Aplica a fórmula: raiz quadrada de ((x2 - x1)^2 + (y2 - y1)^2)
    d = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    
    return d;
}
