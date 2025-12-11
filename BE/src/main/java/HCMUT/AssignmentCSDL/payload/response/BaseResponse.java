package HCMUT.AssignmentCSDL.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BaseResponse<T> {
    private int statusCode;
    private String message;
    private T data; // Dữ liệu trả về (có thể là object, list, hoặc null)

    // Constructor tiện ích cho trường hợp thành công
    public static <T> BaseResponse<T> success(T data, String message) {
        return new BaseResponse<>(200, message, data);
    }

    // Constructor tiện ích cho trường hợp lỗi
    public static <T> BaseResponse<T> error(int code, String message, T data) {
        return new BaseResponse<>(code, message, data);
    }
}