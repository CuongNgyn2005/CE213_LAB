import argparse
import sys
import os
from PIL import Image, ImageFilter

def apply_median_filter(input_path, output_path, kernel_size):
    print(f"-> Processing: {input_path}")
    
    try:
        # 1. Open Image
        if not os.path.exists(input_path):
            print(f"❌ Error: Input file '{input_path}' not found.")
            sys.exit(1)

        with Image.open(input_path) as img:
            # 2. Convert to Grayscale (L)
            # The Verilog module works on 8-bit grayscale, so we must match that.
            gray_img = img.convert('L')
            
            # 3. Apply Median Filter
            # size=3 means a 3x3 window, matching your Verilog design
            print(f"-> Applying Median Filter (Window Size: {kernel_size}x{kernel_size})...")
            filtered_img = gray_img.filter(ImageFilter.MedianFilter(size=kernel_size))
            
            # 4. Save Output
            filtered_img.save(output_path)
            print(f"✅ Success! Filtered image saved to: {output_path}")

    except Exception as e:
        print(f"❌ An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Apply Median Filter to an image (Golden Model).")
    
    # Required Arguments
    parser.add_argument("input_img", help="Path to the input image (e.g., noisy_image.bmp)")
    parser.add_argument("output_img", help="Path to save the result (e.g., golden_output.bmp)")
    
    # Optional Argument for Kernel Size (Default is 3 to match your Verilog)
    parser.add_argument("--size", type=int, default=3, help="Window size for the median filter (default: 3)")

    args = parser.parse_args()
    
    # Run the filter
    apply_median_filter(args.input_img, args.output_img, args.size)