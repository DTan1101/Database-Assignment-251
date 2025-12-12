USE TutorSS;
GO

-- =============================================
-- Procedure: sp_TimKiemQuizNangCao (Improved Version)
-- Mô tả: Tìm kiếm quiz nâng cao với pagination và filter đầy đủ
-- Thay thế hoàn toàn API search cũ
-- =============================================

-- Xóa procedure cũ nếu tồn tại
IF OBJECT_ID('dbo.sp_TimKiemQuizNangCao', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_TimKiemQuizNangCao;
GO

-- Tạo mới procedure
CREATE PROCEDURE dbo.sp_TimKiemQuizNangCao
    -- Filter parameters
    @TenQuiz NVARCHAR(100) = NULL,
    @TenMonHoc NVARCHAR(100) = NULL,
    @TenGiaSu NVARCHAR(100) = NULL,
    @TrangThai NVARCHAR(20) = NULL,
    @LopDay NVARCHAR(50) = NULL,
    @LopHocId INT = NULL,
    @TuNgay DATETIME = NULL,
    @DenNgay DATETIME = NULL,
    @SoLanLamMin INT = NULL,
    @SoLanLamMax INT = NULL,

    -- Sort parameter
    @SortBy INT = 1,

    -- Pagination parameters
    @Page INT = 0,
    @Size INT = 9,

    -- Output parameter
    @TotalCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Temporary table approach (thay vì CTE để tránh lỗi scope)
    -- Step 1: Create temp table với filtered data
    SELECT
        q.lop_hoc_id,
        q.ten_quiz AS TenQuiz,
        q.so_lan_duoc_lam,
        q.thoi_gian_mo,
        q.thoi_gian_dong,
        q.thoi_gian_lam_bai,
        lh.lop_day AS Lop,
        mh.ten_mon_hoc AS MonHoc,
        gs.ho_ten AS GiaoVien,
        CASE
            WHEN GETDATE() < q.thoi_gian_mo THEN N'Chưa mở'
            WHEN GETDATE() > q.thoi_gian_dong THEN N'Đã đóng'
            ELSE N'Đang mở'
        END AS TrangThaiHienTai
    INTO #TempFilteredQuizzes
    FROM quiz q
    JOIN lop_hoc lh ON q.lop_hoc_id = lh.lop_hoc_id
    LEFT JOIN day d ON lh.lop_hoc_id = d.lop_hoc_id
    LEFT JOIN mon_hoc mh ON d.mon_hoc_id = mh.mon_hoc_id
    LEFT JOIN gia_su gs ON lh.gia_su_id = gs.gia_su_id
    WHERE
        (@TenQuiz IS NULL OR q.ten_quiz LIKE N'%' + @TenQuiz + '%')
        AND (@TenMonHoc IS NULL OR mh.ten_mon_hoc LIKE N'%' + @TenMonHoc + '%')
        AND (@TenGiaSu IS NULL OR gs.ho_ten LIKE N'%' + @TenGiaSu + '%')
        AND (@LopHocId IS NULL OR q.lop_hoc_id = @LopHocId)
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
        AND (@SoLanLamMax IS NULL OR q.so_lan_duoc_lam <= @SoLanLamMax);

    -- Step 2: Get total count
    SELECT @TotalCount = COUNT(*) FROM #TempFilteredQuizzes;

    -- Step 3: Return paginated results with sorting
    SELECT
        lop_hoc_id AS LopHocId,
        TenQuiz,
        so_lan_duoc_lam AS SoLanDuocLam,
        thoi_gian_mo AS ThoiGianMo,
        thoi_gian_dong AS ThoiGianDong,
        thoi_gian_lam_bai AS ThoiGianLamBai,
        Lop,
        MonHoc,
        GiaoVien,
        TrangThaiHienTai
    FROM #TempFilteredQuizzes
    ORDER BY
        CASE WHEN @SortBy = 1 THEN TenQuiz END ASC,
        CASE WHEN @SortBy = 2 THEN thoi_gian_dong END DESC,
        CASE WHEN @SortBy = 3 THEN thoi_gian_mo END DESC
    OFFSET (@Page * @Size) ROWS
    FETCH NEXT @Size ROWS ONLY;

    -- Step 4: Cleanup
    DROP TABLE #TempFilteredQuizzes;
END;
GO
