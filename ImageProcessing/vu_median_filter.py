import os

# --- CẤU HÌNH (Theo tb_median_filter.v) ---
WIDTH = 430
HEIGHT = 554
INPUT_FILE = "input.hex"
OUTPUT_FILE = "output.txt"

# Hàm hỗ trợ đọc file Hex (tương tự $readmemh)
def load_hex_image(filepath):
    try:
        with open(filepath, 'r') as f:
            # Đọc toàn bộ nội dung, tách theo khoảng trắng/xuống dòng
            content = f.read().split()
            # Chuyển từ hex string sang integer
            data = [int(x, 16) for x in content]
        return data
    except FileNotFoundError:
        print(f"Lỗi: Không tìm thấy file {filepath}")
        return []

# --- HÀM MÔ PHỎNG LOGIC VERILOG (median_filter.v) ---

# Tương ứng với function sort3_func trong Verilog
# Input: 3 số. Output: (Min, Med, Max)
def sort3(a, b, c):
    # Verilog dùng 3 lệnh compare-swap để sắp xếp
    # Trong Python ta dùng sort() để đạt kết quả tương đương
    arr = [a, b, c]
    arr.sort() 
    # Python list.sort() xếp tăng dần: [0]=min, [1]=med, [2]=max
    # Verilog trả về {Max, Med, Min}, ta map tương ứng bên dưới
    return arr[0], arr[1], arr[2] # (min, med, max)

def calculate_median_pixel(p1, p2, p3, p4, p5, p6, p7, p8, p9):
    # --- STAGE 1: Sort each row independently ---
    # Verilog: {r1_max, r1_med, r1_min} <= sort3_func(p1, p2, p3);
    r1_min, r1_med, r1_max = sort3(p1, p2, p3)
    r2_min, r2_med, r2_max = sort3(p4, p5, p6)
    r3_min, r3_med, r3_max = sort3(p7, p8, p9)

    # --- STAGE 2: Calculate 3 final candidates ---
    
    # 1. Median of the Row Medians (cand1)
    # Verilog: {t3, cand1, t1} <= sort3_func(r1_med, r2_med, r3_med);
    # Lấy phần tử ở giữa (index 1)
    _, cand1, _ = sort3(r1_med, r2_med, r3_med)

    # 2. Max of the Row Mins (cand2)
    # Verilog: Logic if/else tìm max của (r1_min, r2_min, r3_min)
    cand2 = max(r1_min, r2_min, r3_min)

    # 3. Min of the Row Maxs (cand3)
    # Verilog: Logic if/else tìm min của (r1_max, r2_max, r3_max)
    cand3 = min(r1_max, r2_max, r3_max)

    # --- STAGE 3: Final Sort to find the Median ---
    # Verilog: {t3, median_out, t1} <= sort3_func(cand1, cand2, cand3);
    # Lấy phần tử ở giữa (index 1)
    _, median_out, _ = sort3(cand1, cand2, cand3)

    return median_out

# --- CHƯƠNG TRÌNH CHÍNH (Tương ứng tb_median_filter.v) ---
def main():
    print("Đang đọc dữ liệu đầu vào...")
    img_mem = load_hex_image(INPUT_FILE)
    
    if len(img_mem) != WIDTH * HEIGHT:
        print(f"Cảnh báo: Kích thước file đầu vào ({len(img_mem)}) không khớp với WIDTH*HEIGHT ({WIDTH*HEIGHT})")
        # Vẫn tiếp tục xử lý nếu dữ liệu đủ dùng hoặc dư
        if len(img_mem) < WIDTH * HEIGHT:
            return

    output_data = []

    print("Đang xử lý thuật toán Median Filter...")
    
    # Iterate over image (Loop y, x)
    for y in range(HEIGHT):
        for x in range(WIDTH):
            idx = y * WIDTH + x
            
            # --- CASE 1: BORDERS (Copy directly) ---
            # Verilog : if (x == 0 || x == WIDTH-1 || y == 0 || y == HEIGHT-1)
            if x == 0 or x == WIDTH - 1 or y == 0 or y == HEIGHT - 1:
                pixel_out = img_mem[idx]
            
            # --- CASE 2: ACTIVE PIXELS (Process) ---
            else:
                # Setup 3x3 Window inputs
                # Verilog 
                p1 = img_mem[(y-1)*WIDTH + (x-1)]
                p2 = img_mem[(y-1)*WIDTH + (x  )]
                p3 = img_mem[(y-1)*WIDTH + (x+1)]
                
                p4 = img_mem[(y  )*WIDTH + (x-1)]
                p5 = img_mem[(y  )*WIDTH + (x  )]
                p6 = img_mem[(y  )*WIDTH + (x+1)]
                
                p7 = img_mem[(y+1)*WIDTH + (x-1)]
                p8 = img_mem[(y+1)*WIDTH + (x  )]
                p9 = img_mem[(y+1)*WIDTH + (x+1)]

                # Gọi hàm tính toán mô phỏng Module median_filter
                pixel_out = calculate_median_pixel(p1, p2, p3, p4, p5, p6, p7, p8, p9)

            output_data.append(pixel_out)

    # Ghi ra file output.txt
    print(f"Đang ghi kết quả ra {OUTPUT_FILE}...")
    with open(OUTPUT_FILE, 'w') as f:
        for val in output_data:
            # Verilog : $fwrite(file_write, "%2h\n", out_pixel);
            # Format hex 2 ký tự (ví dụ: 0f, a1)
            f.write(f"{val:02x}\n")

    print("Hoàn tất!")

if __name__ == "__main__":
    main()