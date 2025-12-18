import argparse
import sys
import numpy as np
from PIL import Image

def load_txt_to_image(txt_path, width, height, is_hex=True):
    print(f"-> Reading file: {txt_path}...")
    try:
        with open(txt_path, 'r') as f:
            lines = f.readlines()
            
        # Filter empty lines and convert data
        pixels = []
        for line in lines:
            line = line.strip()
            if not line: continue
            
            try:
                # Convert Hex (default) or Decimal based on flag
                val = int(line, 16) if is_hex else int(line)
                pixels.append(val)
            except ValueError:
                continue 

        # Check dimensions
        expected_size = width * height
        if len(pixels) != expected_size:
            print(f"⚠ WARNING: Pixel count ({len(pixels)}) differs from declared size ({width}x{height}={expected_size}).")
            # Handle mismatch by cropping or padding
            if len(pixels) > expected_size:
                pixels = pixels[:expected_size]
            else:
                pixels += [0] * (expected_size - len(pixels))

        # Create Image Array
        img_arr = np.array(pixels, dtype=np.uint8).reshape((height, width))
        return Image.fromarray(img_arr)

    except FileNotFoundError:
        print(f"❌ Error: File {txt_path} not found")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert Hex/Decimal TXT file to BMP Image.")
    
    # Required Arguments
    parser.add_argument("input_txt", help="Path to input text file (e.g., pic_output.txt)")
    parser.add_argument("output_img", help="Path to output image file (e.g., median_result.bmp)")
    parser.add_argument("--width", type=int, required=True, help="Image width")
    parser.add_argument("--height", type=int, required=True, help="Image height")
    
    # Optional Flag for Decimal input
    parser.add_argument("--no-hex", dest="hex", action="store_false", help="Use this flag if input file is DECIMAL")
    parser.set_defaults(hex=True)

    args = parser.parse_args()
    
    # Run Conversion
    img = load_txt_to_image(args.input_txt, args.width, args.height, args.hex)
    if img:
        img.save(args.output_img)
        print(f"✅ Success! Image saved to: {args.output_img}")