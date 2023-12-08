in_fi = './example8_2.txt'
# in_fi = './input8_1.txt'

d_directions = {'L': 0, 'R': 1}

with open(in_fi) as f:
    lines = f.readlines()
lines = [line.rstrip() for line in lines]
directions = [d_directions[i] for i in lines[0]]
nodes = {line.split(" = ")[0]:line.split(" = ")[1] for line in lines[2:]}
nodes = {k:nodes[k].lstrip('(').rstrip(')').split(', ') for k in nodes.keys()}

start_nodes = [node for node in nodes.keys() if node.endswith('A')]
end_nodes = [node for node in nodes.keys() if node.endswith('Z')]

curr_nodes = start_nodes
n_steps = 0
while not all([node in end_nodes for node in curr_nodes]):
    curr_direction = directions[n_steps % len(directions)]
    curr_nodes = [nodes[node][curr_direction] for node in curr_nodes]
    curr_direction = directions
    n_steps += 1

print(n_steps)


# Cycle: number of operations needed to go back to start position with same direction
def getCycle(start_node, nodes, directions):
    start_direction = directions[0]
    cycle_complete = False
    curr_node = start_node
    n_steps = 0
    while not cycle_complete:
        curr_direction = directions[n_steps % len(directions)]
        curr_node = nodes[curr_node][curr_direction]
        n_steps += 1
        if curr_node==start_node and curr_direction==start_direction:
            cycle_complete=True
        print(n_steps)
    out = {'n_steps_cycle': n_steps}
    return out
