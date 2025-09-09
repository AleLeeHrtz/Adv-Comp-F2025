#!/usr/bin/env python3
import sys, json, argparse
from typing import List, Dict
from cfg_utils import get_path_lengths, reverse_postorder, find_back_edges, is_reducible

TERMINATORS = {"jmp", "br", "ret"}

def split_basic_blocks(instrs: List[dict]):
    blocks = []
    current = {"name": None, "instrs": []}
    synthetic_id = 0
    def push_block():
        nonlocal current, blocks, synthetic_id
        if current["name"] is None:
            current["name"] = f"B{synthetic_id}"
            synthetic_id += 1
        blocks.append(current)
        current = {"name": None, "instrs": []}
    i = 0
    while i < len(instrs):
        instr = instrs[i]
        if "label" in instr:
            if current["instrs"]:
                push_block()
            current["name"] = instr["label"]
            i += 1
            continue
        current["instrs"].append(instr)
        if instr.get("op") in TERMINATORS:
            push_block()
        i += 1
    if current["instrs"] or current["name"] is not None:
        push_block()
    return blocks

def successors(blocks):
    name2idx = {blk["name"]: i for i, blk in enumerate(blocks)}
    succ = {blk["name"]: [] for blk in blocks}
    for i, blk in enumerate(blocks):
        instrs = blk["instrs"]
        last = instrs[-1] if instrs else None
        name = blk["name"]
        if last is None:
            if i + 1 < len(blocks):
                succ[name].append(blocks[i+1]["name"])
            continue
        op = last.get("op")
        if op == "jmp":
            lab = last.get("labels", [])[0]
            succ[name].append(lab)
        elif op == "br":
            labs = last.get("labels", [])
            if len(labs) == 2:
                succ[name].append(labs[0])
                succ[name].append(labs[1])
        elif op == "ret":
            pass
        else:
            if i + 1 < len(blocks):
                succ[name].append(blocks[i+1]["name"])
    return succ

def build_cfgs(prog: dict):
    out = {}
    for f in prog.get("functions", []):
        blocks = split_basic_blocks(f.get("instrs", []))
        adj = successors(blocks)
        entry = blocks[0]["name"] if blocks else None
        out[f["name"]] = (entry, adj)
    return out

def print_adj(fname, entry, adj):
    print(f"{fname}:")
    for b in sorted(adj):
        print(f"  {b} -> {' '.join(adj[b])}")
    print()

def print_dot(fname, entry, adj):
    print(f"digraph {fname} {{")
    print(f'  entry="{entry}";')
    for u, succs in adj.items():
        if not succs:
            print(f'  "{u}";')
        for v in succs:
            print(f'  "{u}" -> "{v}";')
    print("}")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--paths", action="store_true")
    ap.add_argument("--rpo", action="store_true")
    ap.add_argument("--backedges", action="store_true")
    ap.add_argument("--reducible", action="store_true")
    ap.add_argument("--dot", action="store_true")
    args = ap.parse_args()

    prog = json.load(sys.stdin)
    cfgs = build_cfgs(prog)

    for fname in sorted(cfgs.keys()):
        entry, adj = cfgs[fname]
        if args.dot:
            print_dot(fname, entry, adj)
            continue

        print_adj(fname, entry, adj)
        if args.paths:
            d = get_path_lengths(adj, entry)
            ordered = " ".join(f"{n}:{d[n]}" for n in sorted(d))
            print(f"{fname} paths: {ordered}\n")
        if args.rpo:
            rpo = reverse_postorder(adj, entry)
            print(f"{fname} rpo: {' '.join(rpo)}\n")
        if args.backedges:
            bes = find_back_edges(adj, entry)
            if bes:
                for u, v in bes:
                    print(f"{fname} backedge: {u}->{v}")
            else:
                print(f"{fname} backedge: (none)")
            print()
        if args.reducible:
            print(f"{fname} reducible: {is_reducible(adj, entry)}\n")

if __name__ == "__main__":
    main()
