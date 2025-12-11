--/*
--Procedure: dbo.UpdateQuiz
--Purpose: Update a quiz's name (primary-key component) and other optional fields with validations:
-- - verifies target row exists
-- - prevents PK conflict on rename
-- - prevents rename when dependent child rows exist
-- - validates thoi_gian_mo < thoi_gian_dong when both provided
-- - validates so_lan_duoc_lam > 0 when provided (NULL = unlimited attempts allowed)
-- - allows setting so_lan_duoc_lam to NULL to represent unlimited attempts
-- - when so_lan_duoc_lam is a number, ensures it's not less than existing attempt numbers
--
-- IMPORTANT: @so_lan_duoc_lam behavior:
--   - If FE sends NULL → Set to NULL in database (unlimited attempts)
--   - If FE sends a positive number → Set to that number
--   - No default value is applied, whatever FE sends is what gets stored
--*/
USE TutorSS;
GO
CREATE OR ALTER PROCEDURE dbo.UpdateQuiz
    @lop_hoc_id        INT,
    @ten_quiz          NVARCHAR(100),      -- tên hiện tại (PK cũ)
    @new_ten_quiz      NVARCHAR(100) = NULL, -- tên mới (NULL = không đổi tên)
    @so_lan_duoc_lam   INT           = NULL, -- NULL = set to unlimited | >0 = set to specific number
    @thoi_gian_mo      DATETIME      = NULL, -- NULL = không đổi
    @thoi_gian_dong    DATETIME      = NULL  -- NULL = không đổi
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @cur_ten_quiz        NVARCHAR(100),
        @cur_so_lan          INT,
        @cur_thoi_gian_mo    DATETIME,
        @cur_thoi_gian_dong  DATETIME;

    DECLARE
        @final_ten_quiz        NVARCHAR(100),
        @final_so_lan          INT,
        @final_thoi_gian_mo    DATETIME,
        @final_thoi_gian_dong  DATETIME;

    BEGIN TRY
        BEGIN TRANSACTION;

-- 1. Đọc bản ghi hiện tại + khóa nó lại để tránh concurrent update
        SELECT
            @cur_ten_quiz       = q.ten_quiz,
            @cur_so_lan         = q.so_lan_duoc_lam,
            @cur_thoi_gian_mo   = q.thoi_gian_mo,
            @cur_thoi_gian_dong = q.thoi_gian_dong
        FROM dbo.quiz AS q WITH (UPDLOCK, HOLDLOCK)
        WHERE q.lop_hoc_id = @lop_hoc_id
          AND q.ten_quiz   = @ten_quiz;

        IF @@ROWCOUNT = 0
            THROW 51020, 'Quiz row not found', 1;

--        /* 2. Tính giá trị cuối cùng (final) sẽ lưu */
        -- Note: FE truyền NULL = muốn set unlimited attempts (NULL trong DB)
        -- Không dùng COALESCE cho so_lan_duoc_lam để giữ nguyên NULL từ FE
        SET @final_ten_quiz       = ISNULL(@new_ten_quiz, @cur_ten_quiz);
        SET @final_so_lan         = @so_lan_duoc_lam;  -- Accept NULL from FE (unlimited)
        SET @final_thoi_gian_mo   = COALESCE(@thoi_gian_mo, @cur_thoi_gian_mo);
        SET @final_thoi_gian_dong = COALESCE(@thoi_gian_dong, @cur_thoi_gian_dong);

--        /* 3. Validate dữ liệu cơ bản */

        -- so_lan_duoc_lam > 0 nếu không NULL (NULL = không giới hạn)
        IF @final_so_lan IS NOT NULL AND @final_so_lan <= 0
            THROW 51025, 'so_lan_duoc_lam must be greater than 0 or NULL for unlimited attempts', 1;

        -- thoi_gian_mo < thoi_gian_dong nếu cả hai đều có giá trị
        IF @final_thoi_gian_mo IS NOT NULL
           AND @final_thoi_gian_dong IS NOT NULL
           AND @final_thoi_gian_mo >= @final_thoi_gian_dong
            THROW 51024, 'thoi_gian_mo must be earlier than thoi_gian_dong', 1;

--        /* 4. Validate rename ten_quiz (PK) nếu có thay đổi */

        IF @final_ten_quiz <> @cur_ten_quiz
        BEGIN
            -- 4.1. Không cho trùng PK với quiz khác
            IF EXISTS (
                SELECT 1
                FROM dbo.quiz
                WHERE lop_hoc_id = @lop_hoc_id
                  AND ten_quiz   = @final_ten_quiz
            )
                THROW 51021, 'A quiz with the new ten_quiz already exists for this lop_hoc_id', 1;

            -- 4.2. Không cho rename nếu đã có bản ghi con
            IF EXISTS (
                SELECT 1
                FROM dbo.cau_hoi
                WHERE lop_hoc_id = @lop_hoc_id
                  AND ten_quiz   = @cur_ten_quiz
            )
                THROW 51022, 'Cannot rename quiz: dependent rows exist in cau_hoi', 1;

            IF EXISTS (
                SELECT 1
                FROM dbo.lich_su_lam_bai
                WHERE lop_hoc_id = @lop_hoc_id
                  AND ten_quiz   = @cur_ten_quiz
            )
                THROW 51023, 'Cannot rename quiz: dependent rows exist in lich_su_lam_bai', 1;

            -- Nếu muốn, có thể thêm check ở các bảng khác nếu sau này FK trực tiếp tới quiz.
        END;

--        /* 5. so_lan_duoc_lam không được nhỏ hơn số lần làm đã tồn tại (nếu không phải NULL = unlimited) */
        -- Nếu đang set thành NULL (unlimited), bỏ qua check này
        -- Nếu set thành giá trị cụ thể, phải >= số lần làm bài hiện có
        IF @final_so_lan IS NOT NULL
           AND EXISTS (
                SELECT 1
                FROM dbo.lich_su_lam_bai AS l
                WHERE l.lop_hoc_id = @lop_hoc_id
                  AND l.ten_quiz   = @cur_ten_quiz
                  AND l.lan        > @final_so_lan
           )
            THROW 51026, 'so_lan_duoc_lam cannot be less than existing attempt numbers in lich_su_lam_bai', 1;

--        /* 6. Thực hiện UPDATE với giá trị final */

        UPDATE dbo.quiz
        SET ten_quiz        = @final_ten_quiz,
            so_lan_duoc_lam = @final_so_lan,
            thoi_gian_mo    = @final_thoi_gian_mo,
            thoi_gian_dong  = @final_thoi_gian_dong
        WHERE lop_hoc_id    = @lop_hoc_id
          AND ten_quiz      = @ten_quiz;    -- dùng tên cũ trong WHERE

        IF @@ROWCOUNT = 0
            THROW 51027, 'Quiz row was modified or deleted by another transaction', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Ném lại lỗi gốc cho dễ debug
        THROW;
    END CATCH;

    RETURN 0;
END;
GO

