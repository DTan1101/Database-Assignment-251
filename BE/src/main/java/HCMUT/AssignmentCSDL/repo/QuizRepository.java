package HCMUT.AssignmentCSDL.repo;

import HCMUT.AssignmentCSDL.entity.Quiz;
import HCMUT.AssignmentCSDL.payload.request.QuizSearchRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Repository
public class QuizRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 1. Gọi thủ tục InsertQuiz (V3)
    public void insertQuiz(Quiz quiz) {
        // Khởi tạo SimpleJdbcCall định danh tên thủ tục
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("InsertQuiz");

        // Map tham số Java -> Tham số SQL (tên phải khớp với trong file .sql)
        Map<String, Object> inParams = new HashMap<>();
        inParams.put("lop_hoc_id", quiz.getLopHocId());
        inParams.put("ten_quiz", quiz.getTenQuiz());
        inParams.put("so_lan_duoc_lam", quiz.getSoLanDuocLam());
        inParams.put("thoi_gian_mo", quiz.getThoiGianMo());
        inParams.put("thoi_gian_dong", quiz.getThoiGianDong());

        // Thực thi
        jdbcCall.execute(inParams);
    }

    // 2. Gọi thủ tục UpdateQuiz (V2)
    public void updateQuiz(Integer lopHocId, String oldName, Quiz quizData) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("UpdateQuiz");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("lop_hoc_id", lopHocId);
        inParams.put("ten_quiz", oldName);            // PK cũ để tìm dòng cần sửa
        inParams.put("new_ten_quiz", quizData.getTenQuiz()); // Tên mới (nếu đổi)
        inParams.put("so_lan_duoc_lam", quizData.getSoLanDuocLam());
        inParams.put("thoi_gian_mo", quizData.getThoiGianMo());
        inParams.put("thoi_gian_dong", quizData.getThoiGianDong());

        jdbcCall.execute(inParams);
    }

    public void deleteQuiz(Integer lopHocId, String tenQuiz) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("DeleteQuiz");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("lop_hoc_id", lopHocId);
        inParams.put("ten_quiz", tenQuiz);

        jdbcCall.execute(inParams);
    }

    // Search with pagination and sorting
    public List<Quiz> searchQuizzes(QuizSearchRequest request) {
        StringBuilder sql = new StringBuilder("SELECT lop_hoc_id, ten_quiz, so_lan_duoc_lam, thoi_gian_mo, thoi_gian_dong FROM QUIZ WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Build WHERE clause dynamically
        if (request.getLopHocId() != null) {
            sql.append(" AND lop_hoc_id = ?");
            params.add(request.getLopHocId());
        }
        if (request.getTenQuiz() != null && !request.getTenQuiz().trim().isEmpty()) {
            sql.append(" AND ten_quiz LIKE ?");
            params.add("%" + request.getTenQuiz().trim() + "%");
        }

        // Filter by soLanDuocLam range
        if (request.getSoLanDuocLamMin() != null) {
            sql.append(" AND so_lan_duoc_lam >= ?");
            params.add(request.getSoLanDuocLamMin());
        }
        if (request.getSoLanDuocLamMax() != null) {
            sql.append(" AND so_lan_duoc_lam <= ?");
            params.add(request.getSoLanDuocLamMax());
        }

        // Filter by thoiGianMo range
        if (request.getThoiGianMoFrom() != null && !request.getThoiGianMoFrom().trim().isEmpty()) {
            sql.append(" AND thoi_gian_mo >= ?");
            params.add(request.getThoiGianMoFrom());
        }
        if (request.getThoiGianMoTo() != null && !request.getThoiGianMoTo().trim().isEmpty()) {
            sql.append(" AND thoi_gian_mo <= ?");
            params.add(request.getThoiGianMoTo());
        }

        // Filter by thoiGianDong range
        if (request.getThoiGianDongFrom() != null && !request.getThoiGianDongFrom().trim().isEmpty()) {
            sql.append(" AND thoi_gian_dong >= ?");
            params.add(request.getThoiGianDongFrom());
        }
        if (request.getThoiGianDongTo() != null && !request.getThoiGianDongTo().trim().isEmpty()) {
            sql.append(" AND thoi_gian_dong <= ?");
            params.add(request.getThoiGianDongTo());
        }

        // Filter by active status (currently open)
        if (request.getIsActive() != null) {
            if (request.getIsActive()) {
                // Quiz is currently active (open)
                sql.append(" AND GETDATE() >= thoi_gian_mo AND GETDATE() <= thoi_gian_dong");
            } else {
                // Quiz is closed
                sql.append(" AND (GETDATE() < thoi_gian_mo OR GETDATE() > thoi_gian_dong)");
            }
        }

        // Add ORDER BY clause
        String sortBy = mapSortField(request.getSortBy());
        String sortDirection = request.getSortDirection().equalsIgnoreCase("DESC") ? "DESC" : "ASC";

        // Special handling for soLanDuocLam: NULL means unlimited (highest value)
        if ("so_lan_duoc_lam".equals(sortBy)) {
            // Use ISNULL to treat NULL as maximum integer value (2147483647)
            sql.append(" ORDER BY ISNULL(").append(sortBy).append(", 2147483647) ").append(sortDirection);
        } else {
            sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortDirection);
        }

        // Add OFFSET and FETCH for pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(request.getPage() * request.getSize());
        params.add(request.getSize());

        return jdbcTemplate.query(sql.toString(), params.toArray(),
                BeanPropertyRowMapper.newInstance(Quiz.class));
    }

    // Count total records for pagination
    public long countQuizzes(QuizSearchRequest request) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM QUIZ WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Build WHERE clause (same as search)
        if (request.getLopHocId() != null) {
            sql.append(" AND lop_hoc_id = ?");
            params.add(request.getLopHocId());
        }
        if (request.getTenQuiz() != null && !request.getTenQuiz().trim().isEmpty()) {
            sql.append(" AND ten_quiz LIKE ?");
            params.add("%" + request.getTenQuiz().trim() + "%");
        }

        // Filter by soLanDuocLam range
        if (request.getSoLanDuocLamMin() != null) {
            sql.append(" AND so_lan_duoc_lam >= ?");
            params.add(request.getSoLanDuocLamMin());
        }
        if (request.getSoLanDuocLamMax() != null) {
            sql.append(" AND so_lan_duoc_lam <= ?");
            params.add(request.getSoLanDuocLamMax());
        }

        // Filter by thoiGianMo range
        if (request.getThoiGianMoFrom() != null && !request.getThoiGianMoFrom().trim().isEmpty()) {
            sql.append(" AND thoi_gian_mo >= ?");
            params.add(request.getThoiGianMoFrom());
        }
        if (request.getThoiGianMoTo() != null && !request.getThoiGianMoTo().trim().isEmpty()) {
            sql.append(" AND thoi_gian_mo <= ?");
            params.add(request.getThoiGianMoTo());
        }

        // Filter by thoiGianDong range
        if (request.getThoiGianDongFrom() != null && !request.getThoiGianDongFrom().trim().isEmpty()) {
            sql.append(" AND thoi_gian_dong >= ?");
            params.add(request.getThoiGianDongFrom());
        }
        if (request.getThoiGianDongTo() != null && !request.getThoiGianDongTo().trim().isEmpty()) {
            sql.append(" AND thoi_gian_dong <= ?");
            params.add(request.getThoiGianDongTo());
        }

        // Filter by active status
        if (request.getIsActive() != null) {
            if (request.getIsActive()) {
                sql.append(" AND GETDATE() >= thoi_gian_mo AND GETDATE() <= thoi_gian_dong");
            } else {
                sql.append(" AND (GETDATE() < thoi_gian_mo OR GETDATE() > thoi_gian_dong)");
            }
        }

        Long count = jdbcTemplate.queryForObject(sql.toString(), params.toArray(), Long.class);
        return count != null ? count : 0;
    }

    // Map Java field names to database column names
    private String mapSortField(String field) {
        if (field == null) return "ten_quiz";
        switch (field) {
            case "lopHocId":
                return "lop_hoc_id";
            case "tenQuiz":
                return "ten_quiz";
            case "soLanDuocLam":
                return "so_lan_duoc_lam";
            case "thoiGianMo":
                return "thoi_gian_mo";
            case "thoiGianDong":
                return "thoi_gian_dong";
            default:
                return "ten_quiz";
        }
    }

}
