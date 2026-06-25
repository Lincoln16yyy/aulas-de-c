#include <stdio.h>
#include <string.h>

struct Disciplina {
    char nome[50];
};

struct Curso {
    char nome[50];
    struct Disciplina disciplinas[6];
};

struct Aluno {
    char nome[50];
    int idade;
    char sexo;
    struct Curso curso;
};

int main() {

    struct Aluno alunos[3];

    strcpy(alunos[0].nome, "Helen");
    alunos[0].idade = 18;
    alunos[0].sexo = 'F';

    strcpy(alunos[0].curso.nome, "Informatica");

    strcpy(alunos[0].curso.disciplinas[0].nome, "Programacao");
    strcpy(alunos[0].curso.disciplinas[1].nome, "Banco de Dados");
    strcpy(alunos[0].curso.disciplinas[2].nome, "Redes");

    printf("Aluno: %s\n", alunos[0].nome);
    printf("Curso: %s\n", alunos[0].curso.nome);

    for(int i = 0; i < 3; i++) {
        printf("Disciplina %d: %s\n",
               i + 1,
               alunos[0].curso.disciplinas[i].nome);
    }

    return 0;
}