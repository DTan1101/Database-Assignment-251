USE master;
GO

-- 1. XÓA DATABASE CŨ NẾU TỒN TẠI
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
-- PHẦN 1: TẠO BẢNG & RÀNG BUỘC (SCHEMA)
-- =============================================================

CREATE TABLE [users] (
  [user_id] int PRIMARY KEY,
  [phone] nvarchar(20) UNIQUE NOT NULL,
  [password] nvarchar(255) NOT NULL,

  -- [RB] Phone: bắt đầu bằng 0, dài 10-11, chỉ chứa số
  CONSTRAINT CK_users_phone_format CHECK (
      [phone] LIKE '0%' AND
      LEN([phone]) BETWEEN 10 AND 11 AND
      [phone] NOT LIKE '%[^0-9]%'
  ),
  -- [RB] Password: tối thiểu 6 ký tự
  CONSTRAINT CK_users_password_len CHECK (LEN([password]) >= 6)
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
  [ten_mon_hoc] nvarchar(100) NOT NULL
)
GO

CREATE TABLE [gia_su] (
  [gia_su_id] int PRIMARY KEY,
  [ho_ten] nvarchar(100),
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
  [so_cccd] nvarchar(50) UNIQUE NOT NULL,

  -- [RB] CCCD: đúng 12 số, không chứa ký tự lạ
  CONSTRAINT CK_gia_su_cccd_format CHECK (LEN([so_cccd]) = 12 AND [so_cccd] NOT LIKE '%[^0-9]%'),
  -- [RB] Email: format cơ bản (cho phép NULL)
  CONSTRAINT CK_gia_su_email_format CHECK ([email] IS NULL OR ([email] LIKE '%_@_%._%')),
  -- [RB] Ngày sinh: phải nhỏ hơn ngày hiện tại
  CONSTRAINT CK_gia_su_ngay_sinh_past CHECK ([ngay_sinh] IS NULL OR [ngay_sinh] < CONVERT(date, GETDATE()))
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
  [thoi_gian_ky] datetime DEFAULT GETDATE(),
  [noi_dung_dieu_khoan] nvarchar(MAX),
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
  [noi_dung] nvarchar(MAX),
  [thoi_gian_gui] datetime DEFAULT GETDATE(),
  [trang_thai_xu_ly] nvarchar(100),
  [admin_id] int,
  PRIMARY KEY ([hoc_vien_id], [phu_huynh_id], [thoi_gian_gui]),

  -- [RB] Trạng thái yêu cầu
  CONSTRAINT CK_yeu_cau_trang_thai CHECK ([trang_thai_xu_ly] IN (N'Chờ xử lý', N'Đang xử lý', N'Đã hoàn thành', N'Từ chối'))
)
GO

CREATE TABLE [tin_nhan] (
  [tin_nhan_id] int PRIMARY KEY,
  [nguoi_gui_id] int,
  [nguoi_nhan_id] int,
  [thoi_gian_gui] datetime DEFAULT GETDATE(),
  [thoi_gian_nhan] datetime,
  [noi_dung] nvarchar(MAX),

  -- [RB] Người gửi khác người nhận
  CONSTRAINT CK_tin_nhan_sender_receiver CHECK ([nguoi_gui_id] <> [nguoi_nhan_id]),
  -- [RB] Thời gian nhận >= thời gian gửi
  CONSTRAINT CK_tin_nhan_time_order CHECK ([thoi_gian_nhan] IS NULL OR [thoi_gian_nhan] >= [thoi_gian_gui])
)
GO

CREATE TABLE [lop_hoc] (
  [lop_hoc_id] int PRIMARY KEY,
  [admin_id] int,
  [gia_su_id] int,
  [dia_chi] nvarchar(255),
  [trang_thai_giao] nvarchar(50),
  [thong_tin] nvarchar(MAX),
  [lop_day] nvarchar(50),
  [hinh_thuc] nvarchar(50),
  [muc_luong] decimal(18,0),
  [yeu_cau] nvarchar(MAX),
  [so_buoi] int,
  [thoi_gian_nhan_lop] datetime,

  -- [RB] Lương > 0
  CONSTRAINT CK_lop_hoc_salary CHECK ([muc_luong] IS NULL OR [muc_luong] > 0),
  -- [RB] Số buổi > 0
  CONSTRAINT CK_lop_hoc_so_buoi CHECK ([so_buoi] IS NULL OR [so_buoi] > 0),
  -- [RB] Danh sách trạng thái hợp lệ (Gồm cả 4 trạng thái để đảm bảo logic vận hành)
  CONSTRAINT CK_lop_hoc_trang_thai CHECK ([trang_thai_giao] IN (N'Chưa giao', N'Đã giao', N'Đang dạy', N'Đã kết thúc')),
  -- [RB] Đồng bộ Logic Trạng thái & Gia sư:
  -- Nếu 'Chưa giao' -> Gia sư phải NULL
  -- Nếu 'Đã giao'/'Đang dạy'/'Đã kết thúc' -> Gia sư phải NOT NULL
  CONSTRAINT CK_lop_hoc_status_tutor CHECK (
      ([trang_thai_giao] = N'Chưa giao' AND [gia_su_id] IS NULL) OR
      ([trang_thai_giao] IN (N'Đã giao', N'Đang dạy', N'Đã kết thúc') AND [gia_su_id] IS NOT NULL)
  )
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
  PRIMARY KEY ([lop_hoc_id], [ngay_thu], [gio_bat_dau], [gio_ket_thuc]),

  -- [RB] Giờ kết thúc phải lớn hơn giờ bắt đầu
  CONSTRAINT CK_tglh_time_order CHECK ([gio_ket_thuc] > [gio_bat_dau])
)
GO

CREATE TABLE [quiz] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [so_lan_duoc_lam] int,
  [thoi_gian_mo] datetime,
  [thoi_gian_dong] datetime,
  [thoi_gian_lam_bai] int,

  PRIMARY KEY ([lop_hoc_id], [ten_quiz]),
  -- [RB] Đóng > Mở
  CONSTRAINT CK_quiz_time_order CHECK ([thoi_gian_dong] > [thoi_gian_mo]),
  -- [RB] Số lần làm > 0
  CONSTRAINT CK_quiz_so_lan CHECK ([so_lan_duoc_lam] > 0),
  -- [RB] Thời gian làm bài phải <= khoảng thời gian mở (Logic nâng cao từ V00)
  CONSTRAINT CK_Quiz_WindowFit CHECK ([thoi_gian_lam_bai] <= DATEDIFF(MINUTE, [thoi_gian_mo], [thoi_gian_dong]))
)
GO

CREATE TABLE [cau_hoi] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [stt] int,
  [cau_hoi] nvarchar(MAX),
  [dap_an] nvarchar(MAX),
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
  [hoc_vien_id] int,

  -- [RB] Điểm 0-10
  CONSTRAINT CK_lslb_diem CHECK ([diem] IS NULL OR ([diem] >= 0 AND [diem] <= 10)),
  -- [RB] Kết thúc >= Bắt đầu
  CONSTRAINT CK_lslb_time_order CHECK ([thoi_gian_ket_thuc] IS NULL OR [thoi_gian_ket_thuc] >= [thoi_gian_bat_dau])
)
GO

CREATE TABLE [ghi_dap_an] (
  [lop_hoc_id] int,
  [ten_quiz] nvarchar(100),
  [stt_quiz] int,
  [lich_su_id] int,
  [dap_an_cua_lan_lam_bai] nvarchar(MAX),
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
  PRIMARY KEY ([tai_lieu_goc_id], [tai_lieu_lien_quan_id]),

  -- [RB] Không liên kết với chính nó
  CONSTRAINT CK_lien_quan_not_self CHECK ([tai_lieu_goc_id] <> [tai_lieu_lien_quan_id])
)
GO

-- =============================================================
-- PHẦN 2: TẠO KHÓA NGOẠI
-- =============================================================
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

ALTER TABLE [quiz] ADD FOREIGN KEY ([lop_hoc_id]) REFERENCES [lop_hoc] ([lop_hoc_id]);
ALTER TABLE [cau_hoi] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz]) REFERENCES [quiz] ([lop_hoc_id], [ten_quiz]);
ALTER TABLE [lua_chon_tra_loi] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz], [stt]) REFERENCES [cau_hoi] ([lop_hoc_id], [ten_quiz], [stt]);
ALTER TABLE [lich_su_lam_bai] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz]) REFERENCES [quiz] ([lop_hoc_id], [ten_quiz]);
ALTER TABLE [lich_su_lam_bai] ADD FOREIGN KEY ([hoc_vien_id]) REFERENCES [hoc_vien] ([hoc_vien_id]);
ALTER TABLE [ghi_dap_an] ADD FOREIGN KEY ([lop_hoc_id], [ten_quiz], [stt_quiz]) REFERENCES [cau_hoi] ([lop_hoc_id], [ten_quiz], [stt]);
ALTER TABLE [ghi_dap_an] ADD FOREIGN KEY ([lich_su_id]) REFERENCES [lich_su_lam_bai] ([id]);
GO
