USE TutorSS;
GO

CREATE OR ALTER PROCEDURE sp_TimKiemQuizNangCao
    @TenQuiz NVARCHAR(100) = NULL,
    @TenMonHoc NVARCHAR(100) = NULL,
    @TenGiaSu NVARCHAR(100) = NULL,
    @TrangThai NVARCHAR(20) = NULL,
    @LopDay NVARCHAR(50) = NULL,
    @TuNgay DATETIME = NULL,
    @DenNgay DATETIME = NULL,
    @SoLanLamMin INT = NULL,

    @SortBy INT = 1
AS
BEGIN
    SELECT
        q.ten_quiz AS TenQuiz,
        q.so_lan_duoc_lam,
        q.thoi_gian_mo,
        q.thoi_gian_dong,
        lh.lop_day AS Lop,
        mh.ten_mon_hoc AS MonHoc,
        gs.ho_ten AS GiaoVien,
        CASE
            WHEN GETDATE() < q.thoi_gian_mo THEN N'Chưa mở'
            WHEN GETDATE() > q.thoi_gian_dong THEN N'Đã đóng'
            ELSE N'Đang mở'
        END AS TrangThaiHienTai
    FROM
        quiz q
    JOIN
        lop_hoc lh ON q.lop_hoc_id = lh.lop_hoc_id
    LEFT JOIN
        day d ON lh.lop_hoc_id = d.lop_hoc_id
    LEFT JOIN
        mon_hoc mh ON d.mon_hoc_id = mh.mon_hoc_id
    LEFT JOIN
        gia_su gs ON lh.gia_su_id = gs.gia_su_id
    WHERE
        (@TenQuiz IS NULL OR q.ten_quiz LIKE N'%' + @TenQuiz + '%')
        AND (@TenMonHoc IS NULL OR mh.ten_mon_hoc LIKE N'%' + @TenMonHoc + '%')
        AND (@TenGiaSu IS NULL OR gs.ho_ten LIKE N'%' + @TenGiaSu + '%')
        AND (
            @TrangThai IS NULL
            OR (@TrangThai = 'DangMo' AND GETDATE() BETWEEN q.thoi_gian_mo AND q.thoi_gian_dong)
            OR (@TrangThai = 'DaDong' AND GETDATE() > q.thoi_gian_dong)
            OR (@TrangThai = 'ChuaMo' AND GETDATE() < q.thoi_gian_mo)
        )
        AND (@LopDay IS NULL OR lh.lop_day LIKE N'%' + @LopDay + '%')
        AND (@TuNgay IS NULL OR q.thoi_gian_mo >= @TuNgay)
        AND (@DenNgay IS NULL OR q.thoi_gian_mo <= @DenNgay)
        AND (@SoLanLamMin IS NULL OR q.so_lan_duoc_lam >= @SoLanLamMin)

    ORDER BY
        CASE WHEN @SortBy = 1 THEN q.ten_quiz END ASC,
        CASE WHEN @SortBy = 2 THEN q.thoi_gian_dong END DESC,
        CASE WHEN @SortBy = 3 THEN q.thoi_gian_mo END DESC;
END;
GO
