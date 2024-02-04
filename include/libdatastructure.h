#ifndef LIBDATASTRUCTURE_H
#define LIBDATASTRUCTURE_H

#define MIN(a, b)           \
  ({                        \
    __typeof__(a) _a = (a); \
    __typeof__(b) _b = (b); \
    _a < _b ? _a : _b;      \
  })

#define MAX(a, b)           \
  ({                        \
    __typeof__(a) _a = (a); \
    __typeof__(b) _b = (b); \
    _a > _b ? _a : _b;      \
  })

#define SWAP(a, b) \
  ({               \
    int temp = a;  \
    a = b;         \
    b = temp;      \
  })

struct vector {};

void quicksort(const int n, int* a);

#endif
