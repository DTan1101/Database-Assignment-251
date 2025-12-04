/* 
 Procedure: dbo.InsertQuiz
 Purpose: Insert a row into dbo.quiz with validations:
  - lop_hoc_id must exist in dbo.lop_hoc
  - when both provided, thoi_gian_mo < thoi_gian_dong
  - when provided, so_lan_duoc_lam > 0
*/
USE TutorSS;
GO

CREATE or ALTER PROCEDURE dbo.InsertQuiz
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200),
    @so_lan_duoc_lam INT = NULL,
    @thoi_gian_dong DATETIME = NULL,
    @thoi_gian_mo DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Ensure lop_hoc exists
        IF NOT EXISTS (SELECT 1 FROM dbo.lop_hoc WHERE lop_hoc_id = @lop_hoc_id)
            THROW 51000, 'lop_hoc_id not found in dbo.lop_hoc', 1;

        -- Ensure times are logical when both provided
        IF @thoi_gian_mo IS NOT NULL AND @thoi_gian_dong IS NOT NULL
            AND @thoi_gian_mo >= @thoi_gian_dong
            THROW 51001, '@thoi_gian_mo must be earlier than @thoi_gian_dong', 1;

        -- Ensure attempt count positive when provided
        IF @so_lan_duoc_lam IS NOT NULL AND @so_lan_duoc_lam <= 0
            THROW 51002, '@so_lan_duoc_lam must be greater than 0', 1;

        INSERT INTO dbo.quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_dong, thoi_gian_mo)
        VALUES (@lop_hoc_id, @ten_quiz, @so_lan_duoc_lam, @thoi_gian_dong, @thoi_gian_mo);

    END TRY
    BEGIN CATCH
        -- Preserve original error information
        THROW;
    END CATCH;

    RETURN 0;
END;

GO

EXEC dbo.InsertQuiz
    @lop_hoc_id = 501,
    @ten_quiz = N'Quiz kiểm tra chương 6',
    @so_lan_duoc_lam = 55,
    @thoi_gian_dong = '2025-12-12 23:59:59',
    @thoi_gian_mo = '2025-12-05 08:00:00';

SELECT * FROM [quiz];