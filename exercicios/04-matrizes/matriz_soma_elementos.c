#include <stdio.h>

int main() {
    int A[2][3], B[2][3], soma[2][3];

    // Ler a primeira matriz
    printf("Digite os elementos da matriz A:\n");

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            scanf("%d", &A[i][j]);
        }
    }

    // Ler a segunda matriz
    printf("Digite os elementos da matriz B:\n");

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            scanf("%d", &B[i][j]);
        }
    }

    // Somar as matrizes
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            soma[i][j] = A[i][j] + B[i][j];
        }
    }

    // Mostrar o resultado
    printf("Matriz resultante:\n");

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", soma[i][j]);
        }
        printf("\n");
    }

    return 0;
}