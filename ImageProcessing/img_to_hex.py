import argparse
import sys
from PIL import Image

def convert_image_to_hex(input_path, output_path, resize_w=None, resize_h=None):
    try:
        # 1. Mở ảnh và chuyển sang hệ màu RGB
        img = Image.open(input_path).convert('RGB')
        
        # 2. Resize nếu có yêu cầu (Quan trọng để giảm thời gian mô phỏng)
        if resize_w and resize_h:
            img = img.resize((resize_w, resize_h), Image.Resampling.LANCZOS)
            print(f"-> Đã resize ảnh về: {resize_w}x{resize_h}")
        
        width, height = img.size
        pixels = list(img.getdata())
        
        print(f"-> Kích thước ảnh xử lý: {width} (Rộng) x {height} (Cao)")
        print(f"-> Tổng số pixel: {len(pixels)}")
        
        # 3. Ghi ra file Hex
        # Định dạng mỗi dòng: RR GG BB (Ví dụ: FF A0 05)
        with open(output_path, 'w') as f:
            for r, g, b in pixels:
                # {:02x} nghĩa là format sang Hex 2 chữ số (0-255 -> 00-FF)
                f.write(f"{r:02x} {g:02x} {b:02x}\n")
                
        print(f"-> Đã ghi thành công dữ liệu Hex vào file: {output_path}")
        print("-" * 30)
        print("THÔNG TIN CẤU HÌNH CHO VERILOG:")
        print(f"TOTAL_PIXELS = {width * height}")
        print("-" * 30)

    except FileNotFoundError:
        print(f"LỖI: Không tìm thấy file ảnh tại '{input_path}'")
        sys.exit(1)
    except Exception as e:
        print(f"LỖI KHÔNG XÁC ĐỊNH: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Cấu hình bộ đọc tham số dòng lệnh
    parser = argparse.ArgumentParser(description="Tool chuyển ảnh sang Hex cho Verilog")
    
    # Các tham số bắt buộc và tùy chọn
    parser.add_argument("-i", "--input", required=True, help="Đường dẫn ảnh đầu vào (.jpg, .png)")
    parser.add_argument("-o", "--output", required=True, help="Đường dẫn file text đầu ra (.txt, .hex)")
    parser.add_argument("--width", type=int, help="Chiều rộng muốn resize (Option)", default=None)
    parser.add_argument("--height", type=int, help="Chiều cao muốn resize (Option)", default=None)

    args = parser.parse_args()

    # Kiểm tra logic resize (phải có cả 2 hoặc không có cái nào)
    if (args.width and not args.height) or (not args.width and args.height):
        print("Lỗi: Nếu resize, phải cung cấp cả --width và --height")
        sys.exit(1)

    # Chạy hàm chuyển đổi
    convert_image_to_hex(args.input, args.output, args.width, args.height)