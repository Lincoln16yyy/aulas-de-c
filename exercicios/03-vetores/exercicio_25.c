#include <stdio.h>

int maiorValor(int Vet[], int Tam) {
    int maior = Vet[0];

    for (int i = 1; i < Tam; i++) {
        if (Vet[i] > maior) {
            maior = Vet[i];
        }
    }

    return maior;
}

int main() {
    int vetor[] = {10, 25, 7, 42, 18};
    int tam = 5;

    printf("Maior valor: %d\n", maiorValor(vetor, tam));

    return 0;
}