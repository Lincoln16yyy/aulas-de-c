#include <stdio.h>
#include <math.h>

int main() {

    float a, b;

    printf("numero 1: ");
    scanf("%f", &a);

    printf("numero 2: ");
    scanf("%f", &b);

    printf("soma: %f\n", a+b);
    printf("produto: %f\n", a*(b*b));
    printf("quadrado do primeiro: %f\n", a*a);
    printf("raiz da soma dos quadrados: %f\n", sqrt(a*a + b*b));
    printf("seno da diferenca: %f\n", sin(a-b));

    if(a < 0)
        printf("modulo do primeiro: %f\n", -a);
    else
        printf("modulo do primeiro: %f\n", a);

}