#include <stdio.h>

int main() {

    float consumoM, consumoH;
    float totalM, totalH, total;
    float precoKg, precoFinal;
    int qtdM, qtdH;

    printf("CALCULO DE CARNE PARA CHURRASCO\n");

    printf("Consumo medio feminino (kg): ");
    scanf("%f", &consumoM);

    printf("Quantidade de mulheres: ");
    scanf("%d", &qtdM);

    printf("Consumo medio masculino (kg): ");
    scanf("%f", &consumoH);

    printf("Quantidade de homens: ");
    scanf("%d", &qtdH);

    printf("Preco do kg da carne: ");
    scanf("%f", &precoKg);

    totalM = consumoM * qtdM;
    totalH = consumoH * qtdH;

    total = (totalM + totalH) * 1.2;

    precoFinal = total * precoKg;

    printf("\nQuantidade total de carne: %.2f kg\n", total);
    printf("Preco total do churrasco: R$ %.2f\n", precoFinal);

}