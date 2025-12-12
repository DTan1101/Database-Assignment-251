USE TutorSS
GO

PRINT N'=== BẮT ĐẦU BƠM DỮ LIỆU (ĐIỂM >= 4) ==='
GO

-- KHỐI 1: TẮT TRIGGER
IF OBJECT_ID('dbo.tr_CalcDiem_AfterGhiDapAn_Insert', 'TR') IS NOT NULL
BEGIN
    DISABLE TRIGGER dbo.tr_CalcDiem_AfterGhiDapAn_Insert ON dbo.ghi_dap_an
    PRINT N'--- Đã tạm tắt Trigger tính điểm ---'
END
GO

-- KHỐI 2: XỬ LÝ CHÍNH
BEGIN TRY
    BEGIN TRANSACTION

    DECLARE @StartUserID INT = 5000
    DECLARE @TotalStudentsPerClass INT = 300
    DECLARE @RefPH INT = 46

    DECLARE @CurrentClassID INT
    DECLARE @TargetQuizName NVARCHAR(100)
    DECLARE @Scenario VARCHAR(20)

    DECLARE @i INT
    DECLARE @NewHV_ID INT
    DECLARE @NewHistoryID INT
    DECLARE @Diem FLOAT
    DECLARE @TimeDoQuiz DATETIME
    DECLARE @GeneratedPhone VARCHAR(20)

    DECLARE @R1 FLOAT
    DECLARE @R2 FLOAT
    DECLARE @Z FLOAT

    DECLARE @TargetClasses TABLE (ClassID INT, KichBan VARCHAR(20))
    INSERT INTO @TargetClasses VALUES
    (500, 'NORMAL'),      -- Phân bố chuẩn
    (512, 'SKEW_LEFT'),   -- Lệch trái (Giỏi)
    (524, 'SKEW_RIGHT'),  -- Lệch phải (Khá/TB)
    (516, 'UNIFORM'),     -- Phân bố đều
    (506, 'BIMODAL')      -- Hai đỉnh

    DECLARE cur_Class CURSOR FOR SELECT ClassID, KichBan FROM @TargetClasses
    OPEN cur_Class
    FETCH NEXT FROM cur_Class INTO @CurrentClassID, @Scenario

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT N'--- Dang xu ly Lop ID: ' + CAST(@CurrentClassID AS NVARCHAR(20)) + N' ---'

        SELECT TOP 1 @TargetQuizName = ten_quiz, @TimeDoQuiz = thoi_gian_mo
        FROM quiz WHERE lop_hoc_id = @CurrentClassID

        SET @i = 1
        WHILE @i <= @TotalStudentsPerClass
        BEGIN
            SET @NewHV_ID = @StartUserID + (@CurrentClassID * 100) + @i
            SET @GeneratedPhone = '099' + RIGHT('0000000' + CAST(@NewHV_ID AS VARCHAR), 7)

            -- Tạo User & Học viên nếu chưa có
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @NewHV_ID)
            BEGIN
                INSERT INTO users (user_id, phone, password)
                VALUES (@NewHV_ID, @GeneratedPhone, '123456')

                INSERT INTO hoc_vien (hoc_vien_id, ho_ten, username, phu_huynh_id)
                VALUES (@NewHV_ID, N'HV Mẫu ' + CAST(@NewHV_ID AS NVARCHAR), 'user' + CAST(@NewHV_ID AS VARCHAR), @RefPH)
            END

            -- Tham gia lớp
            IF NOT EXISTS (SELECT 1 FROM tham_gia WHERE lop_hoc_id = @CurrentClassID AND hoc_vien_id = @NewHV_ID)
            BEGIN
                INSERT INTO tham_gia (lop_hoc_id, hoc_vien_id) VALUES (@CurrentClassID, @NewHV_ID)
            END

            -- === TÍNH ĐIỂM (LOGIC MỚI: TỪ 4 ĐẾN 10) ===
            SET @R1 = RAND(CHECKSUM(NEWID()))
            SET @R2 = RAND(CHECKSUM(NEWID()))
            -- Box-Muller transform
            SET @Z = SQRT(-2 * LOG(CASE WHEN @R1 = 0 THEN 0.00001 ELSE @R1 END)) * COS(2 * 3.14159 * @R2)

            IF @Scenario = 'NORMAL'
                -- Lớp chuẩn: Trung bình 7.0 (thay vì 6.5)
                SET @Diem = 7.0 + @Z * 1.5

            ELSE IF @Scenario = 'SKEW_LEFT'
                -- Lớp Giỏi: Trung bình 8.5 (giữ nguyên, ít khi dưới 4)
                SET @Diem = 8.5 + @Z * 1.0

            ELSE IF @Scenario = 'SKEW_RIGHT'
                -- Lớp Yếu: Nâng trung bình lên 5.5 để ít bị tụt xuống dưới 4
                SET @Diem = 5.5 + @Z * 1.5

            ELSE IF @Scenario = 'UNIFORM'
                -- Lớp Đều: Random tuyến tính từ 4 đến 10 (Công thức: Min + R * (Max-Min))
                SET @Diem = 4.0 + (@R1 * 6.0)

            ELSE -- BIMODAL
                BEGIN
                    -- Đỉnh giỏi: 8.5, Đỉnh yếu: 5.0 (thay vì 3.5)
                    IF @R1 > 0.6 SET @Diem = 8.5 + @Z * 0.8
                    ELSE SET @Diem = 5.0 + @Z * 1.0
                END

            -- === CHẶN TRÊN VÀ CHẶN DƯỚI ===
            IF @Diem > 10 SET @Diem = 10
            IF @Diem < 4 SET @Diem = 4 -- [QUAN TRỌNG] Không cho dưới 4

            -- Làm tròn 0.5
            SET @Diem = ROUND(@Diem * 2, 0) / 2

            -- Insert Lịch sử
            SELECT @NewHistoryID = ISNULL(MAX(id), 0) + 1 FROM lich_su_lam_bai WITH (UPDLOCK, HOLDLOCK)

            INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
            VALUES (@NewHistoryID, @CurrentClassID, @TargetQuizName, 1, @Diem, @TimeDoQuiz, DATEADD(MINUTE, 30, @TimeDoQuiz), @NewHV_ID)

            -- Insert Ghi đáp án
            INSERT INTO ghi_dap_an (lop_hoc_id, ten_quiz, stt_quiz, lich_su_id, dap_an_cua_lan_lam_bai)
            SELECT lop_hoc_id, ten_quiz, stt, @NewHistoryID, N'A'
            FROM cau_hoi
            WHERE lop_hoc_id = @CurrentClassID AND ten_quiz = @TargetQuizName

            SET @i = @i + 1
        END
        FETCH NEXT FROM cur_Class INTO @CurrentClassID, @Scenario
    END

    CLOSE cur_Class
    DEALLOCATE cur_Class

    COMMIT TRANSACTION
    PRINT N'=== THANH CONG: DA BOM DATA (Diem tu 4-10) ==='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT N'!!! LOI: ' + ERROR_MESSAGE()
END CATCH
GO

-- KHỐI 3: BẬT LẠI TRIGGER
IF OBJECT_ID('dbo.tr_CalcDiem_AfterGhiDapAn_Insert', 'TR') IS NOT NULL
BEGIN
    ENABLE TRIGGER dbo.tr_CalcDiem_AfterGhiDapAn_Insert ON dbo.ghi_dap_an
    PRINT N'--- Da bat lai Trigger tinh diem ---'
END
GO