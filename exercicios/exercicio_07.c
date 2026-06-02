#include <stdio.h>

int main() {

    float nota;

    printf("Digite a nota: ");
    scanf("%f", &nota);

    if(nota >= 7)
        printf("Aprovado\n");
    else if(nota >= 5)
        printf("Prova final\n");
    else
        printf("Reprovado\n");

}