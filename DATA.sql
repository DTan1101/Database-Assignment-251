USE TutorSS;
GO

-- --- XÓA DỮ LIỆU CŨ (Nếu có) ---
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
GO

-- Admin
INSERT INTO [users] (user_id, phone, password) VALUES 
-- 20 Admin
(1, '0901888001', 'Admin@123'), (2, '0901888002', 'Admin@123'), (3, '0901888003', 'Admin@123'), (4, '0901888004', 'Admin@123'), (5, '0901888005', 'Admin@123'),
(6, '0901888006', 'Admin@123'), (7, '0901888007', 'Admin@123'), (8, '0901888008', 'Admin@123'), (9, '0901888009', 'Admin@123'), (10, '0901888010', 'Admin@123'),
(11, '0901888011', 'Admin@123'), (12, '0901888012', 'Admin@123'), (13, '0901888013', 'Admin@123'), (14, '0901888014', 'Admin@123'), (15, '0901888015', 'Admin@123'),
(16, '0901888016', 'Admin@123'), (17, '0901888017', 'Admin@123'), (18, '0901888018', 'Admin@123'), (19, '0901888019', 'Admin@123'), (20, '0901888020', 'Admin@123'),
-- 25 Gia sư
(21, '0912000021', 'Tutor@123'), (22, '0912000022', 'Tutor@123'), (23, '0912000023', 'Tutor@123'), (24, '0912000024', 'Tutor@123'), (25, '0912000025', 'Tutor@123'),
(26, '0912000026', 'Tutor@123'), (27, '0912000027', 'Tutor@123'), (28, '0912000028', 'Tutor@123'), (29, '0912000029', 'Tutor@123'), (30, '0912000030', 'Tutor@123'),
(31, '0912000031', 'Tutor@123'), (32, '0912000032', 'Tutor@123'), (33, '0912000033', 'Tutor@123'), (34, '0912000034', 'Tutor@123'), (35, '0912000035', 'Tutor@123'),
(36, '0912000036', 'Tutor@123'), (37, '0912000037', 'Tutor@123'), (38, '0912000038', 'Tutor@123'), (39, '0912000039', 'Tutor@123'), (40, '0912000040', 'Tutor@123'),
(41, '0912000041', 'Tutor@123'), (42, '0912000042', 'Tutor@123'), (43, '0912000043', 'Tutor@123'), (44, '0912000044', 'Tutor@123'), (45, '0912000045', 'Tutor@123'),
-- 25 Phụ huynh
(46, '0933000046', 'Parent@123'), (47, '0933000047', 'Parent@123'), (48, '0933000048', 'Parent@123'), (49, '0933000049', 'Parent@123'), (50, '0933000050', 'Parent@123'),
(51, '0933000051', 'Parent@123'), (52, '0933000052', 'Parent@123'), (53, '0933000053', 'Parent@123'), (54, '0933000054', 'Parent@123'), (55, '0933000055', 'Parent@123'),
(56, '0933000056', 'Parent@123'), (57, '0933000057', 'Parent@123'), (58, '0933000058', 'Parent@123'), (59, '0933000059', 'Parent@123'), (60, '0933000060', 'Parent@123'),
(61, '0933000061', 'Parent@123'), (62, '0933000062', 'Parent@123'), (63, '0933000063', 'Parent@123'), (64, '0933000064', 'Parent@123'), (65, '0933000065', 'Parent@123'),
(66, '0933000066', 'Parent@123'), (67, '0933000067', 'Parent@123'), (68, '0933000068', 'Parent@123'), (69, '0933000069', 'Parent@123'), (70, '0933000070', 'Parent@123'),
-- 30 Học viên
(71, '0944000071', 'Student@123'), (72, '0944000072', 'Student@123'), (73, '0944000073', 'Student@123'), (74, '0944000074', 'Student@123'), (75, '0944000075', 'Student@123'),
(76, '0944000076', 'Student@123'), (77, '0944000077', 'Student@123'), (78, '0944000078', 'Student@123'), (79, '0944000079', 'Student@123'), (80, '0944000080', 'Student@123'),
(81, '0944000081', 'Student@123'), (82, '0944000082', 'Student@123'), (83, '0944000083', 'Student@123'), (84, '0944000084', 'Student@123'), (85, '0944000085', 'Student@123'),
(86, '0944000086', 'Student@123'), (87, '0944000087', 'Student@123'), (88, '0944000088', 'Student@123'), (89, '0944000089', 'Student@123'), (90, '0944000090', 'Student@123'),
(91, '0944000091', 'Student@123'), (92, '0944000092', 'Student@123'), (93, '0944000093', 'Student@123'), (94, '0944000094', 'Student@123'), (95, '0944000095', 'Student@123'),
(96, '0944000096', 'Student@123'), (97, '0944000097', 'Student@123'), (98, '0944000098', 'Student@123'), (99, '0944000099', 'Student@123'), (100,'0944000100', 'Student@123');
GO

-- [2] ADMIN
INSERT INTO [admin] (admin_id, ho_ten) VALUES 
(1, N'Nguyễn Hoàng Dũng'), (2, N'Trần Thị Thanh Thúy'), (3, N'Lê Văn Tuấn'), (4, N'Phạm Ngọc Anh'), (5, N'Huỳnh Minh Hải'),
(6, N'Võ Thị Bích Ngọc'), (7, N'Đặng Văn Lâm'), (8, N'Bùi Thị Thu Hà'), (9, N'Đỗ Minh Quân'), (10, N'Hồ Thị Kim Oanh'),
(11, N'Ngô Văn Nam'), (12, N'Dương Thị Lan'), (13, N'Lý Văn Hùng'), (14, N'Mai Thị Tuyết'), (15, N'Cao Văn Sơn'),
(16, N'Phan Thị Hồng'), (17, N'Trương Văn Tài'), (18, N'Lâm Thị Phương'), (19, N'Đinh Văn Khánh'), (20, N'Hà Thị Mai');
GO

-- [3] PHU_HUYNH
INSERT INTO [phu_huynh] (phu_huynh_id, dia_chi) VALUES 
(46, N'268 Lý Thường Kiệt, P.14, Q.10, TP.HCM'), (47, N'227 Nguyễn Văn Cừ, P.4, Q.5, TP.HCM'), (48, N'10-12 Đinh Tiên Hoàng, P. Bến Nghé, Q.1'), 
(49, N'280 An Dương Vương, P.4, Q.5'), (50, N'01 Võ Văn Ngân, TP. Thủ Đức'), (51, N'12 Nguyễn Văn Bảo, P.4, Q. Gò Vấp'),
(52, N'140 Lê Trọng Tấn, P. Tây Thạnh, Q. Tân Phú'), (53, N'70 Tô Ký, P. Tân Chánh Hiệp, Q.12'), (54, N'475A Điện Biên Phủ, P.25, Q. Bình Thạnh'),
(55, N'331 Quốc lộ 1A, P. An Phú Đông, Q.12'), (56, N'19 Nguyễn Hữu Thọ, P. Tân Phong, Q.7'), (57, N'02 Võ Oanh, P.25, Q. Bình Thạnh'),
(58, N'180 Cao Lỗ, P.4, Q.8'), (59, N'736 Nguyễn Trãi, P.11, Q.5'), (60, N'45 Nguyễn Khắc Nhu, P. Cô Giang, Q.1'),
(61, N'235 Pasteur, P.6, Q.3'), (62, N'97 Võ Văn Tần, P.6, Q.3'), (63, N'300A Nguyễn Tất Thành, P.13, Q.4'),
(64, N'10 Huỳnh Thúc Kháng, P. Bến Nghé, Q.1'), (65, N'08 Nguyễn Văn Tráng, P. Bến Thành, Q.1'), (66, N'56 Hoàng Diệu 2, TP. Thủ Đức'),
(67, N'624 Âu Cơ, P.10, Q. Tân Bình'), (68, N'93 Cao Thắng, P.3, Q.3'), (69, N'155 Sư Vạn Hạnh, P.13, Q.10'), (70, N'20 Cộng Hòa, P.12, Q. Tân Bình');
GO

-- [4] HOC_VIEN
INSERT INTO [hoc_vien] (hoc_vien_id, ho_ten, username, phu_huynh_id) VALUES 
(71, N'Nguyễn Gia Hưng', 'hung_nguyen2k10', 46), (72, N'Trần Ngọc Diệp', 'diep_tran_cute', 47), (73, N'Lê Minh Khôi', 'khoi_minh05', 48), 
(74, N'Phạm Quỳnh Chi', 'chi_quynh', 49), (75, N'Hoàng Đức Anh', 'ducanh_vip', 50), (76, N'Võ Tấn Phát', 'phat_tai_loc', 51), 
(77, N'Đặng Thùy Dương', 'duong_thuy', 52), (78, N'Bùi Minh Nhật', 'nhat_bui_gaming', 53), (79, N'Đỗ Khánh Vy', 'vy_khanh_study', 54), 
(80, N'Hồ Tuấn Kiệt', 'kiet_ho_2008', 55), (81, N'Ngô Bảo Châu', 'chau_ngo_math', 56), (82, N'Dương Trí Dũng', 'dung_tri_dung', 57), 
(83, N'Lý Thiên Kim', 'kim_ly_rich', 58), (84, N'Mai Đăng Khoa', 'khoa_dang', 59), (85, N'Cao Mỹ Tâm', 'tam_cao_singer', 60), 
(86, N'Phan Hữu Nghĩa', 'nghia_phan', 61), (87, N'Trương Ngọc Ánh', 'anh_truong', 62), (88, N'Lâm Văn Hùng', 'hung_lam_sport', 63), 
(89, N'Đinh Thùy Trang', 'trang_dinh', 64), (90, N'Hà Quốc Bảo', 'bao_ha_2012', 65), (91, N'Nguyễn Thị Lan', 'lan_nguyen', 66), 
(92, N'Trần Văn Hậu', 'hau_tran', 67), (93, N'Lê Thị Mai', 'mai_le_flower', 68), (94, N'Phạm Văn Nam', 'nam_pham', 69), 
(95, N'Hoàng Thị Cúc', 'cuc_hoang', 70), (96, N'Vũ Văn Long', 'long_vu_dragon', 46), (97, N'Đặng Thị Mận', 'man_dang', 47), 
(98, N'Bùi Văn Tùng', 'tung_bui_tung', 48), (99, N'Đỗ Thị Đào', 'dao_do_peach', 49), (100, N'Hồ Văn Sơn', 'son_ho_mountain', 50);
GO

-- [5] MON_HOC
INSERT INTO [mon_hoc] (mon_hoc_id, ten_mon_hoc) VALUES 
(101, N'Toán Học'), (102, N'Vật Lý'), (103, N'Hóa Học'), (104, N'Ngữ Văn'), (105, N'Tiếng Anh'), 
(106, N'Sinh Học'), (107, N'Lịch Sử'), (108, N'Địa Lý'), (109, N'Tin Học'), (110, N'Giáo Dục Công Dân'),
(111, N'Công Nghệ'), (112, N'Mỹ Thuật'), (113, N'Âm Nhạc'), (114, N'Tiếng Việt (Tiểu học)'), (115, N'IELTS'),
(116, N'TOEIC'), (117, N'Tiếng Nhật N3-N5'), (118, N'Tiếng Hàn Topik'), (119, N'Tiếng Trung HSK'), (120, N'Lập Trình Python/C++');
GO

-- [6] GIA_SU
INSERT INTO [gia_su] (gia_su_id, ho_ten, so_cccd, email, tinh_thanh_day, truong_dao_tao, trinh_do) VALUES 
(21, N'Nguyễn Văn An', '079201000001', 'an.nguyen@hcmut.edu.vn', N'TP.HCM', N'ĐH Bách Khoa TP.HCM', N'Sinh viên năm 3'),
(22, N'Trần Thị Bích', '079201000002', 'bich.tran@hcmus.edu.vn', N'TP.HCM', N'ĐH Khoa học Tự nhiên', N'Cử nhân'),
(23, N'Lê Văn Cường', '079201000003', 'cuong.le@hcmue.edu.vn', N'TP.HCM', N'ĐH Sư Phạm TP.HCM', N'Sinh viên năm 4'),
(24, N'Phạm Thị Dung', '079201000004', 'dung.pham@ftu.edu.vn', N'TP.HCM', N'ĐH Ngoại Thương', N'Sinh viên năm 2'),
(25, N'Hoàng Văn Em', '079201000005', 'em.hoang@ump.edu.vn', N'TP.HCM', N'ĐH Y Dược TP.HCM', N'Sinh viên năm 5'),
(26, N'Vũ Thị Phương', '079201000006', 'phuong.vu@ueh.edu.vn', N'TP.HCM', N'ĐH Kinh Tế TP.HCM', N'Thạc sĩ'),
(27, N'Đặng Văn Giàu', '079201000007', 'giau.dang@hcmute.edu.vn', N'TP.HCM', N'ĐH Sư Phạm Kỹ Thuật', N'Kỹ sư'),
(28, N'Bùi Thị Hoa', '079201000008', 'hoa.bui@ussh.edu.vn', N'TP.HCM', N'ĐH KHXH&NV', N'Cử nhân'),
(29, N'Đỗ Văn Inh', '079201000009', 'inh.do@uit.edu.vn', N'TP.HCM', N'ĐH CNTT', N'Sinh viên'),
(30, N'Hồ Thị Kim', '079201000010', 'kim.ho@rmit.edu.vn', N'TP.HCM', N'ĐH RMIT', N'Sinh viên'),
(31, N'Ngô Văn Lâm', '079201000011', 'lam.ngo@fpt.edu.vn', N'TP.HCM', N'ĐH FPT', N'Kỹ sư'),
(32, N'Dương Thị Mai', '079201000012', 'mai.duong@hutech.edu.vn', N'TP.HCM', N'ĐH Hutech', N'Sinh viên'),
(33, N'Lý Văn Nam', '079201000013', 'nam.ly@ou.edu.vn', N'TP.HCM', N'ĐH Mở TP.HCM', N'Cử nhân'),
(34, N'Mai Thị Oanh', '079201000014', 'oanh.mai@vlu.edu.vn', N'TP.HCM', N'ĐH Văn Lang', N'Sinh viên'),
(35, N'Cao Văn Phú', '079201000015', 'phu.cao@tdtu.edu.vn', N'TP.HCM', N'ĐH Tôn Đức Thắng', N'Thạc sĩ'),
(36, N'Phan Thị Quyên', '079201000016', 'quyen.phan@hcmuaf.edu.vn', N'TP.HCM', N'ĐH Nông Lâm', N'Kỹ sư'),
(37, N'Trương Văn Rạng', '079201000017', 'rang.truong@sgu.edu.vn', N'TP.HCM', N'ĐH Sài Gòn', N'Giáo viên'),
(38, N'Lâm Thị Sương', '079201000018', 'suong.lam@hcmulaw.edu.vn', N'TP.HCM', N'ĐH Luật TP.HCM', N'Cử nhân'),
(39, N'Đinh Văn Tùng', '079201000019', 'tung.dinh@uah.edu.vn', N'TP.HCM', N'ĐH Kiến Trúc', N'Kiến trúc sư'),
(40, N'Hà Thị Uyên', '079201000020', 'uyen.ha@buh.edu.vn', N'TP.HCM', N'ĐH Ngân Hàng', N'Thạc sĩ'),
(41, N'Nguyễn Văn Vỹ', '079201000021', 'vy.nguyen@hcmut.edu.vn', N'TP.HCM', N'ĐH Bách Khoa', N'Kỹ sư'),
(42, N'Trần Thị Xuyến', '079201000022', 'xuyen.tran@hcmus.edu.vn', N'TP.HCM', N'ĐH Khoa học Tự nhiên', N'Cử nhân'),
(43, N'Lê Văn Yên', '079201000023', 'yen.le@hcmue.edu.vn', N'TP.HCM', N'ĐH Sư Phạm', N'Sinh viên'),
(44, N'Phạm Thị Zô', '079201000024', 'zo.pham@ftu.edu.vn', N'TP.HCM', N'ĐH Ngoại Thương', N'Sinh viên'),
(45, N'Hoàng Văn An', '079201000025', 'an.hoang@ump.edu.vn', N'TP.HCM', N'ĐH Y Dược', N'Bác sĩ nội trú');
GO

-- [7] MON_DAY
INSERT INTO [mon_day] VALUES 
(21, 101), (21, 102), -- Bách Khoa dạy Toán Lý
(22, 103), (22, 106), -- KHTN dạy Hóa Sinh
(23, 104), (23, 107), -- Sư Phạm dạy Văn Sử
(24, 105), (24, 115), -- Ngoại Thương dạy Anh, IELTS
(25, 103), (25, 106), -- Y Dược dạy Hóa Sinh
(26, 101), (26, 110), -- Kinh Tế dạy Toán
(27, 102), (27, 111), -- SPKT dạy Lý Công Nghệ
(28, 104), (28, 108), -- XHNV dạy Văn Địa
(29, 109), (29, 120), -- CNTT dạy Tin, Python
(30, 105), (30, 116), -- RMIT dạy Anh, TOEIC
(31, 120), (32, 105), (33, 109), (34, 112), (35, 114),
(36, 102), (37, 114), (38, 110), (39, 112), (40, 112),
(41, 101), (42, 103), (43, 104), (44, 105), (45, 106);
GO

-- [8] ANH_GIA_SU
INSERT INTO [anh_gia_su] VALUES 
(21, '/images/tutor/21_an.jpg'), (22, '/images/tutor/22_bich.jpg'), (23, '/images/tutor/23_cuong.jpg'), (24, '/images/tutor/24_dung.jpg'), (25, '/images/tutor/25_em.jpg'),
(26, '/images/tutor/26_phuong.jpg'), (27, '/images/tutor/27_giau.jpg'), (28, '/images/tutor/28_hoa.jpg'), (29, '/images/tutor/29_inh.jpg'), (30, '/images/tutor/30_kim.jpg'),
(31, '/images/tutor/31_lam.jpg'), (32, '/images/tutor/32_mai.jpg'), (33, '/images/tutor/33_nam.jpg'), (34, '/images/tutor/34_oanh.jpg'), (35, '/images/tutor/35_phu.jpg'),
(36, '/images/tutor/36_quyen.jpg'), (37, '/images/tutor/37_rang.jpg'), (38, '/images/tutor/38_suong.jpg'), (39, '/images/tutor/39_tung.jpg'), (40, '/images/tutor/40_uyen.jpg'),
(41, '/images/tutor/41_vy.jpg'), (42, '/images/tutor/42_xuyen.jpg'), (43, '/images/tutor/43_yen.jpg'), (44, '/images/tutor/44_zo.jpg'), (45, '/images/tutor/45_an.jpg');
GO

-- [9] THOI_GIAN_DAY
INSERT INTO [thoi_gian_day] VALUES 
(21, N'Tối 2-4-6 (18h-20h)'), (22, N'Tối 3-5-7 (19h-21h)'), (23, N'Sáng T7-CN (8h-10h)'), (24, N'Chiều T2-4-6 (14h-16h)'), (25, N'Full T7-CN'),
(26, N'Sáng 2-4-6'), (27, N'Chiều 3-5-7'), (28, N'Tối T7-CN'), (29, N'Sáng CN'), (30, N'Chiều CN'),
(31, N'Tối 2-6'), (32, N'Sáng 3-5'), (33, N'Chiều T5'), (34, N'Full tuần'), (35, N'Tối T3-5'),
(36, N'Chiều T2-4'), (37, N'Sáng T7'), (38, N'Tối CN'), (39, N'Chiều T6'), (40, N'Sáng T4'),
(41, N'Tối 2-4-6'), (42, N'Tối 3-5-7'), (43, N'Sáng T7-CN'), (44, N'Chiều T7-CN'), (45, N'Full T7-CN');
GO

-- [10] KHU_VUC_DAY
INSERT INTO [khu_vuc_day] VALUES 
(21, N'TP.HCM', N'Q.10'), (22, N'TP.HCM', N'Q.5'), (23, N'TP.HCM', N'Q.3'), (24, N'TP.HCM', N'Bình Thạnh'), (25, N'TP.HCM', N'Q.1'),
(26, N'TP.HCM', N'Q.7'), (27, N'TP.HCM', N'Thủ Đức'), (28, N'TP.HCM', N'Q.4'), (29, N'TP.HCM', N'Tân Bình'), (30, N'TP.HCM', N'Phú Nhuận'),
(31, N'TP.HCM', N'Gò Vấp'), (32, N'TP.HCM', N'Bình Tân'), (33, N'TP.HCM', N'Q.6'), (34, N'TP.HCM', N'Q.8'), (35, N'TP.HCM', N'Q.11'),
(36, N'TP.HCM', N'Tân Phú'), (37, N'TP.HCM', N'Q.12'), (38, N'TP.HCM', N'Nhà Bè'), (39, N'TP.HCM', N'Bình Chánh'), (40, N'TP.HCM', N'Hóc Môn'),
(41, N'TP.HCM', N'Q.10'), (42, N'TP.HCM', N'Q.5'), (43, N'TP.HCM', N'Q.3'), (44, N'TP.HCM', N'Bình Thạnh'), (45, N'TP.HCM', N'Q.1');
GO

-- [11] LOP_DAY
INSERT INTO [lop_day] VALUES 
(21, N'Lớp 12'), (22, N'Lớp 10'), (23, N'Lớp 9'), (24, N'Đại học'), (25, N'Lớp 12'),
(26, N'Lớp 11'), (27, N'Lớp 8'), (28, N'Lớp 7'), (29, N'Lớp 10'), (30, N'IELTS'),
(31, N'Lập trình'), (32, N'Lớp 6'), (33, N'Lớp 5'), (34, N'Lớp 4'), (35, N'Lớp 3'),
(36, N'Lớp 2'), (37, N'Lớp 1'), (38, N'Mầm non'), (39, N'Vẽ'), (40, N'Đàn'),
(41, N'Lớp 12'), (42, N'Lớp 11'), (43, N'Lớp 10'), (44, N'Lớp 9'), (45, N'Lớp 8');
GO

-- [12] CHON_GIA_SU
INSERT INTO [chon_gia_su] VALUES 
(46, 21), (46, 22), (47, 23), (48, 24), (49, 25),
(50, 26), (51, 27), (52, 28), (53, 29), (54, 30),
(55, 31), (56, 32), (57, 33), (58, 34), (59, 35),
(60, 36), (61, 37), (62, 38), (63, 39), (64, 40),
(65, 41), (66, 42), (67, 43), (68, 44), (69, 45);
GO

-- [13] YEU_CAU_THEM
INSERT INTO [yeu_cau_them] (phu_huynh_id, chi_tiet_yeu_cau) VALUES 
(46, N'Yêu cầu gia sư Nữ, giọng miền Nam'), (46, N'Có kinh nghiệm dạy học sinh mất gốc'),
(47, N'Gia sư là sinh viên Đại học Sư Phạm'), (48, N'Không hút thuốc, tác phong nghiêm túc'),
(49, N'Ưu tiên gia sư có bằng IELTS 7.5+'), (50, N'Dạy báo bài các môn tự nhiên'),
(51, N'Có thể dạy thêm giờ vào cuối tuần'), (52, N'Nhà có chó dữ, vui lòng gọi trước'),
(53, N'Yêu cầu gia sư đã tiêm 3 mũi vaccine'), (54, N'Có laptop để dạy Tin học'),
(55, N'Giọng nói to, rõ ràng'), (56, N'Kiên nhẫn với trẻ hiếu động'),
(57, N'Có phương tiện đi lại tự túc'), (58, N'Dạy thử 1 buổi miễn phí'),
(59, N'Cam kết điểm thi cuối kỳ trên 8.0'), (60, N'Gia sư Nam, dạy Toán Lý Hóa'),
(61, N'Dạy rèn chữ đẹp cho bé lớp 1'), (62, N'Biết chơi đàn Piano là lợi thế'),
(63, N'Có kinh nghiệm luyện thi vào lớp 10'), (64, N'Ưu tiên sinh viên Bách Khoa, Y Dược'),
(65, N'Không sử dụng điện thoại trong giờ dạy'), (66, N'Gửi báo cáo tình hình học tập hàng tháng'),
(67, N'Dạy online qua Google Meet khi cần'), (68, N'Gia sư vui vẻ, hòa đồng'),
(69, N'Nghiêm khắc, rèn nề nếp học tập');
GO

-- [14] LOP_HOC
INSERT INTO [lop_hoc] (lop_hoc_id, admin_id, gia_su_id, dia_chi, trang_thai_giao, muc_luong, so_buoi, lop_day, thong_tin, yeu_cau) VALUES 
(500, 1, 21, N'268 Lý Thường Kiệt, Q.10', N'Đã giao', 5000000, 3, N'Lớp 12', N'Luyện thi THPT QG Toán', N'Nắm chắc kiến thức nền'),
(501, 1, 21, N'268 Lý Thường Kiệt, Q.10', N'Đã giao', 4500000, 2, N'Lớp 11', N'Lý 11 nâng cao', N'Giải bài tập khó'),
(502, 1, 21, N'227 Nguyễn Văn Cừ, Q.5', N'Đã giao', 6000000, 3, N'Lớp 10', N'Hóa 10 chuyên', N'Sinh viên KHTN'),
(503, 2, 22, N'10 Đinh Tiên Hoàng, Q.1', N'Đã giao', 3000000, 2, N'Lớp 9', N'Văn 9 ôn thi vào 10', N'Giọng văn hay'),
(504, 2, 22, N'280 An Dương Vương, Q.5', N'Đã giao', 3500000, 2, N'Lớp 8', N'Anh văn căn bản', N'Phát âm chuẩn'),
(505, 3, 23, N'01 Võ Văn Ngân, Thủ Đức', N'Đã giao', 7000000, 3, N'Đại học', N'Toán Cao Cấp', N'Thạc sĩ Toán'),
(506, 3, 23, N'12 Nguyễn Văn Bảo, Gò Vấp', N'Đã giao', 8000000, 3, N'IELTS', N'Luyện Speaking 7.0', N'IELTS 8.0 trở lên'),
(507, 4, 24, N'140 Lê Trọng Tấn, Tân Phú', N'Đã giao', 4000000, 2, N'Lớp 7', N'Sử Địa 7', N'Vui vẻ, kể chuyện hay'),
(508, 5, 25, N'70 Tô Ký, Q.12', N'Đã giao', 5000000, 3, N'Lớp 6', N'Sinh học 6', N'Yêu thiên nhiên'),
(509, 1, 26, N'475A Điện Biên Phủ, B.Thạnh', N'Đã giao', 6000000, 3, N'Lớp 12', N'Văn 12 luyện thi', N'Giáo viên đứng lớp'),
(510, 2, 27, N'331 QL1A, Q.12', N'Đã giao', 3000000, 2, N'Lớp 5', N'Toán 5 nâng cao', N'Tư duy logic'),
(511, 3, 28, N'19 Nguyễn Hữu Thọ, Q.7', N'Đã giao', 2500000, 2, N'Lớp 4', N'Tiếng Việt + Rèn chữ', N'Chữ đẹp'),
(512, 4, 29, N'02 Võ Oanh, B.Thạnh', N'Đã giao', 3500000, 3, N'Lớp 3', N'Toán Tiếng Việt', N'Kiên nhẫn'),
(513, 5, 30, N'180 Cao Lỗ, Q.8', N'Đã giao', 4500000, 3, N'Lớp 2', N'Anh văn thiếu nhi', N'Yêu trẻ'),
(514, 1, 31, N'736 Nguyễn Trãi, Q.5', N'Đã giao', 5000000, 3, N'Lớp 1', N'Chuẩn bị vào lớp 1', N'Cô giáo mầm non'),
(515, 2, 32, N'45 Nguyễn Khắc Nhu, Q.1', N'Đã giao', 6000000, 4, N'Mầm non', N'Dạy hát, vẽ', N'Vui tính'),
(516, 3, 33, N'235 Pasteur, Q.3', N'Đã giao', 7000000, 3, N'Lớp 12', N'Lý 12 luyện thi', N'Nam sinh viên'),
(517, 4, 34, N'97 Võ Văn Tần, Q.3', N'Đã giao', 3000000, 2, N'Lớp 11', N'Hóa 11', N'Nữ sinh viên'),
(518, 5, 35, N'300A Nguyễn Tất Thành, Q.4', N'Đã giao', 4000000, 2, N'Lớp 10', N'Anh 10 thí điểm', N'Sách mới'),
(519, 1, 36, N'10 Huỳnh Thúc Kháng, Q.1', N'Đã giao', 5000000, 3, N'Lớp 9', N'Toán 9 hình học', N'Giỏi hình'),
(520, 2, 37, N'08 Nguyễn Văn Tráng, Q.1', N'Đã giao', 3500000, 2, N'Lớp 8', N'Lý 8', N'Thí nghiệm vui'),
(521, 3, 38, N'56 Hoàng Diệu 2, Thủ Đức', N'Đã giao', 3000000, 2, N'Lớp 7', N'Ngữ Văn 7', N'Soạn văn'),
(522, 4, 39, N'624 Âu Cơ, Tân Bình', N'Đã giao', 4500000, 3, N'Lớp 6', N'Tiếng Anh 6', N'Starter/Mover'),
(523, 5, 40, N'93 Cao Thắng, Q.3', N'Đã giao', 5500000, 3, N'Lớp 5', N'Toán tiếng Anh', N'Hệ Cambridge'),
(524, 1, 21, N'155 Sư Vạn Hạnh, Q.10', N'Đã giao', 6000000, 3, N'Lớp 12', N'Luyện đề Toán', N'Giải đề nhanh'),
(525, 2, NULL, N'20 Cộng Hòa, Tân Bình', N'Chưa giao', 4000000, 2, N'Lớp 10', N'Hóa 10', N'SV Bách Khoa'),
(526, 3, NULL, N'Phạm Văn Đồng, Thủ Đức', N'Chưa giao', 5000000, 3, N'Đại học', N'Cấu trúc dữ liệu', N'Code C++'),
(527, 4, NULL, N'Lê Văn Sỹ, Q.3', N'Chưa giao', 3500000, 2, N'Lớp 8', N'Văn nghị luận', N'Văn hay chữ tốt'),
(528, 5, NULL, N'Điện Biên Phủ, Bình Thạnh', N'Chưa giao', 4500000, 3, N'Lớp 7', N'Sinh học', N'Yêu động vật'),
(529, 1, NULL, N'Nguyễn Oanh, Gò Vấp', N'Chưa giao', 5500000, 3, N'Lớp 11', N'Sử 11', N'Nhớ sự kiện tốt');
GO

-- [15] HOP_DONG
INSERT INTO [hop_dong] VALUES 
(1, 21, '2025-01-01', N'HĐ dạy Toán 12 - Mã 500'), (1, 21, '2025-01-02', N'HĐ dạy Lý 11 - Mã 501'), (1, 21, '2025-01-03', N'HĐ dạy Hóa 10 - Mã 502'),
(2, 22, '2025-01-04', N'HĐ dạy Văn 9 - Mã 503'), (2, 22, '2025-01-05', N'HĐ dạy Anh 8 - Mã 504'), (3, 23, '2025-01-06', N'HĐ dạy Toán CC - Mã 505'),
(3, 23, '2025-01-07', N'HĐ dạy IELTS - Mã 506'), (4, 24, '2025-01-08', N'HĐ dạy Sử 7 - Mã 507'), (5, 25, '2025-01-09', N'HĐ dạy Sinh 6 - Mã 508'),
(1, 26, '2025-01-10', N'HĐ dạy Văn 12 - Mã 509'), (2, 27, '2025-01-11', N'HĐ dạy Toán 5 - Mã 510'), (3, 28, '2025-01-12', N'HĐ dạy TV 4 - Mã 511'),
(4, 29, '2025-01-13', N'HĐ dạy Toán 3 - Mã 512'), (5, 30, '2025-01-14', N'HĐ dạy Anh 2 - Mã 513'), (1, 31, '2025-01-15', N'HĐ dạy Lớp 1 - Mã 514'),
(2, 32, '2025-01-16', N'HĐ dạy Mầm non - Mã 515'), (3, 33, '2025-01-17', N'HĐ dạy Lý 12 - Mã 516'), (4, 34, '2025-01-18', N'HĐ dạy Hóa 11 - Mã 517'),
(5, 35, '2025-01-19', N'HĐ dạy Anh 10 - Mã 518'), (1, 36, '2025-01-20', N'HĐ dạy Toán 9 - Mã 519'), (2, 37, '2025-01-21', N'HĐ dạy Lý 8 - Mã 520'),
(3, 38, '2025-01-22', N'HĐ dạy Văn 7 - Mã 521'), (4, 39, '2025-01-23', N'HĐ dạy Anh 6 - Mã 522'), (5, 40, '2025-01-24', N'HĐ dạy Toán 5 - Mã 523'),
(1, 21, '2025-01-25', N'HĐ dạy Luyện đề - Mã 524');
GO

-- [16] YEU_CAU
INSERT INTO [yeu_cau] VALUES 
(71, 46, N'Tìm gia sư Toán 12 gấp', '2025-01-01', N'Đã hoàn thành', 1), (72, 47, N'Cần tìm gia sư Lý', '2025-01-02', N'Đã hoàn thành', 1),
(73, 48, N'Tìm gia sư Hóa 10', '2025-01-03', N'Đã hoàn thành', 2), (74, 49, N'Tìm gia sư Văn 9', '2025-01-04', N'Đã hoàn thành', 2),
(75, 50, N'Tìm gia sư Anh 8', '2025-01-05', N'Đã hoàn thành', 3), (76, 51, N'Cần gia sư Toán Cao Cấp', '2025-01-06', N'Đã hoàn thành', 3),
(77, 52, N'Tìm gia sư IELTS 7.0', '2025-01-07', N'Đã hoàn thành', 4), (78, 53, N'Cần gia sư Sử 7', '2025-01-08', N'Đã hoàn thành', 4),
(79, 54, N'Tìm gia sư Sinh 6', '2025-01-09', N'Đã hoàn thành', 5), (80, 55, N'Tìm gia sư Văn 12', '2025-01-10', N'Đã hoàn thành', 5),
(81, 56, N'Tìm gia sư Toán 5', '2025-01-11', N'Đã hoàn thành', 1), (82, 57, N'Cần gia sư Tiếng Việt 4', '2025-01-12', N'Đã hoàn thành', 1),
(83, 58, N'Tìm gia sư Toán 3', '2025-01-13', N'Đã hoàn thành', 2), (84, 59, N'Cần gia sư Anh 2', '2025-01-14', N'Đã hoàn thành', 2),
(85, 60, N'Tìm gia sư Lớp 1', '2025-01-15', N'Đã hoàn thành', 3), (86, 61, N'Cần gia sư Mầm non', '2025-01-16', N'Đã hoàn thành', 3),
(87, 62, N'Tìm gia sư Lý 12', '2025-01-17', N'Đã hoàn thành', 4), (88, 63, N'Cần gia sư Hóa 11', '2025-01-18', N'Đã hoàn thành', 4),
(89, 64, N'Tìm gia sư Anh 10', '2025-01-19', N'Đã hoàn thành', 5), (90, 65, N'Cần gia sư Toán 9', '2025-01-20', N'Đã hoàn thành', 5);
GO

-- [17] TIN_NHAN
INSERT INTO [tin_nhan] VALUES 
(1, 21, 46, '2025-02-01', '2025-02-01', N'Chào chị, hôm nay em đến dạy trễ 15p ạ'), (2, 46, 21, '2025-02-01', '2025-02-01', N'Ok em, đi cẩn thận nhé'),
(3, 22, 47, '2025-02-02', '2025-02-02', N'Bé nhà mình hôm nay học rất tốt ạ'), (4, 47, 22, '2025-02-02', '2025-02-02', N'Cảm ơn cô giáo nhiều'),
(5, 71, 21, '2025-02-03', '2025-02-03', N'Thầy ơi bài tập này khó quá'), (6, 21, 71, '2025-02-03', '2025-02-03', N'Để tối thầy giảng lại cho nhé'),
(7, 23, 48, '2025-02-04', '2025-02-04', N'Học phí tháng này là 3tr ạ'), (8, 48, 23, '2025-02-04', '2025-02-04', N'Chị chuyển khoản rồi nha'),
(9, 24, 74, '2025-02-05', '2025-02-05', N'Mai nhớ mang sách bài tập'), (10, 74, 24, '2025-02-05', '2025-02-05', N'Dạ vâng ạ'),
(11, 25, 50, '2025-02-06', '2025-02-06', N'Bé nghỉ 1 buổi nha thầy'), (12, 50, 25, '2025-02-06', '2025-02-06', N'Dạ vâng, tuần sau học bù ạ'),
(13, 1, 21, '2025-01-01', '2025-01-01', N'Mời bạn lên trung tâm ký hợp đồng'), (14, 21, 1, '2025-01-01', '2025-01-01', N'Em sẽ có mặt lúc 9h ạ'),
(15, 26, 51, '2025-02-07', '2025-02-07', N'Hôm nay kiểm tra 1 tiết nhé'), (16, 51, 26, '2025-02-07', '2025-02-07', N'Huhu sợ quá cô ơi'),
(17, 27, 52, '2025-02-08', '2025-02-08', N'Em làm xong bài tập chưa?'), (18, 52, 27, '2025-02-08', '2025-02-08', N'Em đang làm câu cuối ạ'),
(19, 28, 53, '2025-02-09', '2025-02-09', N'Mai nghỉ lễ nha em'), (20, 53, 28, '2025-02-09', '2025-02-09', N'Dạ chúc cô nghỉ lễ vui vẻ'),
(21, 29, 54, '2025-02-10', '2025-02-10', N'Nhớ ôn bài cũ'), (22, 54, 29, '2025-02-10', '2025-02-10', N'Dạ em nhớ rồi'),
(23, 30, 55, '2025-02-11', '2025-02-11', N'Thứ 2 học 18h nhé'), (24, 55, 30, '2025-02-11', '2025-02-11', N'Dạ thầy'),
(25, 31, 56, '2025-02-12', '2025-02-12', N'Hôm nay học bài gì vậy cô?');
GO

-- [18] DAY
INSERT INTO [day] VALUES 
(500, 101), (501, 102), (502, 103), (503, 104), (504, 105),
(505, 101), (506, 115), (507, 107), (508, 106), (509, 104),
(510, 101), (511, 114), (512, 101), (513, 105), (514, 114),
(515, 112), (516, 102), (517, 103), (518, 105), (519, 101),
(520, 102), (521, 104), (522, 105), (523, 101), (524, 101),
(525, 103), (526, 120), (527, 104), (528, 106), (529, 107);
GO

-- [19] THAM_GIA
INSERT INTO [tham_gia] VALUES 
(500, 71), (501, 72), (502, 73), (503, 74), (504, 75),
(505, 76), (506, 77), (507, 78), (508, 79), (509, 80),
(510, 81), (511, 82), (512, 83), (513, 84), (514, 85),
(515, 86), (516, 87), (517, 88), (518, 89), (519, 90),
(520, 91), (521, 92), (522, 93), (523, 94), (524, 95),
(525, 96), (526, 97), (527, 98), (528, 99), (529, 100);
GO

-- [20] SDT_LIEN_HE_LOP_HOC
INSERT INTO [sdt_lien_he_lop_hoc] VALUES 
(500, '0901234500'), (501, '0901234501'), (502, '0901234502'), (503, '0901234503'), (504, '0901234504'),
(505, '0901234505'), (506, '0901234506'), (507, '0901234507'), (508, '0901234508'), (509, '0901234509'),
(510, '0901234510'), (511, '0901234511'), (512, '0901234512'), (513, '0901234513'), (514, '0901234514'),
(515, '0901234515'), (516, '0901234516'), (517, '0901234517'), (518, '0901234518'), (519, '0901234519'),
(520, '0901234520'), (521, '0901234521'), (522, '0901234522'), (523, '0901234523'), (524, '0901234524'),
(525, '0901234525'), (526, '0901234526'), (527, '0901234527'), (528, '0901234528'), (529, '0901234529');
GO

-- [21] THOI_GIAN_LOP_HOC
INSERT INTO [thoi_gian_lop_hoc] VALUES 
(500, N'T2-4-6', '18:00', '19:30'), (501, N'T3-5-7', '19:00', '21:00'), (502, N'T7-CN', '08:00', '10:00'), (503, N'T2-6', '17:00', '19:00'), (504, N'CN', '14:00', '16:00'),
(505, N'T2-4-6', '18:00', '20:00'), (506, N'T3-5-7', '18:00', '20:00'), (507, N'T7-CN', '08:00', '10:00'), (508, N'T2-6', '17:00', '19:00'), (509, N'CN', '14:00', '16:00'),
(510, N'T2-4-6', '18:00', '20:00'), (511, N'T3-5-7', '18:00', '20:00'), (512, N'T7-CN', '08:00', '10:00'), (513, N'T2-6', '17:00', '19:00'), (514, N'CN', '14:00', '16:00'),
(515, N'T2-4-6', '18:00', '20:00'), (516, N'T3-5-7', '18:00', '20:00'), (517, N'T7-CN', '08:00', '10:00'), (518, N'T2-6', '17:00', '19:00'), (519, N'CN', '14:00', '16:00'),
(520, N'T2-4-6', '18:00', '20:00'), (521, N'T3-5-7', '18:00', '20:00'), (522, N'T7-CN', '08:00', '10:00'), (523, N'T2-6', '17:00', '19:00'), (524, N'CN', '14:00', '16:00'),
(525, N'T2-4-6', '18:00', '20:00'), (526, N'T3-5-7', '18:00', '20:00'), (527, N'T7-CN', '08:00', '10:00'), (528, N'T2-6', '17:00', '19:00'), (529, N'CN', '14:00', '16:00');
GO

-- [22] QUIZ
INSERT INTO [quiz] (lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong) VALUES 
(500, N'KT 15 phút Hàm Số', 3, '2025-01-01', '2025-01-02'), (501, N'KT 1 tiết Điện Học', 3, '2025-01-01', '2025-01-02'), 
(502, N'Cân bằng hóa học', 3, '2025-01-01', '2025-01-02'), (503, N'Phân tích bài thơ', 3, '2025-01-01', '2025-01-02'), 
(504, N'Grammar Unit 1', 3, '2025-01-01', '2025-01-02'), (505, N'Đạo hàm', 3, '2025-01-01', '2025-01-02'), 
(506, N'Speaking Part 1', 3, '2025-01-01', '2025-01-02'), (507, N'Chiến tranh thế giới', 3, '2025-01-01', '2025-01-02'), 
(508, N'Tế bào học', 3, '2025-01-01', '2025-01-02'), (509, N'Vợ Chồng A Phủ', 3, '2025-01-01', '2025-01-02'),
(510, N'Phân số', 3, '2025-01-01', '2025-01-02'), (511, N'Chính tả', 3, '2025-01-01', '2025-01-02'), 
(512, N'Bảng cửu chương', 3, '2025-01-01', '2025-01-02'), (513, N'Vocabulary Animals', 3, '2025-01-01', '2025-01-02'), 
(514, N'Chữ cái', 3, '2025-01-01', '2025-01-02'), (515, N'Tô màu', 3, '2025-01-01', '2025-01-02'), 
(516, N'Sóng cơ', 3, '2025-01-01', '2025-01-02'), (517, N'Hữu cơ', 3, '2025-01-01', '2025-01-02'), 
(518, N'Reading', 3, '2025-01-01', '2025-01-02'), (519, N'Hình học', 3, '2025-01-01', '2025-01-02'),
(520, N'Cơ học', 3, '2025-01-01', '2025-01-02'), (521, N'Văn biểu cảm', 3, '2025-01-01', '2025-01-02'), 
(522, N'Listening', 3, '2025-01-01', '2025-01-02'), (523, N'Số thập phân', 3, '2025-01-01', '2025-01-02'), 
(524, N'Tích phân', 3, '2025-01-01', '2025-01-02');
GO

-- [23] CAU_HOI
INSERT INTO [cau_hoi] VALUES 
(500, N'KT 15 phút Hàm Số', 1, N'Đạo hàm x^2?', N'2x'), (501, N'KT 1 tiết Điện Học', 1, N'U=?', N'IR'), 
(502, N'Cân bằng hóa học', 1, N'H2O là gì?', N'Nước'), (503, N'Phân tích bài thơ', 1, N'Tác giả Truyện Kiều?', N'Nguyễn Du'), 
(504, N'Grammar Unit 1', 1, N'Past of Go?', N'Went'), (505, N'Đạo hàm', 1, N'Sin(0)=?', N'0'), 
(506, N'Speaking Part 1', 1, N'Name?', N'My name is'), (507, N'Chiến tranh thế giới', 1, N'Năm 1945?', N'CMT8'), 
(508, N'Tế bào học', 1, N'ADN là gì?', N'Di truyền'), (509, N'Vợ Chồng A Phủ', 1, N'Tô Hoài?', N'Tác giả'),
(510, N'Phân số', 1, N'1/2 + 1/2 = ?', N'1'), (511, N'Chính tả', 1, N'Con gì kêu meo meo?', N'Mèo'), 
(512, N'Bảng cửu chương', 1, N'2x2=?', N'4'), (513, N'Vocabulary Animals', 1, N'Cat?', N'Mèo'), 
(514, N'Chữ cái', 1, N'A là?', N'A'), (515, N'Tô màu', 1, N'Màu đỏ?', N'Red'), 
(516, N'Sóng cơ', 1, N'Lamda?', N'Bước sóng'), (517, N'Hữu cơ', 1, N'CH4?', N'Metan'), 
(518, N'Reading', 1, N'Read text?', N'Yes'), (519, N'Hình học', 1, N'Tam giác?', N'3 cạnh'),
(520, N'Cơ học', 1, N'F=?', N'ma'), (521, N'Văn biểu cảm', 1, N'Yêu?', N'Thương'), 
(522, N'Listening', 1, N'Listen?', N'Hear'), (523, N'Số thập phân', 1, N'0.5?', N'1/2'), 
(524, N'Tích phân', 1, N'Nguyen ham x?', N'x^2/2');
GO

-- [24] LUA_CHON_TRA_LOI
INSERT INTO [lua_chon_tra_loi] VALUES 
(500, N'KT 15 phút Hàm Số', 1, N'A. 2x'), (501, N'KT 1 tiết Điện Học', 1, N'A. IR'), (502, N'Cân bằng hóa học', 1, N'A. Nước'), (503, N'Phân tích bài thơ', 1, N'A. Nguyễn Du'), (504, N'Grammar Unit 1', 1, N'A. Went'),
(505, N'Đạo hàm', 1, N'A. 0'), (506, N'Speaking Part 1', 1, N'A. My name is'), (507, N'Chiến tranh thế giới', 1, N'A. CMT8'), (508, N'Tế bào học', 1, N'A. Di truyền'), (509, N'Vợ Chồng A Phủ', 1, N'A. Tác giả'),
(510, N'Phân số', 1, N'A. 1'), (511, N'Chính tả', 1, N'A. Mèo'), (512, N'Bảng cửu chương', 1, N'A. 4'), (513, N'Vocabulary Animals', 1, N'A. Mèo'), (514, N'Chữ cái', 1, N'A. A'),
(515, N'Tô màu', 1, N'A. Red'), (516, N'Sóng cơ', 1, N'A. Bước sóng'), (517, N'Hữu cơ', 1, N'A. Metan'), (518, N'Reading', 1, N'A. Yes'), (519, N'Hình học', 1, N'A. 3 cạnh'),
(520, N'Cơ học', 1, N'A. ma'), (521, N'Văn biểu cảm', 1, N'A. Thương'), (522, N'Listening', 1, N'A. Hear'), (523, N'Số thập phân', 1, N'A. 1/2'), (524, N'Tích phân', 1, N'A. x^2/2');
GO

-- [25] LICH_SU_LAM_BAI
INSERT INTO [lich_su_lam_bai] VALUES 
(1, 500, N'KT 15 phút Hàm Số', 71, 9.5, '2025-01-01', '2025-01-01', 71), (2, 501, N'KT 1 tiết Điện Học', 72, 8.0, '2025-01-01', '2025-01-01', 72),
(3, 502, N'Cân bằng hóa học', 73, 10, '2025-01-01', '2025-01-01', 73), (4, 503, N'Phân tích bài thơ', 74, 7.5, '2025-01-01', '2025-01-01', 74),
(5, 504, N'Grammar Unit 1', 75, 9.0, '2025-01-01', '2025-01-01', 75), (6, 505, N'Đạo hàm', 76, 8.5, '2025-01-01', '2025-01-01', 76),
(7, 506, N'Speaking Part 1', 77, 6.5, '2025-01-01', '2025-01-01', 77), (8, 507, N'Chiến tranh thế giới', 78, 7.0, '2025-01-01', '2025-01-01', 78),
(9, 508, N'Tế bào học', 79, 9.0, '2025-01-01', '2025-01-01', 79), (10, 509, N'Vợ Chồng A Phủ', 80, 8.0, '2025-01-01', '2025-01-01', 80),
(11, 510, N'Phân số', 81, 10, '2025-01-01', '2025-01-01', 81), (12, 511, N'Chính tả', 82, 7.5, '2025-01-01', '2025-01-01', 82),
(13, 512, N'Bảng cửu chương', 83, 9.0, '2025-01-01', '2025-01-01', 83), (14, 513, N'Vocabulary Animals', 84, 8.5, '2025-01-01', '2025-01-01', 84),
(15, 514, N'Chữ cái', 85, 10, '2025-01-01', '2025-01-01', 85), (16, 515, N'Tô màu', 86, 7.0, '2025-01-01', '2025-01-01', 86),
(17, 516, N'Sóng cơ', 87, 9.5, '2025-01-01', '2025-01-01', 87), (18, 517, N'Hữu cơ', 88, 8.0, '2025-01-01', '2025-01-01', 88),
(19, 518, N'Reading', 89, 10, '2025-01-01', '2025-01-01', 89), (20, 519, N'Hình học', 90, 7.5, '2025-01-01', '2025-01-01', 90),
(21, 520, N'Cơ học', 91, 9.0, '2025-01-01', '2025-01-01', 91), (22, 521, N'Văn biểu cảm', 92, 8.5, '2025-01-01', '2025-01-01', 92),
(23, 522, N'Listening', 93, 10, '2025-01-01', '2025-01-01', 93), (24, 523, N'Số thập phân', 94, 7.0, '2025-01-01', '2025-01-01', 94),
(25, 524, N'Tích phân', 95, 9.0, '2025-01-01', '2025-01-01', 95);
GO

-- [26] GHI_DAP_AN
INSERT INTO [ghi_dap_an] VALUES 
(500, N'KT 15 phút Hàm Số', 1, 1, N'2x'), (501, N'KT 1 tiết Điện Học', 1, 2, N'IR'), (502, N'Cân bằng hóa học', 1, 3, N'Nước'), (503, N'Phân tích bài thơ', 1, 4, N'Nguyễn Du'), (504, N'Grammar Unit 1', 1, 5, N'Went'),
(505, N'Đạo hàm', 1, 6, N'0'), (506, N'Speaking Part 1', 1, 7, N'My name is'), (507, N'Chiến tranh thế giới', 1, 8, N'CMT8'), (508, N'Tế bào học', 1, 9, N'Di truyền'), (509, N'Vợ Chồng A Phủ', 1, 10, N'Tác giả'),
(510, N'Phân số', 1, 11, N'1'), (511, N'Chính tả', 1, 12, N'Mèo'), (512, N'Bảng cửu chương', 1, 13, N'4'), (513, N'Vocabulary Animals', 1, 14, N'Mèo'), (514, N'Chữ cái', 1, 15, N'A'),
(515, N'Tô màu', 1, 16, N'Red'), (516, N'Sóng cơ', 1, 17, N'Bước sóng'), (517, N'Hữu cơ', 1, 18, N'Metan'), (518, N'Reading', 1, 19, N'Yes'), (519, N'Hình học', 1, 20, N'3 cạnh'),
(520, N'Cơ học', 1, 21, N'ma'), (521, N'Văn biểu cảm', 1, 22, N'Thương'), (522, N'Listening', 1, 23, N'Hear'), (523, N'Số thập phân', 1, 24, N'1/2'), (524, N'Tích phân', 1, 25, N'x^2/2');
GO

-- [27] TAI_LIEU
INSERT INTO [tai_lieu] VALUES 
(1, 500, 21, N'Nguyễn Đình Trí', N'Toán Cao Cấp Tập 1', 'drive.google.com/toan1', 101),
(2, 501, 21, N'Lê Bá Trần Phương', N'Phương pháp giải nhanh Toán', 'drive.google.com/toan2', 101),
(3, 502, 21, N'Bộ Giáo Dục', N'SGK Vật Lý 11', 'drive.google.com/ly11', 102),
(4, 503, 22, N'Ngô Ngọc An', N'Tuyển tập Hóa học 10', 'drive.google.com/hoa10', 103),
(5, 504, 22, N'Nguyễn Đăng Mạnh', N'Phân tích tác phẩm Văn học', 'drive.google.com/van9', 104),
(6, 505, 23, N'Mai Lan Hương', N'Giải thích ngữ pháp Tiếng Anh', 'drive.google.com/anh8', 105),
(7, 506, 23, N'Cambridge', N'Cambridge IELTS 18', 'drive.google.com/ielts', 115),
(8, 507, 24, N'Trần Dần', N'Lịch sử Việt Nam', 'drive.google.com/su7', 107),
(9, 508, 25, N'Campbell', N'Sinh học đại cương', 'drive.google.com/sinh6', 106),
(10, 509, 26, N'Hoài Thanh', N'Thi nhân Việt Nam', 'drive.google.com/van12', 104),
(11, 510, 27, N'Tôn Tích Pháp', N'Toán nâng cao tiểu học', 'drive.google.com/toan5', 101),
(12, 511, 28, N'Bộ Giáo Dục', N'Vở tập viết lớp 4', 'drive.google.com/tv4', 114),
(13, 512, 29, N'Huỳnh Quốc Thưởng', N'Toán 3 cơ bản', 'drive.google.com/toan3', 101),
(14, 513, 30, N'Oxford', N'Let Go 2', 'drive.google.com/anh2', 105),
(15, 514, 31, N'Bộ Giáo Dục', N'Tiếng Việt 1 Tập 1', 'drive.google.com/tv1', 114),
(16, 515, 32, N'NXB Kim Đồng', N'Bé tập tô màu', 'drive.google.com/tomau', 112),
(17, 516, 33, N'Vũ Thanh Khiết', N'Bồi dưỡng Vật Lý 12', 'drive.google.com/ly12', 102),
(18, 517, 34, N'Cao Cự Giác', N'Phương pháp giải Hóa 11', 'drive.google.com/hoa11', 103),
(19, 518, 35, N'Pearson', N'Longman Preparation', 'drive.google.com/toeic', 116),
(20, 519, 36, N'Trần Phương', N'Bất đẳng thức', 'drive.google.com/hinh9', 101),
(21, 520, 37, N'Lương Duyên Bình', N'Vật Lý Đại Cương', 'drive.google.com/ly8', 102),
(22, 521, 38, N'Đỗ Kim Hồi', N'Ngữ Văn 7 Nâng cao', 'drive.google.com/van7', 104),
(23, 522, 39, N'Cambridge', N'Flyers Practice Tests', 'drive.google.com/anh6', 105),
(24, 523, 40, N'Violympic', N'Tuyển tập đề thi Toán 5', 'drive.google.com/toan5nc', 101),
(25, 524, 21, N'Thầy Khải', N'Đề thi thử THPT QG 2025', 'drive.google.com/dethi', 101);
GO

-- [28] LIEN_QUAN
INSERT INTO [lien_quan] VALUES 
(1, 2, N'Sách bài tập'), (2, 3, N'Giải chi tiết'), (3, 4, N'Sách nâng cao'), (4, 5, N'Phần 2'), (5, 6, N'Audio đi kèm'),
(6, 7, N'File nghe'), (7, 8, N'Bản đồ tư duy'), (8, 9, N'Video bài giảng'), (9, 10, N'Phân tích nhân vật'), (10, 11, N'Đề thi mẫu'),
(11, 12, N'Vở bài tập'), (12, 13, N'Đáp án'), (13, 14, N'Flashcard'), (14, 15, N'Tranh minh họa'), (15, 16, N'Bút màu'),
(16, 17, N'Công thức nhanh'), (17, 18, N'Sơ đồ phản ứng'), (18, 19, N'Transcript'), (19, 20, N'Hình học không gian'), (20, 21, N'Bài tập trắc nghiệm'),
(21, 22, N'Văn mẫu'), (22, 23, N'Tape script'), (23, 24, N'Lời giải'), (24, 25, N'Đề minh họa'), (25, 1, N'Tổng ôn');
GO

-- KIỂM TRA LẠI SỐ LƯỢNG
SELECT 'lien_quan' as TableName, COUNT(*) as Rows FROM lien_quan
UNION ALL SELECT 'tai_lieu', COUNT(*) FROM tai_lieu
UNION ALL SELECT 'users', COUNT(*) FROM users;

-- KIỂM TRA CHI TIẾT 28 BẢNG --
-- --- NHÓM NGƯỜI DÙNG ---
SELECT * FROM [users];
SELECT * FROM [admin];
SELECT * FROM [phu_huynh];
SELECT * FROM [hoc_vien];
SELECT * FROM [gia_su];

-- --- NHÓM DANH MỤC ---
SELECT * FROM [mon_hoc];
SELECT * FROM [khu_vuc_day];
SELECT * FROM [thoi_gian_day];
SELECT * FROM [lop_day];
SELECT * FROM [anh_gia_su];
SELECT * FROM [mon_day]; -- Gia sư dạy môn gì

-- --- NHÓM TƯƠNG TÁC NGƯỜI DÙNG ---
SELECT * FROM [tin_nhan];
SELECT * FROM [yeu_cau];
SELECT * FROM [yeu_cau_them];
SELECT * FROM [chon_gia_su];
SELECT * FROM [hop_dong];

-- --- NHÓM LỚP HỌC & LIÊN KẾT ---
SELECT * FROM [lop_hoc];
SELECT * FROM [day];       -- Lớp dạy môn gì
SELECT * FROM [tham_gia];  -- Học viên nào học lớp nào
SELECT * FROM [thoi_gian_lop_hoc];
SELECT * FROM [sdt_lien_he_lop_hoc];

-- --- NHÓM TÀI LIỆU ---
SELECT * FROM [tai_lieu];
SELECT * FROM [lien_quan];

-- --- NHÓM QUIZ (KIỂM TRA) ---
SELECT * FROM [quiz];
SELECT * FROM [cau_hoi];
SELECT * FROM [lua_chon_tra_loi];
SELECT * FROM [lich_su_lam_bai];
SELECT * FROM [ghi_dap_an];