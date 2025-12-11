package HCMUT.AssignmentCSDL.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GiaSu {
    private Integer giaSuId;
    private String hoTen;
    private String diaChiHienTai;
    private String nguyenQuan;
    private String truongDaoTao;
    private String trinhDo;
    private String nienKhoa;
    private String email;
    private LocalDate ngaySinh;
    private String nganhHoc;
    private String linkFacebook;
    private String tinhThanhDay;
    private String soCccd;
}

