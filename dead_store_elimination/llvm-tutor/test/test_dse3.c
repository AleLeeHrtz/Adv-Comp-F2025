// Test 3: not a dead store, value is read between stores
// Expected: no elimination, first store is live

int test_live_store() {
    int x;
    x = 10;  // LIVE : value is read below
    int y = x;  // Use of x
    x = 20;  // Different store
    return y;
}

int main() {
    return test_live_store();
}
