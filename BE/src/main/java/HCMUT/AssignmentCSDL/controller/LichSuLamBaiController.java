package HCMUT.AssignmentCSDL.controller;

import HCMUT.AssignmentCSDL.entity.LichSuLamBai;
import HCMUT.AssignmentCSDL.payload.request.LichSuLamBaiRequest;
import HCMUT.AssignmentCSDL.payload.response.BaseResponse;
import HCMUT.AssignmentCSDL.payload.response.PagedResponse;
import HCMUT.AssignmentCSDL.service.LichSuLamBaiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/history")
@CrossOrigin
public class LichSuLamBaiController {

    @Autowired
    private LichSuLamBaiService lichSuLamBaiService;

    @GetMapping
    public ResponseEntity<?> getLichSuLamBai(
            @RequestParam(required = false) Integer lopHocId,
            @RequestParam(required = false) String tenQuiz,
            @RequestParam(required = false) Integer hocVienId,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "9") Integer size,
            @RequestParam(defaultValue = "thoiGianBatDau") String sortBy,
            @RequestParam(defaultValue = "DESC") String sortDirection
    ) {
        LichSuLamBaiRequest request = new LichSuLamBaiRequest(
                lopHocId, tenQuiz, hocVienId, page, size, sortBy, sortDirection
        );
        PagedResponse<LichSuLamBai> result = lichSuLamBaiService.getLichSuLamBai(request);
        return ResponseEntity.ok(BaseResponse.success(result, "Lấy lịch sử làm bài thành công"));
    }
}

