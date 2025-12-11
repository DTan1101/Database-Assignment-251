import { Clock, Users, CheckCircle, Calendar, Plus, Trash2, Edit, Search, Loader2, AlertCircle, Filter, ArrowUpDown } from "lucide-react";
import { Card } from "./ui/card";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { useEffect, useState } from "react";
import { quizApi } from "../api/quizApi";
import type { Quiz, QuizSearchParams, QuizRequest } from "../types/quiz";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "./ui/select";
import { QuizDialog } from "./QuizDialog";
import { DeleteQuizDialog } from "./DeleteQuizDialog";
import { ErrorDialog } from "./ErrorDialog";
import { toast } from "sonner";

export function QuizList() {
  const [quizzes, setQuizzes] = useState<Quiz[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);
  
  // Filter states
  const [filterLopHocId, setFilterLopHocId] = useState<string>("");
  const [soLanDuocLamMin, setSoLanDuocLamMin] = useState<string>("");
  const [soLanDuocLamMax, setSoLanDuocLamMax] = useState<string>("");
  const [thoiGianMoFrom, setThoiGianMoFrom] = useState<string>("");
  const [thoiGianMoTo, setThoiGianMoTo] = useState<string>("");
  const [thoiGianDongFrom, setThoiGianDongFrom] = useState<string>("");
  const [thoiGianDongTo, setThoiGianDongTo] = useState<string>("");
  const [showAdvancedFilters, setShowAdvancedFilters] = useState(false);
  
  // Sort states
  const [sortBy, setSortBy] = useState<QuizSearchParams['sortBy']>('tenQuiz');
  const [sortDirection, setSortDirection] = useState<'ASC' | 'DESC'>('ASC');
  const [pageSize, setPageSize] = useState(9);
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState("");

  // Dialog states
  const [quizDialogOpen, setQuizDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedQuiz, setSelectedQuiz] = useState<Quiz | null>(null);
  const [dialogMode, setDialogMode] = useState<"create" | "edit">("create");
  const [deleteLoading, setDeleteLoading] = useState(false);
  
  // Error dialog states
  const [errorDialogOpen, setErrorDialogOpen] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [errorData, setErrorData] = useState<any>(null);

  // Debounce search term - chỉ update debouncedSearchTerm
  useEffect(() => {
    console.log('⏱️ Search term changed:', searchTerm);
    const timer = setTimeout(() => {
      console.log('✅ Applying debounced search:', searchTerm);
      setDebouncedSearchTerm(searchTerm);
    }, 500);
    return () => clearTimeout(timer);
  }, [searchTerm]);

  // Fetch quizzes from API - gọi khi dependencies thay đổi
  useEffect(() => {
    console.log('🔄 useEffect triggered - fetching quizzes...');
    fetchQuizzes();
  }, [debouncedSearchTerm, filterLopHocId, soLanDuocLamMin, soLanDuocLamMax, 
      thoiGianMoFrom, thoiGianMoTo, thoiGianDongFrom, thoiGianDongTo,
      sortBy, sortDirection, pageSize, currentPage]);

  const fetchQuizzes = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Convert datetime-local format to ISO 8601 format (yyyy-MM-ddTHH:mm:ss)
      const formatDateTime = (dateTimeLocal: string) => {
        if (!dateTimeLocal) return undefined;
        return dateTimeLocal + ':00'; // datetime-local gives yyyy-MM-ddTHH:mm, add :00 for seconds
      };
      
      const params: QuizSearchParams = {
        tenQuiz: debouncedSearchTerm || undefined,
        lopHocId: filterLopHocId ? parseInt(filterLopHocId) : undefined,
        soLanDuocLamMin: soLanDuocLamMin ? parseInt(soLanDuocLamMin) : undefined,
        soLanDuocLamMax: soLanDuocLamMax ? parseInt(soLanDuocLamMax) : undefined,
        thoiGianMoFrom: formatDateTime(thoiGianMoFrom),
        thoiGianMoTo: formatDateTime(thoiGianMoTo),
        thoiGianDongFrom: formatDateTime(thoiGianDongFrom),
        thoiGianDongTo: formatDateTime(thoiGianDongTo),
        page: currentPage,
        size: pageSize,
        sortBy: sortBy,
        sortDirection: sortDirection,
      };
      
      console.log('🔵 Calling API: GET /quizzes/search');
      console.log('📤 Parameters:', params);
      console.log('🔍 Search:', debouncedSearchTerm || 'none');
      console.log('🎯 Filter LopHocId:', filterLopHocId || 'none');
      console.log('📊 Sort:', sortBy, sortDirection);
      console.log('📄 Page:', currentPage, '| Size:', pageSize);
      
      const response = await quizApi.searchQuizzes(params);
      
      console.log('✅ API Response:', response);
      console.log('📊 Total items:', response.data.totalElements);
      console.log('📄 Current page:', response.data.currentPage);
      console.log('📚 Items in page:', response.data.content.length);
      
      if (response.statusCode === 200) {
        setQuizzes(response.data.content);
        setTotalPages(response.data.totalPages);
        setTotalElements(response.data.totalElements);
      }
    } catch (err: any) {
      console.error('❌ API Error:', err);
      console.error('❌ Error response:', err.response?.data);
      setError(err.response?.data?.message || 'Không thể tải danh sách quiz');
    } finally {
      setLoading(false);
    }
  };

  // Determine quiz status based on dates
  const getQuizStatus = (thoiGianMo: string, thoiGianDong: string) => {
    const now = new Date();
    const openTime = new Date(thoiGianMo);
    const closeTime = new Date(thoiGianDong);

    if (now < openTime) return { text: "Sắp mở", color: "bg-yellow-500" };
    if (now > closeTime) return { text: "Đã đóng", color: "bg-gray-400" };
    return { text: "Đang mở", color: "bg-green-500" };
  };

  // Format date for display
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  // Toggle sort direction
  // Handle filter change
  const handleFilterChange = (value: string) => {
    console.log('🎯 Filter LopHocId changed to:', value || 'none');
    setFilterLopHocId(value);
    setCurrentPage(0);
  };

  // Handle sort change
  const handleSortChange = (value: string) => {
    console.log('📊 Sort field changed to:', value);
    setSortBy(value as QuizSearchParams['sortBy']);
    setCurrentPage(0);
  };

  const handleSortDirectionChange = (value: string) => {
    console.log('🔄 Sort direction changed to:', value);
    setSortDirection(value as 'ASC' | 'DESC');
    setCurrentPage(0);
  };

  // Handle page size change
  const handlePageSizeChange = (value: string) => {
    console.log('📄 Page size changed to:', value);
    setPageSize(parseInt(value));
    setCurrentPage(0);
  };

  // Clear all filters
  const handleClearFilters = () => {
    console.log('🧹 Clearing all filters');
    setFilterLopHocId("");
    setSoLanDuocLamMin("");
    setSoLanDuocLamMax("");
    setThoiGianMoFrom("");
    setThoiGianMoTo("");
    setThoiGianDongFrom("");
    setThoiGianDongTo("");
    setSearchTerm("");
    setCurrentPage(0);
  };

  // Check if any filter is active
  const hasActiveFilters = () => {
    return filterLopHocId || searchTerm ||
           soLanDuocLamMin || soLanDuocLamMax ||
           thoiGianMoFrom || thoiGianMoTo ||
           thoiGianDongFrom || thoiGianDongTo;
  };

  // Handle create quiz
  const handleCreateQuiz = () => {
    setDialogMode("create");
    setSelectedQuiz(null);
    setQuizDialogOpen(true);
  };

  // Handle edit quiz
  const handleEditQuiz = (quiz: Quiz) => {
    setDialogMode("edit");
    setSelectedQuiz(quiz);
    setQuizDialogOpen(true);
  };

  // Handle delete quiz
  const handleDeleteQuiz = (quiz: Quiz) => {
    setSelectedQuiz(quiz);
    setDeleteDialogOpen(true);
  };

  // Submit create/edit quiz
  const handleSubmitQuiz = async (data: QuizRequest) => {
    console.log('📝 [QuizList] handleSubmitQuiz called');
    console.log('📝 [QuizList] Mode:', dialogMode);
    console.log('📝 [QuizList] Data:', data);
    
    try {
      let response;
      if (dialogMode === "create") {
        console.log('➕ [QuizList] Creating quiz...');
        response = await quizApi.createQuiz(data);
      } else {
        console.log('✏️ [QuizList] Updating quiz...');
        response = await quizApi.updateQuiz(data);
      }
      console.log('✅ [QuizList] Success response:', response);
      
      // Show success message from backend with data if available
      const message = response.message || "Thao tác thành công!";
      const dataInfo = response.data ? `\nData: ${JSON.stringify(response.data)}` : "";
      toast.success(message + dataInfo);
      
      // Wait a bit before closing dialog to ensure toast is shown
      await new Promise(resolve => setTimeout(resolve, 100));
      fetchQuizzes(); // Refresh list
    } catch (err: any) {
      console.error("❌ [QuizList] Error submitting quiz:", err);
      console.error("❌ [QuizList] Error response:", err.response);
      // Show error dialog instead of toast
      setErrorMessage(err.response?.data?.message || "Có lỗi xảy ra");
      setErrorData(err.response?.data?.data || null);
      setErrorDialogOpen(true);
      throw err; // Re-throw to keep dialog open
    }
  };

  // Confirm delete quiz
  const handleConfirmDelete = async () => {
    if (!selectedQuiz) return;
    
    setDeleteLoading(true);
    try {
      const response = await quizApi.deleteQuiz(selectedQuiz.lopHocId, selectedQuiz.tenQuiz);
      // Show success message from backend with data if available
      const message = response.message || "Xóa thành công!";
      const dataInfo = response.data ? `\nData: ${JSON.stringify(response.data)}` : "";
      toast.success(message + dataInfo);
      
      // Wait a bit before closing dialog to ensure toast is shown
      await new Promise(resolve => setTimeout(resolve, 100));
      setDeleteDialogOpen(false);
      fetchQuizzes(); // Refresh list
    } catch (err: any) {
      console.error("Error deleting quiz:", err);
      // Show error dialog instead of toast
      setErrorMessage(err.response?.data?.message || "Không thể xóa quiz");
      setErrorData(err.response?.data?.data || null);
      setErrorDialogOpen(true);
    } finally {
      setDeleteLoading(false);
    }
  };

  return (
    <div>
      {/* 1. Lọc và Sắp xếp */}
      <div className="mb-4 p-4 bg-gray-50 rounded-lg border border-gray-200">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
          {/* Sắp xếp theo */}
          <div>
            <label className="block text-xs text-gray-600 mb-1">Sắp xếp theo</label>
            <Select value={sortBy} onValueChange={handleSortChange}>
              <SelectTrigger className="h-9 bg-white">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="tenQuiz">Tên A-Z</SelectItem>
                <SelectItem value="lopHocId">Lớp học</SelectItem>
                <SelectItem value="soLanDuocLam">Số lần làm</SelectItem>
                <SelectItem value="thoiGianMo">Thời gian mở</SelectItem>
                <SelectItem value="thoiGianDong">Thời gian đóng</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Hiển thị */}
          <div>
            <label className="block text-xs text-gray-600 mb-1">Hiển thị</label>
            <Select value={pageSize.toString()} onValueChange={handlePageSizeChange}>
              <SelectTrigger className="h-9 bg-white">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="6">6</SelectItem>
                <SelectItem value="9">9</SelectItem>
                <SelectItem value="12">12</SelectItem>
                <SelectItem value="18">18</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Thứ tự - Button */}
          <div>
            <label className="block text-xs text-gray-600 mb-1">Sắp xếp</label>
            <Button
              variant="outline"
              className="w-full h-9 justify-start gap-2 font-normal bg-white hover:bg-gray-50"
              onClick={() => handleSortDirectionChange(sortDirection === 'ASC' ? 'DESC' : 'ASC')}
            >
              <ArrowUpDown className="w-4 h-4" />
              <span>{sortDirection === 'ASC' ? 'Tăng dần' : 'Giảm dần'}</span>
            </Button>
          </div>
        </div>

        {/* Second row - Lọc lớp học và Toggle Advanced */}
        <div className="mt-3 flex items-center gap-3">
          <div className="flex-1 max-w-xs">
            <label className="block text-xs text-gray-600 mb-1">Lớp học</label>
            <Input
              type="number"
              placeholder="ID lớp học"
              className="h-9 bg-white"
              value={filterLopHocId}
              onChange={(e) => handleFilterChange(e.target.value)}
            />
          </div>

          {/* Toggle Advanced Filters */}
          <Button
            variant="outline"
            size="sm"
            onClick={() => setShowAdvancedFilters(!showAdvancedFilters)}
            className="mt-5 gap-2"
          >
            <Filter className="w-4 h-4" />
            {showAdvancedFilters ? 'Ẩn bộ lọc nâng cao' : 'Bộ lọc nâng cao'}
          </Button>

          {/* Clear Filters */}
          {hasActiveFilters() && (
            <Button
              variant="ghost"
              size="sm"
              onClick={handleClearFilters}
              className="mt-5 text-red-600 hover:text-red-700 hover:bg-red-50"
            >
              Xóa tất cả bộ lọc
            </Button>
          )}
        </div>

        {/* Advanced Filters */}
        {showAdvancedFilters && (
          <div className="mt-4 pt-4 border-t border-gray-200">
            <h4 className="text-sm font-medium text-gray-700 mb-3">Bộ lọc nâng cao</h4>
            
            {/* Số lần được làm */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 mb-3">
              <div>
                <label className="block text-xs text-gray-600 mb-1">Số lần làm (Tối thiểu)</label>
                <Input
                  type="number"
                  placeholder="Từ"
                  className="h-9 bg-white"
                  value={soLanDuocLamMin}
                  onChange={(e) => {
                    setSoLanDuocLamMin(e.target.value);
                    setCurrentPage(0);
                  }}
                />
              </div>
              <div>
                <label className="block text-xs text-gray-600 mb-1">Số lần làm (Tối đa)</label>
                <Input
                  type="number"
                  placeholder="Đến"
                  className="h-9 bg-white"
                  value={soLanDuocLamMax}
                  onChange={(e) => {
                    setSoLanDuocLamMax(e.target.value);
                    setCurrentPage(0);
                  }}
                />
              </div>
            </div>

            {/* Thời gian mở */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 mb-3">
              <div>
                <label className="block text-xs text-gray-600 mb-1">Thời gian mở (Từ)</label>
                <Input
                  type="datetime-local"
                  className="h-9 bg-white"
                  value={thoiGianMoFrom}
                  onChange={(e) => {
                    setThoiGianMoFrom(e.target.value);
                    setCurrentPage(0);
                  }}
                />
              </div>
              <div>
                <label className="block text-xs text-gray-600 mb-1">Thời gian mở (Đến)</label>
                <Input
                  type="datetime-local"
                  className="h-9 bg-white"
                  value={thoiGianMoTo}
                  onChange={(e) => {
                    setThoiGianMoTo(e.target.value);
                    setCurrentPage(0);
                  }}
                />
              </div>
            </div>

            {/* Thời gian đóng */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs text-gray-600 mb-1">Thời gian đóng (Từ)</label>
                <Input
                  type="datetime-local"
                  className="h-9 bg-white"
                  value={thoiGianDongFrom}
                  onChange={(e) => {
                    setThoiGianDongFrom(e.target.value);
                    setCurrentPage(0);
                  }}
                />
              </div>
              <div>
                <label className="block text-xs text-gray-600 mb-1">Thời gian đóng (Đến)</label>
                <Input
                  type="datetime-local"
                  className="h-9 bg-white"
                  value={thoiGianDongTo}
                  onChange={(e) => {
                    setThoiGianDongTo(e.target.value);
                    setCurrentPage(0);
                  }}
                />
              </div>
            </div>
          </div>
        )}
      </div>

      {/* 2. Tìm kiếm và Tạo Quiz */}
      <div className="mb-6 flex items-center justify-between gap-4">
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <Input
            type="text"
            placeholder="Tìm kiếm quiz theo tên..."
            className="pl-10 bg-white border-gray-200"
            value={searchTerm}
            onChange={(e) => {
              console.log('🔍 Search input changed:', e.target.value);
              setSearchTerm(e.target.value);
            }}
          />
        </div>
        
        <Button className="bg-blue-500 hover:bg-blue-600 text-white gap-2" onClick={handleCreateQuiz}>
          <Plus className="w-5 h-5" />
          Tạo Quiz mới
        </Button>
      </div>

      {/* Results Summary */}
      {!loading && !error && (
        <div className="mb-4 text-sm text-gray-600">
          Tìm thấy <span className="font-semibold text-gray-900">{totalElements}</span> quiz
        </div>
      )}

      {/* Loading State */}
      {loading && (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
          <span className="ml-3 text-gray-600">Đang tải danh sách quiz...</span>
        </div>
      )}

      {/* Error State */}
      {error && !loading && (
        <div className="flex items-center justify-center py-12">
          <div className="text-center">
            <AlertCircle className="w-12 h-12 text-red-500 mx-auto mb-3" />
            <p className="text-red-600 font-medium">{error}</p>
            <Button 
              onClick={fetchQuizzes} 
              className="mt-4 bg-blue-500 hover:bg-blue-600"
            >
              Thử lại
            </Button>
          </div>
        </div>
      )}

      {/* Empty State */}
      {!loading && !error && quizzes.length === 0 && (
        <div className="text-center py-12">
          <p className="text-gray-500">Không tìm thấy quiz nào</p>
        </div>
      )}

      {/* Quiz Grid */}
      {!loading && !error && quizzes.length > 0 && (
        <>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {quizzes.map((quiz, index) => {
              const status = getQuizStatus(quiz.thoiGianMo, quiz.thoiGianDong);
              
              return (
                <Card key={`${quiz.lopHocId}-${quiz.tenQuiz}-${index}`} className="p-6 hover:shadow-lg transition-shadow">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <span className="text-blue-600 text-sm">Lớp: {quiz.lopHocId}</span>
                        <Badge 
                          variant={status.text === "Đang mở" ? "default" : "secondary"}
                          className={status.color}
                        >
                          {status.text}
                        </Badge>
                      </div>
                      <h3 className="text-gray-900 mb-2 font-semibold">{quiz.tenQuiz}</h3>
                    </div>
                    <div className="flex gap-1 ml-2">
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 text-blue-600 hover:text-blue-700 hover:bg-blue-50"
                        onClick={() => handleEditQuiz(quiz)}
                      >
                        <Edit className="w-4 h-4" />
                      </Button>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 text-red-600 hover:text-red-700 hover:bg-red-50"
                        onClick={() => handleDeleteQuiz(quiz)}
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>

                  <div className="space-y-3 mb-4">
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <Users className="w-4 h-4 text-blue-500" />
                      <span>Số lần làm: <span className="text-gray-900 font-medium">
                        {quiz.soLanDuocLam === null || quiz.soLanDuocLam === undefined 
                          ? "Không giới hạn" 
                          : quiz.soLanDuocLam}
                      </span></span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <Calendar className="w-4 h-4 text-green-500" />
                      <span>Mở: <span className="text-gray-900">{formatDate(quiz.thoiGianMo)}</span></span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <Clock className="w-4 h-4 text-red-500" />
                      <span>Đóng: <span className="text-gray-900">{formatDate(quiz.thoiGianDong)}</span></span>
                    </div>
                  </div>

                  <div className="pt-4 border-t border-gray-200">
                    <button className="w-full py-2 px-4 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors">
                      Xem chi tiết
                    </button>
                  </div>
                </Card>
              );
            })}
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="mt-6 flex flex-col sm:flex-row items-center justify-between gap-4">
              <div className="text-sm text-gray-600">
                Hiển thị {currentPage * pageSize + 1} - {Math.min((currentPage + 1) * pageSize, totalElements)} trong tổng số {totalElements}
              </div>
              <div className="flex items-center gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage(0)}
                  disabled={currentPage === 0}
                >
                  Đầu
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage(prev => Math.max(0, prev - 1))}
                  disabled={currentPage === 0}
                >
                  Trước
                </Button>
                <span className="px-3 py-1 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded">
                  {currentPage + 1} / {totalPages}
                </span>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage(prev => Math.min(totalPages - 1, prev + 1))}
                  disabled={currentPage >= totalPages - 1}
                >
                  Sau
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage(totalPages - 1)}
                  disabled={currentPage >= totalPages - 1}
                >
                  Cuối
                </Button>
              </div>
            </div>
          )}
        </>
      )}

      {/* Quiz Dialog (Create/Edit) */}
      <QuizDialog
        open={quizDialogOpen}
        onOpenChange={setQuizDialogOpen}
        quiz={selectedQuiz}
        onSubmit={handleSubmitQuiz}
        mode={dialogMode}
      />

      {/* Delete Confirmation Dialog */}
      <DeleteQuizDialog
        open={deleteDialogOpen}
        onOpenChange={setDeleteDialogOpen}
        quiz={selectedQuiz}
        onConfirm={handleConfirmDelete}
        loading={deleteLoading}
      />

      {/* Error Dialog */}
      <ErrorDialog
        open={errorDialogOpen}
        onOpenChange={setErrorDialogOpen}
        message={errorMessage}
        data={errorData}
      />
    </div>
  );
}