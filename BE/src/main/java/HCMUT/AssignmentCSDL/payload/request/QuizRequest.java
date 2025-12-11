package HCMUT.AssignmentCSDL.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuizRequest {
    private Integer lopHocId;
    private String tenQuiz;
    private String oldName; // For update operation
    private Integer soLanDuocLam;
    private LocalDateTime thoiGianDong;
    private LocalDateTime thoiGianMo;
}

