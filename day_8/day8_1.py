in_fi = './example8.txt'
# in_fi = './input8_1.txt'

d_directions = {'L': 0, 'R': 1}
start_node = 'AAA'
end_node = 'ZZZ'

with open(in_fi) as f:
    lines = f.readlines()
lines = [line.rstrip() for line in lines]
directions = [d_directions[i] for i in lines[0]]
nodes = {line.split(" = ")[0]:line.split(" = ")[1] for line in lines[2:]}
nodes = {k:nodes[k].lstrip('(').rstrip(')').split(', ') for k in nodes.keys()}

curr_node = 'AAA'
n_steps = 0
while curr_node != 'ZZZ':
    curr_direction = directions[n_steps % len(directions)]
    curr_node = nodes[curr_node][curr_direction]
    n_steps += 1

print(n_steps)