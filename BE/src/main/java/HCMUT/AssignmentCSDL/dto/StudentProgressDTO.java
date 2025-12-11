package HCMUT.AssignmentCSDL.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class StudentProgressDTO {
    private Integer hocVienId;
    private String tenHocVien;
    private Integer soBaiDaLam;
    private Integer soQuizBiLo;
    private BigDecimal diemTrungBinh;
    private BigDecimal diemCaoNhat;
    private BigDecimal diemThapNhat;
    private String xuHuong;
    private String nhanXet;
    private String lichSuDiem;  // Chuỗi chứa tất cả điểm (thêm mới)
}
