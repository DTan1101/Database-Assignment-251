-- HÀM 1: THỐNG KÊ HIỆU QUẢ GIA SƯ
-- Mục đích: Đánh giá hiệu suất gia sư dựa trên nhiều chỉ số
-- Sử dụng: Cursor, IF/CASE, JOIN, Aggregate functions
USE TutorSS;
GO

IF OBJECT_ID('dbo.fn_ThongKeHieuQuaGiaSu', 'TF') IS NOT NULL
    DROP FUNCTION dbo.fn_ThongKeHieuQuaGiaSu;
GO

CREATE FUNCTION dbo.fn_ThongKeHieuQuaGiaSu
(
    @gia_su_id INT,
    @thang INT,
    @nam INT
)
RETURNS @KetQua TABLE
(
    gia_su_id INT,
    ho_ten NVARCHAR(100),
    so_lop_dang_day INT,        -- Số lớp đang active
    tong_hoc_vien INT,          -- Tổng số học viên phục vụ
    diem_chat_luong DECIMAL(4,2), -- Điểm trung bình riêng tháng này
    so_hop_dong_moi INT,        -- Số hợp đồng ký mới trong tháng
    doanh_thu_du_kien DECIMAL(18,0), -- Tổng lương dự kiến từ các lớp
    xep_hang NVARCHAR(20),
    nhan_xet NVARCHAR(500)
)
AS
BEGIN
    -- 1. KIỂM TRA ĐẦU VÀO (VALIDATION)
    IF @gia_su_id IS NULL OR NOT EXISTS (SELECT 1 FROM gia_su WHERE gia_su_id = @gia_su_id) RETURN;
    IF @thang < 1 OR @thang > 12 RETURN;
    IF @nam < 2000 OR @nam > YEAR(GETDATE()) + 1 RETURN;

    -- 2. KHAI BÁO BIẾN
    DECLARE @ho_ten NVARCHAR(100);
    DECLARE @so_hop_dong_moi INT = 0;
    DECLARE @so_lop_dang_day INT = 0;
    DECLARE @tong_hoc_vien INT = 0;
    DECLARE @diem_chat_luong DECIMAL(4,2) = 0;
    DECLARE @doanh_thu_du_kien DECIMAL(18,0) = 0;
    DECLARE @xep_hang NVARCHAR(20);
    DECLARE @nhan_xet NVARCHAR(500);

    -- Lấy tên gia sư
    SELECT @ho_ten = ho_ten FROM gia_su WHERE gia_su_id = @gia_su_id;

    -- 3. TÍNH CÁC CHỈ SỐ CƠ BẢN (Set-based queries cho hiệu suất cao)
    
    -- Đếm hợp đồng mới ký TRONG THÁNG (KPI Sales)
    SELECT @so_hop_dong_moi = COUNT(*) 
    FROM hop_dong 
    WHERE gia_su_id = @gia_su_id 
      AND MONTH(thoi_gian_ky) = @thang 
      AND YEAR(thoi_gian_ky) = @nam;

    -- Tính điểm trung bình của Quiz kết thúc TRONG THÁNG (KPI Chất lượng)
    SELECT @diem_chat_luong = AVG(ls.diem)
    FROM lich_su_lam_bai ls
    JOIN quiz q ON ls.lop_hoc_id = q.lop_hoc_id AND ls.ten_quiz = q.ten_quiz
    JOIN lop_hoc lh ON q.lop_hoc_id = lh.lop_hoc_id
    WHERE lh.gia_su_id = @gia_su_id
      AND MONTH(ls.thoi_gian_ket_thuc) = @thang
      AND YEAR(ls.thoi_gian_ket_thuc) = @nam;
    
    -- Nếu tháng này không có bài kiểm tra nào, lấy điểm trung bình tích lũy
    IF @diem_chat_luong IS NULL
    BEGIN
        SELECT @diem_chat_luong = AVG(ls.diem)
        FROM lich_su_lam_bai ls
        JOIN tham_gia tg ON ls.hoc_vien_id = tg.hoc_vien_id
        JOIN lop_hoc lh ON tg.lop_hoc_id = lh.lop_hoc_id
        WHERE lh.gia_su_id = @gia_su_id;
        
        SET @diem_chat_luong = ISNULL(@diem_chat_luong, 0); -- Vẫn null thì cho bằng 0
    END

    -- 4. SỬ DỤNG CURSOR ĐỂ DUYỆT LỚP (KPI Khối lượng công việc & Doanh thu)
    -- Logic: Duyệt từng lớp đang dạy để cộng dồn lương và đếm học viên
    DECLARE @lop_id INT;
    DECLARE @muc_luong DECIMAL(18,0);
    DECLARE @hoc_vien_trong_lop INT;

    DECLARE cur_lop CURSOR FOR
        SELECT lop_hoc_id, muc_luong
        FROM lop_hoc
        WHERE gia_su_id = @gia_su_id 
          AND trang_thai_giao = N'Đã giao'; -- Chỉ tính lớp đang dạy

    OPEN cur_lop;
    FETCH NEXT FROM cur_lop INTO @lop_id, @muc_luong;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tăng số lớp
        SET @so_lop_dang_day = @so_lop_dang_day + 1;

        -- Cộng dồn doanh thu dự kiến (Lương lớp này)
        SET @doanh_thu_du_kien = @doanh_thu_du_kien + ISNULL(@muc_luong, 0);

        -- Đếm học viên của lớp này (Logic Loop phục vụ tính toán chi tiết)
        SELECT @hoc_vien_trong_lop = COUNT(*) 
        FROM tham_gia 
        WHERE lop_hoc_id = @lop_id;

        SET @tong_hoc_vien = @tong_hoc_vien + @hoc_vien_trong_lop;

        FETCH NEXT FROM cur_lop INTO @lop_id, @muc_luong;
    END

    CLOSE cur_lop;
    DEALLOCATE cur_lop;

    -- 5. LOGIC XẾP HẠNG (Logic đã cải tiến - Fair hơn)
    -- Hạng A: Chất lượng cao VÀ (Nhiều lớp dạy HOẶC Mở rộng được hợp đồng mới)
    IF @diem_chat_luong >= 8.0 AND (@so_lop_dang_day >= 3 OR @so_hop_dong_moi >= 1)
    BEGIN
        SET @xep_hang = N'Hạng A - Xuất Sắc';
        SET @nhan_xet = N'Chất lượng giảng dạy tốt, khối lượng công việc đảm bảo hoặc có phát triển mới.';
    END
    -- Hạng B: Chất lượng khá VÀ Có hoạt động dạy
    ELSE IF @diem_chat_luong >= 6.5 AND @so_lop_dang_day >= 1
    BEGIN
        SET @xep_hang = N'Hạng B - Tốt';
        SET @nhan_xet = N'Hoạt động giảng dạy ổn định, chất lượng đạt yêu cầu.';
    END
    -- Hạng C: Có dạy nhưng điểm thấp hoặc dạy ít
    ELSE IF @so_lop_dang_day >= 1
    BEGIN
        SET @xep_hang = N'Hạng C - Trung Bình';
        SET @nhan_xet = N'Cần cải thiện chất lượng giảng dạy hoặc nhận thêm lớp.';
    END
    -- Hạng D: Không có lớp dạy
    ELSE
    BEGIN
        SET @xep_hang = N'Hạng D - Cần Cải Thiện';
        SET @nhan_xet = N'Gia sư chưa có hoạt động giảng dạy trong thời gian này.';
    END

    -- 6. TRẢ VỀ KẾT QUẢ
    INSERT INTO @KetQua
    VALUES (
        @gia_su_id,
        @ho_ten,
        @so_lop_dang_day,
        @tong_hoc_vien,
        @diem_chat_luong,
        @so_hop_dong_moi,
        @doanh_thu_du_kien,
        @xep_hang,
        @nhan_xet
    );

    RETURN;
END;
GO

-- Test case 1: Gia sư ID 10 (Nguyễn Thị Lan Anh) - Tháng 11/2025
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(10, 11, 2025);

-- Test case 2: Gia sư ID 11 (Trần Minh Hiếu) - Tháng 11/2025
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(11, 11, 2025);

-- Test case 3: Gia sư ID 12 (Lê Thị Thu Hà) - Tháng 11/2025
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(12, 11, 2025);

-- Test case 4: Gia sư ID 13 (Phạm Văn Long) - Tháng 11/2025
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(13, 11, 2025);


-- Test case 5: Gia sư ID 14 (Hoàng Thị Mai) - Tháng 11/2025
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(14, 11, 2025);

-- Test case 6: Tham số không hợp lệ (ID = -1) -> Bảng rỗng
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(-1, 11, 2025);


-- Test case 7: Tháng không hợp lệ -> Bảng rỗng
SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(10, 13, 2025);




