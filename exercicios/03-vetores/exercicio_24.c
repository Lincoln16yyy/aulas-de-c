#include <stdio.h>

int main() {
    int tamanho;

    printf("Digite o tamanho do vetor: ");
    scanf("%d", &tamanho);

    int vetor[tamanho];
    int soma = 0;
    float media;

    // Leitura dos elementos
    for (int i = 0; i < tamanho; i++) {
        printf("Digite o elemento %d: ", i + 1);
        scanf("%d", &vetor[i]);

        soma += vetor[i];
    }

    media = (float)soma / tamanho;

    printf("\nSoma dos elementos: %d\n", soma);
    printf("Media dos elementos: %.2f\n", media);

    return 0;
}