USE TutorSS;
GO

-- =============================================================
-- 1. CẬP NHẬT CẤU TRÚC BẢNG (Chạy 1 lần cho chắc)
-- =============================================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[lop_hoc]') AND name = 'thoi_gian_nhan_lop')
BEGIN
    ALTER TABLE [lop_hoc] ADD [thoi_gian_nhan_lop] DATETIME;
END
GO

-- =============================================================
-- 2. TẠO HÀM BÁO CÁO (Logic Doanh Thu "Tiền Trao Cháo Múc")
-- =============================================================
IF OBJECT_ID('dbo.fn_ThongKeHieuQuaGiaSu', 'TF') IS NOT NULL
    DROP FUNCTION dbo.fn_ThongKeHieuQuaGiaSu;
GO

CREATE FUNCTION dbo.fn_ThongKeHieuQuaGiaSu
(
    @gia_su_id INT,
    @thang_bao_cao INT,
    @nam_bao_cao INT
)
RETURNS @KetQua TABLE
(
    thang INT, nam INT,
    gia_su_id INT, ho_ten NVARCHAR(100),

    so_lop_dang_day INT,          -- KPI 1: Số lớp MỚI NHẬN trong tháng
    tong_hoc_vien INT,            -- KPI 1: Tổng học viên của các lớp mới nhận

    hop_dong_hieu_luc INT,        -- KPI 2: Số hợp đồng đang hiệu lực (Overlap)

    doanh_thu_du_kien DECIMAL(18,0), -- KPI 3: Lương nhận được (Của các lớp KẾT THÚC trong tháng)

    diem_chat_luong DECIMAL(4,2),    -- KPI 4: Điểm chất lượng
    xep_hang NVARCHAR(20), nhan_xet NVARCHAR(500)
)
AS
BEGIN
    -- 1. VALIDATION
    IF @gia_su_id IS NULL OR NOT EXISTS (SELECT 1 FROM gia_su WHERE gia_su_id = @gia_su_id) RETURN;
    IF @thang_bao_cao < 1 OR @thang_bao_cao > 12 RETURN;

    -- 2. KHỞI TẠO 3 THÁNG
    DECLARE @BaseDate DATE = DATEFROMPARTS(@nam_bao_cao, @thang_bao_cao, 1);
    DECLARE @TimeList TABLE (thang INT, nam INT, stt INT);
    INSERT INTO @TimeList VALUES (MONTH(DATEADD(MONTH, -1, @BaseDate)), YEAR(DATEADD(MONTH, -1, @BaseDate)), 1);
    INSERT INTO @TimeList VALUES (MONTH(@BaseDate), YEAR(@BaseDate), 2);
    INSERT INTO @TimeList VALUES (MONTH(DATEADD(MONTH, 1, @BaseDate)), YEAR(DATEADD(MONTH, 1, @BaseDate)), 3);

    DECLARE @ho_ten NVARCHAR(100);
    SELECT @ho_ten = ho_ten FROM gia_su WHERE gia_su_id = @gia_su_id;

    DECLARE @cur_thang INT, @cur_nam INT;
    DECLARE @MonthStart DATE, @MonthEnd DATE;

    -- Các biến tính toán
    DECLARE @hop_dong_hieu_luc INT;
    DECLARE @so_lop_dang_day INT, @tong_hoc_vien INT;
    DECLARE @diem_chat_luong DECIMAL(4,2);
    DECLARE @doanh_thu_du_kien DECIMAL(18,0);
    DECLARE @xep_hang NVARCHAR(20), @nhan_xet NVARCHAR(500);

    DECLARE cur_thoi_gian CURSOR FOR SELECT thang, nam FROM @TimeList ORDER BY stt ASC;
    OPEN cur_thoi_gian;
    FETCH NEXT FROM cur_thoi_gian INTO @cur_thang, @cur_nam;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- A. XÁC ĐỊNH PHẠM VI THÁNG
        SET @MonthStart = DATEFROMPARTS(@cur_nam, @cur_thang, 1);
        SET @MonthEnd = EOMONTH(@MonthStart);

        -- *** QUAN TRỌNG: RESET BIẾN VỀ 0 ĐẦU MỖI THÁNG ***
        -- Đảm bảo không cộng dồn doanh thu từ tháng trước sang tháng sau
        SET @so_lop_dang_day = 0;
        SET @tong_hoc_vien = 0;
        SET @hop_dong_hieu_luc = 0;
        SET @doanh_thu_du_kien = 0;
        SET @diem_chat_luong = NULL;

        -- B. KPI 1: SỐ LỚP MỚI (New Starts)
        -- Logic: Đếm lớp có Ngày Nhận Lớp nằm TRONG tháng báo cáo
        SELECT
            @so_lop_dang_day = COUNT(DISTINCT lh.lop_hoc_id),
            @tong_hoc_vien = COUNT(tg.hoc_vien_id)
        FROM lop_hoc lh
        LEFT JOIN tham_gia tg ON lh.lop_hoc_id = tg.lop_hoc_id
        WHERE lh.gia_su_id = @gia_su_id
          AND lh.thoi_gian_nhan_lop IS NOT NULL
          AND lh.thoi_gian_nhan_lop >= @MonthStart
          AND lh.thoi_gian_nhan_lop <= @MonthEnd;

        -- C. KPI 2: HỢP ĐỒNG (Active Contracts)
        -- Logic: Đếm hợp đồng còn hiệu lực (Giao nhau với tháng báo cáo)
        SELECT @hop_dong_hieu_luc = COUNT(*)
        FROM hop_dong
        WHERE gia_su_id = @gia_su_id
          AND thoi_gian_ky IS NOT NULL
          AND thoi_gian_ky <= @MonthEnd
          AND DATEADD(DAY, 30, thoi_gian_ky) >= @MonthStart;

        -- D. KPI 3: DOANH THU (Completed Classes)
        -- Logic:
        -- 1. Tính ngày kết thúc = Ngày nhận + 30 ngày.
        -- 2. Chỉ cộng lương nếu Ngày kết thúc nằm TRONG tháng báo cáo.
        -- 3. Dùng SUM() để cộng gộp lương nếu có nhiều lớp cùng kết thúc.
        SELECT @doanh_thu_du_kien = ISNULL(SUM(lh.muc_luong), 0)
        FROM lop_hoc lh
        WHERE lh.gia_su_id = @gia_su_id
          AND lh.thoi_gian_nhan_lop IS NOT NULL
          AND DATEADD(DAY, 30, lh.thoi_gian_nhan_lop) >= @MonthStart
          AND DATEADD(DAY, 30, lh.thoi_gian_nhan_lop) <= @MonthEnd;

        -- E. KPI 4: CHẤT LƯỢNG (Quiz Score)
        SELECT @diem_chat_luong = AVG(ls.diem)
        FROM lich_su_lam_bai ls
        JOIN quiz q ON ls.lop_hoc_id = q.lop_hoc_id AND ls.ten_quiz = q.ten_quiz
        JOIN lop_hoc lh ON q.lop_hoc_id = lh.lop_hoc_id
        WHERE lh.gia_su_id = @gia_su_id
          AND ls.thoi_gian_ket_thuc >= @MonthStart
          AND ls.thoi_gian_ket_thuc <= @MonthEnd;

        IF @diem_chat_luong IS NULL SET @diem_chat_luong = 0;

        -- F. XẾP HẠNG
        IF @diem_chat_luong >= 8.0 AND @so_lop_dang_day >= 1
            BEGIN SET @xep_hang = N'Hạng A'; SET @nhan_xet = N'Xuất sắc.'; END
        ELSE IF @diem_chat_luong >= 6.5
            BEGIN SET @xep_hang = N'Hạng B'; SET @nhan_xet = N'Tốt.'; END
        ELSE IF @diem_chat_luong > 0 OR @so_lop_dang_day > 0
            BEGIN SET @xep_hang = N'Hạng C'; SET @nhan_xet = N'Cần cố gắng.'; END
        ELSE
            BEGIN SET @xep_hang = N'---'; SET @nhan_xet = N'Chưa có dữ liệu.'; END

        -- Insert kết quả
        INSERT INTO @KetQua VALUES (
            @cur_thang, @cur_nam,
            @gia_su_id, @ho_ten,
            @so_lop_dang_day, @tong_hoc_vien,
            @hop_dong_hieu_luc,
            @doanh_thu_du_kien,
            @diem_chat_luong,
            @xep_hang, @nhan_xet
        );

        FETCH NEXT FROM cur_thoi_gian INTO @cur_thang, @cur_nam;
    END

    CLOSE cur_thoi_gian;
    DEALLOCATE cur_thoi_gian;
    RETURN;
END;
GO