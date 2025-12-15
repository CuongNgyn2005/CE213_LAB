import sys
import os
from PIL import Image

#!/usr/bin/env python3
"""
bitmap_converter.py

Convert an RGB image into a BMP bitmap file.
- Supports 24-bit color BMP (default).
- Optional 1-bit monochrome BMP with Floyd–Steinberg dithering.

Usage:
    python bitmap_converter.py input_image.jpg output_image.bmp [--mono]

Requires:
    pip install Pillow
"""



def convert_to_bmp_24(input_path: str, output_path: str) -> None:
        """
        Convert any input image to a 24-bit BMP.
        """
        with Image.open(input_path) as img:
                rgb = img.convert("RGB")  # ensure 24-bit RGB
                rgb.save(output_path, format="BMP")


def convert_to_bmp_1bit_mono(input_path: str, output_path: str) -> None:
        """
        Convert any input image to a 1-bit (black/white) BMP using dithering.
        """
        with Image.open(input_path) as img:
                # Convert to 1-bit using Floyd-Steinberg dithering
                mono = img.convert("1")  # Pillow applies dithering by default for "1"
                mono.save(output_path, format="BMP")


def main(argv: list[str]) -> int:
        if len(argv) < 3 or len(argv) > 4:
                print("Usage: python bitmap_converter.py <input> <output.bmp> [--mono]")
                return 2

        input_path = argv[1]
        output_path = argv[2]
        mono = len(argv) == 4 and argv[3] == "--mono"

        if not os.path.isfile(input_path):
                print(f"Input file not found: {input_path}")
                return 1

        out_dir = os.path.dirname(os.path.abspath(output_path))
        if out_dir and not os.path.isdir(out_dir):
                try:
                        os.makedirs(out_dir, exist_ok=True)
                except Exception as e:
                        print(f"Failed to create output directory '{out_dir}': {e}")
                        return 1

        try:
                if mono:
                        convert_to_bmp_1bit_mono(input_path, output_path)
                else:
                        convert_to_bmp_24(input_path, output_path)
        except Exception as e:
                print(f"Conversion failed: {e}")
                return 1

        print(f"Saved BMP to: {output_path}")
        return 0


if __name__ == "__main__":
        sys.exit(main(sys.argv))