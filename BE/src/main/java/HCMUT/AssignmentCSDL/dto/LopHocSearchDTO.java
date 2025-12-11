package HCMUT.AssignmentCSDL.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class LopHocSearchDTO {
    private Integer maLop;          // lop_hoc_id
    private String monDay;          // ten_mon_hoc
    private String lop;             // lop_day
    private BigDecimal mucLuong;    // muc_luong
    private String diaChi;          // dia_chi
    private Integer soBuoi;         // so_buoi
    private String yeuCau;          // yeu_cau
    private String trangThaiGiao;   // trang_thai_giao
}

