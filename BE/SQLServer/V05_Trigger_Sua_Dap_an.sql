-- Trigger: dbo.tr_UpdateScore_OnCauHoiAnswerChange
-- Purpose: When cau_hoi.dap_an changes, recalculate diem in lich_su_lam_bai
USE TutorSS;
GO
CREATE OR ALTER TRIGGER dbo.tr_UpdateScore_OnCauHoiAnswerChange
ON dbo.cau_hoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Nếu không sửa đáp án thì thoát ngay để nhẹ hệ thống
    IF NOT UPDATE(dap_an) RETURN;

    BEGIN TRY
        -- 2. Tìm danh sách các Quiz bị ảnh hưởng (chỉ lấy ID lớp và Tên Quiz)
        ;WITH AffectedQuizzes AS (
            SELECT DISTINCT i.lop_hoc_id, i.ten_quiz
            FROM inserted i
            JOIN deleted d ON i.lop_hoc_id = d.lop_hoc_id
                          AND i.ten_quiz = d.ten_quiz
                          AND i.stt = d.stt
            -- Dùng TRIM để chỉ kích hoạt khi nội dung thực sự thay đổi
            WHERE TRIM(ISNULL(i.dap_an, N'')) <> TRIM(ISNULL(d.dap_an, N''))
        ),

        -- 3. Tính lại mẫu số: Tổng số câu hỏi thực tế của mỗi Quiz
        QuizTotalQuestions AS (
            SELECT c.lop_hoc_id, c.ten_quiz, COUNT(*) AS TotalQ
            FROM dbo.cau_hoi c
            JOIN AffectedQuizzes aq ON c.lop_hoc_id = aq.lop_hoc_id
                                   AND c.ten_quiz = aq.ten_quiz
            GROUP BY c.lop_hoc_id, c.ten_quiz
        ),

        -- 4. Tính lại điểm số cho TẤT CẢ bài làm thuộc Quiz đó
        RecalculatedScores AS (
            SELECT
                ls.id AS lich_su_id,
                -- FIX LỖI 1: Nhân thêm 10.0 để ra thang điểm 10
                CAST(
                    (SUM(CASE
                        -- FIX LỖI 2: Dùng TRIM để so sánh chính xác
                        WHEN TRIM(ISNULL(g.dap_an_cua_lan_lam_bai, N'')) = TRIM(ISNULL(c.dap_an, N''))
                        THEN 1 ELSE 0
                     END) * 10.0)
                    / NULLIF(qt.TotalQ, 0) -- Chia cho tổng số câu hỏi của đề (không chia cho số câu đã làm)
                AS DECIMAL(4,2)) AS NewScore
            FROM dbo.lich_su_lam_bai ls
            JOIN QuizTotalQuestions qt ON ls.lop_hoc_id = qt.lop_hoc_id
                                      AND ls.ten_quiz = qt.ten_quiz
            -- FIX LỖI 3: LEFT JOIN để tính đúng cả khi học viên bỏ làm câu hỏi
            LEFT JOIN dbo.ghi_dap_an g ON ls.id = g.lich_su_id
            LEFT JOIN dbo.cau_hoi c ON g.lop_hoc_id = c.lop_hoc_id
                                   AND g.ten_quiz = c.ten_quiz
                                   AND g.stt_quiz = c.stt
            GROUP BY ls.id, qt.TotalQ
        )

        -- 5. Update ngược lại vào bảng lịch sử
        UPDATE ls
        SET diem = rs.NewScore
        FROM dbo.lich_su_lam_bai ls
        JOIN RecalculatedScores rs ON ls.id = rs.lich_su_id;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


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

