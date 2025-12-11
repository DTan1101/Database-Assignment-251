USE TutorSS;
GO

CREATE OR ALTER PROCEDURE dbo.InsertQuiz
    @lop_hoc_id        INT,
    @ten_quiz          NVARCHAR(100),
    @so_lan_duoc_lam   INT       = NULL,
    @thoi_gian_dong    DATETIME  = NULL,   -- có thể NULL (không giới hạn)
    @thoi_gian_mo      DATETIME            -- bắt buộc, NOT NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Validate tham số bắt buộc
        IF @lop_hoc_id IS NULL
            THROW 51010, '@lop_hoc_id is required', 1;

        IF @ten_quiz IS NULL OR LTRIM(RTRIM(@ten_quiz)) = ''
            THROW 51011, '@ten_quiz must not be null or empty', 1;

        IF LEN(@ten_quiz) > 100
            THROW 51012, '@ten_quiz length must be <= 100', 1;

        -- thoi_gian_mo bắt buộc phải có
        IF @thoi_gian_mo IS NULL
            THROW 51003, '@thoi_gian_mo is required', 1;

        -- 2. Ensure lop_hoc exists & Get Class Info
        DECLARE @NgayNhanLop DATETIME;
        
        SELECT @NgayNhanLop = thoi_gian_nhan_lop 
        FROM dbo.lop_hoc 
        WHERE lop_hoc_id = @lop_hoc_id;

        IF @@ROWCOUNT = 0
            THROW 51000, 'lop_hoc_id not found in dbo.lop_hoc', 1;

        -- 3. Validate Logic Thời Gian Quiz (Mở < Đóng)
        IF @thoi_gian_dong IS NOT NULL
           AND @thoi_gian_mo >= @thoi_gian_dong
            THROW 51001, '@thoi_gian_mo must be earlier than @thoi_gian_dong', 1;

        -- 4. [MỚI] Validate: Quiz không được vượt quá thời hạn lớp học (30 ngày)
        -- Chỉ kiểm tra nếu lớp đã có ngày nhận và Quiz có ngày đóng
        IF @thoi_gian_dong IS NOT NULL AND @NgayNhanLop IS NOT NULL
        BEGIN
            -- Tính ngày kết thúc lớp học (Quy tắc 30 ngày)
            DECLARE @NgayKetThucLop DATETIME = DATEADD(DAY, 30, @NgayNhanLop);

            IF @thoi_gian_dong > @NgayKetThucLop
            BEGIN
                -- Format ngày tháng ra chuỗi để báo lỗi cho dễ hiểu (dd/mm/yyyy)
                DECLARE @Msg NVARCHAR(255) = N'Lỗi nghiệp vụ: Thời gian đóng Quiz (' 
                                           + CONVERT(NVARCHAR, @thoi_gian_dong, 103) 
                                           + N') không được vượt quá ngày kết thúc lớp học (' 
                                           + CONVERT(NVARCHAR, @NgayKetThucLop, 103) + N').';
                THROW 51014, @Msg, 1;
            END
        END

        -- 5. Check so_lan_duoc_lam
        IF @so_lan_duoc_lam IS NOT NULL AND @so_lan_duoc_lam <= 0
            THROW 51002, '@so_lan_duoc_lam must be greater than 0', 1;

        -- 6. Check trùng quiz trong cùng lớp
        IF EXISTS (
            SELECT 1 FROM dbo.quiz
            WHERE lop_hoc_id = @lop_hoc_id
              AND ten_quiz   = @ten_quiz
        )
            THROW 51013, 'Quiz with same ten_quiz already exists in this lop_hoc', 1;

        -- 7. Thực hiện insert
        INSERT INTO dbo.quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_dong, thoi_gian_mo)
        VALUES (@lop_hoc_id, @ten_quiz, @so_lan_duoc_lam, @thoi_gian_dong, @thoi_gian_mo);

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;

    RETURN 0;
END;
GO