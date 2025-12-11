package HCMUT.AssignmentCSDL.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LopHocSearchRequest {
    private String tenMonHoc;       // @TenMonHoc
    private String khuVuc;          // @KhuVuc
    private BigDecimal mucLuongMin; // @MucLuongMin
    private BigDecimal mucLuongMax; // @MucLuongMax
    private String trangThai;       // @TrangThai
    private Integer sortBy;         // @SortBy (1=ASC, 2=DESC, 3=Newest)

    // Paging parameters
    private Integer page;           // Trang hiện tại (0-based)
    private Integer size;           // Số items mỗi trang

    // Default sortBy = 1 nếu không truyền
    public Integer getSortBy() {
        return sortBy != null ? sortBy : 1;
    }

    // Default page = 0
    public Integer getPage() {
        return page != null ? page : 0;
    }

    // Default size = 9
    public Integer getSize() {
        return size != null ? size : 9;
    }
}

