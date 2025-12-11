USE TutorSS;
GO
IF OBJECT_ID('dbo.fn_PhanTichTienDoHocVien', 'TF') IS NOT NULL
    DROP FUNCTION dbo.fn_PhanTichTienDoHocVien;
GO

CREATE FUNCTION dbo.fn_PhanTichTienDoHocVien
(
    @hoc_vien_id INT,
    @lop_hoc_id INT
)
RETURNS @KetQua TABLE
(
    hoc_vien_id INT,
    ten_hoc_vien NVARCHAR(100),
    so_bai_da_lam INT,
    so_quiz_bi_lo INT,
    diem_trung_binh DECIMAL(4,2),
    diem_cao_nhat DECIMAL(4,2),
    diem_thap_nhat DECIMAL(4,2),
    xu_huong NVARCHAR(100),
    nhan_xet NVARCHAR(500),
    lich_su_diem NVARCHAR(MAX) -- [NEW] Cột mới chứa chuỗi điểm
)
AS
BEGIN
    -- 1. VALIDATION
    IF NOT EXISTS (SELECT 1 FROM tham_gia WHERE hoc_vien_id = @hoc_vien_id AND lop_hoc_id = @lop_hoc_id)
        RETURN;

    -- 2. KHAI BÁO BIẾN
    DECLARE @ten_hoc_vien NVARCHAR(100);
    DECLARE @count_total_attempts INT = 0;
    DECLARE @count_distinct_quiz_done INT = 0;
    DECLARE @avg_score DECIMAL(4,2) = 0;
    DECLARE @max_score DECIMAL(4,2) = 0;
    DECLARE @min_score DECIMAL(4,2) = 0;

    -- Biến phân tích xu hướng
    DECLARE @curr_score DECIMAL(4,2);
    DECLARE @prev_score DECIMAL(4,2) = NULL;
    DECLARE @trend_score INT = 0;
    DECLARE @consecutive_drop INT = 0;

    -- Biến nhận xét & string điểm
    DECLARE @total_closed_quiz INT = 0;
    DECLARE @missing_quiz INT = 0;
    DECLARE @nhan_xet NVARCHAR(500) = N'';
    DECLARE @str_diem NVARCHAR(MAX) = N''; -- [NEW] Biến lưu chuỗi điểm

    -- Lấy tên học viên
    SELECT @ten_hoc_vien = ho_ten FROM hoc_vien WHERE hoc_vien_id = @hoc_vien_id;

    -- 3. TÍNH TOÁN CÁC CHỈ SỐ AGGREGATE
    SELECT
        @count_total_attempts = COUNT(*),
        @count_distinct_quiz_done = COUNT(DISTINCT ten_quiz),
        @avg_score = ISNULL(AVG(diem), 0),
        @max_score = ISNULL(MAX(diem), 0),
        @min_score = ISNULL(MIN(diem), 0)
    FROM lich_su_lam_bai
    WHERE hoc_vien_id = @hoc_vien_id AND lop_hoc_id = @lop_hoc_id;

    -- [NEW] 3.1. TẠO CHUỖI STRING CHỨA TẤT CẢ ĐIỂM (Sử dụng STRING_AGG)
    -- Logic: Lấy tất cả điểm thuộc lớp học & học viên đó, nối bằng dấu phẩy, sắp xếp theo thời gian
    SELECT @str_diem = STRING_AGG(CAST(diem AS VARCHAR(20)), ', ') WITHIN GROUP (ORDER BY thoi_gian_bat_dau ASC)
    FROM lich_su_lam_bai
    WHERE hoc_vien_id = @hoc_vien_id AND lop_hoc_id = @lop_hoc_id;

    -- Nếu chưa có điểm nào thì để trống hoặc thông báo
    IF @str_diem IS NULL SET @str_diem = N'Chưa có dữ liệu điểm';

    -- 4. TÍNH SỐ QUIZ BỊ BỎ LỠ
    SELECT @total_closed_quiz = COUNT(*)
    FROM quiz
    WHERE lop_hoc_id = @lop_hoc_id AND thoi_gian_dong < GETDATE();

    SET @missing_quiz = @total_closed_quiz - @count_distinct_quiz_done;
    IF @missing_quiz < 0 SET @missing_quiz = 0;

    -- 5. CURSOR: PHÂN TÍCH XU HƯỚNG
    DECLARE cur_progress CURSOR FOR
        SELECT diem
        FROM lich_su_lam_bai
        WHERE hoc_vien_id = @hoc_vien_id AND lop_hoc_id = @lop_hoc_id
        ORDER BY thoi_gian_bat_dau ASC;

    OPEN cur_progress;
    FETCH NEXT FROM cur_progress INTO @curr_score;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @prev_score IS NOT NULL
        BEGIN
            IF @curr_score > @prev_score
            BEGIN
                SET @trend_score = @trend_score + 1;
                SET @consecutive_drop = 0;
            END
            ELSE IF @curr_score < @prev_score
            BEGIN
                SET @trend_score = @trend_score - 1;
                SET @consecutive_drop = @consecutive_drop + 1;
            END
        END

        IF @consecutive_drop >= 2
            SET @nhan_xet = N'Điểm số đang giảm 2 lần liên tiếp. ';

        SET @prev_score = @curr_score;
        FETCH NEXT FROM cur_progress INTO @curr_score;
    END

    CLOSE cur_progress;
    DEALLOCATE cur_progress;

    -- 6. TỔNG HỢP KẾT LUẬN
    DECLARE @xu_huong NVARCHAR(100);

    IF @count_total_attempts < 2
        SET @xu_huong = N'Chưa đủ dữ liệu đánh giá';
    ELSE IF @trend_score >= 2
        SET @xu_huong = N'📈 Đang tiến bộ';
    ELSE IF @trend_score <= -2
        SET @xu_huong = N'📉 Đang sa sút';
    ELSE
        SET @xu_huong = N'➖ Phong độ ổn định';

    IF @missing_quiz > 0
        SET @nhan_xet = @nhan_xet + N'Bỏ lỡ ' + CAST(@missing_quiz AS NVARCHAR(10)) + N' bài kiểm tra. ';

    IF @avg_score < 5.0
        SET @nhan_xet = @nhan_xet + N'Điểm trung bình YẾU. ';
    ELSE IF @avg_score >= 8.0 AND @missing_quiz = 0
        SET @nhan_xet = N'Học tập xuất sắc! ';

    IF @nhan_xet = N'' SET @nhan_xet = N'Không có nhận xét đặc biệt.';

    -- 7. TRẢ KẾT QUẢ (Thêm @str_diem vào cuối)
    INSERT INTO @KetQua VALUES (
        @hoc_vien_id, @ten_hoc_vien, @count_total_attempts, @missing_quiz,
        @avg_score, @max_score, @min_score,
        @xu_huong, @nhan_xet,
        @str_diem -- [NEW] Insert chuỗi điểm vào bảng
    );

    RETURN;
END;
GO