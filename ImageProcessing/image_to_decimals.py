import cv2
import numpy as np

# Read image in Greyscale
img = cv2.imread('baitap1_anhgoc.jpg', cv2.IMREAD_GRAYSCALE)

# Save to text file (hex or decimal)
with open('pic_input.txt', 'w') as f:
    for row in img:
        for pixel in row:
            f.write(f"{pixel}\n")