#include "criterion/criterion.h"
#include "include/libdatastructure.h"

Test(algorithm, quicksort_small) {
  int arr[1] = {3};
  int ans[1] = {3};
  quicksort(1, arr);
  cr_assert_arr_eq(arr, ans, 1);

  int arr2[2] = {3, 5};
  int ans2[2] = {3, 5};
  quicksort(2, arr2);
  cr_assert_arr_eq(arr2, ans2, 2);

  int arr3[2] = {5, 3};
  int ans3[2] = {3, 5};
  quicksort(2, arr3);
  cr_assert_arr_eq(arr3, ans3, 2);
}

Test(algorithm, quicksort_normal) {
  int answer[8] = {0, 1, 2, 3, 5, 6, 7, 8};
  int arr[8] = {2, 6, 5, 3, 8, 7, 1, 0};
  quicksort(8, arr);
  cr_assert_arr_eq(arr, answer, 8);
}

