#include <stdio.h>

int main() {

    float a, b, c;

    printf("Digite os 3 lados: ");
    scanf("%f %f %f", &a, &b, &c);

    if(a+b > c && a+c > b && b+c > a) {

        if(a == b && b == c)
            printf("Equilatero\n");

        else if(a == b || a == c || b == c)
            printf("Isosceles\n");

        else
            printf("Escaleno\n");

    } else {
        printf("Nao forma triangulo\n");
    }

}