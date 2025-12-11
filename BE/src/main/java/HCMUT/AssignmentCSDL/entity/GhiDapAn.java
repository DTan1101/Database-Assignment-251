package HCMUT.AssignmentCSDL.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GhiDapAn {
    private Integer lopHocId;
    private String tenQuiz;
    private Integer sttQuiz;
    private Integer lichSuId;
    private String dapAnCuaLanLamBai;
}

