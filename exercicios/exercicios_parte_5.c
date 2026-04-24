#include <stdio.h>

int main() {

    int d1, m1, a1;
    int d2, m2, a2;

    printf("Data 1 (dia mes ano): ");
    scanf("%d %d %d", &d1, &m1, &a1);

    printf("Data 2 (dia mes ano): ");
    scanf("%d %d %d", &d2, &m2, &a2);

    if(a1 < a2)
        printf("Data 1 veio antes\n");
    else if(a1 > a2)
        printf("Data 2 veio antes");
    else {
        if(m1 < m2)
            printf("Data 1 veio antes\n");
        else if(m1 > m2)
            printf("Data 2 veio antes\n");
        else {
            if(d1 < d2)
                printf("Data 1 veio antes\n");
            else if(d1 > d2)
                printf("Data 2 veio antes\n");
            else
                printf("Datas iguais\n");
        }
    }

}