package HCMUT.AssignmentCSDL.repo;

import HCMUT.AssignmentCSDL.dto.PersonDTO;
import HCMUT.AssignmentCSDL.dto.StudentProgressDTO;
import HCMUT.AssignmentCSDL.dto.TutorEfficiencyDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ReportRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<TutorEfficiencyDTO> getTutorEfficiency(Integer giaSuId, Integer thang, Integer nam) {
        String sql = "SELECT * FROM dbo.fn_ThongKeHieuQuaGiaSu(?, ?, ?)";

        // BeanPropertyRowMapper tự động map cột SQL (snake_case) sang field Java (camelCase)
        // Ví dụ: gia_su_id -> giaSuId, diem_chat_luong -> diemChatLuong
        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(TutorEfficiencyDTO.class),
                giaSuId, thang, nam
        );
    }

    public List<StudentProgressDTO> getStudentProgress(Integer hocVienId, Integer lopHocId) {
        String sql = "SELECT * FROM dbo.fn_PhanTichTienDoHocVien(?, ?)";

        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(StudentProgressDTO.class),
                hocVienId, lopHocId
        );
    }

    /**
     * Lấy danh sách tất cả gia sư (id và tên)
     */
    public List<PersonDTO> getAllTutors() {
        String sql = "SELECT gia_su_id as id, ho_ten as name FROM gia_su ORDER BY ho_ten";

        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(PersonDTO.class));
    }

    /**
     * Lấy danh sách tất cả học viên (id và tên)
     */
    public List<PersonDTO> getAllStudents() {
        String sql = "SELECT hoc_vien_id as id, ho_ten as name FROM hoc_vien ORDER BY hoc_vien_id";

        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(PersonDTO.class));
    }
}