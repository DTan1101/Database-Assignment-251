// Types cho Quiz API

export interface Quiz {
  lopHocId: number;
  tenQuiz: string;
  soLanDuocLam: number | null;
  thoiGianDong: string; // ISO 8601 format
  thoiGianMo: string; // ISO 8601 format
}

export interface BaseResponse<T> {
  statusCode: number;
  message: string;
  data: T;
}

export interface PagedResponse<T> {
  content: T[];
  currentPage: number;
  pageSize: number;
  totalElements: number;
  totalPages: number;
  first: boolean;
  last: boolean;
}

export interface QuizSearchParams {
  lopHocId?: number;
  tenQuiz?: string;
  soLanDuocLamMin?: number;
  soLanDuocLamMax?: number;
  thoiGianMoFrom?: string;
  thoiGianMoTo?: string;
  thoiGianDongFrom?: string;
  thoiGianDongTo?: string;
  isActive?: boolean;
  page?: number;
  size?: number;
  sortBy?: 'lopHocId' | 'tenQuiz' | 'soLanDuocLam' | 'thoiGianMo' | 'thoiGianDong';
  sortDirection?: 'ASC' | 'DESC';
}

export interface QuizRequest {
  lopHocId: number | null;
  tenQuiz: string | null;
  soLanDuocLam: number | null;
  thoiGianMo: string | null;
  thoiGianDong: string | null;
  oldName?: string; // For update
}
