// Optimizable
int always_same(int x) {
    int a = x * 2;
    int b = x + x;
    return a == b ? 1 : 0;  // Siempre retorna 1
}

// No optimizable por aliasing
void mystery(int *a, int *b) {
    *a = 1;
    *b = 2;
    *a = 3;  // elim  *a = 1? no, it might a == b
}

// No optimizable por funcion externa
extern int random_function();
int unpredictable() {
    int x = random_function();
    return x * 2;  // No se que retorna, no puedo precalcular
}
