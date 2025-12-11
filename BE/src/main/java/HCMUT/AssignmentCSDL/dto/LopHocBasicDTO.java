package HCMUT.AssignmentCSDL.dto;

import lombok.Data;

@Data
public class LopHocBasicDTO {
    private Integer lopHocId;
    private String thongTin;  // Kết hợp: "Môn học - Lớp - Địa chỉ"
}

