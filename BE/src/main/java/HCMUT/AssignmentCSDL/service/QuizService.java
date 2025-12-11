package HCMUT.AssignmentCSDL.service;

import HCMUT.AssignmentCSDL.entity.Quiz;
import HCMUT.AssignmentCSDL.mapper.SqlErrorMapper;
import HCMUT.AssignmentCSDL.payload.request.QuizRequest;
import HCMUT.AssignmentCSDL.payload.request.QuizSearchRequest;
import HCMUT.AssignmentCSDL.payload.response.PagedResponse;
import HCMUT.AssignmentCSDL.repo.QuizRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuizService {
    @Autowired
    private QuizRepository quizRepo;

    public void createQuiz(QuizRequest request) {
        try {
            Quiz quiz = new Quiz(
                    request.getLopHocId(),
                    request.getTenQuiz(),
                    request.getSoLanDuocLam(),
                    request.getThoiGianDong(),
                    request.getThoiGianMo()
            );
            quizRepo.insertQuiz(quiz);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }

    public void updateQuiz(QuizRequest request) {
        try {
            Quiz quizData = new Quiz(
                    request.getLopHocId(),
                    request.getTenQuiz(),
                    request.getSoLanDuocLam(),
                    request.getThoiGianDong(),
                    request.getThoiGianMo()
            );
            System.out.println("Quiz data:" + quizData);
            quizRepo.updateQuiz(request.getLopHocId(), request.getOldName(), quizData);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }

    public void deleteQuiz(QuizRequest request) {
        try {
            quizRepo.deleteQuiz(request.getLopHocId(), request.getTenQuiz());
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }

    public PagedResponse<Quiz> searchQuizzes(QuizSearchRequest request) {
        try {
            // Validate and set defaults
            if (request.getPage() == null || request.getPage() < 0) {
                request.setPage(0);
            }
            if (request.getSize() == null || request.getSize() <= 0) {
                request.setSize(10);
            }
            if (request.getSize() > 100) {
                request.setSize(100); // Max 100 items per page
            }
            if (request.getSortBy() == null || request.getSortBy().isEmpty()) {
                request.setSortBy("tenQuiz");
            }
            if (request.getSortDirection() == null || request.getSortDirection().isEmpty()) {
                request.setSortDirection("ASC");
            }

            // Get data
            List<Quiz> quizzes = quizRepo.searchQuizzes(request);
            long totalElements = quizRepo.countQuizzes(request);

            return PagedResponse.of(quizzes, request.getPage(), request.getSize(), totalElements);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }
}
