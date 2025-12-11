// Test 2: Dead store before return
// Expected: Store should be eliminated due to it being never read

void test_dead_before_return() {
    int x;
    x = 42;  // DEAD : function returns immediately, value never used
    return;
}

int main() {
    test_dead_before_return();
    return 0;
}
