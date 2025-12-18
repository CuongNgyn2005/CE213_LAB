import argparse
import os
import sys
from PIL import Image

def convert_to_txt(input_file, output_file, width=None, height=None):
    try:
        # 1. Validate Input File
        if not os.path.exists(input_file):
            print(f"Error: Input file '{input_file}' not found!")
            sys.exit(1)

        with Image.open(input_file) as img:
            print(f"Processing image: {input_file}")
            
            # 2. Resize Image (If arguments provided)
            if width is not None and height is not None:
                target_size = (width, height)
                img = img.resize(target_size, Image.Resampling.LANCZOS)
                print(f"-> Resized to: {target_size}")
            else:
                print(f"-> Original size: {img.size}")

            # 3. Convert to Grayscale (8-bit)
            gray_img = img.convert('L')
            
            # 4. Get Pixel Data
            pixels = list(gray_img.getdata())
            
            # 5. Write to .txt file
            with open(output_file, 'w') as f:
                # Write raw hex data (no header)
                for pixel in pixels:
                    # Write 2-digit Hex value (e.g., a5, 0f, ff)
                    f.write(f"{pixel:02x}\n")
            
            # 6. Final Report
            current_width, current_height = gray_img.size
            print(f"------------------------------------------------")
            print(f"SUCCESS! Data saved to: {output_file}")
            print(f"Total pixels: {len(pixels)}")
            print(f"Verilog Array Declaration:")
            print(f"Verilog Parameters:")
            print(f"  parameter WIDTH = {current_width};")
            print(f"  parameter HEIGHT = {current_height};")
            print(f"------------------------------------------------")

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # --- ARGUMENT PARSING CONFIGURATION ---
    parser = argparse.ArgumentParser(
        description="Convert an image to a Hex text file for Verilog $readmemh."
    )
    
    # Required Argument: Input Filename
    parser.add_argument("input_file", help="Path to the input image file (e.g., image.bmp)")
    
    # Optional Argument: Output Filename (Default: pic_input.txt)
    parser.add_argument(
        "-o", "--output", 
        default="pic_input.txt",
        help="Path to the output text file (default: pic_input.txt)"
    )
    
    # Optional Arguments: Resize dimensions
    parser.add_argument("--width", type=int, help="Target width to resize image")
    parser.add_argument("--height", type=int, help="Target height to resize image")

    args = parser.parse_args()

    # Run the converter with parsed arguments
    convert_to_txt(args.input_file, args.output, args.width, args.height)