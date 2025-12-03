-- Created by GitHub Copilot in SSMS - review carefully before executing
-- Trigger: dbo.tr_UpdateScore_OnCauHoiAnswerChange
-- Purpose: When cau_hoi.dap_an changes, recalculate diem in lich_su_lam_bai
CREATE OR ALTER TRIGGER dbo.tr_UpdateScore_OnCauHoiAnswerChange
ON dbo.cau_hoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only proceed if dap_an was updated
    IF NOT UPDATE(dap_an)
        RETURN;

    BEGIN TRY
        BEGIN TRANSACTION;

        ;WITH ChangedQuestions AS (
            SELECT i.lop_hoc_id, i.ten_quiz, i.stt
            FROM inserted i
            LEFT JOIN deleted d
                ON i.lop_hoc_id = d.lop_hoc_id
               AND i.ten_quiz = d.ten_quiz
               AND i.stt = d.stt
            WHERE ISNULL(i.dap_an, N'') <> ISNULL(d.dap_an, N'')
        ),
        AffectedLichSu AS (
            SELECT DISTINCT g.lich_su_id
            FROM dbo.ghi_dap_an g
            INNER JOIN ChangedQuestions cq
                ON g.lop_hoc_id = cq.lop_hoc_id
               AND g.ten_quiz = cq.ten_quiz
               AND g.stt_quiz = cq.stt
        ),
        LichSuQuiz AS (
            SELECT DISTINCT g.lich_su_id, g.lop_hoc_id, g.ten_quiz
            FROM dbo.ghi_dap_an g
            WHERE g.lich_su_id IN (SELECT lich_su_id FROM AffectedLichSu)
        ),
        CorrectCounts AS (
            SELECT g.lich_su_id,
                   SUM(CASE WHEN ISNULL(g.dap_an_cua_lan_lam_bai, N'') = ISNULL(c.dap_an, N'') THEN 1 ELSE 0 END) AS correct_count
            FROM dbo.ghi_dap_an g
            INNER JOIN dbo.cau_hoi c
                ON g.lop_hoc_id = c.lop_hoc_id
               AND g.ten_quiz = c.ten_quiz
               AND g.stt_quiz = c.stt
            WHERE g.lich_su_id IN (SELECT lich_su_id FROM LichSuQuiz)
            GROUP BY g.lich_su_id
        ),
        Totals AS (
            SELECT c.lop_hoc_id, c.ten_quiz, COUNT(*) AS total_questions
            FROM dbo.cau_hoi c
            INNER JOIN (SELECT DISTINCT lop_hoc_id, ten_quiz FROM ChangedQuestions) cq
                ON c.lop_hoc_id = cq.lop_hoc_id
               AND c.ten_quiz = cq.ten_quiz
            GROUP BY c.lop_hoc_id, c.ten_quiz
        )
        UPDATE ls
        SET diem = CAST(cc.correct_count AS decimal(9,4)) / NULLIF(t.total_questions, 0)
        FROM dbo.lich_su_lam_bai ls
        INNER JOIN CorrectCounts cc ON ls.id = cc.lich_su_id
        INNER JOIN LichSuQuiz lq ON cc.lich_su_id = lq.lich_su_id
        INNER JOIN Totals t ON t.lop_hoc_id = lq.lop_hoc_id AND t.ten_quiz = lq.ten_quiz
        WHERE ls.id IN (SELECT lich_su_id FROM AffectedLichSu);

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
-- Procedure: dbo.UpdateCauHoi
-- Purpose: Update a question in dbo.cau_hoi identified by (lop_hoc_id, ten_quiz, stt).
CREATE OR ALTER PROCEDURE dbo.UpdateCauHoi
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200),
    @stt INT,
    @cau_hoi NVARCHAR(MAX) = NULL,
    @dap_an NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Ensure target exists
        IF NOT EXISTS (
            SELECT 1 FROM dbo.cau_hoi
            WHERE lop_hoc_id = @lop_hoc_id
              AND ten_quiz = @ten_quiz
              AND stt = @stt
        )
            THROW 52000, 'cau_hoi row not found', 1;

        BEGIN TRANSACTION;

        UPDATE dbo.cau_hoi
        SET cau_hoi = CASE WHEN @cau_hoi IS NULL THEN cau_hoi ELSE @cau_hoi END,
            dap_an = CASE WHEN @dap_an IS NULL THEN dap_an ELSE @dap_an END
        WHERE lop_hoc_id = @lop_hoc_id
          AND ten_quiz = @ten_quiz
          AND stt = @stt;

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

EXEC dbo.UpdateCauHoi
    @lop_hoc_id = 500,
    @ten_quiz = N'Kiểm tra 15p Hàm số',
    @stt = 1,
    @cau_hoi = N'Đạo hàm của y=x^3?',
    @dap_an = N'3x^3';

