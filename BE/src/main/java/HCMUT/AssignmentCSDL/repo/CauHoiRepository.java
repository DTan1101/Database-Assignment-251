package HCMUT.AssignmentCSDL.repo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;
@Repository
public class CauHoiRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void updateCauHoi(Integer lopHocId, String tenQuiz, Integer stt,
                             String noiDungCauHoi, String dapAnMoi) {

        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("UpdateCauHoi");

        Map<String, Object> inParams = new HashMap<>();
        inParams.put("lop_hoc_id", lopHocId);
        inParams.put("ten_quiz", tenQuiz);
        inParams.put("stt", stt);
        inParams.put("cau_hoi", noiDungCauHoi);
        inParams.put("dap_an", dapAnMoi);

        jdbcCall.execute(inParams);
    }
}
