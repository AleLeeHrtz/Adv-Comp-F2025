# Working with CFGs submission

This folder contains:

- 'cfg.py': Bril CFG builder with CLI flags for the requested py functions
- 'cfg_utils.py': library implementing:
  * get_path_lengths(cfg, entry)
  * reverse_postorder(cfg, entry)
  * find_back_edges(cfg, entry)
  * is_reducible(cfg, entry)

- 'tests/': three Bril programs and expected adjacency snapshots.
- 'tests-adv/': same Bril programs with expected adjacency + analyses snapshots.
- 'turnt.toml': runs adjacency-only (keeps original outputs intact).
- 'turnt-adv.toml': runs with '--paths --rpo --backedges --reducible'.

Usage:

Adjacency only:

bril2json < tests/loop.bril | python3 cfg.py


Adjacency + functions:


bril2json < tests/loop.bril | python3 cfg.py --paths --rpo --backedges --reducible


Run tests with Turnt:

Adjacency tests:

turnt -c turnt.toml tests/*.bril


Advanced suite (including functions):

turnt -c turnt-adv.toml tests-adv/*.bril


