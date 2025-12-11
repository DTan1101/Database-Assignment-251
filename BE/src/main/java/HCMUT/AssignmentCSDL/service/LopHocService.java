package HCMUT.AssignmentCSDL.service;

import HCMUT.AssignmentCSDL.dto.ChiTietDiemLopHocDTO;
import HCMUT.AssignmentCSDL.dto.LopHocBasicDTO;
import HCMUT.AssignmentCSDL.dto.LopHocSearchDTO;
import HCMUT.AssignmentCSDL.mapper.SqlErrorMapper;
import HCMUT.AssignmentCSDL.payload.request.LopHocSearchRequest;
import HCMUT.AssignmentCSDL.payload.response.PagedResponse;
import HCMUT.AssignmentCSDL.repo.LopHocRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LopHocService {

    @Autowired
    private LopHocRepository lopHocRepo;

    /**
     * Tìm kiếm lớp học với các tiêu chí nâng cao (có phân trang)
     * @param request chứa các tiêu chí tìm kiếm (tenMonHoc, khuVuc, mucLuong, trangThai, sortBy, page, size)
     * @return PagedResponse chứa danh sách lớp học và thông tin phân trang
     */
    public PagedResponse<LopHocSearchDTO> searchLopHoc(LopHocSearchRequest request) {
        try {
            List<LopHocSearchDTO> content = lopHocRepo.searchLopHoc(request);
            long totalElements = lopHocRepo.countLopHoc(request);

            return PagedResponse.of(content, request.getPage(), request.getSize(), totalElements);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }

    /**
     * Lấy chi tiết thống kê điểm của các lớp học
     * @param minSoBaiLam số bài làm tối thiểu để lấy thống kê (mặc định 1)
     * @return danh sách thống kê điểm theo lớp học
     */
    public List<ChiTietDiemLopHocDTO> getChiTietDiemLopHoc(Integer minSoBaiLam) {
        try {
            return lopHocRepo.getChiTietDiemLopHoc(minSoBaiLam);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }

    /**
     * Lấy danh sách lớp học của một học viên
     * @param hocVienId ID học viên
     * @return danh sách lớp học mà học viên đó tham gia
     */
    public List<LopHocBasicDTO> getLopHocByHocVien(Integer hocVienId) {
        try {
            return lopHocRepo.getLopHocByHocVien(hocVienId);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }

}

