#include <stdio.h>

// Protótipo da função adaptada para receber 5 parâmetros
int compara(int a, int b, int c, int d, int e);

int main() {
    int n1, n2, n3, n4, n5, res;

    printf("Digite cinco valores separados por espaco:\n");
    // Lendo os 5 números inteiros
    scanf("%d %d %d %d %d", &n1, &n2, &n3, &n4, &n5);

    // Chamando a função passando os 5 valores
    res = compara(n1, n2, n3, n4, n5);
    
    printf("o menor numero eh: %d\n", res);

    return 0;
}

// Implementação da função que encontra o menor número
int compara(int a, int b, int c, int d, int e) {
    int menor = a; // Começamos assumindo que o primeiro número ('a') é o menor

    // Comparamos o menor atual com cada um dos outros números
    if (b < menor) {
        menor = b;
    }
    if (c < menor) {
        menor = c;
    }
    if (d < menor) {
        menor = d;
    }
    if (e < menor) {
        menor = e;
    }

    return menor; // Retorna o menor de todos
}
