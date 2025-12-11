package HCMUT.AssignmentCSDL.repo;

import HCMUT.AssignmentCSDL.dto.ChiTietDiemLopHocDTO;
import HCMUT.AssignmentCSDL.dto.LopHocBasicDTO;
import HCMUT.AssignmentCSDL.dto.LopHocSearchDTO;
import HCMUT.AssignmentCSDL.payload.request.LopHocSearchRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class LopHocRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Gọi stored procedure sp_TimKiemLopHocNangCao (V9)
     * Tìm kiếm lớp học với các tiêu chí nâng cao
     * Note: Stored procedure không hỗ trợ paging nên phải handle ở application layer
     */
    public List<LopHocSearchDTO> searchLopHoc(LopHocSearchRequest request) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("sp_TimKiemLopHocNangCao")
                .returningResultSet("result", new BeanPropertyRowMapper<>(LopHocSearchDTO.class));

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("TenMonHoc", request.getTenMonHoc());
        inParams.put("KhuVuc", request.getKhuVuc());
        inParams.put("MucLuongMin", request.getMucLuongMin());
        inParams.put("MucLuongMax", request.getMucLuongMax());
        inParams.put("TrangThai", request.getTrangThai());
        inParams.put("SortBy", request.getSortBy());

        Map<String, Object> out = jdbcCall.execute(inParams);

        @SuppressWarnings("unchecked")
        List<LopHocSearchDTO> allResults = (List<LopHocSearchDTO>) out.get("result");

        if (allResults == null || allResults.isEmpty()) {
            return List.of();
        }

        // Apply pagination manually since stored procedure doesn't support it
        int totalElements = allResults.size();
        int page = request.getPage();
        int size = request.getSize();
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, totalElements);

        if (startIndex >= totalElements) {
            return List.of();
        }

        return allResults.subList(startIndex, endIndex);
    }

    /**
     * Đếm tổng số lớp học thỏa mãn điều kiện tìm kiếm
     * Gọi cùng stored procedure nhưng chỉ để lấy count
     */
    public long countLopHoc(LopHocSearchRequest request) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("sp_TimKiemLopHocNangCao")
                .returningResultSet("result", new BeanPropertyRowMapper<>(LopHocSearchDTO.class));

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("TenMonHoc", request.getTenMonHoc());
        inParams.put("KhuVuc", request.getKhuVuc());
        inParams.put("MucLuongMin", request.getMucLuongMin());
        inParams.put("MucLuongMax", request.getMucLuongMax());
        inParams.put("TrangThai", request.getTrangThai());
        inParams.put("SortBy", request.getSortBy());

        Map<String, Object> out = jdbcCall.execute(inParams);

        @SuppressWarnings("unchecked")
        List<LopHocSearchDTO> result = (List<LopHocSearchDTO>) out.get("result");

        return result != null ? result.size() : 0;
    }

    /**
     * Gọi stored procedure sp_LayChiTietDiemLopHoc (V10)
     * Lấy thống kê chi tiết điểm của các lớp học
     */
    public List<ChiTietDiemLopHocDTO> getChiTietDiemLopHoc(Integer minSoBaiLam) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("sp_LayChiTietDiemLopHoc")
                .returningResultSet("result", new BeanPropertyRowMapper<>(ChiTietDiemLopHocDTO.class));

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("MinSoBaiLam", minSoBaiLam != null ? minSoBaiLam : 1);

        Map<String, Object> out = jdbcCall.execute(inParams);

        @SuppressWarnings("unchecked")
        List<ChiTietDiemLopHocDTO> result = (List<ChiTietDiemLopHocDTO>) out.get("result");

        return result != null ? result : List.of();
    }

    /**
     * Lấy danh sách lớp học của một học viên (các lớp mà học viên đó tham gia)
     */
    public List<LopHocBasicDTO> getLopHocByHocVien(Integer hocVienId) {
        String sql = "SELECT lh.lop_hoc_id AS lopHocId, " +
                     "       lh.thong_tin AS thongTin " +
                     "FROM lop_hoc lh " +
                     "INNER JOIN tham_gia tg ON lh.lop_hoc_id = tg.lop_hoc_id " +
                     "WHERE tg.hoc_vien_id = ? " +
                     "ORDER BY lh.lop_hoc_id";

        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(LopHocBasicDTO.class), hocVienId);
    }
}
