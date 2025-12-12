USE TutorSS;
GO

IF OBJECT_ID('dbo.sp_LayChiTietDiemLopHoc', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_LayChiTietDiemLopHoc;
GO

-- 2. Sau đó TẠO MỚI (CREATE) lại từ đầu
CREATE PROCEDURE dbo.sp_LayChiTietDiemLopHoc
    @MinSoBaiLam INT = 1 -- Chỉ lấy lớp có ít nhất 1 bài kiểm tra
AS
BEGIN
    SELECT
        mh.ten_mon_hoc AS TenMon,
        lh.lop_hoc_id AS MaLop,
        gs.ho_ten AS TenGiaSu,
        lh.muc_luong AS HocPhi,

        -- Thống kê tổng quan
        COUNT(DISTINCT tg.hoc_vien_id) AS SoHocVien,
        CAST(AVG(ls.diem) AS DECIMAL(4,2)) AS DiemTrungBinh,

        -- Gom tất cả điểm số thành 1 chuỗi, cách nhau bởi dấu phẩy
        STRING_AGG(CAST(ls.diem AS VARCHAR(MAX)), ',') WITHIN GROUP (ORDER BY ls.diem) AS DanhSachDiemRaw

    FROM lop_hoc lh
    JOIN day d ON lh.lop_hoc_id = d.lop_hoc_id
    JOIN mon_hoc mh ON d.mon_hoc_id = mh.mon_hoc_id
    JOIN gia_su gs ON lh.gia_su_id = gs.gia_su_id
    JOIN tham_gia tg ON lh.lop_hoc_id = tg.lop_hoc_id

    -- JOIN lấy điểm
    JOIN quiz q ON lh.lop_hoc_id = q.lop_hoc_id
    JOIN lich_su_lam_bai ls ON q.lop_hoc_id = ls.lop_hoc_id AND q.ten_quiz = ls.ten_quiz

    GROUP BY
        mh.ten_mon_hoc, lh.lop_hoc_id, gs.ho_ten, lh.muc_luong

    HAVING
        COUNT(ls.id) >= @MinSoBaiLam
    ORDER BY
        DiemTrungBinh DESC;
END;
GO