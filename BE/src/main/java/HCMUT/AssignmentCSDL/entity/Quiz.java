package HCMUT.AssignmentCSDL.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Quiz {
    private Integer lopHocId;
    private String tenQuiz;
    private Integer soLanDuocLam;
    private LocalDateTime thoiGianDong;
    private LocalDateTime thoiGianMo;
}

