#include <stdio.h>

int indice_maximo(int v[], int n) {
    int indice = 0;

    for (int i = 1; i < n; i++) {
        if (v[i] > v[indice]) {
            indice = i;
        }
    }

    return indice;
}

int main() {
    int v[] = {10, 25, 7, 42, 18};
    int n = 5;

    printf("Indice do maior elemento: %d\n", indice_maximo(v, n));

    return 0;
}