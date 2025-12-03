-- 1. Tạo Database
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TutorSS')
    DROP DATABASE TutorSS;
GO
CREATE DATABASE TutorSS;
GO
USE TutorSS;
GO

-- 2. Tạo Bảng (Theo thứ tự: Bảng cha trước, bảng con sau)

-- [1] USERS (Bảng cha của Admin, Gia Sư, Phụ Huynh, Học Viên)
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    phone VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL
);
GO

-- [2] ADMIN
CREATE TABLE admin (
    admin_id INT PRIMARY KEY,
    ho_ten NVARCHAR(100),
    FOREIGN KEY (admin_id) REFERENCES users(user_id)
);
GO

-- [3] PHU_HUYNH
CREATE TABLE phu_huynh (
    phu_huynh_id INT PRIMARY KEY,
    dia_chi NVARCHAR(200),
    FOREIGN KEY (phu_huynh_id) REFERENCES users(user_id)
);
GO

-- [4] HOC_VIEN
CREATE TABLE hoc_vien (
    hoc_vien_id INT PRIMARY KEY,
    ho_ten NVARCHAR(100),
    username VARCHAR(50) UNIQUE,
    phu_huynh_id INT, -- Có thể null nếu học viên tự đăng ký
    FOREIGN KEY (hoc_vien_id) REFERENCES users(user_id),
    FOREIGN KEY (phu_huynh_id) REFERENCES phu_huynh(phu_huynh_id)
);
GO

-- [5] MON_HOC
CREATE TABLE mon_hoc (
    mon_hoc_id INT PRIMARY KEY,
    ten_mon_hoc NVARCHAR(100)
);
GO

-- [6] GIA_SU
CREATE TABLE gia_su (
    gia_su_id INT PRIMARY KEY,
    ho_ten NVARCHAR(100),
    so_cccd VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    tinh_thanh_day NVARCHAR(100),
    truong_dao_tao NVARCHAR(100),
    trinh_do NVARCHAR(50),
    FOREIGN KEY (gia_su_id) REFERENCES users(user_id)
);
GO

-- [7] MON_DAY (Gia sư dạy môn gì - Multivalued Attribute)
CREATE TABLE mon_day (
    gia_su_id INT,
    mon_hoc_id INT,
    PRIMARY KEY (gia_su_id, mon_hoc_id),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id),
    FOREIGN KEY (mon_hoc_id) REFERENCES mon_hoc(mon_hoc_id)
);
GO

-- [8] ANH_GIA_SU (Multivalued)
CREATE TABLE anh_gia_su (
    gia_su_id INT,
    duong_dan_anh VARCHAR(255),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [9] THOI_GIAN_DAY (Multivalued)
CREATE TABLE thoi_gian_day (
    gia_su_id INT,
    thoi_gian NVARCHAR(100),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [10] KHU_VUC_DAY (Multivalued)
CREATE TABLE khu_vuc_day (
    gia_su_id INT,
    thanh_pho NVARCHAR(50),
    quan_huyen NVARCHAR(50),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [11] LOP_DAY (Gia sư dạy lớp mấy - Multivalued)
CREATE TABLE lop_day (
    gia_su_id INT,
    lop NVARCHAR(50),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [12] CHON_GIA_SU (Phụ huynh chọn gia sư)
CREATE TABLE chon_gia_su (
    phu_huynh_id INT,
    gia_su_id INT,
    PRIMARY KEY (phu_huynh_id, gia_su_id),
    FOREIGN KEY (phu_huynh_id) REFERENCES phu_huynh(phu_huynh_id),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [13] YEU_CAU_THEM (Của phụ huynh)
CREATE TABLE yeu_cau_them (
    phu_huynh_id INT,
    chi_tiet_yeu_cau NVARCHAR(255),
    FOREIGN KEY (phu_huynh_id) REFERENCES phu_huynh(phu_huynh_id)
);
GO

-- [14] LOP_HOC
CREATE TABLE lop_hoc (
    lop_hoc_id INT PRIMARY KEY,
    admin_id INT,
    gia_su_id INT,
    dia_chi NVARCHAR(200),
    trang_thai_giao NVARCHAR(50),
    muc_luong DECIMAL(18, 0),
    so_buoi INT,
    lop_day NVARCHAR(50),
    thong_tin NVARCHAR(MAX),
    yeu_cau NVARCHAR(MAX),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [15] HOP_DONG
CREATE TABLE hop_dong (
    hop_dong_id INT PRIMARY KEY IDENTITY(1,1), -- Tự tăng để dễ quản lý
    admin_id INT,
    gia_su_id INT,
    thoi_gian_ky DATE,
    noi_dung NVARCHAR(MAX),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id)
);
GO

-- [16] YEU_CAU (Phụ huynh gửi Admin)
CREATE TABLE yeu_cau (
    yeu_cau_id INT PRIMARY KEY,
    phu_huynh_id INT,
    noi_dung NVARCHAR(MAX),
    thoi_gian_gui DATE,
    trang_thai_xu_ly NVARCHAR(50),
    admin_id INT, -- Admin xử lý
    FOREIGN KEY (phu_huynh_id) REFERENCES phu_huynh(phu_huynh_id),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);
GO

-- [17] TIN_NHAN
CREATE TABLE tin_nhan (
    tin_nhan_id INT PRIMARY KEY,
    nguoi_gui_id INT,
    nguoi_nhan_id INT,
    thoi_gian_gui DATETIME,
    thoi_gian_nhan DATETIME,
    noi_dung NVARCHAR(MAX),
    FOREIGN KEY (nguoi_gui_id) REFERENCES users(user_id),
    FOREIGN KEY (nguoi_nhan_id) REFERENCES users(user_id)
);
GO

-- [18] DAY (Lớp học dạy môn gì)
CREATE TABLE day (
    lop_hoc_id INT,
    mon_hoc_id INT,
    PRIMARY KEY (lop_hoc_id, mon_hoc_id),
    FOREIGN KEY (lop_hoc_id) REFERENCES lop_hoc(lop_hoc_id),
    FOREIGN KEY (mon_hoc_id) REFERENCES mon_hoc(mon_hoc_id)
);
GO

-- [19] THAM_GIA (Học viên tham gia lớp học)
CREATE TABLE tham_gia (
    lop_hoc_id INT,
    hoc_vien_id INT,
    PRIMARY KEY (lop_hoc_id, hoc_vien_id),
    FOREIGN KEY (lop_hoc_id) REFERENCES lop_hoc(lop_hoc_id),
    FOREIGN KEY (hoc_vien_id) REFERENCES hoc_vien(hoc_vien_id)
);
GO

-- [20] SDT_LIEN_HE_LOP_HOC
CREATE TABLE sdt_lien_he_lop_hoc (
    lop_hoc_id INT,
    sdt_lien_he VARCHAR(15),
    FOREIGN KEY (lop_hoc_id) REFERENCES lop_hoc(lop_hoc_id)
);
GO

-- [21] THOI_GIAN_LOP_HOC
CREATE TABLE thoi_gian_lop_hoc (
    lop_hoc_id INT,
    ngay_thu NVARCHAR(20),
    gio_bat_dau TIME,
    gio_ket_thuc TIME,
    FOREIGN KEY (lop_hoc_id) REFERENCES lop_hoc(lop_hoc_id)
);
GO

-- [22] QUIZ
CREATE TABLE quiz (
    quiz_id INT PRIMARY KEY IDENTITY(1,1), -- Tạo ID tự tăng cho Quiz vì dữ liệu bạn insert không có ID
    lop_hoc_id INT,
    ten_quiz NVARCHAR(100),
    so_lan_duoc_lam INT,
    thoi_gian_mo DATETIME,
    thoi_gian_dong DATETIME,
    FOREIGN KEY (lop_hoc_id) REFERENCES lop_hoc(lop_hoc_id)
);
GO

-- [23] CAU_HOI
CREATE TABLE cau_hoi (
    cau_hoi_id INT PRIMARY KEY IDENTITY(1,1),
    lop_hoc_id INT, -- Dữ liệu insert của bạn tham chiếu Lớp học + Tên Quiz (hơi lạ), nên điều chỉnh sau
    ten_quiz NVARCHAR(100), 
    stt INT,
    noi_dung NVARCHAR(MAX),
    dap_an NVARCHAR(MAX)
    -- Lưu ý: Thực tế nên link bằng Quiz_ID, nhưng ở đây tạm tạo theo cấu trúc dữ liệu bạn đưa
);
GO

-- [24] LUA_CHON_TRA_LOI
CREATE TABLE lua_chon_tra_loi (
    lop_hoc_id INT,
    ten_quiz NVARCHAR(100),
    stt_cau_hoi INT,
    noi_dung_lua_chon NVARCHAR(MAX)
);
GO

-- [25] LICH_SU_LAM_BAI
CREATE TABLE lich_su_lam_bai (
    lich_su_id INT PRIMARY KEY,
    lop_hoc_id INT,
    ten_quiz NVARCHAR(100),
    hoc_vien_id INT,
    diem FLOAT,
    thoi_gian_bat_dau DATETIME,
    thoi_gian_ket_thuc DATETIME,
    lan_lam_bai INT,
    FOREIGN KEY (hoc_vien_id) REFERENCES hoc_vien(hoc_vien_id)
);
GO

-- [26] GHI_DAP_AN
CREATE TABLE ghi_dap_an (
    lop_hoc_id INT,
    ten_quiz NVARCHAR(100),
    stt_cau_hoi INT,
    lich_su_id INT,
    ghi_dap_an NVARCHAR(MAX),
    FOREIGN KEY (lich_su_id) REFERENCES lich_su_lam_bai(lich_su_id)
);
GO

-- [27] TAI_LIEU
CREATE TABLE tai_lieu (
    tai_lieu_id INT PRIMARY KEY,
    lop_hoc_id INT,
    gia_su_id INT,
    tac_gia NVARCHAR(100),
    ten_tai_lieu NVARCHAR(200),
    link_tai_lieu VARCHAR(255),
    mon_hoc_id INT,
    FOREIGN KEY (lop_hoc_id) REFERENCES lop_hoc(lop_hoc_id),
    FOREIGN KEY (gia_su_id) REFERENCES gia_su(gia_su_id),
    FOREIGN KEY (mon_hoc_id) REFERENCES mon_hoc(mon_hoc_id)
);
GO

-- [28] LIEN_QUAN (Tài liệu liên quan)
CREATE TABLE lien_quan (
    tai_lieu_goc_id INT,
    tai_lieu_lien_quan_id INT,
    mo_ta NVARCHAR(255),
    PRIMARY KEY (tai_lieu_goc_id, tai_lieu_lien_quan_id),
    FOREIGN KEY (tai_lieu_goc_id) REFERENCES tai_lieu(tai_lieu_id),
    FOREIGN KEY (tai_lieu_lien_quan_id) REFERENCES tai_lieu(tai_lieu_id)
);
GO

