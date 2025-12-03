-- Created by GitHub Copilot in SSMS - review carefully before executing
-- Trigger: dbo.tr_DeleteQuiz_CascadeDeps
-- Purpose: When a delete is issued against dbo.quiz, delete dependent rows
-- in dbo.cau_hoi and dbo.lich_su_lam_bai first, then delete the quiz rows.
CREATE OR ALTER TRIGGER dbo.tr_DeleteQuiz_CascadeDeps
ON dbo.quiz
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete dap an of his
        DELETE gda
        FROM dbo.ghi_dap_an AS gda
        INNER JOIN deleted AS d
            ON gda.lop_hoc_id = d.lop_hoc_id
           AND gda.ten_quiz = d.ten_quiz;

        -- Delete lua_chon_tra_loi
        DELETE lctl
        FROM dbo.lua_chon_tra_loi AS lctl
        INNER JOIN deleted AS d
            ON lctl.lop_hoc_id = d.lop_hoc_id
           AND lctl.ten_quiz = d.ten_quiz;


        -- Delete dependent questions
        DELETE ch
        FROM dbo.cau_hoi AS ch
        INNER JOIN deleted AS d
            ON ch.lop_hoc_id = d.lop_hoc_id
           AND ch.ten_quiz = d.ten_quiz;


        -- Delete dependent history rows
        DELETE ls
        FROM dbo.lich_su_lam_bai AS ls
        INNER JOIN deleted AS d
            ON ls.lop_hoc_id = d.lop_hoc_id
           AND ls.ten_quiz = d.ten_quiz;
        

        -- Delete quiz rows
        DELETE q
        FROM dbo.quiz AS q
        INNER JOIN deleted AS d
            ON q.lop_hoc_id = d.lop_hoc_id
           AND q.ten_quiz = d.ten_quiz;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO

-- Created by GitHub Copilot in SSMS - review carefully before executing
-- Procedure: dbo.DeleteQuiz
-- Purpose: Delete a quiz identified by PK (lop_hoc_id, ten_quiz).
-- Blocks delete when dependent rows exist in child tables.
CREATE OR ALTER PROCEDURE dbo.DeleteQuiz
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM dbo.quiz
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




EXEC dbo.DeleteQuiz
    @lop_hoc_id = 500,
    @ten_quiz = N'Kiểm tra 15p Hàm số';

