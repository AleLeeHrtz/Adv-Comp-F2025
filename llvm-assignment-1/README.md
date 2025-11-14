Homework # 5

Using Homework 4 as starting point.

Testing: 

From build directory:

opt -load-pass-plugin ./lib/libDerivedInductionVar.so   -passes='mem2reg,loop-simplify,derived-iv'   -S ../inputs/derived_loop.ll -o out.ll


NOTE:

Please note that I obtained AI help to generate .ll files to test with at 'inputs/derived_loop.ll' and 'inputs/simple_loop.ll' 

Of course, such files are just intended to be used for testing and I believe, in good faith, that does not really affect my learning outcome from this assignment.
