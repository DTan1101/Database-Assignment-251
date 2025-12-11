package HCMUT.AssignmentCSDL.exception;

import HCMUT.AssignmentCSDL.payload.response.BaseResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class CentralException {
    /**
     * Xử lý lỗi nghiệp vụ (Business Logic & SQL Validation)
     */
    @ExceptionHandler(QuizSQLException.class)
    public ResponseEntity<BaseResponse<String>> handleQuizException(QuizSQLException ex) {
        // Trả về BaseResponse với data là thông báo lỗi gốc SQL (để debug)
        BaseResponse<String> response = new BaseResponse<>(
                ex.getErrorCode().getCode(),
                ex.getMessage(),
                ex.getOriginalSqlError()
        );

        // HTTP Status vẫn là 400 (Bad Request) nhưng body JSON theo chuẩn BaseResponse
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    /**
     * Xử lý các lỗi hệ thống không mong muốn (System Error)
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<BaseResponse<String>> handleGenericException(Exception ex) {
        BaseResponse<String> response = new BaseResponse<>(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Lỗi hệ thống không mong muốn.",
                ex.getMessage()
        );

        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
