
CREATE OR ALTER PROCEDURE dbo.DeleteQuiz_AllCascade
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete ghi_dap_an
        DELETE gda
        FROM dbo.ghi_dap_an AS gda
        WHERE gda.lop_hoc_id = @lop_hoc_id
          AND gda.ten_quiz = @ten_quiz;

        -- Delete lua_chon_tra_loi
        DELETE lctl
        FROM dbo.lua_chon_tra_loi AS lctl
        WHERE lctl.lop_hoc_id = @lop_hoc_id
          AND lctl.ten_quiz = @ten_quiz;

        -- Delete cau_hoi
        DELETE ch
        FROM dbo.cau_hoi AS ch
        WHERE ch.lop_hoc_id = @lop_hoc_id
          AND ch.ten_quiz = @ten_quiz;

        -- Delete lich_su_lam_bai
        DELETE ls
        FROM dbo.lich_su_lam_bai AS ls
        WHERE ls.lop_hoc_id = @lop_hoc_id
          AND ls.ten_quiz = @ten_quiz;

        -- Delete quiz
        DELETE FROM dbo.quiz
        WHERE lop_hoc_id = @lop_hoc_id
          AND ten_quiz = @ten_quiz;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    RETURN 0;
END;







