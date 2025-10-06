#!/usr/bin/env python3
import sys
import json
from collections import namedtuple
from form_blocks import form_blocks
import cfg
from df import Analysis, union

def fmt(val):
    if isinstance(val, set):
        if val:
            return ", ".join(str(v) for v in sorted(val, key=str))
        else:
            return "∅"
    else:
        return str(val)

import df
df.fmt = fmt

# Store current block name for transfer function
_current_block = None

def rd_transfer(block, in_set):
    global _current_block
    block_name = _current_block if _current_block else "entry"
    
    out_set = in_set.copy()
    
    for i, instr in enumerate(block):
        if 'dest' in instr:
            var = instr['dest']
            def_id = (block_name, i, var)
            
            # Kill previous definitions of this variable
            to_remove = {d for d in out_set if isinstance(d, tuple) and len(d) == 3 and d[2] == var}
            out_set -= to_remove
            
            out_set.add(def_id)
    
    return out_set

REACHING_DEFINITIONS = Analysis(
    forward=True,
    init=set(),
    merge=union,
    transfer=rd_transfer
)

def run_df_with_names(bril, analysis):
    global _current_block
    
    for func in bril["functions"]:
        blocks = cfg.block_map(form_blocks(func["instrs"]))
        cfg.add_terminators(blocks)
        
        preds, succs = cfg.edges(blocks)
        
        if analysis.forward:
            first_block = list(blocks.keys())[0]
            in_edges = preds
            out_edges = succs
        else:
            first_block = list(blocks.keys())[-1]
            in_edges = succs
            out_edges = preds
        
        in_ = {first_block: analysis.init}
        out = {node: analysis.init for node in blocks}
        
        worklist = list(blocks.keys())
        while worklist:
            node = worklist.pop(0)
            
            inval = analysis.merge(out[n] for n in in_edges[node])
            in_[node] = inval
            
            # Set current block name before calling transfer
            _current_block = node
            outval = analysis.transfer(blocks[node], inval)
            
            if outval != out[node]:
                out[node] = outval
                worklist += out_edges[node]
        
        for block in blocks:
            print("{}:".format(block))
            print("  in: ", fmt(in_[block]))
            print("  out:", fmt(out[block]))

if __name__ == "__main__":
    bril = json.load(sys.stdin)
    print("=== Reaching Definitions Analysis ===")
    run_df_with_names(bril, REACHING_DEFINITIONS)
