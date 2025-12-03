USE master;
GO

-- 1. XÓA DATABASE CŨ (NẾU CÓ) ĐỂ LÀM SẠCH TỪ ĐẦU
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TutorSS')
BEGIN
    ALTER DATABASE TutorSS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TutorSS;
END
GO

-- 2. TẠO DATABASE MỚI
CREATE DATABASE TutorSS;
GO
USE TutorSS;
GO

-- =============================================================
-- PHẦN 1: TẠO BẢNG (SCHEMA) - ĐÃ CHUẨN HÓA
-- =============================================================

CREATE TABLE [users] (
  [user_id] int PRIMARY KEY,
  [phone] nvarchar(20) UNIQUE NOT NULL, -- Dư dả cho số đt
  [password] nvarchar(255) NOT NULL
)
GO

CREATE TABLE [admin] (
  [admin_id] int PRIMARY KEY,
  [ho_ten] nvarchar(100)
)
GO
  
CREATE TABLE [phu_huynh] (
  [phu_huynh_id] int PRIMARY KEY,
  [dia_chi] nvarchar(255)
)
GO

CREATE TABLE [hoc_vien] (
  [hoc_vien_id] int PRIMARY KEY,
  [ho_ten] nvarchar(100),
  [username] nvarchar(100) UNIQUE NOT NULL,
  [phu_huynh_id] int
)
GO

CREATE TABLE [mon_hoc] (
  [mon_hoc_id] int PRIMARY KEY,
  [ten_mon_hoc] nvarchar(100)
)
GO

CREATE TABLE [gia_su] (
  [gia_su_id] int PRIMARY KEY,
  [ho_ten] nvarchar(100), -- Đã bổ sung
  [dia_chi_hien_tai] nvarchar(255),
  [nguyen_quan] nvarchar(100),
  [truong_dao_tao] nvarchar(100),
  [trinh_do] nvarchar(100),
  [nien_khoa] nvarchar(50),
  [email] nvarchar(100),
  [ngay_sinh] date,
  [nganh_hoc] nvarchar(100),
  [link_facebook] nvarchar(255),
  [tinh_thanh_day] nvarchar(100),
  [so_cccd] nvarchar(50) UNIQUE NOT NULL
)
GO

CREATE TABLE [mon_day] (
  [gia_su_id] int,
  [mon_hoc_id] int,
  PRIMARY KEY ([gia_su_id], [mon_hoc_id])
)
GO

CREATE TABLE [anh_gia_su] (
  [gia_su_id] int,
  [duong_dan_anh] nvarchar(255),
  PRIMARY KEY ([gia_su_id], [duong_dan_anh])
)
GO

CREATE TABLE [thoi_gian_day] (
  [gia_su_id] int,
  [thoi_gian] nvarchar(100),
  PRIMARY KEY ([gia_su_id], [thoi_gian])
)
GO

CREATE TABLE [khu_vuc_day] (
  [gia_su_id] int,
  [thanh_pho] nvarchar(100),
  [phuong] nvarchar(100),
  PRIMARY KEY ([gia_su_id], [thanh_pho], [phuong])
)
GO

CREATE TABLE [lop_day] (
  [gia_su_id] int,
  [lop] nvarchar(50),
  PRIMARY KEY ([gia_su_id], [lop])
)
GO

CREATE TABLE [chon_gia_su] (
  [phu_huynh_id] int,
  [gia_su_id] int,
  PRIMARY KEY ([phu_huynh_id], [gia_su_id])
)
GO

CREATE TABLE [hop_dong] (
  [admin_id] int,
  [gia_su_id] int,
  [thoi_gian_ky] datetime,
  [noi_dung_dieu_khoan] nvarchar(MAX), -- Đã sửa TEXT -> NVARCHAR(MAX)
  PRIMARY KEY ([admin_id], [gia_su_id], [thoi_gian_ky])
)
GO

CREATE TABLE [yeu_cau_them] (
  [phu_huynh_id] int,
  [chi_tiet_yeu_cau] nvarchar(255), 
  PRIMARY KEY ([phu_huynh_id], [chi_tiet_yeu_cau])
)
GO

CREATE TABLE [yeu_cau] (
  [hoc_vien_id] int,
  [phu_huynh_id] int,
  [noi_dung] nvarchar(MAX), -- Đã sửa
  [thoi_gian_gui] datetime,
  [trang_thai_xu_ly] nvarchar(100),
  [admin_id] int,
  PRIMARY KEY ([hoc_vien_id], [phu_huynh_id], [thoi_gian_gui])
)
GO

CREATE TABLE [tin_nhan] (
  [tin_nhan_id] int PRIMARY KEY,
  [nguoi_gui_id] int,
  [nguoi_nhan_id] int,
  [thoi_gian_gui] datetime,
  [thoi_gian_nhan] datetime,
  [noi_dung] nvarchar(MAX) -- Đã sửa
)
GO

CREATE TABLE [lop_hoc] (
  [lop_hoc_id] int PRIMARY KEY,
  [dia_chi] nvarchar(255),
  [trang_thai_giao] nvarchar(50),
  [thong_tin] nvarchar(MAX), -- Đã sửa
  [lop_day] nvarchar(50),
  [hinh_thuc] nvarchar(50),
  [muc_luong] decimal(18,0),
  [yeu_cau] nvarchar(MAX), -- Đã sửa
  [so_buoi] int,
  [admin_id] int,
  [gia_su_id] int -- Có thể NULL nếu chưa giao
)
GO

CREATE TABLE [day] (
  [lop_hoc_id] int,
  [mon_hoc_id] int,
  PRIMARY KEY ([lop_hoc_id], [mon_hoc_id])
)
GO

CREATE TABLE [tham_gia] (
  [lop_hoc_id] int,
  [hoc_vien_id] int,
  PRIMARY KEY ([lop_hoc_id], [hoc_vien_id])
)
GO

CREATE TABLE [sdt_lien_he_lop_hoc] (
  [lop_hoc_id] int,
  [sdt_lien_he] nvarchar(20),
  PRIMARY KEY ([lop_hoc_id], [sdt_lien_he])
)
GO

CREATE TABLE [thoi_gian_lop_hoc] (
  [lop_hoc_id] int,
  [ngay_thu] nvarchar(50),
  [gio_bat_dau] time,
  [gio_ket_thuc] time,
  PRIMARY KEY ([lop_hoc_id], [ngay_thu], [gio_bat_dau], [gio_ket_thuc])
)
GO

CREATE TABLE [quiz] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [so_lan_duoc_lam] int,
  [thoi_gian_dong] datetime,
  [thoi_gian_mo] datetime,
  PRIMARY KEY ([lop_hoc_id], [ten_quiz])
)
GO

CREATE TABLE [cau_hoi] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [stt] int,
  [cau_hoi] nvarchar(MAX), -- Đã sửa
  [dap_an] nvarchar(MAX), -- Đã sửa
  PRIMARY KEY ([lop_hoc_id], [ten_quiz], [stt])
)
GO

CREATE TABLE [lua_chon_tra_loi] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [stt] int,
  [noi_dung_lua_chon] nvarchar(255),
  PRIMARY KEY ([lop_hoc_id], [ten_quiz], [stt], [noi_dung_lua_chon])
)
GO

CREATE TABLE [lich_su_lam_bai] (
  [id] int PRIMARY KEY,
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [lan] int,
  [diem] decimal(4,2),
  [thoi_gian_bat_dau] datetime,
  [thoi_gian_ket_thuc] datetime,
  [hoc_vien_id] int
)
GO

CREATE TABLE [ghi_dap_an] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [stt_quiz] int,
  [lich_su_id] int,
  [dap_an_cua_lan_lam_bai] nvarchar(MAX), -- Đã sửa
  PRIMARY KEY ([lop_hoc_id], [ten_quiz], [stt_quiz], [lich_su_id])
)
GO

CREATE TABLE [tai_lieu] (
  [tai_lieu_id] int PRIMARY KEY,
  [lop_hoc_id] int,
  [gia_su_id] int,
  [tac_gia] nvarchar(100),
  [ten_tai_lieu] nvarchar(255),
  [link_tai_lieu] nvarchar(255),
  [mon_hoc_id] int
)
GO

CREATE TABLE [lien_quan] (
  [tai_lieu_goc_id] int,
  [tai_lieu_lien_quan_id] int,
  [mo_ta] nvarchar(MAX),
  PRIMARY KEY ([tai_lieu_goc_id], [tai_lieu_lien_quan_id])
)
GO

-- TẠO KHÓA NGOẠI (Đã gộp đúng chuẩn)
ALTER TABLE [admin] ADD FOREIGN KEY ([admin_id]) REFERENCES [users] ([user_id]);
ALTER TABLE [phu_huynh] ADD FOREIGN KEY ([phu_huynh_id]) REFERENCES [users] ([user_id]);
ALTER TABLE [hoc_vien] ADD FOREIGN KEY ([hoc_vien_id]) REFERENCES [users] ([user_id]);
ALTER TABLE [hoc_vien] ADD FOREIGN KEY ([phu_huynh_id]) REFERENCES [phu_huynh] ([phu_huynh_id]);
ALTER TABLE [gia_su] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [users] ([user_id]);
ALTER TABLE [mon_day] ADD FOREIGN KEY ([mon_hoc_id]) REFERENCES [mon_hoc] ([mon_hoc_id]);
ALTER TABLE [mon_day] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [anh_gia_su] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [thoi_gian_day] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [khu_vuc_day] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [lop_day] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [chon_gia_su] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [chon_gia_su] ADD FOREIGN KEY ([phu_huynh_id]) REFERENCES [phu_huynh] ([phu_huynh_id]);
ALTER TABLE [hop_dong] ADD FOREIGN KEY ([admin_id]) REFERENCES [admin] ([admin_id]);
ALTER TABLE [hop_dong] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [yeu_cau_them] ADD FOREIGN KEY ([phu_huynh_id]) REFERENCES [phu_huynh] ([phu_huynh_id]);
ALTER TABLE [yeu_cau] ADD FOREIGN KEY ([phu_huynh_id]) REFERENCES [phu_huynh] ([phu_huynh_id]);
ALTER TABLE [yeu_cau] ADD FOREIGN KEY ([admin_id]) REFERENCES [admin] ([admin_id]);
ALTER TABLE [yeu_cau] ADD FOREIGN KEY ([hoc_vien_id]) REFERENCES [hoc_vien] ([hoc_vien_id]);
ALTER TABLE [tin_nhan] ADD FOREIGN KEY ([nguoi_gui_id]) REFERENCES [users] ([user_id]);
ALTER TABLE [tin_nhan] ADD FOREIGN KEY ([nguoi_nhan_id]) REFERENCES [users] ([user_id]);
ALTER TABLE [lop_hoc] ADD FOREIGN KEY ([admin_id]) REFERENCES [admin] ([admin_id]);
ALTER TABLE [lop_hoc] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [day] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [day] ADD FOREIGN KEY ([mon_hoc_id]) REFERENCES [mon_hoc] ([mon_hoc_id]);
ALTER TABLE [tham_gia] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [tham_gia] ADD FOREIGN KEY ([hoc_vien_id]) REFERENCES [hoc_vien] ([hoc_vien_id]);
ALTER TABLE [sdt_lien_he_lop_hoc] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [thoi_gian_lop_hoc] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [tai_lieu] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [tai_lieu] ADD FOREIGN KEY ([gia_su_id]) REFERENCES [gia_su] ([gia_su_id]);
ALTER TABLE [tai_lieu] ADD FOREIGN KEY ([mon_hoc_id]) REFERENCES [mon_hoc] ([mon_hoc_id]);
ALTER TABLE [lien_quan] ADD FOREIGN KEY ([tai_lieu_goc_id]) REFERENCES [tai_lieu] ([tai_lieu_id]);
ALTER TABLE [lien_quan] ADD FOREIGN KEY ([tai_lieu_lien_quan_id]) REFERENCES [tai_lieu] ([tai_lieu_id]);

-- Khóa ngoại phức hợp
ALTER TABLE [quiz] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [cau_hoi] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz]) REFERENCES [quiz] ([lop_hoc_id], [ten_quiz]);
ALTER TABLE [lua_chon_tra_loi] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz], [stt]) REFERENCES [cau_hoi] ([lop_hoc_id], [ten_quiz], [stt]);
ALTER TABLE [lich_su_lam_bai] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz]) REFERENCES [quiz] ([lop_hoc_id], [ten_quiz]);
ALTER TABLE [lich_su_lam_bai] ADD FOREIGN KEY ([hoc_vien_id]) REFERENCES [hoc_vien] ([hoc_vien_id]);
ALTER TABLE [ghi_dap_an] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz], [stt_quiz]) REFERENCES [cau_hoi] ([lop_hoc_id], [ten_quiz], [stt]);
ALTER TABLE [ghi_dap_an] ADD FOREIGN KEY ([lich_su_id]) REFERENCES [lich_su_lam_bai] ([id]);
GO

-- =============================================================
-- PHẦN 2: DỮ LIỆU MẪU (INSERT DATA)
-- =============================================================

-- 1. TẠO USERS (Cần tạo 7 người dùng để test)
-- ID 1: Admin
-- ID 2, 3: Gia sư
-- ID 4, 5: Phụ huynh
-- ID 6, 7: Học viên

INSERT INTO [users] (user_id, phone, password) VALUES 
(1, '0900111111', 'adminpass'), -- Admin
(2, '0900222222', 'tutor1pass'), -- Gia sư Toán
(3, '0900333333', 'tutor2pass'), -- Gia sư Anh
(4, '0900444444', 'parent1pass'), -- Phụ huynh A
(5, '0900555555', 'parent2pass'), -- Phụ huynh B
(6, '0900666666', 'student1pass'), -- Học viên A
(7, '0900777777', 'student2pass'); -- Học viên B
GO

-- 2. PHÂN QUYỀN VÀ THÔNG TIN CHI TIẾT

-- Admin
INSERT INTO [admin] (admin_id, ho_ten) VALUES (1, N'Nguyễn Quản Trị');

-- Gia sư
INSERT INTO [gia_su] (gia_su_id, ho_ten, so_cccd, email, tinh_thanh_day, truong_dao_tao, trinh_do) VALUES 
(2, N'Trần Minh Toán', '079123000001', 'minh.toan@email.com', N'TP.HCM', N'ĐH Sư Phạm', N'Cử nhân'),
(3, N'Lê Thị Anh Văn', '079123000002', 'le.anh@email.com', N'TP.HCM', N'ĐH KHXH&NV', N'Thạc sĩ');

-- Phụ huynh
INSERT INTO [phu_huynh] (phu_huynh_id, dia_chi) VALUES 
(4, N'123 CMT8, Q.10, TP.HCM'),
(5, N'456 Võ Văn Ngân, Thủ Đức');

-- Học viên (Liên kết với phụ huynh)
INSERT INTO [hoc_vien] (hoc_vien_id, ho_ten, username, phu_huynh_id) VALUES 
(6, N'Nguyễn Bé Tí', 'beti2025', 4), -- Con của phụ huynh 4
(7, N'Trần Tí Nị', 'tini2025', 5); -- Con của phụ huynh 5
GO

-- 3. MÔN HỌC
INSERT INTO [mon_hoc] (mon_hoc_id, ten_mon_hoc) VALUES 
(101, N'Toán Lớp 12'),
(102, N'Tiếng Anh Giao Tiếp'),
(103, N'Vật Lý Lớp 10');
GO

-- 4. GIA SƯ ĐĂNG KÝ DẠY
INSERT INTO [mon_day] (gia_su_id, mon_hoc_id) VALUES 
(2, 101), -- Ông Toán dạy Toán
(2, 103), -- Ông Toán dạy thêm Lý
(3, 102); -- Bà Anh dạy Anh
GO

-- 5. LỚP HỌC (Tạo 2 lớp: 1 lớp đã có người dạy, 1 lớp đang tìm)

-- Lớp 501: Toán 12 - Đã giao cho Gia sư 2 (Ông Toán)
INSERT INTO [lop_hoc] (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, so_buoi, thong_tin, lop_day) VALUES 
(501, 1, 2, N'Nhà Phụ huynh A, Q.10', N'Đã giao', 5000000, 3, N'Yêu cầu dạy kỹ hình học', N'Lớp 12');

-- Lớp 502: Tiếng Anh - Chưa giao (Đang tìm gia sư)
INSERT INTO [lop_hoc] (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, so_buoi, thong_tin, lop_day) VALUES 
(502, 1, NULL, N'Nhà Phụ huynh B, Thủ Đức', N'Chưa giao', 3000000, 2, N'Luyện thi IELTS 6.0', N'Lớp 10');

-- Liên kết lớp với môn học
INSERT INTO [day] (lop_hoc_id, mon_hoc_id) VALUES (501, 101), (502, 102);
GO

-- 6. HỌC VIÊN THAM GIA LỚP
INSERT INTO [tham_gia] (lop_hoc_id, hoc_vien_id) VALUES (501, 6); -- Bé Tí học Toán lớp 501
GO

-- 7. QUIZ VÀ CÂU HỎI (Test khóa chính phức hợp)

-- Tạo Quiz cho lớp 501
INSERT INTO [quiz] (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong) VALUES 
(501, N'KiemTra15Phut', 3, '2025-12-01 08:00:00', '2025-12-01 09:00:00');

-- Câu hỏi 1
INSERT INTO [cau_hoi] (lop_hoc_id, ten_quiz, stt, cau_hoi, dap_an) VALUES 
(501, N'KiemTra15Phut', 1, N'Đạo hàm của x^2 là gì?', N'2x');
INSERT INTO [lua_chon_tra_loi] VALUES 
(501, N'KiemTra15Phut', 1, N'A. 2x'),
(501, N'KiemTra15Phut', 1, N'B. x'),
(501, N'KiemTra15Phut', 1, N'C. 2');

-- Câu hỏi 2
INSERT INTO [cau_hoi] (lop_hoc_id, ten_quiz, stt, cau_hoi, dap_an) VALUES 
(501, N'KiemTra15Phut', 2, N'1+1 = ?', N'2');
INSERT INTO [lua_chon_tra_loi] VALUES 
(501, N'KiemTra15Phut', 2, N'A. 3'),
(501, N'KiemTra15Phut', 2, N'B. 2');
GO

-- =============================================================
-- KIỂM TRA KẾT QUẢ
-- =============================================================
SELECT 'USERS' as TableName, * FROM users;
SELECT 'GIA SU' as TableName, * FROM gia_su;
SELECT 'LOP HOC' as TableName, * FROM lop_hoc;