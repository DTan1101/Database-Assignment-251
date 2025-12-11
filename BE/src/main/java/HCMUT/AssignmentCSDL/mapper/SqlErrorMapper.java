package HCMUT.AssignmentCSDL.mapper;

import HCMUT.AssignmentCSDL.exception.QuizErrorCode;
import HCMUT.AssignmentCSDL.exception.QuizSQLException;
import org.springframework.dao.DataAccessException;

import java.sql.SQLException;

public class SqlErrorMapper {

    public static RuntimeException map(DataAccessException e) {
        Throwable rootCause = e;
        while (rootCause.getCause() != null && rootCause.getCause() != rootCause) {
            rootCause = rootCause.getCause();
        }

        String sqlMessage = rootCause.getMessage();
        QuizErrorCode errorCode = getQuizErrorCode(rootCause);

        if (errorCode != QuizErrorCode.UNKNOWN_ERROR) {
            return new QuizSQLException(errorCode, sqlMessage);
        }
        // Nếu không xác định được mã lỗi cụ thể, trả về lỗi gốc
        return e;
    }

    private static QuizErrorCode getQuizErrorCode(Throwable rootCause) {
        int sqlErrorNumber = 0;

        // Nếu root cause là SQLException, ta có thể lấy ErrorCode chính xác
        if (rootCause instanceof SQLException) {
            sqlErrorNumber = ((SQLException) rootCause).getErrorCode();
        }
        return QuizErrorCode.fromCode(sqlErrorNumber);
    }
}
