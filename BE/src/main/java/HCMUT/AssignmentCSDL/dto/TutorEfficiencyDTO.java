package HCMUT.AssignmentCSDL.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class TutorEfficiencyDTO {
    private Integer thang;
    private Integer nam;
    private Integer giaSuId;
    private String hoTen;
    private Integer soLopDangDay;
    private Integer tongHocVien;
    private Integer hopDongHieuLuc;      // hop_dong_hieu_luc
    private BigDecimal doanhThuDuKien;   // doanh_thu_du_kien
    private BigDecimal diemChatLuong;    // diem_chat_luong
    private String xepHang;
    private String nhanXet;
}