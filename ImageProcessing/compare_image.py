import argparse
import math
import sys
import os
import numpy as np
from PIL import Image
from skimage.metrics import structural_similarity as ssim

def calculate_psnr(img1_arr, img2_arr):
    # Mean Squared Error
    mse = np.mean((img1_arr - img2_arr) ** 2)
    if mse == 0:
        return 100 # Perfect match
    PIXEL_MAX = 255.0
    return 20 * math.log10(PIXEL_MAX / math.sqrt(mse))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare two images using PSNR and SSIM metrics.")
    
    parser.add_argument("ref_img", help="Path to the Reference (Original/Clean) image")
    parser.add_argument("test_img", help="Path to the Test (Filtered/Distorted) image")
    parser.add_argument("--resize", action="store_true", help="Force resize Test image to match Reference if dimensions differ")

    args = parser.parse_args()

    # 1. Validate files exist
    if not os.path.exists(args.ref_img) or not os.path.exists(args.test_img):
        print("❌ Error: One or both image files not found.")
        sys.exit(1)

    # 2. Load and convert to Grayscale (L)
    # Comparing color vs grayscale affects metrics, so we normalize to 8-bit grayscale
    i1 = Image.open(args.ref_img).convert('L')
    i2 = Image.open(args.test_img).convert('L')

    # 3. Check Dimensions
    if i1.size != i2.size:
        print(f"⚠ Warning: Dimensions mismatch. Ref:{i1.size} vs Test:{i2.size}")
        if args.resize:
            print(f"-> Resizing Test image to match Reference...")
            i2 = i2.resize(i1.size)
        else:
            print("❌ Error: Images must be same size to compare. Use --resize to force match.")
            sys.exit(1)

    # 4. Calculate Metrics
    arr1 = np.array(i1)
    arr2 = np.array(i2)

    psnr_val = calculate_psnr(arr1, arr2)
    ssim_val = ssim(arr1, arr2, data_range=255)

    # 5. Print Report
    print("="*40)
    print("      IMAGE COMPARISON REPORT")
    print("="*40)
    print(f"Reference Image : {os.path.basename(args.ref_img)}")
    print(f"Test Image      : {os.path.basename(args.test_img)}")
    print("-" * 40)
    print(f"🔰 PSNR : {psnr_val:.4f} dB")
    print(f"🔰 SSIM : {ssim_val:.4f}")
    print("="*40)
    
    if psnr_val > 30:
        print("Result: EXCELLENT Match")
    elif psnr_val > 25:
        print("Result: GOOD Match")
    else:
        print("Result: POOR Match (Significant differences)")