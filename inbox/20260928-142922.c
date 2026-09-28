#include <stdio.h>

int main() {
    int matriz[3][3];
    int soma = 0;

    // Ler os elementos
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("Digite o elemento [%d][%d]: ", i, j);
            scanf("%d", &matriz[i][j]);

            soma = soma + matriz[i][j];
        }
    }

    printf("A soma dos elementos e: %d\n", soma);

    return 0;
}