package HCMUT.AssignmentCSDL.controller;

import HCMUT.AssignmentCSDL.dto.PersonDTO;
import HCMUT.AssignmentCSDL.dto.StudentProgressDTO;
import HCMUT.AssignmentCSDL.dto.TutorEfficiencyDTO;
import HCMUT.AssignmentCSDL.payload.response.BaseResponse;
import HCMUT.AssignmentCSDL.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/report")
@CrossOrigin
public class ReportController {

    @Autowired
    private ReportService reportService;

    // Báo cáo hiệu quả Gia sư (V6)
    // GET /api/report/tutor?giaSuId=10&thang=11&nam=2025
    @GetMapping("/tutor")
    public ResponseEntity<?> getTutorReport(
            @RequestParam Integer giaSuId,
            @RequestParam Integer thang,
            @RequestParam Integer nam) {

        List<TutorEfficiencyDTO> data = reportService.getTutorReport(giaSuId, thang, nam);

        return ResponseEntity.ok(BaseResponse.success(data, "Lấy báo cáo gia sư thành công"));
    }

    // Phân tích tiến độ Học viên (V7)
    // GET /api/report/student?hocVienId=51&lopHocId=902
    @GetMapping("/student")
    public ResponseEntity<?> getStudentProgress(
            @RequestParam Integer hocVienId,
            @RequestParam Integer lopHocId) {

        StudentProgressDTO data = reportService.getStudentProgress(hocVienId, lopHocId);

        return ResponseEntity.ok(BaseResponse.success(data, "Phân tích tiến độ thành công"));
    }

    // Lấy danh sách tất cả gia sư (id và tên)
    // GET /report/tutors
    @GetMapping("/tutors")
    public ResponseEntity<?> getAllTutors() {
        List<PersonDTO> data = reportService.getAllTutors();

        return ResponseEntity.ok(BaseResponse.success(data, "Lấy danh sách gia sư thành công"));
    }

    // Lấy danh sách tất cả học viên (id và tên)
    // GET /report/students
    @GetMapping("/students")
    public ResponseEntity<?> getAllStudents() {
        List<PersonDTO> data = reportService.getAllStudents();

        return ResponseEntity.ok(BaseResponse.success(data, "Lấy danh sách học viên thành công"));
    }
}