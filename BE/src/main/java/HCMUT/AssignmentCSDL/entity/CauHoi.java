package HCMUT.AssignmentCSDL.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CauHoi {
    private Integer lopHocId;
    private String tenQuiz;
    private Integer stt;
    private String cauHoi;
    private String dapAn;
}

