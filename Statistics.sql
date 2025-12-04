USE TutorSS
GO

CREATE OR ALTER PROCEDURE sp_ThongKeLopTheoMonHoc
    @Thang INT,
    @Nam INT,
    @MinSoLop INT = 0
AS
BEGIN
    SELECT 
        mh.ten_mon_hoc,
        COUNT(lh.lop_hoc_id) AS Tong_So_Lop,          
        SUM(lh.muc_luong) AS Tong_Gia_Tri_Lop,   
        AVG(lh.muc_luong) AS Luong_Trung_Binh
    FROM 
        lop_hoc lh 
    JOIN 
        day d ON lh.lop_hoc_id = d.lop_hoc_id         
    JOIN 
        mon_hoc mh ON d.mon_hoc_id = mh.mon_hoc_id    
    WHERE 
        1=1 
    GROUP BY 
        mh.ten_mon_hoc                           
    HAVING 
        COUNT(lh.lop_hoc_id) >= @MinSoLop             
    ORDER BY 
        Tong_So_Lop DESC;                        
END;
GO

EXEC sp_ThongKeLopTheoMonHoc 
    @Thang = 10, 
    @Nam = 2025, 
    @MinSoLop = 1; 