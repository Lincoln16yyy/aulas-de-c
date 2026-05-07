#include <stdio.h>

int main() {

    double vetor1[5], vetor2[5], resultado = 0.0;
    int i;

    // Leitura do vetor 1
    for(i = 0; i < 5; i++) {
        printf("Entre com o valor %d para o vetor 1: ", i + 1);
        scanf("%lf", &vetor1[i]);
    }

    printf("\n");

    // Leitura do vetor 2
    for(i = 0; i < 5; i++) {
        printf("Entre com o valor %d para o vetor 2: ", i + 1);
        scanf("%lf", &vetor2[i]);
    }

    // Calculando o produto interno
    for(i = 0; i < 5; i++) {
        resultado = resultado + (vetor1[i] * vetor2[i]);
    }

    printf("\nO produto interno e: %lf\n", resultado);

    return 0;
}