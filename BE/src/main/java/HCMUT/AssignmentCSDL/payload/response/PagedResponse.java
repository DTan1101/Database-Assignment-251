package HCMUT.AssignmentCSDL.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PagedResponse<T> {
    private List<T> content; // Danh sách items trong trang hiện tại
    private int currentPage; // Trang hiện tại
    private int pageSize; // Số items mỗi trang
    private long totalElements; // Tổng số items
    private int totalPages; // Tổng số trang
    private boolean first; // Có phải trang đầu không
    private boolean last; // Có phải trang cuối không

    public static <T> PagedResponse<T> of(List<T> content, int page, int size, long totalElements) {
        int totalPages = (int) Math.ceil((double) totalElements / size);
        return new PagedResponse<>(
                content,
                page,
                size,
                totalElements,
                totalPages,
                page == 0,
                page >= totalPages - 1
        );
    }
}

