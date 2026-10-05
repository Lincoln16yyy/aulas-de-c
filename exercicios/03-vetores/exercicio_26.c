#include <stdio.h>

int main() {
    int vet1[5], vet2[5], vet3[10];

    // Leitura do primeiro vetor
    printf("Digite os 5 elementos do primeiro vetor:\n");
    for (int i = 0; i < 5; i++) {
        scanf("%d", &vet1[i]);
    }

    // Leitura do segundo vetor
    printf("Digite os 5 elementos do segundo vetor:\n");
    for (int i = 0; i < 5; i++) {
        scanf("%d", &vet2[i]);
    }

    // Intercalação dos vetores
    for (int i = 0; i < 5; i++) {
        vet3[2 * i] = vet1[i];
        vet3[2 * i + 1] = vet2[i];
    }

    // Exibição do terceiro vetor
    printf("Vetor intercalado:\n");
    for (int i = 0; i < 10; i++) {
        printf("%d ", vet3[i]);
    }

    printf("\n");

    return 0;
}