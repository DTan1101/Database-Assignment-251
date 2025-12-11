package HCMUT.AssignmentCSDL.service;

import HCMUT.AssignmentCSDL.entity.LichSuLamBai;
import HCMUT.AssignmentCSDL.mapper.SqlErrorMapper;
import HCMUT.AssignmentCSDL.payload.request.LichSuLamBaiRequest;
import HCMUT.AssignmentCSDL.payload.response.PagedResponse;
import HCMUT.AssignmentCSDL.repo.LichSuLamBaiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LichSuLamBaiService {

    @Autowired
    private LichSuLamBaiRepository lichSuLamBaiRepo;

    public PagedResponse<LichSuLamBai> getLichSuLamBai(LichSuLamBaiRequest request) {
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
                request.setSortBy("thoiGianBatDau");
            }
            if (request.getSortDirection() == null || request.getSortDirection().isEmpty()) {
                request.setSortDirection("DESC");
            }

            // Get data
            List<LichSuLamBai> histories = lichSuLamBaiRepo.getLichSuLamBai(request);
            long totalElements = lichSuLamBaiRepo.countLichSuLamBai(request);

            return PagedResponse.of(histories, request.getPage(), request.getSize(), totalElements);
        } catch (DataAccessException e) {
            throw SqlErrorMapper.map(e);
        }
    }
}

