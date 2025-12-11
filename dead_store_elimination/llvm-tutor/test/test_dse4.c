// Test 4: mUltiple dead stores in sequence
// Expected: first two stores eliminated, only last one survives

int test_multiple_dead() {
    int x;
    x = 1;   // DEAD
    x = 2;   // DEAD
    x = 3;   // LIVE
    return x;
}

int main() {
    return test_multiple_dead();
}
