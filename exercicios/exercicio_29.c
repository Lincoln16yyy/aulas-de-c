#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main() {
    char texto[51];
    char limpa[51];
    int j = 0;

    printf("Digite uma frase: ");
    fgets(texto, sizeof(texto), stdin);

    // Remove espaços e converte para minúsculas
    for (int i = 0; texto[i] != '\0'; i++) {
        if (texto[i] != ' ' && texto[i] != '\n') {
            limpa[j++] = tolower(texto[i]);
        }
    }
    limpa[j] = '\0';

    int tamanho = strlen(limpa);
    int palindromo = 1;

    for (int i = 0; i < tamanho / 2; i++) {
        if (limpa[i] != limpa[tamanho - 1 - i]) {
            palindromo = 0;
            break;
        }
    }

    if (palindromo)
        printf("Palindromo\n");
    else
        printf("Nao Palindromo\n");

    return 0;
}