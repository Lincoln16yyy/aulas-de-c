#include <stdio.h>

void troca(int *a, int *b) {
    int temp;

    temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int x = 10;
    int y = 20;

    printf("Antes da troca: x = %d, y = %d\n", x, y);

    troca(&x, &y);

    printf("Depois da troca: x = %d, y = %d\n", x, y);

    return 0;
}