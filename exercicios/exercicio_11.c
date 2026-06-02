#include <stdio.h>

int main() {

    char op;
    float a, b;

    printf("Digite operador (+ - * /): ");
    scanf(" %c", &op);

    printf("Digite dois numeros: ");
    scanf("%f %f", &a, &b);

    if(op == '+')
        printf("Resultado: %f\n", a + b);
    else if(op == '-')
        printf("Resultado: %f\n", a - b);
    else if(op == '*')
        printf("Resultado: %f\n", a * b);
    else if(op == '/') {
        if(b != 0)
            printf("Resultado: %f\n", a / b);
        else
            printf("Divisao por zero nao pode\n");
    }
    else
        printf("Operador invalido\n");

}