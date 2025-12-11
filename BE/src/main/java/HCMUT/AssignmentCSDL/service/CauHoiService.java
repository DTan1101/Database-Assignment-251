package HCMUT.AssignmentCSDL.service;

import HCMUT.AssignmentCSDL.mapper.SqlErrorMapper;
import HCMUT.AssignmentCSDL.payload.request.CauHoiRequest;
import HCMUT.AssignmentCSDL.repo.CauHoiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

@Service
public class CauHoiService {
    @Autowired
    private CauHoiRepository cauHoiRepo;

    public void updateQuestion(CauHoiRequest request) {
        try {
            cauHoiRepo.updateCauHoi(
                    request.getLopHocId(),
                    request.getTenQuiz(),
                    request.getStt(),
                    request.getNoiDung(),
                    request.getDapAn()
            );
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }
}
