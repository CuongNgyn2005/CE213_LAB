import cv2
import numpy as np
def median_filter(image, filter_size):
   # Get image dimensions
   m, n = image.shape
   # Create an empty output image
   filtered_image = np.zeros((m, n), dtype=np.uint8)
   # Define the offset based on filter size
   offset = filter_size // 2
   # Apply the median filter
   for i in range(offset, m - offset):
       for j in range(offset, n - offset):
           # Extract the neighborhood
           neighborhood = []
           for k in range(-offset, offset + 1):
               for l in range(-offset, offset + 1):
                   neighborhood.append(image[i + k, j + l])
           # Compute the median and assign it to the pixel
           filtered_image[i, j] = np.median(neighborhood)
   return filtered_image
# Example usage
if __name__ == "__main__":
   # Read a noisy image (grayscale)
   noisy_image = cv2.imread('baitap1_anhgoc.jpg', 0)
   # Apply a 3x3 median filter
   result = median_filter(noisy_image, 3)
   # Save or display the result
   cv2.imwrite('median_filtered.jpg', result)