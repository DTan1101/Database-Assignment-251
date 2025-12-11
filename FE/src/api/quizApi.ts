import axios from 'axios';
import type { BaseResponse, PagedResponse, Quiz, QuizSearchParams, QuizRequest } from '../types/quiz';

const API_BASE_URL = 'http://localhost:8082';

// Create axios instance
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Quiz API functions
export const quizApi = {
  // Search quizzes with pagination
  searchQuizzes: async (params?: QuizSearchParams): Promise<BaseResponse<PagedResponse<Quiz>>> => {
    const queryParams = {
      lopHocId: params?.lopHocId,
      tenQuiz: params?.tenQuiz,
      soLanDuocLamMin: params?.soLanDuocLamMin,
      soLanDuocLamMax: params?.soLanDuocLamMax,
      thoiGianMoFrom: params?.thoiGianMoFrom,
      thoiGianMoTo: params?.thoiGianMoTo,
      thoiGianDongFrom: params?.thoiGianDongFrom,
      thoiGianDongTo: params?.thoiGianDongTo,
      isActive: params?.isActive,
      page: params?.page ?? 0,
      size: params?.size ?? 9,
      sortBy: params?.sortBy ?? 'tenQuiz',
      sortDirection: params?.sortDirection ?? 'ASC',
    };

    // Build URL with query params for logging
    const url = new URL('/quizzes/search', API_BASE_URL);
    Object.entries(queryParams).forEach(([key, value]) => {
      if (value !== undefined && value !== null) {
        url.searchParams.append(key, String(value));
      }
    });

    console.log('🌐 Full API URL:', url.toString());
    console.log('📋 All Query Params:', queryParams);
    
    const response = await apiClient.get<BaseResponse<PagedResponse<Quiz>>>('/quizzes/search', {
      params: queryParams,
    });
    return response.data;
  },

  // Create new quiz
  createQuiz: async (quiz: QuizRequest): Promise<BaseResponse<null>> => {
    console.log('🚀 [API] POST /quizzes - Request:', quiz);
    const response = await apiClient.post<BaseResponse<null>>('/quizzes', quiz);
    console.log('✅ [API] POST /quizzes - Response:', response.data);
    return response.data;
  },

  // Update existing quiz
  updateQuiz: async (quiz: QuizRequest): Promise<BaseResponse<null>> => {
    console.log('🚀 [API] PUT /quizzes - Request:', quiz);
    const response = await apiClient.put<BaseResponse<null>>('/quizzes', quiz);
    console.log('✅ [API] PUT /quizzes - Response:', response.data);
    return response.data;
  },

  // Delete quiz
  deleteQuiz: async (lopHocId: number, tenQuiz: string): Promise<BaseResponse<null>> => {
    const requestData = { lopHocId, tenQuiz };
    console.log('🚀 [API] DELETE /quizzes - Request:', requestData);
    const response = await apiClient.delete<BaseResponse<null>>('/quizzes', {
      data: requestData,
    });
    console.log('✅ [API] DELETE /quizzes - Response:', response.data);
    return response.data;
  },
};

export default apiClient;
