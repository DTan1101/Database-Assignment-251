USE TutorSS
GO

CREATE OR ALTER PROCEDURE sp_TimKiemLopHocNangCao
    @TenMonHoc NVARCHAR(50) = NULL,      
    @KhuVuc NVARCHAR(50) = NULL,         
    @MucLuongMin DECIMAL(18,0) = NULL,   
    @MucLuongMax DECIMAL(18,0) = NULL,
    @TrangThai NVARCHAR(50) = NULL,      
    @SortBy INT = 1                      
AS
BEGIN
    SELECT 
        lh.lop_hoc_id AS MaLop,          
        mh.ten_mon_hoc AS MonDay,
        lh.lop_day AS Lop,
        lh.muc_luong,
        lh.dia_chi,
        lh.so_buoi,
        lh.yeu_cau,
        lh.trang_thai_giao
    FROM 
        lop_hoc lh                       
    LEFT JOIN 
        day d ON lh.lop_hoc_id = d.lop_hoc_id
    LEFT JOIN 
        mon_hoc mh ON d.mon_hoc_id = mh.mon_hoc_id 
    WHERE 
        (@TenMonHoc IS NULL OR mh.ten_mon_hoc LIKE N'%' + @TenMonHoc + '%')
        AND (@KhuVuc IS NULL OR lh.dia_chi LIKE N'%' + @KhuVuc + '%')
        AND (@MucLuongMin IS NULL OR lh.muc_luong >= @MucLuongMin)
        AND (@MucLuongMax IS NULL OR lh.muc_luong <= @MucLuongMax)
        AND (@TrangThai IS NULL OR lh.trang_thai_giao = @TrangThai)
    ORDER BY 
        CASE WHEN @SortBy = 1 THEN lh.muc_luong END ASC,
        CASE WHEN @SortBy = 2 THEN lh.muc_luong END DESC,
        CASE WHEN @SortBy = 3 THEN lh.lop_hoc_id END DESC;
END;
GO

EXEC sp_TimKiemLopHocNangCao 
    @TenMonHoc = N'Toán', 
    @MucLuongMin = 4000000, 
    @SortBy = 2; 

EXEC sp_TimKiemLopHocNangCao 
    @KhuVuc = N'Q.10', 
    @SortBy = 1;