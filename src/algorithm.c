#include "include/libdatastructure.h"

int _partition(int* a, int low, int high) {
  // use 'median-of-three' to find the pivot in the array.
  int x = low;
  int y = high / 2;
  int z = high - 1;

  // sort the three
  if (a[x] > a[y])
    SWAP(a[x], a[y]);
  if (a[x] > a[z])
    SWAP(a[x], a[z]);
  if (a[y] > a[z])
    SWAP(a[y], a[z]);

  SWAP(a[y], a[z]);
  int pivot = a[z];

  int l = low;
  int r = high - 2;

  while (l <= r)
    if (a[l] <= pivot)
      l++;
    else if (a[r] >= pivot)
      r--;
    else 
      SWAP(a[l], a[r]), l++, r--;

  SWAP(a[l], a[z]);
  return l;
}

void _quicksort(int* a, int low, int high) {
  if (low >= high)
    return;

  int first_wall = _partition(a, low, high);
  _quicksort(a, 0, first_wall - 1);
  _quicksort(a, first_wall + 1, high);
}

/*
 * Worst case: O(n^2)
 * Best case : O(n log n)
 */
void quicksort(const int n, int* a) {
  _quicksort(a, 0, n);
}
