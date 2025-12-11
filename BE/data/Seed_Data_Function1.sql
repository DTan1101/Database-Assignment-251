/*
TYPE: FINAL MASTER DATA SCRIPT (MERGED & OPTIMIZED)
FILES MERGED: V01, V09, V12, V13
PURPOSE: Nạp dữ liệu mẫu toàn diện cho:
         1. Demo Web App (Lớp 1001)
         2. Báo cáo KPI Gia sư (Gia sư 11, 12)
         3. Biểu đồ tiến độ học tập (Lớp 501, 502)
         4. Phân trang & Tìm kiếm (Lớp 2000+)
NOTE: Chạy file này SAU KHI chạy các file tạo Bảng, Procedure và Trigger.
*/

USE TutorSS;
GO

PRINT '=== BẮT ĐẦU QUÁ TRÌNH NẠP MASTER DATA (ALL IN ONE) ===';

-- =============================================================
-- PHẦN 0: DỌN DẸP DỮ LIỆU CŨ (CLEANUP)
-- =============================================================
PRINT '--- 0. Cleaning old data...';
-- Tắt check khóa ngoại tạm thời để xóa nhanh
ALTER TABLE lich_su_lam_bai NOCHECK CONSTRAINT ALL;
ALTER TABLE ghi_dap_an NOCHECK CONSTRAINT ALL;

-- Xóa theo thứ tự ngược của quan hệ (Con xóa trước, Cha xóa sau)
DELETE FROM lien_quan;
DELETE FROM tai_lieu;
DELETE FROM ghi_dap_an;
DELETE FROM lich_su_lam_bai;
DELETE FROM lua_chon_tra_loi;
DELETE FROM cau_hoi;
DELETE FROM quiz;
DELETE FROM thoi_gian_lop_hoc;
DELETE FROM sdt_lien_he_lop_hoc;
DELETE FROM tham_gia;
DELETE FROM day;
DELETE FROM lop_hoc;
DELETE FROM tin_nhan;
DELETE FROM yeu_cau;
DELETE FROM yeu_cau_them;
DELETE FROM hop_dong;
DELETE FROM chon_gia_su;
DELETE FROM lop_day;
DELETE FROM khu_vuc_day;
DELETE FROM thoi_gian_day;
DELETE FROM anh_gia_su;
DELETE FROM mon_day;
DELETE FROM gia_su;
DELETE FROM mon_hoc;
DELETE FROM hoc_vien;
DELETE FROM phu_huynh;
DELETE FROM admin;
DELETE FROM users;

-- Bật lại check khóa ngoại
ALTER TABLE lich_su_lam_bai CHECK CONSTRAINT ALL;
ALTER TABLE ghi_dap_an CHECK CONSTRAINT ALL;
GO

-- =============================================================
-- PHẦN 1: HẠ TẦNG (USERS, SUBJECTS)
-- =============================================================
PRINT '--- 1. Creating Infrastructure...';

-- 1.1 MÔN HỌC
INSERT INTO [mon_hoc] (mon_hoc_id, ten_mon_hoc) VALUES
(100, N'Toán Học'), (101, N'Vật Lý'), (102, N'Hóa Học'),
(103, N'Tiếng Anh'), (104, N'Ngữ Văn'), (105, N'Sinh Học'), (115, N'IELTS');

-- 1.2 ADMIN & PHỤ HUYNH CHUNG
INSERT INTO [users] (user_id, phone, password) VALUES
(1, '0900000001', 'admin123'),    -- Admin Hệ thống
(900, '0999999999', 'admin123'), -- Admin Demo
(930, '0999111222', 'parent123'); -- Phụ huynh Vinhome

INSERT INTO [admin] (admin_id, ho_ten) VALUES (1, N'System Admin'), (900, N'Admin Demo Web');
INSERT INTO [phu_huynh] (phu_huynh_id, dia_chi) VALUES (930, N'Biệt thự Vinhome, Q1');

-- 1.3 GIA SƯ (Gộp từ các file)
-- GS 11, 12: Dùng cho KPI
-- GS 910, 911: Dùng cho Demo Web
INSERT INTO [users] (user_id, phone, password) VALUES
(11, '0912000011', 'tutor11'),
(12, '0912000012', 'tutor12'),
(910, '0999888777', 'tutorPro'),
(911, '0999888666', 'tutorNew');

INSERT INTO [gia_su] (gia_su_id, ho_ten, so_cccd, email, tinh_thanh_day, trinh_do) VALUES
(11, N'Nguyễn Văn Xuất Sắc', '079111', 'xs@mail.com', N'TP.HCM', N'Thạc Sĩ'),
(12, N'Trần Thị Cần Cố Gắng', '079112', 'try@mail.com', N'TP.HCM', N'Sinh Viên'),
(910, N'Nguyễn Văn Pro', '001999', 'pro@email.com', N'TP.HCM', N'Tiến Sĩ'),
(911, N'Trần Thị Mới', '001998', 'new@email.com', N'Hà Nội', N'Cử Nhân');

-- Đăng ký môn dạy
INSERT INTO [mon_day] VALUES (11, 100), (11, 101), (12, 103), (910, 100), (911, 104);

-- 1.4 HỌC VIÊN (Gộp từ các file)
INSERT INTO [users] (user_id, phone, password) VALUES
(50, '0944000050', 'sv50'), (52, '0944000052', 'sv52'), (55, '0944000055', 'sv55'), -- Nhóm 5x (Rich History)
(950, '0999000001', 'chamchi'), (951, '0999000002', 'sasut'); -- Nhóm 95x (Demo Web)

INSERT INTO [hoc_vien] (hoc_vien_id, ho_ten, username, phu_huynh_id) VALUES
(50, N'Nguyễn Gia Bảo', 'giabao', 930),
(52, N'Lê Minh Khôi', 'minhkhoi', 930),
(55, N'Phạm Tấn Phát', 'tanphat', 930),
(950, N'Lê Chăm Chỉ', 'chamchi', 930),
(951, N'Phạm Sa Sút', 'sasut', 930);

-- =============================================================
-- PHẦN 2: KỊCH BẢN DEMO WEB APP (DATA_TEST.sql)
-- Lớp 1001: Đầy đủ Quiz quá khứ, hiện tại, tương lai
-- =============================================================
PRINT '--- 2. Creating Web App Scenario (Class 1001)...';

-- 2.1 Tạo Lớp
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (1001, 900, 910, N'Q.1', N'Đã giao', 10000000, N'Lớp 12', N'Luyện thi Đại học VIP', DATEADD(MONTH, -2, GETDATE()));

INSERT INTO day VALUES (1001, 100); -- Môn Toán
INSERT INTO tham_gia VALUES (1001, 950), (1001, 951); -- Chăm Chỉ & Sa Sút tham gia

-- 2.2 Tạo Hợp đồng
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan)
VALUES (900, 910, DATEADD(MONTH, -2, GETDATE()), N'HĐ VIP Lớp 1001');

-- 2.3 Tạo Quiz (Timeline động theo GETDATE)
-- Quiz 1: Quá khứ xa
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (1001, N'Quiz 1 - Đầu Khóa', 1, DATEADD(DAY, -40, GETDATE()), DATEADD(DAY, -39, GETDATE()));

-- Quiz 2: Vừa xong
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (1001, N'Quiz 2 - Giữa Kỳ', 1, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -9, GETDATE()));

-- Quiz 3: Đang mở (Dùng để test làm bài)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (1001, N'Quiz 3 - Hiện Tại', 10, DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, 2, GETDATE()));

-- 2.4 Câu hỏi & Đáp án
INSERT INTO cau_hoi (lop_hoc_id, ten_quiz, stt, cau_hoi, dap_an) VALUES
(1001, N'Quiz 3 - Hiện Tại', 1, N'1 + 1 = ?', N'2'),
(1001, N'Quiz 3 - Hiện Tại', 2, N'Thủ đô VN?', N'Hà Nội');

-- 2.5 Lịch sử làm bài (HV 950 Giỏi, 951 Kém)
-- HV 950: 9.0 -> 9.5
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(90001, 1001, N'Quiz 1 - Đầu Khóa', 1, 9.0, DATEADD(DAY, -40, GETDATE()), 950),
(90002, 1001, N'Quiz 2 - Giữa Kỳ', 1, 9.5, DATEADD(DAY, -10, GETDATE()), 950);

-- HV 951: 5.0 -> 0.0
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(90003, 1001, N'Quiz 1 - Đầu Khóa', 1, 5.0, DATEADD(DAY, -40, GETDATE()), 951),
(90004, 1001, N'Quiz 2 - Giữa Kỳ', 1, 0.0, DATEADD(DAY, -10, GETDATE()), 951);

-- =============================================================
-- PHẦN 3: KỊCH BẢN REPORT KPI (Seed_Data_Function1.sql)
-- Gia sư 11 (Tốt) vs Gia sư 12 (Kém)
-- =============================================================
PRINT '--- 3. Creating KPI Scenario (Tutors 11, 12)...';

-- 3.1 Lớp của GS 11 (Nhiều lớp, lương cao)
-- Lớp 1101: Đã kết thúc (để tính Doanh thu)
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (1101, 1, 11, N'Q.3', N'Đã giao', 8000000, N'Lớp 12', N'Toán Cao Cấp', DATEADD(DAY, -35, GETDATE()));
INSERT INTO day VALUES (1101, 100);

-- Lớp 1102: Mới nhận (để tính KPI Lớp mới)
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (1102, 1, 11, N'Q.5', N'Đã giao', 6000000, N'Lớp 10', N'Lý Cơ Bản', DATEADD(DAY, -5, GETDATE()));
INSERT INTO day VALUES (1102, 101);

-- 3.2 Lớp của GS 12 (Ít lớp)
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (1201, 1, 12, N'Q.7', N'Đã giao', 3000000, N'Lớp 6', N'Anh Văn Nhi Đồng', DATEADD(DAY, -15, GETDATE()));
INSERT INTO day VALUES (1201, 103);

-- 3.3 Hợp đồng tương ứng
INSERT INTO hop_dong (admin_id, gia_su_id, thoi_gian_ky, noi_dung_dieu_khoan) VALUES
(1, 11, DATEADD(DAY, -40, GETDATE()), N'HĐ Lớp 1101'),
(1, 11, DATEADD(DAY, -7, GETDATE()), N'HĐ Lớp 1102'),
(1, 12, DATEADD(DAY, -20, GETDATE()), N'HĐ Lớp 1201');

-- 3.4 Học viên tham gia để tính KPI sĩ số
INSERT INTO tham_gia VALUES (1101, 50), (1101, 52); -- Lớp 1101 có 2 HV
INSERT INTO tham_gia VALUES (1102, 55); -- Lớp 1102 có 1 HV

-- 3.5 Điểm số để tính KPI Chất lượng
-- Lớp 1101: Điểm cao (KPI tốt)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong) VALUES (1101, N'Q1', 1, DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -4, GETDATE()));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(11001, 1101, N'Q1', 1, 9.0, DATEADD(DAY, -5, GETDATE()), 50),
(11002, 1101, N'Q1', 1, 8.5, DATEADD(DAY, -5, GETDATE()), 52);

-- Lớp 1201: Điểm thấp (KPI kém)
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong) VALUES (1201, N'Q1', 1, DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -4, GETDATE()));
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(12001, 1201, N'Q1', 1, 4.0, DATEADD(DAY, -5, GETDATE()), 50); -- Dùng tạm HV 50 tham gia lớp này (dù logic tham gia chưa insert, nhưng để test KPI thì ok)
INSERT INTO tham_gia VALUES (1201, 50);

-- =============================================================
-- PHẦN 4: KỊCH BẢN TIẾN ĐỘ HỌC TẬP (LichSuLamBai_Data.sql)
-- Demo biểu đồ tăng trưởng điểm
-- =============================================================
PRINT '--- 4. Creating Progress Chart Scenario (Classes 501, 502)...';

-- 4.1 Lớp 501 (Vật Lý)
INSERT INTO lop_hoc (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
VALUES (501, 1, 11, N'Q.10', N'Đã giao', 5000000, N'Lớp 10', N'Lý Nâng Cao', DATEADD(MONTH, -2, GETDATE()));
INSERT INTO day VALUES (501, 101);
INSERT INTO tham_gia VALUES (501, 50), (501, 55);

-- Quiz: Động lực học
INSERT INTO quiz (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong)
VALUES (501, N'Động lực học chất điểm', 5, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -5, GETDATE()));

-- HV 50: Thi 2 lần, điểm tăng (7.5 -> 8.5)
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(60001, 501, N'Động lực học chất điểm', 1, 7.50, DATEADD(HOUR, -2, DATEADD(DAY, -10, GETDATE())), 50),
(60002, 501, N'Động lực học chất điểm', 2, 8.50, DATEADD(HOUR, -1, DATEADD(DAY, -10, GETDATE())), 50);

-- HV 55: Thi lại vẫn thấp (3.0 -> 4.5)
INSERT INTO lich_su_lam_bai (id, lop_hoc_id, ten_quiz, lan, diem, thoi_gian_bat_dau, hoc_vien_id) VALUES
(60004, 501, N'Động lực học chất điểm', 1, 3.00, DATEADD(HOUR, -2, DATEADD(DAY, -10, GETDATE())), 55),
(60005, 501, N'Động lực học chất điểm', 2, 4.50, DATEADD(HOUR, -1, DATEADD(DAY, -10, GETDATE())), 55);


-- =============================================================
-- PHẦN 5: MASS DATA (Seed_Data_Chart.sql)
-- Tạo 50 lớp học tự động để test phân trang
-- =============================================================
PRINT '--- 5. Generating Mass Data for Pagination...';

DECLARE @i INT = 2000;
DECLARE @max_i INT = 2050;

WHILE @i <= @max_i
BEGIN
    INSERT INTO [lop_hoc] (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, lop_day, thong_tin, thoi_gian_nhan_lop)
    VALUES (
        @i, 1, NULL, -- Chưa giao
        N'Địa chỉ Auto ' + CAST(@i AS NVARCHAR),
        N'Chưa giao',
        3000000 + (@i % 10) * 100000,
        N'Lớp ' + CAST((6 + (@i % 7)) AS NVARCHAR),
        N'Lớp tự động số ' + CAST(@i AS NVARCHAR),
        NULL
    );

    INSERT INTO [day] VALUES (@i, 100 + (@i % 6)); -- Random môn

    SET @i = @i + 1;
END

PRINT '=== NẠP DỮ LIỆU HOÀN TẤT ===';
GO