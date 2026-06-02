#include <stdio.h>

int soma(int a, int b){
    int c;

    c = a + b;

    return c;
}

int main(){

    int res, x1 = 4, x2 = -10;

    res = soma(5,6);
    printf("Primeira soma: %d\n", res);

    res = soma(x1,x2);
    printf("Segunda soma: %d\n", res);

}