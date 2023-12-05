import re
from collections import OrderedDict

class MapRange:
  def __init__(self, start_destination, start_source, length):
    self.start_destination = start_destination
    self.start_source = start_source
    self.length = length

  def __str__(self):
    return f"Range[{self.start_destination}, {self.start_source}, {self.length}]"
  
  def __repr__(self):
    return self.__str__()

  def get_destinations(self):
    return list(range(self.start_destination, self.start_destination + self.length))
  
  def get_sources(self):
    return list(range(self.start_source, self.start_source + self.length))

  def isin_destinations(self, dest):
    return self.start_destination <= dest < self.start_destination + self.length
  
  def isin_sources(self, source):
    return self.start_source <= source < self.start_source + self.length
  
  def get_destination(self, source):
    if self.isin_sources(source):
      diff = source - self.start_source
      return self.start_destination + diff
    else:
      return None

# tmp = MapRange(50, 98, 2)
# tmp.isin_sources(98)
# tmp.get_destination(100)

in_fi = "./input5_1.txt"
# in_fi = "./example5_1.txt"
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
    l_range = [int(i) for i in item.split(" ")]
    d_all_maps[last_key].append(MapRange(start_destination=l_range[0], start_source=l_range[1], length=l_range[2]))
  else:
    last_key = item.rstrip(" map:")
    d_all_maps[last_key] = []
order_maps = list(d_all_maps.keys())  # Ordered by order of reading


d_out = {}
for seed in seeds:
  soil = [irange.get_destination(seed) for irange in d_all_maps['seed-to-soil']]
  soil = next((dest for dest in soil if dest is not None), seed) # First non None otherwise itself

  current_coord = soil
  for key_map in order_maps[1:]: # skip seed to soil
    new_coord = [irange.get_destination(current_coord) for irange in d_all_maps[key_map]]
    new_coord = next((dest for dest in new_coord if dest is not None), current_coord) # First non None otherwise itself
    current_coord = new_coord

  d_out[str(seed)] = current_coord

out = min(d_out.values())
print(out)
