#include <stdio.h>

int main() {

    float notas[100];
    int i;

    // Entrada das notas
    for(i = 0; i < 100; i++) {
        printf("Digite a nota %d: ", i + 1);
        scanf("%f", &notas[i]);
    }

    // Exibição das notas
    printf("\nNotas armazenadas:\n");

    for(i = 0; i < 100; i++) {
        printf("Nota %d: %.2f\n", i + 1, notas[i]);
    }

    return 0;
}