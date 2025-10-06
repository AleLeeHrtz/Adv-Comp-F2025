#!/usr/bin/env python3

import sys
import json
from collections import namedtuple
from form_blocks import form_blocks
import cfg

from df import run_df, Analysis

def fmt(val):
    if isinstance(val, set):
        if val:
            return ", ".join(str(v) for v in sorted(val))  # Convert to str
        else:
            return "∅"
    else:
        return str(val)

import df
df.fmt = fmt

def ae_transfer(block, in_set):
    out_set = in_set.copy()
    
    for instr in block:
        # Kill expressions that use variables being defined
        if 'dest' in instr:
            var = instr['dest']
            to_remove = set()
            for expr in out_set:
                if isinstance(expr, tuple) and len(expr) >= 2:
                    # Check if this expression uses the variable being defined
                    expr_vars = set()
                    for component in expr[1:]:  # Skip operation name
                        if isinstance(component, str):
                            expr_vars.add(component)
                        elif isinstance(component, tuple):
                            for subcomp in component:
                                if isinstance(subcomp, str):
                                    expr_vars.add(subcomp)
                    
                    if var in expr_vars:
                        to_remove.add(expr)
            
            out_set -= to_remove
        
        # Generate new expressions
        if 'op' in instr and instr['op'] not in ['const', 'id', 'print', 'br', 'jmp', 'ret'] and 'args' in instr:
            if len(instr['args']) == 1:
                expr = (instr['op'], instr['args'][0])
            elif len(instr['args']) == 2:
                # Sort args for commutative operations
                if instr['op'] in ['add', 'mul', 'eq']:
                    args = tuple(sorted(instr['args']))
                else:
                    args = tuple(instr['args'])
                expr = (instr['op'], args[0], args[1])
            else:
                expr = (instr['op'], tuple(instr['args']))
            
            out_set.add(expr)
    
    return out_set

def ae_merge(sets):
    sets_list = list(sets)
    if not sets_list:
        return set()  # No predecessors
    
    if len(sets_list) == 1:
        return sets_list[0].copy()
    
    # Intersection of all sets
    result = sets_list[0].copy()
    for s in sets_list[1:]:
        result &= s
    return result

# Define the available expressions analysis
AVAILABLE_EXPRESSIONS = Analysis(
    forward=True,
    init=set(), 
    merge=ae_merge,
    transfer=ae_transfer
)

if __name__ == "__main__":
    bril = json.load(sys.stdin)
    print("=== Available Expressions Analysis ===")
    run_df(bril, AVAILABLE_EXPRESSIONS)
