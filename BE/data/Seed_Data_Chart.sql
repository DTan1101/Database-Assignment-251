USE TutorSS;
GO

PRINT '=== BẮT ĐẦU TẠO DỮ LIỆU ĐẦY ĐỦ CHO 3 LỚP (TOÁN - LÝ - ANH) ===';

-- =============================================================
-- PHẦN 1: KHÔI PHỤC HẠ TẦNG (ADMIN, GIA SƯ, MÔN HỌC, PHỤ HUYNH)
-- =============================================================

-- 1. Admin & Phụ huynh
IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = 1)
    INSERT INTO users (user_id, phone, password) VALUES (1, '0909000000', 'admin');
IF NOT EXISTS (SELECT 1 FROM admin WHERE admin_id = 1)
    INSERT INTO admin (admin_id, ho_ten) VALUES (1, N'Admin Hệ Thống');

IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = 930)
    INSERT INTO users (user_id, phone, password) VALUES (930, '0900999999', 'parent123');
IF NOT EXISTS (SELECT 1 FROM phu_huynh WHERE phu_huynh_id = 930)
    INSERT INTO phu_huynh (phu_huynh_id, dia_chi) VALUES (930, N'TP.HCM');

-- 2. Môn Học (Toán, Lý, Anh)
IF NOT EXISTS (SELECT 1 FROM mon_hoc WHERE mon_hoc_id = 100) INSERT INTO mon_hoc VALUES (100, N'Toán Học');
IF NOT EXISTS (SELECT 1 FROM mon_hoc WHERE mon_hoc_id = 101) INSERT INTO mon_hoc VALUES (101, N'Vật Lý');
IF NOT EXISTS (SELECT 1 FROM mon_hoc WHERE mon_hoc_id = 103) INSERT INTO mon_hoc VALUES (103, N'Tiếng Anh');

-- 3. Gia Sư (Tạo 2 người để chia nhau dạy 3 lớp)
IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = 11)
    INSERT INTO users (user_id, phone, password) VALUES (11, '0918000002', 'gs1');
IF NOT EXISTS (SELECT 1 FROM gia_su WHERE gia_su_id = 11)
    INSERT INTO gia_su (gia_su_id, ho_ten, so_cccd, email, tinh_thanh_day) VALUES (11, N'Trần Minh Hiếu', '079111', 'hieu@mail', N'TP.HCM');

IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = 12)
    INSERT INTO users (user_id, phone, password) VALUES (12, '0918000003', 'gs2');
IF NOT EXISTS (SELECT 1 FROM gia_su WHERE gia_su_id = 12)
    INSERT INTO gia_su (gia_su_id, ho_ten, so_cccd, email, tinh_thanh_day) VALUES (12, N'Lê Thị Thu Hà', '079222', 'ha@mail', N'TP.HCM');

PRINT '--- Đã xong hạ tầng ---';

-- =============================================================
-- PHẦN 2: TẠO 3 LỚP HỌC, QUIZ VÀ GẮN MÔN (QUAN TRỌNG)
-- =============================================================

-- A. LỚP 1001 (TOÁN 12 - Gia sư 11)
IF EXISTS (SELECT 1 FROM lop_hoc WHERE lop_hoc_id = 1001)
    UPDATE lop_hoc SET gia_su_id = 11, trang_thai_giao = N'Đã giao', muc_luong = 4000000 WHERE lop_hoc_id = 1001;
ELSE
    INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, so_buoi, lop_day, thong_tin, yeu_cau)
    VALUES (1001, 1, 11, N'Q.10', N'Đã giao', 4000000, 2, N'Lớp 12', N'Toán Cơ Bản', N'Vui vẻ');

-- B. LỚP 1002 (LÝ 10 - Gia sư 11)
IF EXISTS (SELECT 1 FROM lop_hoc WHERE lop_hoc_id = 1002)
    UPDATE lop_hoc SET gia_su_id = 11, trang_thai_giao = N'Đã giao', muc_luong = 4500000 WHERE lop_hoc_id = 1002;
ELSE
    INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, so_buoi, lop_day, thong_tin, yeu_cau)
    VALUES (1002, 1, 11, N'Q.3', N'Đã giao', 4500000, 2, N'Lớp 10', N'Lý Nâng Cao', N'Khó');

-- C. LỚP 1003 (ANH 12 - Gia sư 12)
IF EXISTS (SELECT 1 FROM lop_hoc WHERE lop_hoc_id = 1003)
    UPDATE lop_hoc SET gia_su_id = 12, trang_thai_giao = N'Đã giao', muc_luong = 5000000 WHERE lop_hoc_id = 1003;
ELSE
    INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, so_buoi, lop_day, thong_tin, yeu_cau)
    VALUES (1003, 1, 12, N'Q.5', N'Đã giao', 5000000, 3, N'Lớp 12', N'IELTS', N'Giỏi');

-- D. LIÊN KẾT MÔN HỌC (Bảng DAY - Xóa đi tạo lại cho chắc)
DELETE FROM day WHERE lop_hoc_id IN (1001, 1002, 1003);
INSERT INTO day (lop_hoc_id, mon_hoc_id) VALUES (1001, 100); -- 1001 học Toán
INSERT INTO day (lop_hoc_id, mon_hoc_id) VALUES (1002, 101); -- 1002 học Lý
INSERT INTO day (lop_hoc_id, mon_hoc_id) VALUES (1003, 103); -- 1003 học Anh

-- E. TẠO QUIZ (Đảm bảo mỗi lớp có ít nhất 1 quiz)
DELETE FROM quiz WHERE lop_hoc_id IN (1001, 1002, 1003); -- Reset quiz để tránh trùng tên
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo) VALUES
(1001, N'Kiểm tra Đại số', 1, GETDATE()),
(1002, N'Kiểm tra Cơ học', 1, GETDATE()),
(1003, N'Vocabulary Test', 1, GETDATE());

PRINT '--- Đã xong cấu hình 3 Lớp ---';

-- =============================================================
-- PHẦN 3: SINH HỌC VIÊN & ĐIỂM SỐ (LOOP)
-- =============================================================

DECLARE @i INT = 1;
DECLARE @HocVienID INT;
DECLARE @Score DECIMAL(4,2);

-- Reset lịch sử làm bài của 3 lớp này để nạp mới cho sạch
DELETE FROM lich_su_lam_bai WHERE lop_hoc_id IN (1001, 1002, 1003);
DELETE FROM tham_gia WHERE lop_hoc_id IN (1001, 1002, 1003);

WHILE @i <= 30
BEGIN
    SET @HocVienID = 2000 + @i;

    -- 3.1. Tạo User & Học Viên
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = @HocVienID)
    BEGIN
        INSERT INTO users (user_id, phone, password) VALUES (@HocVienID, '0900' + CAST(@i AS NVARCHAR), '123');
        INSERT INTO hoc_vien (hoc_vien_id, ho_ten, username, phu_huynh_id)
        VALUES (@HocVienID, N'Học Viên ' + CAST(@i AS NVARCHAR), 'hv' + CAST(@i AS NVARCHAR), 930);
    END

    -- 3.2. NẠP LỚP 1001 (TOÁN - Điểm 5.0 -> 9.0)
    INSERT INTO tham_gia VALUES (1001, @HocVienID);
    SET @Score = CAST(5 + (RAND() * 4) AS DECIMAL(4,2));
    INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id)
    VALUES (30000 + @i, 1001, N'Kiểm tra Đại số', 1, @Score, GETDATE(), @HocVienID);

    -- 3.3. NẠP LỚP 1002 (LÝ - Điểm 2.0 -> 7.0)
    INSERT INTO tham_gia VALUES (1002, @HocVienID);
    SET @Score = CAST(2 + (RAND() * 5) AS DECIMAL(4,2));
    INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id)
    VALUES (40000 + @i, 1002, N'Kiểm tra Cơ học', 1, @Score, GETDATE(), @HocVienID);

    -- 3.4. NẠP LỚP 1003 (ANH - Điểm 7.5 -> 10.0)
    INSERT INTO tham_gia VALUES (1003, @HocVienID);
    SET @Score = CAST(7.5 + (RAND() * 2.5) AS DECIMAL(4,2));
    -- Fix lỗi vượt quá 10
    IF @Score > 10 SET @Score = 10;
    INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id)
    VALUES (50000 + @i, 1003, N'Vocabulary Test', 1, @Score, GETDATE(), @HocVienID);

    SET @i = @i + 1;
END

PRINT '=== HOÀN TẤT. KIỂM TRA KẾT QUẢ BÊN DƯỚI ===';
GO

-- CHẠY THỦ TỤC ĐỂ XEM KẾT QUẢ NGAY
EXEC dbo.sp_LayChiTietDiemLopHoc;