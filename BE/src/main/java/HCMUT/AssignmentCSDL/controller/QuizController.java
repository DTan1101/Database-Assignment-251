package HCMUT.AssignmentCSDL.controller;

import HCMUT.AssignmentCSDL.entity.Quiz;
import HCMUT.AssignmentCSDL.payload.request.QuizRequest;
import HCMUT.AssignmentCSDL.payload.request.QuizSearchRequest;
import HCMUT.AssignmentCSDL.payload.response.BaseResponse;
import HCMUT.AssignmentCSDL.payload.response.PagedResponse;
import HCMUT.AssignmentCSDL.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/quizzes")
@CrossOrigin
public class QuizController {
    @Autowired
    private QuizService quizService;

    @GetMapping("/search")
    public ResponseEntity<BaseResponse<PagedResponse<Quiz>>> searchQuizzes(
            @RequestParam(required = false) Integer lopHocId,
            @RequestParam(required = false) String tenQuiz,
            @RequestParam(required = false) Integer soLanDuocLamMin,
            @RequestParam(required = false) Integer soLanDuocLamMax,
            @RequestParam(required = false) String thoiGianMoFrom,
            @RequestParam(required = false) String thoiGianMoTo,
            @RequestParam(required = false) String thoiGianDongFrom,
            @RequestParam(required = false) String thoiGianDongTo,
            @RequestParam(required = false) Boolean isActive,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "9") Integer size,
            @RequestParam(defaultValue = "tenQuiz") String sortBy,
            @RequestParam(defaultValue = "ASC") String sortDirection
    ) {
        QuizSearchRequest request = new QuizSearchRequest(
                lopHocId, tenQuiz, soLanDuocLamMin, soLanDuocLamMax,
                thoiGianMoFrom, thoiGianMoTo, thoiGianDongFrom, thoiGianDongTo,
                isActive, page, size, sortBy, sortDirection
        );
        PagedResponse<Quiz> result = quizService.searchQuizzes(request);
        return ResponseEntity.ok(BaseResponse.success(result, "Search completed successfully"));
    }

    @PostMapping
    public ResponseEntity<?> createQuiz(@RequestBody QuizRequest request) {
        quizService.createQuiz(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseResponse.success(null, "Quiz created successfully"));
    }

    @PutMapping
    public ResponseEntity<?> updateQuiz(@RequestBody QuizRequest request) {
        quizService.updateQuiz(request);
        return ResponseEntity.ok(BaseResponse.success(null, "Quiz updated successfully"));
    }

    @DeleteMapping
    public ResponseEntity<?> deleteQuiz(@RequestBody QuizRequest request) {
        quizService.deleteQuiz(request);
        return ResponseEntity.ok(BaseResponse.success(null, "Quiz deleted successfully"));
    }
}
