// Test 8: dead store in loop
// Expected: store before loop eliminated (more complex analysis)

int test_loop_dead_store() {
    int x = 0;  // DEAD if loop always executes
    
    for (int i = 0; i < 10; i++) {
        x = i;  // Overwrites x every iteration
    }
    
    return x;
}

int main() {
    return test_loop_dead_store();
}
