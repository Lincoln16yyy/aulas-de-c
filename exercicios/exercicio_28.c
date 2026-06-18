#include <stdio.h>

int main() {
    int n, primo;

    printf("Digite um valor para n: ");
    scanf("%d", &n);

    printf("Numeros primos entre 2 e %d:\n", n);

    for (int i = 2; i <= n; i++) {
        primo = 1;

        for (int j = 2; j < i; j++) {
            if (i % j == 0) {
                primo = 0;
                break;
            }
        }

        if (primo) {
            printf("%d ", i);
        }
    }

    printf("\n");

    return 0;
}