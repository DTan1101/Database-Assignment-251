/*
TYPE: SCENARIO ADD-ON DATA (RICH & DIVERSE VERSION)
PURPOSE: Tạo dữ liệu phức tạp cho Gia sư 911 (Tốt) và 912 (Tệ).
         - Nhiều Quiz, nhiều lần làm bài.
         - Có dữ liệu bỏ thi (Missing Quiz).
         - Phổ điểm rộng (0 -> 10).
*/

USE TutorSS;
GO

PRINT '=== BẮT ĐẦU NẠP DỮ LIỆU KỊCH BẢN PHONG PHÚ ===';

-- =============================================================
-- PHẦN 1: DỌN DẸP DỮ LIỆU CŨ CỦA KỊCH BẢN NÀY (Để chạy lại được nhiều lần)
-- =============================================================
PRINT '--- 1. Cleaning scenario data...';

-- Danh sách các lớp sẽ dùng cho kịch bản này (3100 -> 3299)
DECLARE @ScenarioClasses TABLE (id INT);
INSERT INTO @ScenarioClasses
SELECT lop_hoc_id FROM lop_hoc WHERE lop_hoc_id BETWEEN 3100 AND 3299;

-- Xóa dữ liệu con trước (Tránh lỗi FK)
DELETE FROM ghi_dap_an WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM lich_su_lam_bai WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM lua_chon_tra_loi WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM cau_hoi WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM quiz WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM tham_gia WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM day WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);
DELETE FROM hop_dong WHERE gia_su_id IN (911, 912);
DELETE FROM lop_hoc WHERE lop_hoc_id IN (SELECT id FROM @ScenarioClasses);

-- Xóa User kịch bản nếu đã tồn tại
DELETE FROM mon_day WHERE gia_su_id IN (911, 912);
DELETE FROM gia_su WHERE gia_su_id IN (911, 912);
DELETE FROM hoc_vien WHERE hoc_vien_id IN (950, 951, 952);
DELETE FROM users WHERE user_id IN (911, 912, 950, 951, 952);
GO

-- =============================================================
-- PHẦN 2: TẠO USER (Gia sư & 3 Học viên A, B, C)
-- =============================================================
PRINT '--- 2. Creating Users...';

-- 2.1 Gia sư
INSERT INTO [users] (user_id, phone, password) VALUES
(911, '0999000911', 'tutor11'),
(912, '0999000912', 'tutor12');

INSERT INTO [gia_su] (gia_su_id, ho_ten, so_cccd, email, tinh_thanh_day, trinh_do) VALUES
(911, N'Nguyễn Văn Xuất Sắc', '079911', 'xs@mail.com', N'TP.HCM', N'Thạc Sĩ'), -- Trend Tăng
(912, N'Trần Thị Đi Xuống', '079912', 'down@mail.com', N'TP.HCM', N'Sinh Viên'); -- Trend Giảm

INSERT INTO [mon_day] VALUES (911, 101), (912, 103);

-- 2.2 Học viên (A, B, C)
INSERT INTO [users] (user_id, phone, password) VALUES
(950, '0999000950', 'sv1'), (951, '0999000951', 'sv2'), (952, '0999000952', 'sv3');

DECLARE @PH INT = 46; -- Mượn tạm 1 phụ huynh
IF NOT EXISTS (SELECT 1 FROM phu_huynh WHERE phu_huynh_id = 46)
BEGIN
    INSERT INTO users(user_id, phone, password) VALUES (46, '0909999046', '123');
    INSERT INTO phu_huynh(phu_huynh_id, dia_chi) VALUES (46, 'HCM');
END

INSERT INTO [hoc_vien] (hoc_vien_id, ho_ten, username, phu_huynh_id) VALUES
(950, N'Học Viên A (Giỏi)', 'hva', @PH),
(951, N'Học Viên B (Khá)', 'hvb', @PH),
(952, N'Học Viên C (TB)', 'hvc', @PH);

-- =============================================================
-- PHẦN 3: KỊCH BẢN GIA SƯ 911 (TREND TĂNG - HOẠT ĐỘNG SÔI NỔI)
-- Đặc điểm: Nhiều quiz, điểm cao, ít bỏ thi.
-- =============================================================
PRINT '--- 3. Creating UP Trend (Tutor 911)...';

-- >>> LỚP 3101 (Tháng T-2): 3 Quiz
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (3101, 1, 911, N'Q.1', N'Đã giao', 5000000, N'Lớp 10', N'Lý Căn Bản', DATEADD(MONTH, -2, GETDATE()));
INSERT INTO day VALUES (3101, 101);
INSERT INTO tham_gia VALUES (3101, 950), (3101, 951); -- A và B học
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES (1, 911, DATEADD(MONTH, -2, GETDATE()), N'HĐ 3101');

-- Quiz 1: Khởi động (Điểm khá)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3101, N'Khởi động', 2, DATEADD(DAY, 7, DATEADD(MONTH, -2, GETDATE())), DATEADD(DAY, 8, DATEADD(MONTH, -2, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(31001, 3101, N'Khởi động', 1, 7.5, DATEADD(DAY, 7, DATEADD(MONTH, -2, GETDATE())), 950),
(31002, 3101, N'Khởi động', 1, 7.0, DATEADD(DAY, 7, DATEADD(MONTH, -2, GETDATE())), 951);

-- Quiz 2: Giữa kỳ (Điểm tốt lên)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3101, N'Giữa kỳ', 1, DATEADD(DAY, 15, DATEADD(MONTH, -2, GETDATE())), DATEADD(DAY, 16, DATEADD(MONTH, -2, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(31003, 3101, N'Giữa kỳ', 1, 8.5, DATEADD(DAY, 15, DATEADD(MONTH, -2, GETDATE())), 950),
(31004, 3101, N'Giữa kỳ', 1, 8.0, DATEADD(DAY, 15, DATEADD(MONTH, -2, GETDATE())), 951);

-- Quiz 3: Cuối kỳ (Điểm cao)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3101, N'Cuối kỳ', 1, DATEADD(DAY, 25, DATEADD(MONTH, -2, GETDATE())), DATEADD(DAY, 26, DATEADD(MONTH, -2, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(31005, 3101, N'Cuối kỳ', 1, 9.0, DATEADD(DAY, 25, DATEADD(MONTH, -2, GETDATE())), 950);
-- Lưu ý: HV 951 bỏ thi Quiz cuối kỳ -> Tạo chút biến động


-- >>> LỚP 3102 (Tháng T-1): 2 Quiz (Điểm rất cao)
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (3102, 1, 911, N'Q.3', N'Đã giao', 6000000, N'Lớp 11', N'Lý Nâng Cao', DATEADD(MONTH, -1, GETDATE()));
INSERT INTO day VALUES (3102, 101); INSERT INTO tham_gia VALUES (3102, 951), (3102, 952); -- B và C học
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES (1, 911, DATEADD(MONTH, -1, GETDATE()), N'HĐ 3102');

INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3102, N'Chương 1', 1, DATEADD(DAY, 10, DATEADD(MONTH, -1, GETDATE())), DATEADD(DAY, 11, DATEADD(MONTH, -1, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(31006, 3102, N'Chương 1', 1, 9.5, DATEADD(DAY, 10, DATEADD(MONTH, -1, GETDATE())), 951),
(31007, 3102, N'Chương 1', 1, 8.5, DATEADD(DAY, 10, DATEADD(MONTH, -1, GETDATE())), 952);

INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3102, N'Chương 2', 1, DATEADD(DAY, 20, DATEADD(MONTH, -1, GETDATE())), DATEADD(DAY, 21, DATEADD(MONTH, -1, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(31008, 3102, N'Chương 2', 1, 10.0, DATEADD(DAY, 20, DATEADD(MONTH, -1, GETDATE())), 951),
(31009, 3102, N'Chương 2', 1, 9.0, DATEADD(DAY, 20, DATEADD(MONTH, -1, GETDATE())), 952);


-- >>> LỚP 3104, 3105, 3106 (Tháng này): Nhận nhiều lớp, điểm tuyệt đối
DECLARE @j INT = 3104;
WHILE @j <= 3106
BEGIN
    INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
    VALUES (@j, 1, 911, N'Q.1', N'Đã giao', 7000000, N'Lớp 12', N'Luyện Thi VIP', DATEADD(DAY, -(@j-3100), GETDATE()));

    INSERT INTO day VALUES (@j, 101); INSERT INTO tham_gia VALUES (@j, 950);
    INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES (1, 911, DATEADD(DAY, -(@j-3100), GETDATE()), N'HĐ VIP');

    INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
    VALUES (@j, N'Test Đầu Vào', 1, DATEADD(DAY, 1, GETDATE()), DATEADD(DAY, 2, GETDATE()));

    INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id)
    VALUES (31000 + @j, @j, N'Test Đầu Vào', 1, 10.0, GETDATE(), 950);

    SET @j = @j + 1;
END


-- =============================================================
-- PHẦN 4: KỊCH BẢN GIA SƯ 912 (TREND GIẢM - THẢM HỌA)
-- Đặc điểm: Điểm thấp, bỏ thi hàng loạt, làm lại nhiều lần vẫn thấp.
-- =============================================================
PRINT '--- 4. Creating DOWN Trend (Tutor 912)...';

-- >>> LỚP 3201 (Tháng T-2): Bắt đầu có dấu hiệu bất ổn
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (3201, 1, 912, N'Q.7', N'Đã giao', 4000000, N'Lớp 6', N'Anh Văn', DATEADD(MONTH, -2, GETDATE()));
INSERT INTO day VALUES (3201, 103); INSERT INTO tham_gia VALUES (3201, 950), (3201, 951);
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES (1, 912, DATEADD(MONTH, -2, GETDATE()), N'HĐ 3201');

-- Quiz 1: Điểm trung bình thấp
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3201, N'Vocab 1', 1, DATEADD(DAY, 10, DATEADD(MONTH, -2, GETDATE())), DATEADD(DAY, 11, DATEADD(MONTH, -2, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(32001, 3201, N'Vocab 1', 1, 6.0, DATEADD(DAY, 10, DATEADD(MONTH, -2, GETDATE())), 950),
(32002, 3201, N'Vocab 1', 1, 5.5, DATEADD(DAY, 10, DATEADD(MONTH, -2, GETDATE())), 951);

-- Quiz 2: Bỏ thi 1 người
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3201, N'Grammar 1', 1, DATEADD(DAY, 20, DATEADD(MONTH, -2, GETDATE())), DATEADD(DAY, 21, DATEADD(MONTH, -2, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(32003, 3201, N'Grammar 1', 1, 6.5, DATEADD(DAY, 20, DATEADD(MONTH, -2, GETDATE())), 950);
-- 951 bỏ thi quiz này (Không có insert)


-- >>> LỚP 3203 (Tháng T-1): Tệ hại
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (3203, 1, 912, N'Q.7', N'Đã giao', 3500000, N'Lớp 5', N'Anh Văn TN', DATEADD(MONTH, -1, GETDATE()));
INSERT INTO day VALUES (3203, 103); INSERT INTO tham_gia VALUES (3203, 952);
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES (1, 912, DATEADD(MONTH, -1, GETDATE()), N'HĐ 3203');

-- Quiz 1: Điểm yếu (4.0)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3203, N'Midterm', 3, DATEADD(DAY, 15, DATEADD(MONTH, -1, GETDATE())), DATEADD(DAY, 16, DATEADD(MONTH, -1, GETDATE())));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(32004, 3203, N'Midterm', 1, 3.0, DATEADD(DAY, 15, DATEADD(MONTH, -1, GETDATE())), 952),
(32005, 3203, N'Midterm', 2, 4.0, DATEADD(HOUR, 1, DATEADD(DAY, 15, DATEADD(MONTH, -1, GETDATE()))), 952); -- Làm lại vẫn thấp

-- Quiz 2: Bỏ thi (Tạo quiz nhưng không ai làm) -> Missing Quiz
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3203, N'Speaking Test', 1, DATEADD(DAY, 25, DATEADD(MONTH, -1, GETDATE())), DATEADD(DAY, 26, DATEADD(MONTH, -1, GETDATE())));
-- Không có insert lịch sử làm bài -> Missing 100%


-- >>> LỚP 3204 (Tháng này): Thảm họa
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (3204, 1, 912, N'Q.7', N'Đã giao', 3000000, N'Lớp 4', N'Anh Văn Vỡ Lòng', DATEADD(DAY, -5, GETDATE()));
INSERT INTO day VALUES (3204, 103); INSERT INTO tham_gia VALUES (3204, 950), (3204, 951), (3204, 952);
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES (1, 912, DATEADD(DAY, -5, GETDATE()), N'HĐ 3204');

-- Quiz 1: Điểm liệt (0 - 2.0)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3204, N'Final Exam', 1, DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, 1, GETDATE()));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(32006, 3204, N'Final Exam', 1, 2.0, GETDATE(), 950),
(32007, 3204, N'Final Exam', 1, 1.5, GETDATE(), 951);
-- 952 bỏ thi

-- Quiz 2: Bỏ thi tập thể
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (3204, N'Bonus Quiz', 1, DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, 1, GETDATE()));
-- Không ai làm cả -> 3 Missing Quizzes

-- Update thời gian kết thúc tự động để tránh NULL
UPDATE lich_su_lam_bai
SET thoi_gian_ket_thuc = DATEADD(MINUTE, 30, thoi_gian_bat_dau)
WHERE thoi_gian_ket_thuc IS NULL;
GO

PRINT '=== NẠP DỮ LIỆU TREND PHONG PHÚ THÀNH CÔNG ===';
GO

PRINT '=== BẮT ĐẦU GÁN 3 HỌC VIÊN (950, 951, 952) VÀO LỚP 520-524 ===';

-- 1. Xóa dữ liệu tham gia cũ (nếu có) của 3 bạn này trong các lớp này
-- Để tránh lỗi "Trùng khóa chính" nếu chạy script nhiều lần
DELETE FROM tham_gia
WHERE hoc_vien_id IN (950, 951, 952)
  AND lop_hoc_id BETWEEN 520 AND 524;

-- 2. Gán lớp Random
INSERT INTO tham_gia (lop_hoc_id, hoc_vien_id)
SELECT
    ListLop.id_lop,
    ListHV.id_hv
FROM
    -- Danh sách ID lớp (lấy từ ảnh của bạn)
    (VALUES (520), (521), (522), (523), (524)) AS ListLop(id_lop)
CROSS JOIN
    -- Danh sách 3 ID học viên đã có sẵn
    (VALUES (950), (951), (952)) AS ListHV(id_hv)
WHERE
    -- Logic Random:
    -- CHECKSUM(NEWID()) sinh số ngẫu nhiên.
    -- % 10 < 7 nghĩa là xác suất ~70% sẽ được gán vào lớp.
    -- Bạn 950 (Giỏi) sẽ được ưu tiên vào tất cả các lớp để dễ test.
    (ListHV.id_hv = 950)
    OR
    (ABS(CHECKSUM(NEWID())) % 10) < 7;

PRINT '=== GÁN LỚP THÀNH CÔNG ===';
