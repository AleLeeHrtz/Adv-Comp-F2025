int add(int a, int b) {
    return a + b;
}

int redundant(int x) {
    int a = x * 2;
    int b = x + x;  // Redundante con a
    int c = a;
    return b;
}
