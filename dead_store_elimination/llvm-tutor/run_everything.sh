#!/bin/bash

echo "=========================================="
echo "  DSE Pass - Test Suite"
echo "=========================================="
echo ""

# ===========================================
# 1. COMPILE DSE PASS
# ===========================================
echo "Step 1: Compiling DSE Pass..."
if clang++ -std=c++17 -fPIC -shared DSEPass.cpp \
  -o libDSEPass.so \
  $(llvm-config --cxxflags --ldflags) -lLLVM 2>/dev/null; then
    echo "  OK - DSE Pass compiled"
else
    echo "  ERROR - Failed to compile DSE Pass"
    exit 1
fi
echo ""

# ===========================================
# 2. CREATE DIRECTORIES
# ===========================================
echo "Step 2: Creating directories..."
mkdir -p dse_tests
mkdir -p dse_results
mkdir -p memssa_graphs
echo "  OK"
echo ""

# ===========================================
# 3. COMPILE TEST CASES
# ===========================================
echo "Step 3: Compiling test cases..."

compiled=0
failed=0

for test_file in test/test_dse*.c; do
    if [ ! -f "$test_file" ]; then
        continue
    fi
    
    base_name=$(basename "$test_file" .c)
    echo -n "  $base_name... "
    
    if clang -O0 -Xclang -disable-O0-optnone -S -emit-llvm "$test_file" \
        -o "dse_tests/${base_name}.ll" 2>/dev/null; then
        echo "OK"
        ((compiled++))
    else
        echo "FAILED"
        ((failed++))
        # Show error
        clang -O0 -Xclang -disable-O0-optnone -S -emit-llvm "$test_file" \
            -o "dse_tests/${base_name}.ll" 2>&1 | head -5
    fi
done

echo ""
echo "  Compiled: $compiled tests"
if [ $failed -gt 0 ]; then
    echo "  Failed: $failed tests"
fi
echo ""

# ===========================================
# 4. RUN DSE ON EACH TEST
# ===========================================
echo "Step 4: Running DSE Pass..."
echo ""

for test_file in dse_tests/test_dse*.ll; do
    if [ ! -f "$test_file" ]; then
        continue
    fi
    
    base_name=$(basename "$test_file" .ll)
    
    echo "--- $base_name ---"
    
    # Count stores before
    stores_before=$(grep "store " "$test_file" 2>/dev/null | wc -l)

    # Run DSE
    opt -load-pass-plugin=./libDSEPass.so \
        -passes='dse' \
        "$test_file" -S -o "dse_results/${base_name}_dse.ll" \
        2>&1 > "dse_results/${base_name}_output.txt"
    
    # Count stores after
    stores_after=$(grep "store " "dse_results/${base_name}_dse.ll" 2>/dev/null | wc -l)

    # Calculate eliminated
    eliminated=$((stores_before - stores_after))
    
    echo "  Stores before:  $stores_before"
    echo "  Stores after:   $stores_after"
    echo "  Eliminated:     $eliminated"
    echo ""
done

# ===========================================
# 5. COMPILE MEMORYSSA DEMO AND GENERATE GRAPHS
# ===========================================
echo "Step 5: Generating MemorySSA graphs..."

if [ -f "MemorySSADemo_extended.cpp" ] || [ -f "lib/MemorySSADemo_extended.cpp" ]; then
    echo -n "  Compiling MemorySSA Demo... "
    
    if SRC="MemorySSADemo_extended.cpp"; [ ! -f "$SRC" ] && [ -f "lib/$SRC" ] && SRC="lib/$SRC"; clang++ -std=c++17 -fPIC -shared "$SRC" \
      -o libMemorySSADemo.so \
      $(llvm-config --cxxflags --ldflags) -lLLVM 2>/dev/null; then
        echo "OK"
        
        # Generate graphs for key tests
        for test in 1 3 4; do
            if [ -f "dse_tests/test_dse${test}.ll" ]; then
                echo -n "  Generating graph for test_dse${test}... "
                
                opt -load-pass-plugin=./libMemorySSADemo.so \
                    -passes='memssa-demo' \
                    "dse_tests/test_dse${test}.ll" -disable-output 2>&1 > /dev/null
                
                # Convert all .dot files to PDF
                graph_generated=0
                for dotfile in *_memssa.dot; do
                    if [ -f "$dotfile" ]; then
                        pdffile="memssa_graphs/${dotfile%.dot}.pdf"
                        if dot -Tpdf "$dotfile" -o "$pdffile" 2>/dev/null; then
                            graph_generated=1
                        fi
                        mv "$dotfile" memssa_graphs/ 2>/dev/null
                    fi
                done
                
                if [ $graph_generated -eq 1 ]; then
                    echo "OK"
                else
                    echo "FAILED"
                fi
            fi
        done
    else
        echo "FAILED"
    fi
    echo ""
else
    echo "  MemorySSADemo_extended.cpp not found - skipping graphs"
    echo ""
fi

# ===========================================
# 6. GENERATE SUMMARY
# ===========================================
echo "=========================================="
echo "  SUMMARY"
echo "=========================================="
echo ""

for i in {1..8}; do
    test_ll="dse_tests/test_dse${i}.ll"
    result_ll="dse_results/test_dse${i}_dse.ll"

    if [ -f "$test_ll" ] && [ -f "$result_ll" ]; then
        before=$(grep "store " "$test_ll" 2>/dev/null | wc -l)
        after=$(grep "store " "$result_ll" 2>/dev/null | wc -l)
        elim=$((before - after))

        printf "Test %d:  %2d -> %2d stores  (eliminated: %2d)\n" $i $before $after $elim
    fi
done

echo ""
echo "Files generated:"
echo "  - dse_tests/        (original IR)"
echo "  - dse_results/      (optimized IR)"
echo "  - memssa_graphs/    (MemorySSA visualizations)"
echo ""
echo "To compare a test:"
echo "  diff dse_tests/test_dse1.ll dse_results/test_dse1_dse.ll"
echo ""
echo "To view a graph:"
echo "  xpdf memssa_graphs/test_simple_dead_store_memssa.pdf"
echo ""
echo "Done!"
