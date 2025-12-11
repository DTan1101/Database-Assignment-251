package HCMUT.AssignmentCSDL.controller;

import HCMUT.AssignmentCSDL.payload.request.CauHoiRequest;
import HCMUT.AssignmentCSDL.payload.response.BaseResponse;
import HCMUT.AssignmentCSDL.service.CauHoiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/questions")
@CrossOrigin
public class CauHoiController {
    @Autowired
    private CauHoiService cauHoiService;

    @PutMapping
    public ResponseEntity<?> updateQuestion(@RequestBody CauHoiRequest request) {
        cauHoiService.updateQuestion(request);
        return ResponseEntity.ok(BaseResponse.success(null, "Question updated successfully"));
    }
}

