import numpy as np
from PIL import Image
import os
import time
import argparse
import math

# ==========================================
# 1. SETUP PARAMETERS (CẤU HÌNH)
# ==========================================
WIDTH = 430          # Chiều rộng ảnh (theo bài của bạn)
HEIGHT = 554         # Chiều cao ảnh
INPUT_FILE = 'pic_output.txt'      # File txt từ Verilog
OUTPUT_IMAGE = 'median_result.png' # Tên file ảnh kết quả sẽ lưu
REF_IMAGE = 'baitap1_anhgoc.jpg'     # <<< ĐIỀN TÊN FILE ẢNH GỐC (SẠCH) CỦA BẠN VÀO ĐÂY
SHOW_IMAGE = True
NORMALIZE = 'none' 
RESHAPE_ORDER = 'C'
# ==========================================

def calculate_metrics(img_out_path, img_ref_path, width, height):
    """Hàm tính PSNR và SSIM"""
    print(f"\n--- Calculating PSNR & SSIM ---")
    
    # 1. Kiểm tra file ảnh gốc
    if not os.path.exists(img_ref_path):
        print(f"CẢNH BÁO: Không tìm thấy ảnh gốc '{img_ref_path}' để so sánh!")
        print("Vui lòng đặt file ảnh gốc vào cùng thư mục hoặc chỉnh sửa biến REF_IMAGE.")
        return

    # 2. Đọc ảnh và chuyển sang Grayscale (L) -> Numpy array
    try:
        # Ảnh kết quả (Vừa tạo)
        img_out = Image.open(img_out_path).convert('L')
        arr_out = np.array(img_out, dtype=np.float64)

        # Ảnh gốc (Tham chiếu)
        img_ref = Image.open(img_ref_path).convert('L')
        # Resize ảnh gốc nếu kích thước không khớp (phòng ngừa lỗi)
        if img_ref.size != (width, height):
            print(f"Lưu ý: Ảnh gốc có kích thước {img_ref.size}, đang resize về {width}x{height}...")
            img_ref = img_ref.resize((width, height))
        arr_ref = np.array(img_ref, dtype=np.float64)

    except Exception as e:
        print(f"Lỗi khi đọc ảnh để so sánh: {e}")
        return

    # 3. Tính PSNR (Thủ công hoặc dùng thư viện)
    # Công thức: PSNR = 10 * log10(MAX^2 / MSE)
    mse = np.mean((arr_ref - arr_out) ** 2)
    if mse == 0:
        psnr_val = 100 # Ảnh giống hệt nhau
    else:
        max_pixel = 255.0
        psnr_val = 10 * math.log10((max_pixel ** 2) / mse)
    
    print(f" -> MSE (Mean Squared Error): {mse:.2f}")
    print(f" -> PSNR: {psnr_val:.2f} dB")

    # 4. Tính SSIM (Cần thư viện scikit-image)
    try:
        from skimage.metrics import structural_similarity as ssim
        # data_range=255 vì ảnh grayscale 8-bit
        ssim_val = ssim(arr_ref, arr_out, data_range=255)
        print(f" -> SSIM: {ssim_val:.4f}")
    except ImportError:
        print(" -> SSIM: Không tính được (Thiếu thư viện 'scikit-image')")
        print("    Gợi ý: Cài đặt bằng lệnh 'pip install scikit-image'")
        
def txt_to_img(input_file: str = INPUT_FILE,
               output_image: str = OUTPUT_IMAGE,
               width: int = WIDTH,
               height: int = HEIGHT,
               show_image: bool = SHOW_IMAGE,
               normalize: str = NORMALIZE,
               reshape_order: str = RESHAPE_ORDER):
    print(f"Reading {input_file}...")

    if not os.path.exists(input_file):
        print(f"ERROR: {input_file} not found!")
        return

    # --- (GIỮ NGUYÊN PHẦN ĐỌC FILE CŨ CỦA BẠN) ---
    t0 = time.perf_counter()
    try:
        with open(input_file, 'r') as f:
            arr = np.fromiter(
                (int(line) for line in f if line.strip()),
                dtype=np.uint16,
            )
    except ValueError as e:
        print(f"ERROR: File contains non-integer data. {e}")
        return
    
    expected_pixels = width * height
    actual_pixels = arr.size
    
    if actual_pixels != expected_pixels:
        print(f"WARNING: Pixel count mismatch! Read {actual_pixels}, expected {expected_pixels}.")
        if actual_pixels > expected_pixels:
            arr = arr[:expected_pixels]
        else:
            pad = np.zeros(expected_pixels - actual_pixels, dtype=arr.dtype)
            arr = np.concatenate([arr, pad])

    img_array = arr.astype(np.uint8, copy=False)
    try:
        img_matrix = img_array.reshape((height, width), order=reshape_order)
    except ValueError:
        print(f"CRITICAL ERROR: Cannot reshape.")
        return

    # Lưu ảnh
    img = Image.fromarray(img_matrix, 'L')
    img.save(output_image)
    print(f"SUCCESS: Image saved as '{output_image}'")
    
    # === PHẦN MỚI THÊM: GỌI HÀM TÍNH PSNR/SSIM ===
    # Kiểm tra xem người dùng có file ảnh gốc để so sánh không
    calculate_metrics(output_image, REF_IMAGE, width, height)
    # ==============================================

    if show_image:
        img.show()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default=INPUT_FILE)
    parser.add_argument("--output", default=OUTPUT_IMAGE)
    parser.add_argument("--width", type=int, default=WIDTH)
    parser.add_argument("--height", type=int, default=HEIGHT)
    parser.add_argument("--ref", default=REF_IMAGE, help="Path to original clean image for comparison")
    parser.add_argument("--show", action="store_true")
    
    args = parser.parse_args()
    
    # Cập nhật biến toàn cục nếu có tham số dòng lệnh
    if args.ref: REF_IMAGE = args.ref
        
    txt_to_img(args.input, args.output, args.width, args.height, args.show)