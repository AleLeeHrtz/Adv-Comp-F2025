// Test 5: Dead store to pointer location
// Expected: First store eliminated if alias analysis confirms overwrite

#include <stdlib.h>

void test_pointer_dead_store() {
    int *p = (int*)malloc(sizeof(int));
    *p = 100;  // DEAD : overwritten immediately
    *p = 200;  // LIVE
    free(p);
}

int main() {
    test_pointer_dead_store();
    return 0;
}
