package HCMUT.AssignmentCSDL.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LopHoc {
    private Integer lopHocId;
    private String diaChi;
    private String trangThaiGiao;
    private String thongTin;
    private String lopDay;
    private String hinhThuc;
    private BigDecimal mucLuong;
    private String yeuCau;
    private Integer soBuoi;
    private Integer adminId;
    private Integer giaSuId;
}

