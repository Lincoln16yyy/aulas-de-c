#include <stdio.h>

int main()
{
  int a, b, c, d;
  
  d = 3;
  c = 2;
  b = 4;
  d = c + b;
  a = d + 1;
  a = a + 1;
  
  printf("o valor de a é %d\n", a);
  
  return 0;
}