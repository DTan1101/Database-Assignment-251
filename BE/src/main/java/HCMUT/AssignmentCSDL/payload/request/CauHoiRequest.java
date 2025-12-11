package HCMUT.AssignmentCSDL.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CauHoiRequest {
    private Integer lopHocId;
    private String tenQuiz;
    private Integer stt;
    private String noiDung;
    private String dapAn;
}

