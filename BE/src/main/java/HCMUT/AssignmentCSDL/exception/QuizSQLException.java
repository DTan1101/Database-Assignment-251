package HCMUT.AssignmentCSDL.exception;

import lombok.Getter;

@Getter
public class QuizSQLException extends RuntimeException {
    private final QuizErrorCode errorCode;
    private final String originalSqlError; // Lỗi gốc

    public QuizSQLException(QuizErrorCode errorCode, String originalSqlError) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.originalSqlError = originalSqlError;
    }
}
