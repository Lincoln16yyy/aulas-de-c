#include <stdio.h>

struct aluno {
    int num_aluno;
    float nota1, nota2, nota3;
    float media;
};

int main() {
    struct aluno alunos[10];

    for (int i = 0; i < 10; i++) {
        printf("\nAluno %d\n", i + 1);

        printf("Numero do aluno: ");
        scanf("%d", &alunos[i].num_aluno);

        printf("Nota 1: ");
        scanf("%f", &alunos[i].nota1);

        printf("Nota 2: ");
        scanf("%f", &alunos[i].nota2);

        printf("Nota 3: ");
        scanf("%f", &alunos[i].nota3);

        alunos[i].media = (alunos[i].nota1 +
                           alunos[i].nota2 +
                           alunos[i].nota3) / 3;
    }

    printf("\n--- Dados dos alunos ---\n");

    for (int i = 0; i < 10; i++) {
        printf("\nAluno: %d", alunos[i].num_aluno);
        printf("\nNota 1: %.2f", alunos[i].nota1);
        printf("\nNota 2: %.2f", alunos[i].nota2);
        printf("\nNota 3: %.2f", alunos[i].nota3);
        printf("\nMedia: %.2f\n", alunos[i].media);
    }

    return 0;
}