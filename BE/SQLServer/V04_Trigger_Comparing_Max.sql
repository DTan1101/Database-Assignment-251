USE TutorSS;
GO

-- =============================================
-- 1. PROCEDURE: Nộp bài (Đã xử lý nộp bài trắng)
-- =============================================
CREATE OR ALTER PROCEDURE dbo.InsertLichSuWithAnswers
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200),
    @thoi_gian_bat_dau DATETIME = NULL,
    @thoi_gian_ket_thuc DATETIME = NULL,
    @hoc_vien_id INT,
    @answersJson NVARCHAR(MAX) -- JSON array
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- Tự động rollback nếu có lỗi run-time

    BEGIN TRY
        -- 1. Validate Quiz Tồn Tại
        IF NOT EXISTS (SELECT 1 FROM dbo.quiz WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @ten_quiz)
            THROW 54000, 'Quiz not found', 1;

        BEGIN TRANSACTION;

        -- 2. Tạo ID Mới (Concurrency-safe)
        DECLARE @newId INT;
        SELECT @newId = ISNULL(MAX(id),0) + 1 
        FROM dbo.lich_su_lam_bai WITH (UPDLOCK, HOLDLOCK);

        -- 3. Tính Số Lần Làm Bài (Lan)
        DECLARE @lan INT;
        SELECT @lan = ISNULL(MAX(lan), 0) + 1
        FROM dbo.lich_su_lam_bai
        WHERE lop_hoc_id = @lop_hoc_id
          AND ten_quiz = @ten_quiz
          AND hoc_vien_id = @hoc_vien_id;

        -- 4. Insert Lịch Sử (Mặc định Diem = NULL, chờ tính toán)
        INSERT INTO dbo.lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
        VALUES (@newId, @lop_hoc_id, @ten_quiz, @lan, NULL, @thoi_gian_bat_dau, @thoi_gian_ket_thuc, @hoc_vien_id);

        -- 5. Insert Đáp Án (Sử dụng đúng key từ JSON Postman)
        DECLARE @InsertedCount INT = 0;

        INSERT INTO dbo.ghi_dap_an (lop_hoc_id, ten_quiz, stt_quiz, lich_su_id, dap_an_cua_lan_lam_bai)
        SELECT 
            @lop_hoc_id, 
            @ten_quiz, 
            a.stt_quiz, 
            @newId, 
            a.dap_an_cua_lan_lam_bai
        FROM OPENJSON(@answersJson)
             WITH (
                stt_quiz                INT             '$.sttQuiz',          -- CamelCase từ Java/Postman
                dap_an_cua_lan_lam_bai  NVARCHAR(MAX)   '$.dapAnCuaLanLamBai' -- CamelCase từ Java/Postman
             ) AS a
        WHERE a.stt_quiz IS NOT NULL;

        SET @InsertedCount = @@ROWCOUNT;

        -- 6. XỬ LÝ NỘP BÀI TRẮNG (QUAN TRỌNG)
        -- Nếu không có dòng nào được insert vào ghi_dap_an (do JSON rỗng hoặc sai key),
        -- Trigger sẽ không chạy -> Điểm vẫn là NULL -> Cần update thủ công về 0.
        IF @InsertedCount = 0
        BEGIN
            UPDATE dbo.lich_su_lam_bai 
            SET diem = 0 
            WHERE id = @newId;
            
            -- Optional: Ghi log hoặc print cảnh báo
            -- PRINT 'Warning: No answers found. Score set to 0.';
        END

        COMMIT TRANSACTION;

        -- 7. Trả về kết quả
        SELECT * FROM dbo.lich_su_lam_bai WHERE id = @newId;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- =============================================
-- 2. TRIGGER TÍNH ĐIỂM (Giữ nguyên logic cũ nhưng clean hơn)
-- =============================================
CREATE OR ALTER TRIGGER dbo.tr_CalcDiem_AfterGhiDapAn_Insert
ON dbo.ghi_dap_an
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM inserted) RETURN;

    BEGIN TRY
        ;WITH Affected AS (
            SELECT DISTINCT lich_su_id FROM inserted WHERE lich_su_id IS NOT NULL
        )
        ,Scores AS (
            SELECT
                g.lich_su_id,
                -- Tính số câu đúng
                SUM(CASE 
                    WHEN TRIM(ISNULL(g.dap_an_cua_lan_lam_bai, N'')) = TRIM(ISNULL(l.dap_an, N'')) 
                    THEN 1 ELSE 0 
                END) AS correct_count,
                -- Tổng số câu hỏi CỦA ĐỀ THI
                (SELECT COUNT(*) FROM dbo.cau_hoi ch WHERE ch.lop_hoc_id = g.lop_hoc_id AND ch.ten_quiz = g.ten_quiz) AS total_questions
            FROM dbo.ghi_dap_an g
            JOIN dbo.cau_hoi l 
                ON g.lop_hoc_id = l.lop_hoc_id 
               AND g.ten_quiz = l.ten_quiz 
               AND g.stt_quiz = l.stt
            WHERE g.lich_su_id IN (SELECT lich_su_id FROM Affected)
            GROUP BY g.lich_su_id, g.lop_hoc_id, g.ten_quiz
        )
        UPDATE ls
        SET diem = CASE 
            WHEN s.total_questions = 0 THEN 0 
            ELSE CAST(s.correct_count AS decimal(9,4)) / s.total_questions * 10 
        END
        FROM dbo.lich_su_lam_bai ls
        INNER JOIN Scores s ON ls.id = s.lich_su_id

    END TRY
    BEGIN CATCH
        PRINT 'Trigger CalcDiem Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

-- =============================================
-- 3. TRIGGER CHẶN SỐ LẦN LÀM (Giữ nguyên)
-- =============================================
CREATE OR ALTER TRIGGER dbo.tr_lich_su_lam_bai_prevent_over_attempts
ON dbo.lich_su_lam_bai
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.quiz q ON q.lop_hoc_id = i.lop_hoc_id AND q.ten_quiz = i.ten_quiz
        CROSS APPLY (
            SELECT COUNT(*) as SoLanDaLam 
            FROM dbo.lich_su_lam_bai l 
            WHERE l.lop_hoc_id = i.lop_hoc_id 
              AND l.ten_quiz = i.ten_quiz 
              AND l.hoc_vien_id = i.hoc_vien_id
        ) CurrentStats
        WHERE q.so_lan_duoc_lam IS NOT NULL 
          AND CurrentStats.SoLanDaLam >= q.so_lan_duoc_lam
    )
    BEGIN
        THROW 51000, 'Bạn đã hết số lần làm bài cho phép.', 1;
    END

    INSERT INTO dbo.lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    SELECT id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id
    FROM inserted;
END;
GO