#include <stdio.h>

double pot(double a, int b){

    double resultado = 1;
    int i;

    for(i = 0; i < b; i++){
        resultado = resultado * a;
    }

    return resultado;
}

int main(){

    int base, expoente;

    for(base = 2; base <= 10; base++){

        for(expoente = 0; expoente <= 10; expoente++){

            printf("%d^%d = %.0lf\n",
                   base,
                   expoente,
                   pot(base, expoente));

        }

        printf("\n");
    }

}