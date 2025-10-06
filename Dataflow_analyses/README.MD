# Dataflow Analysis


Two dataflow analyses for Bril:
rd_simple.py: reaching definitions
ae_simple.py: available expressions

## Running

bril2json < test/simple_rd.bril | python3 rd_simple.py
bril2json < test/simple_ae.bril | python3 ae_simple.py

## Tests

turnt -v -c turnt-rd.toml test/simple_rd.bril
turnt -v -c turnt-ae.toml test/simple_ae.bril

Update test outputs:
turnt -c turnt-rd.toml test/simple_rd.bril --save

## Workflow

Reaching Definitions: tracks which variable assignments reach each point. Uses union to merge, kills old definitions when variables get reassigned.

Available Expressions: finds which expressions are already computed. Uses intersection to merge, kills expressions when their variables change.

## Notes

Had to write a custom run_df_with_names() in rd_simple.py because the framework doesn't pass block names to transfer functions, but we need them to label each definition.
