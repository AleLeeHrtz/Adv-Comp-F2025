Dead Store Elimination | Using last homework as starting point - might not be sequential.

Files:

- `DSEPass.cpp` : DSE implementation
- `lib/MemorySSADemo_extended.cpp` : MemorySSA visualization
- `test/test_dse*.c` : Test cases, 8 tests
- `run_everything.sh` : Automated test script

Note: I missed the class where we were whared the DSE pseudocode, I proceeded to implement my own; broader descrition of it inside the corresponding file DSEPass.cpp.

How to Run:

```bash
./run_everything.sh
```

This compiles everything and runs all tests automatically. The tests created can be found in the dir tests/test_dse<n>.c | n = 1 - 8. Explanation on why each specific test can be found inside each specific file.

Results:

| Test | Before | After | Eliminated |
|------|--------|-------|------------|
| 1 - Simple dead store | 3 | 0 | 3 |
| 2 - Dead before return | 2 | 0 | 2 |
| 3 - Live store | 4 | 2 | 2 |
| 4 - Multiple dead | 4 | 1 | 3 |
| 5 - Pointers | 4 | 3 | 1 |
| 6 - Conditionals | 6 | 5 | 1 |
| 7 - Arrays | 3 | 0 | 3 |
| 8 - Loops | 5 | 4 | 1 |
| TOTAL | 31 | 15 | 16 |

DSE Algorithm

The pass detects dead stores using two strategies:

Dead at end: Store has no uses (no one reads it)
Killed by later store: Another store overwrites it before any load

Uses MemorySSA for efficient memory dependence analysis.

Generated Files

- `dse_tests/` : LLVM IR of test cases
- `dse_results/` : Optimized IR after DSE
- `memssa_graphs/*.pdf` : MemorySSA visualization graphs

View Results

```bash
# Compare before/after
diff dse_tests/test_dse1.ll dse_results/test_dse1_dse.ll

# View graph
xpdf memssa_graphs/test_simple_dead_store_memssa.pdf
```

You can replace xpdf with your favourite pdf previewer.
