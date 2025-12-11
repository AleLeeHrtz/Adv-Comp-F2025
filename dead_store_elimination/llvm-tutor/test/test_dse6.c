// Test 6: store in conditional, should be conservative
// Expected: No elimination, store might be needed in some path

int test_conditional(int cond) {
    int x;
    x = 10;  // Might be LIVE depending on branch
    
    if (cond) {
        return x;  // Use in true branch
    }
    
    x = 20;  // Store in false branch
    return x;
}

int main() {
    return test_conditional(1);
}
