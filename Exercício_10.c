#include <stdio.h>

int main() {

    int op;

    printf("1 - Miojo\n2 - Ensopado\n3 - Arroz\n4 - Feijao\n5 - Carne\n");
    scanf("%d", &op);

    switch(op) {
        case 1:
            printf("Macarrao instantaneo\n");
            break;
        case 2:
            printf("Carne cozida com molho\n");
            break;
        case 3:
            printf("Arroz branco\n");
            break;
        case 4:
            printf("Feijao\n");
            break;
        case 5:
            printf("Carne grelhada\n");
            break;
        default:
            printf("Opcao invalida\n");
    }

}