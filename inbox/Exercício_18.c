#include <stdio.h>

int main() {

    int x = 5;
    int y = 8;
    int z = 1;
    int w = 10;

    int maior = x;

    if (y > maior) {
        maior = y;
    }

    if (z > maior) {
        maior = z;
    }

    if (w > maior) {
        maior = w;
    }

    printf("O maior numero eh: %d\n", maior);

    return 0;
}