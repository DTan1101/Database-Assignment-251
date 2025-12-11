-- Procedure: dbo.InsertLichSuWithAnswers
-- Purpose: Insert a new record into dbo.lich_su_lam_bai and related answers into dbo.ghi_dap_an and dbo.lua_chon_tra_loi.
CREATE or ALTER PROCEDURE dbo.InsertLichSuWithAnswers
    @lop_hoc_id INT,
    @ten_quiz NVARCHAR(200),
    @thoi_gian_bat_dau DATETIME = NULL,
    @thoi_gian_ket_thuc DATETIME = NULL,
    @hoc_vien_id INT,
    @answersJson NVARCHAR(MAX) -- JSON array: [{"stt_quiz":1,"noi_dung_lua_chon":"..."},...]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate quiz exists
        IF NOT EXISTS (SELECT 1 FROM dbo.quiz WHERE lop_hoc_id = @lop_hoc_id AND ten_quiz = @ten_quiz)
            THROW 54000, 'Quiz not found', 1;

        BEGIN TRANSACTION;

        -- Allocate new id in a concurrency-safe manner
        DECLARE @newId INT;
        SELECT @newId = ISNULL(MAX(id),0) + 1
        FROM dbo.lich_su_lam_bai WITH (UPDLOCK, HOLDLOCK);

        -- Insert history row; diem will be calculated by trigger after inserting answers
        DECLARE @lan INT;
        SELECT @lan = ISNULL(MAX(lan), 0) + 1
        FROM dbo.lich_su_lam_bai
        WHERE lop_hoc_id = @lop_hoc_id
          AND ten_quiz = @ten_quiz
          AND hoc_vien_id = @hoc_vien_id;

        INSERT INTO dbo.lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
        VALUES (@newId, @lop_hoc_id, @ten_quiz, @lan, NULL, @thoi_gian_bat_dau, @thoi_gian_ket_thuc, @hoc_vien_id);


        -- Parse answers JSON and insert into ghi_dap_an
        INSERT INTO dbo.ghi_dap_an (lop_hoc_id, ten_quiz, stt_quiz, lich_su_id, dap_an_cua_lan_lam_bai)
        SELECT @lop_hoc_id, @ten_quiz, a.stt_quiz, @newId, a.dap_an_cua_lan_lam_bai
        FROM OPENJSON(@answersJson)
             WITH (
                stt_quiz INT '$.stt_quiz',
                dap_an_cua_lan_lam_bai NVARCHAR(MAX) '$.dap_an_cua_lan_lam_bai'
             ) AS a
        WHERE a.stt_quiz IS NOT NULL;

        COMMIT TRANSACTION;

        -- Return the inserted history row
        SELECT * FROM dbo.lich_su_lam_bai WHERE id = @newId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO



-- Trigger: dbo.tr_CalcDiem_AfterGhiDapAn_Insert
-- Purpose: After answers are inserted into dbo.ghi_dap_an, recalculate diem in dbo.lich_su_lam_bai
CREATE OR ALTER TRIGGER dbo.tr_CalcDiem_AfterGhiDapAn_Insert
ON dbo.ghi_dap_an
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Get affected lich_su_ids
        ;WITH Affected AS (
            SELECT DISTINCT lich_su_id
            FROM inserted
            WHERE lich_su_id IS NOT NULL
        )
        -- Compute correct counts and totals per lich_su_id
        ,Scores AS (
            SELECT a.lich_su_id,
                   SUM(CASE WHEN ISNULL(g.dap_an_cua_lan_lam_bai, N'') = ISNULL(l.dap_an, N'') THEN 1 ELSE 0 END) AS correct_count,
                   COUNT(*) AS total_questions
            FROM dbo.ghi_dap_an g
            LEFT JOIN dbo.cau_hoi l
                ON g.lop_hoc_id = l.lop_hoc_id
               AND g.ten_quiz = l.ten_quiz
               AND g.stt_quiz = l.stt
            INNER JOIN Affected a ON g.lich_su_id = a.lich_su_id
            GROUP BY a.lich_su_id
        )
        UPDATE ls
        SET diem = CASE WHEN s.total_questions = 0 THEN NULL ELSE CAST(s.correct_count AS decimal(9,4)) / s.total_questions * 10 END
        FROM dbo.lich_su_lam_bai ls
        INNER JOIN Scores s ON ls.id = s.lich_su_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO



CREATE or ALTER TRIGGER dbo.tr_lich_su_lam_bai_prevent_over_attempts
ON dbo.lich_su_lam_bai
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- If any inserted row references a quiz where the current max(lan) >= allowed attempts, abort
    IF EXISTS (
        SELECT 1
        FROM (
            SELECT DISTINCT i.lop_hoc_id, i.ten_quiz, i.hoc_vien_id
            FROM inserted i
        ) AS ins
        INNER JOIN dbo.quiz q
            ON q.lop_hoc_id = ins.lop_hoc_id
            AND q.ten_quiz = ins.ten_quiz
        CROSS APPLY (
            SELECT ISNULL(MAX(l.lan), 0) AS maxLan
            FROM dbo.lich_su_lam_bai l
            WHERE l.lop_hoc_id = ins.lop_hoc_id
              AND l.ten_quiz = ins.ten_quiz
              AND l.hoc_vien_id = ins.hoc_vien_id
        ) AS cur
        WHERE q.so_lan_duoc_lam IS NOT NULL
          AND cur.maxLan >= q.so_lan_duoc_lam
    )
        BEGIN
            ;THROW 51000, 'Maximum number of attempts reached for one or more inserted records. Insert aborted.', 1;
        END
    -- Otherwise perform the insert
    INSERT INTO dbo.lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    SELECT i.id, i.lop_hoc_id, i.ten_quiz, i.lan, i.diem, i.thoi_gian_bat_dau, i.thoi_gian_ket_thuc, i.hoc_vien_id
    FROM inserted i;
END;

GO
