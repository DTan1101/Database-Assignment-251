import apiClient from './quizApi';
import type { BaseResponse } from '../types/quiz';

// Person DTO for tutor/student list
export interface PersonDTO {
  id: number;
  name: string;
}

// Class DTO for class list
export interface ClassDTO {
  lopHocId: number;
  thongTin: string;
}

// Tutor Efficiency DTO
export interface TutorEfficiencyDTO {
  giaSuId: number;
  hoTen: string;
  soLopDangDay: number;
  tongHocVien: number;
  diemChatLuong: number;
  hopDongKyTrongThang: number | null;
  doanhThuDuKien: number;
  xepHang: string;
  nhanXet: string;
  thang: number;
  nam: number;
}

// Student Progress DTO
export interface StudentProgressDTO {
  hocVienId: number;
  tenHocVien: string;
  soBaiDaLam: number;
  soQuizBiLo: number;
  diemTrungBinh: number;
  diemCaoNhat: number;
  diemThapNhat: number;
  xuHuong: string;
  canhBao: string;
  lichSuDiem: string;
}

// Report API functions
export const reportApi = {
  // Get all tutors (id and name)
  getAllTutors: async (): Promise<BaseResponse<PersonDTO[]>> => {
    const response = await apiClient.get<BaseResponse<PersonDTO[]>>('/report/tutors');
    return response.data;
  },

  // Get all students (id and name)
  getAllStudents: async (): Promise<BaseResponse<PersonDTO[]>> => {
    const response = await apiClient.get<BaseResponse<PersonDTO[]>>('/report/students');
    return response.data;
  },

  // Get classes by student ID
  getClassesByStudent: async (hocVienId: number): Promise<BaseResponse<ClassDTO[]>> => {
    const response = await apiClient.get<BaseResponse<ClassDTO[]>>('/classes', {
      params: { hocVienId },
    });
    return response.data;
  },

  // Get tutor report
  getTutorReport: async (
    giaSuId: number,
    thang: number,
    nam: number
  ): Promise<BaseResponse<TutorEfficiencyDTO[]>> => {
    const response = await apiClient.get<BaseResponse<TutorEfficiencyDTO[]>>('/report/tutor', {
      params: { giaSuId, thang, nam },
    });
    return response.data;
  },

  // Get student progress report
  getStudentProgress: async (
    hocVienId: number,
    lopHocId: number
  ): Promise<BaseResponse<StudentProgressDTO>> => {
    const response = await apiClient.get<BaseResponse<StudentProgressDTO>>('/report/student', {
      params: { hocVienId, lopHocId },
    });
    return response.data;
  },
};
