package HCMUT.AssignmentCSDL.exception;

import lombok.Getter;

@Getter
public enum QuizErrorCode {
    // --- Nhóm lỗi Insert (V3) ---
    LOPHOC_NOT_FOUND(51000, "Lớp học không tồn tại."), //
    TIME_INVALID_ORDER(51001, "Thời gian Mở phải trước thời gian Đóng."), //
    ATTEMPTS_INVALID(51002, "Số lần làm bài phải lớn hơn 0."), //
    OPEN_TIME_REQUIRED(51003, "Thời gian mở là bắt buộc."), //
    LOPHOC_ID_REQUIRED(51010, "ID lớp học là bắt buộc."), //
    NAME_REQUIRED(51011, "Tên Quiz không được để trống."), //
    NAME_TOO_LONG(51012, "Tên Quiz không được quá 100 ký tự."), //
    DUPLICATE_QUIZ_NAME(51013, "Tên Quiz này đã tồn tại trong lớp."), //

    // --- Nhóm lỗi Update (V2) ---
    QUIZ_NOT_FOUND(51020, "Không tìm thấy bài Quiz này."), //
    RENAME_DUPLICATE(51021, "Tên mới bị trùng với một Quiz khác trong lớp."), //
    RENAME_HAS_DEPENDENCY_Q(51022, "Không thể đổi tên: Quiz đã có câu hỏi."), //
    RENAME_HAS_DEPENDENCY_H(51023, "Không thể đổi tên: Quiz đã có lịch sử làm bài."), //
    UPDATE_TIME_INVALID(51024, "Thời gian Mở phải trước thời gian Đóng (Update)."), //
    UPDATE_ATTEMPTS_INVALID(51025, "Số lần làm bài phải lớn hơn 0."), //
    REDUCE_ATTEMPTS_ERROR(51026, "Không được giảm số lần làm bài thấp hơn số lần học viên đã thực hiện."), //
    CONCURRENT_UPDATE(51027, "Dữ liệu đã bị thay đổi bởi người khác, vui lòng tải lại."), //

    // --- Nhóm lỗi Câu hỏi (V5) ---
    CAUHOI_NOT_FOUND(52000, "Không tìm thấy câu hỏi để cập nhật."), //

    // Lỗi mặc định
    UNKNOWN_ERROR(99999, "Lỗi hệ thống không xác định.");

    private final int code;
    private final String message;

    QuizErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    // Hàm lookup ngược từ mã SQL -> Enum
    public static QuizErrorCode fromCode(int code) {
        for (QuizErrorCode e : values()) {
            if (e.code == code) return e;
        }
        return UNKNOWN_ERROR;
    }
}