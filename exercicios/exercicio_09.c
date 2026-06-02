#include <stdio.h>

int main() {

    char c;

    printf("Digite um caractere: ");
    scanf(" %c", &c);

    if(c >= 'a' && c <= 'z')
        printf("Eh letra minuscula\n");
    else
        printf("Nao eh letra minuscula\n");

}