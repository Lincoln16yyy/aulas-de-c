#include <stdio.h>

int main() {
     
     int a = 10, b = 20; 
     char *n = "alfabeto";
     
     FILE* arq = fopen("arquivo1.txt", "w");
         fprintf(arq, "%d %d %s", a, b, n);
         fclose(arq);
     
     return 0; 
}
