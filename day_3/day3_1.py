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
l_symbols = list(set(np.unique(img)) - set(l_digits + ["."]))

# Define a mask for numbers, detect horizontal blobs to agglomerate the full numbers
mask_numbers = np.isin(img, l_digits)
horiz_filter = np.array([[0,0,0],[1,1,1],[0,0,0]])
blob_numbers = label(mask_numbers, structure=horiz_filter)[0]

# Define a mask for symbol, extract coordinates
mask_symbols = np.isin(img, l_symbols)
full_filter =np.array([[1,1,1],[1,1,1],[1,1,1]])
blob_symbols = label(mask_symbols, structure=full_filter)[0]
n_symbol_blobs = len(np.unique(blob_symbols))

# For each number blob, check if within range of a symbol - Generate a new mask per number by summing its coordinates and symbols mask, try to connect with scipy label, check if the number of symbol blobs changed
# Numbers can be repeated so loop through labels and reassign number later
is_connected = []
for label_number in set(np.unique(blob_numbers)) - set([0]):
  tmp_mask = np.copy(mask_symbols)
  pos_label = np.where(blob_numbers==label_number)
  tmp_mask[pos_label] = True

  tmp_blob_number = label(tmp_mask, structure=full_filter)[0]
  tmp_n_symbol_blobs = len(np.unique(tmp_blob_number))
  if tmp_n_symbol_blobs <= n_symbol_blobs:
    number = img[pos_label]
    number = int(''.join(number))
    is_connected.append(number)

out = [int(ii) for ii in is_connected]
out = sum(out)
print(out)
