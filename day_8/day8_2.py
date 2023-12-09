import numpy as np
from math import lcm

# in_fi = './example8_2.txt'
in_fi = './input8_2.txt'

d_directions = {'L': 0, 'R': 1}

with open(in_fi) as f:
    lines = f.readlines()
lines = [line.rstrip() for line in lines]
directions = [d_directions[i] for i in lines[0]]
nodes = {line.split(" = ")[0]:line.split(" = ")[1] for line in lines[2:]}
nodes = {k:nodes[k].lstrip('(').rstrip(')').split(', ') for k in nodes.keys()}

start_nodes = [node for node in nodes.keys() if node.endswith('A')]
end_nodes = [node for node in nodes.keys() if node.endswith('Z')]

# Follow a starting point until a cycle is detected, return the path that was followed
# A node is defined by its name (label), direction (left/right) and the current position in the directions sequence
def traceCyclicPath(start_node, nodes, directions):
    visited_states = {(node_name, node_direction, idx_direction):False for node_direction in [0,1] for node_name in nodes.keys() for idx_direction in range(len(directions))}
    path = []
    curr_node, curr_direction, curr_idx = start_node, directions[0], 0
    while not visited_states[(curr_node, curr_direction, curr_idx)]:
        visited_states[(curr_node, curr_direction, curr_idx)] = True
        path.append((curr_node, curr_direction, curr_idx))
        curr_node = nodes[curr_node][curr_direction]
        curr_idx = len(path) % len(directions)
        curr_direction = directions[curr_idx]
    path.append((curr_node, curr_direction, curr_idx))

    len_tail = path.index(path[-1]) #length before entering the cycle
    len_cycle = len(path) - path.index(path[-1]) -1 # length between first occurence of cycle entry point and end of cycle
    return path, len_tail, len_cycle

# Return the times at which a path goes through an end node
def times_pathThroughEndNode(path):
    nodes = [ii for ii, tup in enumerate(path) if tup[0].endswith('Z')]
    return nodes


# Every cyclic path goes through an end node exactly once and this node is the first node after beginning of the cycle
endpoints = []
tails = []
cycles = []
for start in start_nodes:
    path, len_tail, len_cycle = traceCyclicPath(start, nodes, directions)
    endpoint_times = times_pathThroughEndNode(path)
    print("{}  - endpoint time: {} - len cycle: {} - len tail: {}".format(start, endpoint_times, len_cycle, len_tail))
    endpoints.append(endpoint_times[0])
    tails.append(len_tail)
    cycles.append(len_cycle)
endpoints = np.array(endpoints)
tails = np.array(tails)
cycles = np.array(cycles)

out = lcm(*list(cycles))
print(out)
