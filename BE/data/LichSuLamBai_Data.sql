-- FILE: V09_LichSuLamBai_Data.sql (ENRICHED DATA VERSION)
USE TutorSS;
GO

PRINT '=== BẮT ĐẦU NẠP DỮ LIỆU LỊCH SỬ LÀM BÀI PHONG PHÚ (V09) ===';

-- =========================================================================
-- PHẦN 1: LỚP 501 (VẬT LÝ) - Quiz: Động lực học chất điểm
-- Tình huống: Có học viên giỏi, có học viên cần thi lại
-- =========================================================================
IF EXISTS (SELECT 1 FROM quiz WHERE lop_hoc_id = 501 AND ten_quiz = N'Động lực học chất điểm')
BEGIN
    PRINT '--- Nạp dữ liệu Lý 10 (Lớp 501)...';

    -- HV 50 (Gia Bảo): Thi 2 lần, điểm tăng dần (7.5 -> 8.5)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60001, 501, N'Động lực học chất điểm', 1, 7.50, '2025-10-06 08:00:00', '2025-10-06 08:15:00', 50);

    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60002, 501, N'Động lực học chất điểm', 2, 8.50, '2025-10-07 08:00:00', '2025-10-07 08:15:00', 50);

    -- HV 51 (Ngọc Hân): Học lực trung bình (6.0)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60003, 501, N'Động lực học chất điểm', 1, 6.00, '2025-10-06 08:00:00', '2025-10-06 08:15:00', 51);

    -- HV 55 (Tấn Phát): Học yếu, thi lại vẫn thấp (3.0 -> 4.5)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60004, 501, N'Động lực học chất điểm', 1, 3.00, '2025-10-06 08:00:00', '2025-10-06 08:10:00', 55);

    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60005, 501, N'Động lực học chất điểm', 2, 4.50, '2025-10-08 08:00:00', '2025-10-08 08:15:00', 55);
END

-- =========================================================================
-- PHẦN 2: LỚP 500 (TOÁN 12) - Quiz: Kiểm tra 15p Hàm số
-- Tình huống: Lớp chọn, điểm cao
-- =========================================================================
IF EXISTS (SELECT 1 FROM quiz WHERE lop_hoc_id = 500 AND ten_quiz = N'Kiểm tra 15p Hàm số')
BEGIN
    PRINT '--- Nạp dữ liệu Toán 12 (Lớp 500)...';

    -- HV 50 (Gia Bảo - học cả Toán): Xuất sắc (10.0)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60006, 500, N'Kiểm tra 15p Hàm số', 1, 10.00, '2025-10-02 14:00:00', '2025-10-02 14:15:00', 50);

    -- HV 56 (Thùy Dương): Khá (8.0)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60007, 500, N'Kiểm tra 15p Hàm số', 1, 8.00, '2025-10-02 14:05:00', '2025-10-02 14:20:00', 56);
END

-- =========================================================================
-- PHẦN 3: LỚP 502 (TIẾNG ANH) - Quiz: Unit 1 Vocabulary
-- Tình huống: Nhiều người thi lại để lấy điểm tối đa
-- =========================================================================
IF EXISTS (SELECT 1 FROM quiz WHERE lop_hoc_id = 502 AND ten_quiz = N'Unit 1 Vocabulary')
BEGIN
    PRINT '--- Nạp dữ liệu Tiếng Anh (Lớp 502)...';

    -- HV 52 (Minh Khôi): Thi 3 lần mới đạt yêu cầu (4.0 -> 6.5 -> 9.0)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60008, 502, N'Unit 1 Vocabulary', 1, 4.00, '2025-10-01 19:00:00', '2025-10-01 19:10:00', 52);

    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60009, 502, N'Unit 1 Vocabulary', 2, 6.50, '2025-10-02 19:00:00', '2025-10-02 19:15:00', 52);

    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60010, 502, N'Unit 1 Vocabulary', 3, 9.00, '2025-10-03 19:00:00', '2025-10-03 19:12:00', 52);

    -- HV 53 (Quỳnh Anh): Giỏi (9.5)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60011, 502, N'Unit 1 Vocabulary', 1, 9.50, '2025-10-01 19:05:00', '2025-10-01 19:15:00', 53);
END

-- =========================================================================
-- PHẦN 4: LỚP 504 (VĂN 9) - Quiz: Phân tích bài thơ
-- Tình huống: Bài tự luận, làm 1 lần
-- =========================================================================
IF EXISTS (SELECT 1 FROM quiz WHERE lop_hoc_id = 504 AND ten_quiz = N'Phân tích bài thơ')
BEGIN
    PRINT '--- Nạp dữ liệu Văn 9 (Lớp 504)...';

    -- HV 54 (Đức Anh): Điểm khá (7.5)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60012, 504, N'Phân tích bài thơ', 1, 7.50, '2025-10-12 15:00:00', '2025-10-12 15:45:00', 54);

    -- HV 60 (Bảo Châu): Điểm giỏi (9.0)
    INSERT INTO [lich_su_lam_bai] (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id)
    VALUES (60013, 504, N'Phân tích bài thơ', 1, 9.00, '2025-10-12 15:00:00', '2025-10-12 15:40:00', 60);
END

PRINT '=== HOÀN TẤT NẠP DỮ LIỆU PHONG PHÚ ===';
GO