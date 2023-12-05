import re
import pandas as pd
import numpy as np
from collections import OrderedDict
from functools import reduce

in_fi = "./day_5/input5_1.txt"
# in_fi = "./day_5/example5_1.txt"
with open(in_fi) as f:
  lines = f.readlines()
lines = [line.strip("\n") for line in lines]

# Read seeds
seeds = lines.pop(0).lstrip("seeds: ")
seeds = seeds.split(" ")
seeds = [int(i) for i in seeds]

# Read in the maps
d_all_maps = OrderedDict()
last_key = ""
for item in lines:
  if item == "":
    continue
  elif re.search("\d", item) is not None:
    d_all_maps[last_key].append([int(i) for i in item.split(" ")])
  else:
    last_key = item.rstrip(" map:")
    d_all_maps[last_key] = []
order_maps = list(d_all_maps.keys())  # Ordered by order of reading

# Format the maps into dataframes/arrays with source-destination ranges
for key_map in order_maps:
  key_source, key_dest = key_map.split("-to-")
  l_df = []
  for val_map in d_all_maps[key_map]:
    start_dest, start_source, length = val_map
    d_map = {
      "source": np.arange(start_source, start_source + length),
      "dest": np.arange(start_dest, start_dest + length)
    }
    df_map = pd.DataFrame.from_dict(d_map)
    l_df.append(df_map)
  d_all_maps[key_map] = pd.concat(l_df)

def reduceMerge(x,y):
  out = pd.merge(x, y, left_on="dest", right_on="source", how="left")
  # Numbers that were not mapped are mapped on themselves
  out.loc[pd.isna(out.source_y), "dest_y"] = out.loc[pd.isna(out.source_y), "dest_x"]
  out = out.drop(["source_x", "dest_x"], axis = 1)
  out.columns = ["source", "dest"]
  # Left Merge is turning into float
  out.dest = out.dest.astype(int)
  return out
  
# out= pd.merge(d_all_maps[order_maps[0]], d_all_maps[order_maps[1]], left_on="dest", right_on="source", how="left")
l_out = {}
for seed in seeds:
  if seed in list(d_all_maps[order_maps[0]].source):
    df_seed = d_all_maps[order_maps[0]].loc[d_all_maps[order_maps[0]].source == seed]
  else:
    df_seed = pd.DataFrame({"source": [seed], "dest": [seed]})
  seed_to_location = reduce(reduceMerge, [df_seed] + [d_all_maps[k] for k in order_maps[1:]])
  l_out[str(seed)] = int(seed_to_location.dest)

out = min(l_out.values())
print(out)
