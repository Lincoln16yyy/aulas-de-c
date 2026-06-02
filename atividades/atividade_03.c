#include <stdio.h>

int main() {

    int p, b;
    float total, guardar;

    printf("paes: ");
    scanf("%d", &p);

    printf("broas: ");
    scanf("%d", &b);

    total = (p * 0.12) + (b * 1.50);

    guardar = total * 0.10;

    printf("total: %f\n", total);
    printf("poupanca: %f\n", guardar);

}