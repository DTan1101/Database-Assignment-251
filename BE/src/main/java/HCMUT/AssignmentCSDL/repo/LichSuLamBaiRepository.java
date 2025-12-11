package HCMUT.AssignmentCSDL.repo;

import HCMUT.AssignmentCSDL.entity.LichSuLamBai;
import HCMUT.AssignmentCSDL.payload.request.LichSuLamBaiRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class LichSuLamBaiRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Get history with filters and pagination
    public List<LichSuLamBai> getLichSuLamBai(LichSuLamBaiRequest request) {
        StringBuilder sql = new StringBuilder(
            "SELECT id, lop_hoc_id, ten_quiz, lan, diem, " +
            "thoi_gian_bat_dau, thoi_gian_ket_thuc, hoc_vien_id " +
            "FROM lich_su_lam_bai WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Build WHERE clause dynamically
        if (request.getLopHocId() != null && request.getTenQuiz() != null) {
            sql.append(" AND lop_hoc_id = ? AND ten_quiz = ?");
            params.add(request.getLopHocId());
            params.add(request.getTenQuiz());
        } else if (request.getLopHocId() != null) {
            sql.append(" AND lop_hoc_id = ?");
            params.add(request.getLopHocId());
        } else if (request.getTenQuiz() != null) {
            sql.append(" AND ten_quiz = ?");
            params.add(request.getTenQuiz());
        }

        if (request.getHocVienId() != null) {
            sql.append(" AND hoc_vien_id = ?");
            params.add(request.getHocVienId());
        }

        // Add ORDER BY clause
        String sortBy = mapSortField(request.getSortBy());
        String sortDirection = request.getSortDirection().equalsIgnoreCase("DESC") ? "DESC" : "ASC";
        sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortDirection);

        // Add OFFSET and FETCH for pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(request.getPage() * request.getSize());
        params.add(request.getSize());

        return jdbcTemplate.query(sql.toString(), params.toArray(),
                BeanPropertyRowMapper.newInstance(LichSuLamBai.class));
    }

    // Count total records
    public long countLichSuLamBai(LichSuLamBaiRequest request) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM lich_su_lam_bai WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Build WHERE clause (same as get method)
        if (request.getLopHocId() != null && request.getTenQuiz() != null) {
            sql.append(" AND lop_hoc_id = ? AND ten_quiz = ?");
            params.add(request.getLopHocId());
            params.add(request.getTenQuiz());
        } else if (request.getLopHocId() != null) {
            sql.append(" AND lop_hoc_id = ?");
            params.add(request.getLopHocId());
        } else if (request.getTenQuiz() != null) {
            sql.append(" AND ten_quiz = ?");
            params.add(request.getTenQuiz());
        }

        if (request.getHocVienId() != null) {
            sql.append(" AND hoc_vien_id = ?");
            params.add(request.getHocVienId());
        }

        Long count = jdbcTemplate.queryForObject(sql.toString(), params.toArray(), Long.class);
        return count != null ? count : 0;
    }

    // Map Java field names to database column names
    private String mapSortField(String field) {
        if (field == null) return "thoi_gian_bat_dau";
        switch (field) {
            case "id":
                return "id";
            case "lopHocId":
                return "lop_hoc_id";
            case "tenQuiz":
                return "ten_quiz";
            case "lan":
                return "lan";
            case "diem":
                return "diem";
            case "thoiGianBatDau":
                return "thoi_gian_bat_dau";
            case "thoiGianKetThuc":
                return "thoi_gian_ket_thuc";
            case "hocVienId":
                return "hoc_vien_id";
            default:
                return "thoi_gian_bat_dau";
        }
    }
}

