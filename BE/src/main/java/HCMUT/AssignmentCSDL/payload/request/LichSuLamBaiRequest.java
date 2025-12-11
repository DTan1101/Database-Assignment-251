package HCMUT.AssignmentCSDL.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LichSuLamBaiRequest {
    private Integer lopHocId;
    private String tenQuiz;
    private Integer hocVienId;

    // Pagination
    private Integer page = 0;
    private Integer size = 10;

    // Sorting
    private String sortBy = "thoiGianBatDau"; // id, thoiGianBatDau, diem, lan
    private String sortDirection = "DESC"; // ASC or DESC
}

