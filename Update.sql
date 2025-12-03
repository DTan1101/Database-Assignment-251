/*
Procedure: dbo.UpdateQuizName
Purpose: Update a quiz's name (primary-key component) and other optional fields with validations:
 - verifies target row exists
 - prevents PK conflict on rename
 - prevents rename when dependent child rows exist
 - validates thoi_gian_mo < thoi_gian_dong when both provided
 - validates so_lan_duoc_lam > 0 when provided
*/
CREATE OR ALTER PROCEDURE dbo.UpdateQuiz
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200),
    @new_ten_quiz NVARCHAR(200),
    @so_lan_duoc_lam INT = NULL,
    @thoi_gian_dong DATETIME = NULL,
    @thoi_gian_mo DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Ensure target row exists
        IF NOT EXISTS (SELECT 1 FROM dbo.quiz WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @ten_quiz)
            THROW 51020, 'Quiz row not found', 1;

        -- If rename requested, check for conflicts and dependents
        IF @new_ten_quiz IS NOT NULL AND @new_ten_quiz <> @ten_quiz
        BEGIN
            -- Prevent PK conflict
            IF EXISTS (SELECT 1 FROM dbo.quiz WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @new_ten_quiz)
                THROW 51021, 'A quiz with the new ten_quiz already exists for this lop_hoc_id', 1;

            -- Prevent rename if child rows reference the existing PK
            IF EXISTS (SELECT 1 FROM dbo.cau_hoi WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @ten_quiz)
                THROW 51022, 'Cannot rename quiz: dependent rows exist in dbo.cau_hoi', 1;

            IF EXISTS (SELECT 1 FROM dbo.lich_su_lam_bai WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @ten_quiz)
                THROW 51023, 'Cannot rename quiz: dependent rows exist in dbo.lich_su_lam_bai', 1;
        END

        -- Validate times when both provided
        IF @thoi_gian_mo IS NOT NULL AND @thoi_gian_dong IS NOT NULL
            AND @thoi_gian_mo >= @thoi_gian_dong
            THROW 51024, '@thoi_gian_mo must be earlier than @thoi_gian_dong', 1;

        -- Validate attempt count when provided
        IF @so_lan_duoc_lam IS NOT NULL AND @so_lan_duoc_lam <= 0
            THROW 51025, '@so_lan_duoc_lam must be greater than 0', 1;

        BEGIN TRANSACTION;

        UPDATE dbo.quiz
        SET ten_quiz = CASE WHEN @new_ten_quiz IS NULL OR @new_ten_quiz = '' THEN ten_quiz ELSE @new_ten_quiz END,
            so_lan_duoc_lam = COALESCE(@so_lan_duoc_lam, so_lan_duoc_lam),
            thoi_gian_dong = COALESCE(@thoi_gian_dong, thoi_gian_dong),
            thoi_gian_mo = COALESCE(@thoi_gian_mo, thoi_gian_mo)
        WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @ten_quiz;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    RETURN 0;
END;

GO

EXEC dbo.UpdateQuiz
    @lop_hoc_id = 501,
    @ten_quiz = N'Quiz chương 1',
    @new_ten_quiz = N'Quiz chương 1 - update',
    @so_lan_duoc_lam = 1,
    @thoi_gian_dong = '2025-12-10 23:59:59',
    @thoi_gian_mo = '2025-12-05 08:00:00';