#include <stdio.h>
#define QTD_ALUNOS 10

typedef struct {
    int matricula;
    char nome[50];
    float media;
} Aluno;

int main() {
    Aluno alunos[QTD_ALUNOS] = {
        {1001, "Joao Silva", 8.5f},
        {1002, "Maria Souza", 9.0f},
        {1003, "Carlos Lima", 7.8f},
        {1004, "Ana Costa", 8.2f},
        {1005, "Pedro Alves", 6.9f},
        {1006, "Julia Pereira", 9.5f},
        {1007, "Lucas Santos", 7.4f},
        {1008, "Fernanda Rocha", 8.8f},
        {1009, "Bruno Martins", 5.9f},
        {1010, "Camila Oliveira", 9.1f}
    };

    FILE *arquivo = fopen("alunos.bin", "wb");

    if (arquivo == NULL) {
        printf("Erro ao criar o arquivo.\n");
        return 1;
    }

    fwrite(alunos, sizeof(Aluno), QTD_ALUNOS, arquivo);
    fclose(arquivo);

    printf("Arquivo binario com 10 alunos criado com sucesso.\n");

    return 0;
}