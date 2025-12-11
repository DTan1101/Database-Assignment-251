package HCMUT.AssignmentCSDL.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ChiTietDiemLopHocDTO {
    private String tenMon;              // ten_mon_hoc
    private Integer maLop;              // lop_hoc_id
    private String tenGiaSu;            // ho_ten
    private BigDecimal hocPhi;          // muc_luong
    private Integer soHocVien;          // COUNT(DISTINCT tg.hoc_vien_id)
    private BigDecimal diemTrungBinh;   // AVG(ls.diem)
    private String danhSachDiemRaw;     // STRING_AGG(CAST(ls.diem AS VARCHAR), ',')
}

