#include <stdio.h>

typedef struct {
    int matricula;
    char nome[50];
    float media;
} Aluno;

int main() {
    Aluno a = {1001, "Joao Silva", 8.5f};
    FILE *arquivo = fopen("aluno.bin", "wb");

    if (arquivo == NULL) {
        printf("Erro ao criar o arquivo.\n");
        return 1;
    }

    fwrite(&a, sizeof(Aluno), 1, arquivo);
    fclose(arquivo);

    printf("Arquivo binario criado com sucesso.\n");
    return 0;
}