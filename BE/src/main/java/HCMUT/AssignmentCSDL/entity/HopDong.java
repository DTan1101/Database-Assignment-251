package HCMUT.AssignmentCSDL.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HopDong {
    private Integer adminId;
    private Integer giaSuId;
    private LocalDateTime thoiGianKy;
    private String noiDungDieuKhoan;
}

