package HCMUT.AssignmentCSDL.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuizSearchRequest {
    // Search filters
    private Integer lopHocId;
    private String tenQuiz; // Search by quiz name (partial match)

    // Range filters
    private Integer soLanDuocLamMin; // Minimum number of attempts
    private Integer soLanDuocLamMax; // Maximum number of attempts

    // Date range filters (ISO 8601 format: yyyy-MM-ddTHH:mm:ss)
    private String thoiGianMoFrom; // Start of opening time range
    private String thoiGianMoTo; // End of opening time range
    private String thoiGianDongFrom; // Start of closing time range
    private String thoiGianDongTo; // End of closing time range

    // Status filter
    private Boolean isActive; // true = currently open, false = closed, null = all

    // Pagination
    private Integer page = 0; // Page number (0-based)
    private Integer size = 9; // Items per page

    // Sorting
    private String sortBy = "tenQuiz"; // Field to sort by: tenQuiz, soLanDuocLam, thoiGianMo, thoiGianDong
    private String sortDirection = "ASC"; // ASC or DESC
}

