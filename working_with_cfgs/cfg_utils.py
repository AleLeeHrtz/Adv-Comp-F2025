#!/usr/bin/env python3
from collections import deque, defaultdict
from typing import Dict, List, Set, Tuple

CFG = Dict[str, List[str]]

def reachable(cfg: CFG, entry: str) -> Set[str]:
    vis: Set[str] = set()
    q = deque([entry])
    while q:
        u = q.popleft()
        if u in vis:
            continue
        vis.add(u)
        for v in cfg.get(u, []):
            if v not in vis:
                q.append(v)
    return vis

def preds(cfg: CFG) -> Dict[str, List[str]]:
    pr: Dict[str, List[str]] = defaultdict(list)
    for u, succs in cfg.items():
        for v in succs:
            pr[v].append(u)
    for u in cfg.keys():
        pr.setdefault(u, pr.get(u, []))
    return pr

def get_path_lengths(cfg: CFG, entry: str) -> Dict[str, int]:
    dist: Dict[str, int] = {}
    q = deque([entry])
    dist[entry] = 0
    while q:
        u = q.popleft()
        for v in cfg.get(u, []):
            if v not in dist:
                dist[v] = dist[u] + 1
                q.append(v)
    return dist

def reverse_postorder(cfg: CFG, entry: str) -> List[str]:
    vis: Set[str] = set()
    post: List[str] = []
    def dfs(u: str):
        vis.add(u)
        for v in cfg.get(u, []):
            if v not in vis:
                dfs(v)
        post.append(u)
    dfs(entry)
    return list(reversed(post))

def find_back_edges(cfg: CFG, entry: str) -> List[Tuple[str, str]]:
    WHITE, GRAY, BLACK = 0, 1, 2
    color: Dict[str, int] = {}
    back: List[Tuple[str, str]] = []

    def dfs(u: str):
        color[u] = GRAY
        for v in cfg.get(u, []):
            c = color.get(v, WHITE)
            if c == WHITE:
                dfs(v)
            elif c == GRAY:
                back.append((u, v))
        color[u] = BLACK

    dfs(entry)
    return back

def dominators(cfg: CFG, entry: str):
    reach = reachable(cfg, entry)
    pr = preds(cfg)

    dom = {}
    for n in reach:
        if n == entry:
            dom[n] = {entry}
        else:
            dom[n] = set(reach)

    changed = True
    while changed:
        changed = False
        for n in reach:
            if n == entry: 
                continue
            pred_sets = [dom[p] for p in pr.get(n, []) if p in reach]
            new = set.intersection(*pred_sets) if pred_sets else set()
            new.add(n)
            if new != dom[n]:
                dom[n] = new
                changed = True
    return dom

def is_reducible(cfg: CFG, entry: str) -> bool:
    back = find_back_edges(cfg, entry)
    dom = dominators(cfg, entry)
    for u, v in back:
        if v not in dom.get(u, set()):
            return False
    return True
