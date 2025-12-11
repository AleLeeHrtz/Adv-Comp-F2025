// Test 7: dead store to array element
// Expected: first store eliminated

void test_array_dead_store() {
    int arr[10];
    arr[0] = 5;   // DEAD
    arr[0] = 10;  // LIVE
}

int main() {
    test_array_dead_store();
    return 0;
}
