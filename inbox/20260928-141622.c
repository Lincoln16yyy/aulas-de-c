#include <stdio.h>

int main() {
    int numeros[5];
    int maior;

    printf("Digite 5 numeros inteiros:\n");

    for (int i = 0; i < 5; i++) {
        scanf("%d", &numeros[i]);
    }

    maior = numeros[0];

    for (int i = 1; i < 5; i++) {
        if (numeros[i] > maior) {
            maior = numeros[i];
        }
    }

    printf("O maior elemento do array e: %d\n", maior);

    return 0;
}