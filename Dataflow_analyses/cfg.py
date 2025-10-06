def block_map(blocks):
    block_dict = {}
    
    for i, block in enumerate(blocks):
        # Find label
        block_name = None
        if block and 'label' in block[0]:
            block_name = block[0]['label']
        # Default
        else:
            if i == 0:
                block_name = 'entry'
            else:
                block_name = f'block_{i}'
        
        block_dict[block_name] = block
    
    return block_dict

def add_terminators(blocks):
    block_names = list(blocks.keys())
    
    for i, (block_name, block) in enumerate(blocks.items()):
        if not block:
            continue
            
        last_instr = block[-1]
        
        # Check if terminator
        has_terminator = ('op' in last_instr and 
                         last_instr['op'] in ['jmp', 'br', 'ret'])
        
        # Default
        if not has_terminator and i < len(block_names) - 1:
            next_block = block_names[i + 1]
            block.append({
                'op': 'jmp',
                'labels': [next_block]
            })

def edges(blocks):
    predecessors = {name: [] for name in blocks}
    successors = {name: [] for name in blocks}
    
    block_names = list(blocks.keys())
    
    for i, (block_name, block) in enumerate(blocks.items()):
        if not block:
            continue
            
        last_instr = block[-1]
        
        if 'op' in last_instr:
            if last_instr['op'] == 'jmp':
                # Unconditional jump
                if 'labels' in last_instr:
                    target = last_instr['labels'][0]
                    successors[block_name].append(target)
                    predecessors[target].append(block_name)
            
            elif last_instr['op'] == 'br':
                # Conditional branch
                if 'labels' in last_instr and len(last_instr['labels']) >= 2:
                    true_target = last_instr['labels'][0]
                    false_target = last_instr['labels'][1]
                    
                    successors[block_name].extend([true_target, false_target])
                    predecessors[true_target].append(block_name)
                    predecessors[false_target].append(block_name)
            
            elif last_instr['op'] == 'ret':
                # No successors for return
                pass
            
            else:
                # Fall through to next block
                if i < len(block_names) - 1:
                    next_block = block_names[i + 1]
                    successors[block_name].append(next_block)
                    predecessors[next_block].append(block_name)
        
        else:
            # No explicit terminator, fall through
            if i < len(block_names) - 1:
                next_block = block_names[i + 1]
                successors[block_name].append(next_block)
                predecessors[next_block].append(block_name)
    
    return predecessors, successors
