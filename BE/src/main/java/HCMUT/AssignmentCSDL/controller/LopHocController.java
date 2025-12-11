package HCMUT.AssignmentCSDL.controller;

import HCMUT.AssignmentCSDL.dto.ChiTietDiemLopHocDTO;
import HCMUT.AssignmentCSDL.dto.LopHocBasicDTO;
import HCMUT.AssignmentCSDL.dto.LopHocSearchDTO;
import HCMUT.AssignmentCSDL.payload.request.LopHocSearchRequest;
import HCMUT.AssignmentCSDL.payload.response.BaseResponse;
import HCMUT.AssignmentCSDL.payload.response.PagedResponse;
import HCMUT.AssignmentCSDL.service.LopHocService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/classes")
@CrossOrigin
public class LopHocController {

    @Autowired
    private LopHocService lopHocService;

    /**
     * Tìm kiếm lớp học nâng cao với phân trang
     * GET /classes/search?tenMonHoc=Toán&khuVuc=Q.10&mucLuongMin=4000000&mucLuongMax=10000000&trangThai=Đang tuyển&sortBy=2&page=0&size=10
     */
    @GetMapping("/search")
    public ResponseEntity<BaseResponse<PagedResponse<LopHocSearchDTO>>> searchLopHoc(
            @RequestParam(required = false) String tenMonHoc,
            @RequestParam(required = false) String khuVuc,
            @RequestParam(required = false) java.math.BigDecimal mucLuongMin,
            @RequestParam(required = false) java.math.BigDecimal mucLuongMax,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false, defaultValue = "1") Integer sortBy,
            @RequestParam(required = false, defaultValue = "0") Integer page,
            @RequestParam(required = false, defaultValue = "9") Integer size) {

        // Tạo request object từ params
        LopHocSearchRequest request = new LopHocSearchRequest(
            tenMonHoc, khuVuc, mucLuongMin, mucLuongMax, trangThai, sortBy, page, size
        );

        PagedResponse<LopHocSearchDTO> data = lopHocService.searchLopHoc(request);

        return ResponseEntity.ok(BaseResponse.success(
            data,
            "Tìm kiếm lớp học thành công - Trang " + (page + 1) + "/" + data.getTotalPages() +
            " - Tổng " + data.getTotalElements() + " lớp"
        ));
    }

    /**
     * Lấy chi tiết thống kê điểm của các lớp học
     * GET /classes/statistics/scores?minSoBaiLam=1
     */
    @GetMapping("/statistics/scores")
    public ResponseEntity<BaseResponse<List<ChiTietDiemLopHocDTO>>> getThongKeDiem(
            @RequestParam(required = false, defaultValue = "1") Integer minSoBaiLam) {

        List<ChiTietDiemLopHocDTO> data = lopHocService.getChiTietDiemLopHoc(minSoBaiLam);

        return ResponseEntity.ok(BaseResponse.success(
            data,
            "Lấy thống kê điểm thành công - Có " + data.size() + " lớp học"
        ));
    }

    /**
     * Lấy danh sách lớp học theo học viên ID
     * GET /classes?hocVienId=51
     */
    @GetMapping
    public ResponseEntity<?> getLopHocByHocVien(@RequestParam Integer hocVienId) {
        List<LopHocBasicDTO> data = lopHocService.getLopHocByHocVien(hocVienId);

        return ResponseEntity.ok(BaseResponse.success(
            data,
            "Lấy danh sách lớp học của học viên thành công - Tổng " + data.size() + " lớp"
        ));
    }
}

