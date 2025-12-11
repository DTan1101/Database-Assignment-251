package HCMUT.AssignmentCSDL.service;

import HCMUT.AssignmentCSDL.dto.PersonDTO;
import HCMUT.AssignmentCSDL.dto.StudentProgressDTO;
import HCMUT.AssignmentCSDL.dto.TutorEfficiencyDTO;
import HCMUT.AssignmentCSDL.repo.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {

    @Autowired
    private ReportRepository reportRepo;

    public List<TutorEfficiencyDTO> getTutorReport(Integer giaSuId, Integer thang, Integer nam) {
        List<TutorEfficiencyDTO> result = reportRepo.getTutorEfficiency(giaSuId, thang, nam);

        if (result == null || result.isEmpty()) {
            throw new RuntimeException("No report data found for the given tutor and date.");
        }
        return result;
    }

    public StudentProgressDTO getStudentProgress(Integer hocVienId, Integer lopHocId) {
        List<StudentProgressDTO> result = reportRepo.getStudentProgress(hocVienId, lopHocId);

        if (result == null || result.isEmpty()) {
            throw new RuntimeException("No progress data found for the given student and class.");
        }
        return result.get(0);
    }

    /**
     * Lấy danh sách tất cả gia sư
     */
    public List<PersonDTO> getAllTutors() {
        return reportRepo.getAllTutors();
    }

    /**
     * Lấy danh sách tất cả học viên
     */
    public List<PersonDTO> getAllStudents() {
        return reportRepo.getAllStudents();
    }
}