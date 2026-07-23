#include <stdio.h>

int main() {
    FILE *fp;

    fp = fopen("exemplo.bin", "wb");

    if (fp == NULL)
        printf("Erro na abertura do arquivo.\n");

    fclose(fp);

    return 0;
}