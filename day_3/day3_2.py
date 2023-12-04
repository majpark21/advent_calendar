from scipy.ndimage import label, find_objects
import numpy as np

in_fi = "./day_3/input_3_1.txt"
# in_fi = "./day_3/example3_1.txt"

with open(in_fi) as f:
  lines = f.readlines()
lines = [line.strip("\n") for line in lines]
lines = [list(line) for line in lines]
img = np.vstack(lines)

l_digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
l_symbols = ["*"]

# Define a mask for numbers, detect horizontal blobs to agglomerate the full numbers
mask_numbers = np.isin(img, l_digits)
horiz_filter = np.array([[0,0,0],[1,1,1],[0,0,0]])
blob_numbers = label(mask_numbers, structure=horiz_filter)[0]

# Define a mask for symbol, extract coordinates
mask_symbols = np.isin(img, l_symbols)
full_filter =np.array([[1,1,1],[1,1,1],[1,1,1]])
blob_symbols = label(mask_symbols, structure=full_filter)[0]

# For each symbol, check if adjacent to 2 different number labels
l_ratio = []
for label_symbol in set(np.unique(blob_symbols)) - set([0]):
  pos_symbol = np.where(blob_symbols==label_symbol)
  x = int(pos_symbol[0])
  y = int(pos_symbol[1])
  search_area = blob_numbers[(x-1) : (x+2), (y-1) : (y+2)]
  surrounding_blobs = list(np.unique(search_area))
  surrounding_blobs.pop(0)
  # Is a gear
  if len(surrounding_blobs) == 2:
    pos_label_1 = np.where(blob_numbers==surrounding_blobs[0])
    pos_label_2 = np.where(blob_numbers==surrounding_blobs[1])
    number_1 = int(''.join(img[pos_label_1]))
    number_2 = int(''.join(img[pos_label_2]))
    l_ratio.append(number_1 * number_2)

out = sum(l_ratio)
print(out)
