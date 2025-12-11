// Test 1: Simple dead store, value overwritten immediately
// Expected: First store should be eliminated

void test_simple_dead_store() {
    int x;
    x = 10;  // DEAD - overwritten before any use
    x = 20;  // LIVE
}

int main() {
    test_simple_dead_store();
    return 0;
}
