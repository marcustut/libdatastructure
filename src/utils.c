#include <stdio.h>

void print_arr(const int n, int* a) {
  for (int i = 0; i < n; i++)
    printf("%d ", a[i]);
  printf("\n");
}
