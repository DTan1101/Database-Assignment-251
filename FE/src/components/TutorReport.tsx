import { useState, useEffect, useRef } from "react";
import { Search, TrendingUp, TrendingDown, Users, DollarSign, Award, Star, BookOpen } from "lucide-react";
import { Card } from "./ui/card";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Badge } from "./ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "./ui/select";
import { Progress } from "./ui/progress";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";
import { reportApi, PersonDTO, TutorEfficiencyDTO } from "../api/reportApi";

export function TutorReport() {
  const [tutors, setTutors] = useState<PersonDTO[]>([]);
  const [giaSuId, setGiaSuId] = useState("");
  const [thang, setThang] = useState("12");
  const [nam, setNam] = useState("2025");
  const [reportData, setReportData] = useState<TutorEfficiencyDTO[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isExporting, setIsExporting] = useState(false);
  const reportRef = useRef<HTMLDivElement>(null);

  // Get current month data - tìm tháng user search
  const currentMonthData = reportData.find(
    data => data.thang === parseInt(thang) && data.nam === parseInt(nam)
  ) || null;
  
  // Get previous month data for comparison - tìm tháng trước đó
  const currentIndex = reportData.findIndex(
    data => data.thang === parseInt(thang) && data.nam === parseInt(nam)
  );
  const previousMonthData = currentIndex > 0 ? reportData[currentIndex - 1] : null;

  // Export to PDF function
  const handleExportPDF = async () => {
    if (!reportRef.current || !currentMonthData) return;
    
    setIsExporting(true);
    try {
      const { jsPDF } = await import('jspdf');
      const html2canvas = (await import('html2canvas')).default;
      
      const element = reportRef.current;
      const canvas = await html2canvas(element, {
        scale: 2,
        useCORS: true,
        logging: false,
        backgroundColor: '#ffffff'
      });
      
      const imgData = canvas.toDataURL('image/png');
      const pdf = new jsPDF({
        orientation: 'portrait',
        unit: 'mm',
        format: 'a4'
      });
      
      const imgWidth = 210; // A4 width in mm
      const imgHeight = (canvas.height * imgWidth) / canvas.width;
      
      pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
      pdf.save(`Bao-cao-gia-su-${currentMonthData.giaSuId}-T${currentMonthData.thang}-${currentMonthData.nam}.pdf`);
    } catch (error) {
      console.error('Error exporting PDF:', error);
      alert('Đã xảy ra lỗi khi xuất PDF');
    } finally {
      setIsExporting(false);
    }
  };

  // Load tutors on mount
  useEffect(() => {
    const loadTutors = async () => {
      try {
        console.log('🔵 [TutorReport] Calling getAllTutors...');
        const response = await reportApi.getAllTutors();
        console.log('✅ [TutorReport] getAllTutors response:', response);
        console.log('📦 [TutorReport] Response data:', response.data);
        if (response.data) {
          setTutors(response.data);
          console.log('✅ [TutorReport] Tutors set:', response.data);
        }
      } catch (err) {
        console.error("❌ [TutorReport] Error loading tutors:", err);
        setError("Không thể tải danh sách gia sư");
      }
    };
    loadTutors();
  }, []);

  const handleSearch = async () => {
    if (!giaSuId || !thang || !nam) return;
    
    setLoading(true);
    setError(null);
    try {
      console.log('🔵 [TutorReport] Calling getTutorReport with:', { giaSuId, thang, nam });
      const response = await reportApi.getTutorReport(
        parseInt(giaSuId),
        parseInt(thang),
        parseInt(nam)
      );
      console.log('✅ [TutorReport] getTutorReport response:', response);
      console.log('📦 [TutorReport] Report data:', response.data);
      if (response.data && Array.isArray(response.data)) {
        // Sort by month to ensure correct order
        const sortedData = response.data.sort((a, b) => {
          if (a.nam !== b.nam) return a.nam - b.nam;
          return a.thang - b.thang;
        });
        setReportData(sortedData);
        console.log('✅ [TutorReport] Report data set (sorted):', sortedData);
      }
    } catch (err: any) {
      console.error("❌ [TutorReport] Error fetching tutor report:", err);
      console.error("❌ [TutorReport] Error response:", err.response);
      setError(err.response?.data?.message || "Không thể tải báo cáo gia sư");
      setReportData([]);
    } finally {
      setLoading(false);
    }
  };

  const getXepHangColor = (xepHang: string) => {
    switch (xepHang) {
      case "Xuất sắc": return "bg-green-500";
      case "Tốt": return "bg-blue-500";
      case "Khá": return "bg-yellow-500";
      default: return "bg-gray-500";
    }
  };

  const getQualityPercentage = (score: number) => {
    return (score / 10) * 100;
  };

  // Calculate difference from previous month
  const calculateDifference = (current: number, previous: number | undefined) => {
    if (previous === undefined) return null;
    const diff = current - previous;
    return {
      value: Math.abs(diff),
      isPositive: diff > 0,
      percentage: previous !== 0 ? ((diff / previous) * 100).toFixed(1) : '0'
    };
  };

  // Chart data for the selected tutor - using real data from API
  const getMonthlyPerformanceData = () => {
    if (reportData.length === 0) return [];
    return reportData.map(data => ({
      thang: `T${data.thang}`,
      hocVien: data.tongHocVien,
      lop: data.soLopDangDay,
      diemChatLuong: data.diemChatLuong
    }));
  };

  return (
    <div>
      {/* Search Form */}
      <Card className="p-6 mb-6 bg-gradient-to-br from-blue-50 to-white">
        <h3 className="text-gray-900 mb-4">Thông tin tìm kiếm</h3>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div>
            <Label htmlFor="giaSuId">ID Gia sư</Label>
            <Select value={giaSuId} onValueChange={setGiaSuId}>
              <SelectTrigger id="giaSuId">
                <SelectValue placeholder="Chọn gia sư" />
              </SelectTrigger>
              <SelectContent className="max-h-[300px] overflow-y-auto">
                {tutors.map((tutor) => (
                  <SelectItem key={tutor.id} value={tutor.id.toString()}>
                    {tutor.id} - {tutor.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label htmlFor="thang">Tháng</Label>
            <Select value={thang} onValueChange={setThang}>
              <SelectTrigger id="thang">
                <SelectValue placeholder="Chọn tháng" />
              </SelectTrigger>
              <SelectContent>
                {Array.from({ length: 12 }, (_, i) => i + 1).map((month) => (
                  <SelectItem key={month} value={month.toString()}>
                    Tháng {month}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label htmlFor="nam">Năm</Label>
            <Select value={nam} onValueChange={setNam}>
              <SelectTrigger id="nam">
                <SelectValue placeholder="Chọn năm" />
              </SelectTrigger>
              <SelectContent>
                {[2025, 2024, 2023, 2022, 2021].map((year) => (
                  <SelectItem key={year} value={year.toString()}>
                    {year}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="flex items-end">
            <Button 
              onClick={handleSearch} 
              className="w-full bg-blue-500 hover:bg-blue-600 gap-2"
              disabled={!giaSuId || !thang || !nam || loading}
            >
              <Search className="w-4 h-4" />
              Tìm kiếm
            </Button>
          </div>
        </div>
      </Card>

      {error && (
        <Card className="p-4 bg-red-50 border-l-4 border-l-red-500">
          <p className="text-red-700">{error}</p>
        </Card>
      )}

      {loading && (
        <Card className="p-8">
          <div className="text-center text-gray-600">Đang tải dữ liệu...</div>
        </Card>
      )}

      {!loading && reportData.length > 0 && currentMonthData && (
        <div ref={reportRef} className="space-y-6">
          {/* Header Card */}
          <Card className="p-6 bg-gradient-to-r from-blue-500 to-blue-600 text-white">
            <div className="flex items-center justify-between">
              <div>
                <div className="flex items-center gap-3 mb-2">
                  <h2 className="text-white">{currentMonthData.hoTen}</h2>
                  <Badge className={`${getXepHangColor(currentMonthData.xepHang)} border-0`}>
                    <Award className="w-3 h-3 mr-1" />
                    {currentMonthData.xepHang}
                  </Badge>
                </div>
                <p className="text-blue-100">ID: {currentMonthData.giaSuId} | Báo cáo tháng {currentMonthData.thang}/{currentMonthData.nam}</p>
              </div>
              <div className="text-right">
                <div className="text-blue-100 text-sm mb-1">Điểm chất lượng</div>
                <div className="flex items-center gap-2">
                  <Star className="w-6 h-6 fill-yellow-300 text-yellow-300" />
                  <span className="text-white">{currentMonthData.diemChatLuong}/10</span>
                </div>
              </div>
            </div>
          </Card>

          {/* Stats Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <Card className="p-6 border-l-4 border-l-blue-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-blue-100 p-3 rounded-lg">
                  <BookOpen className="w-6 h-6 text-blue-600" />
                </div>
                {(() => {
                  const diff = calculateDifference(currentMonthData.soLopDangDay, previousMonthData?.soLopDangDay);
                  return diff && diff.value > 0 ? (
                    diff.isPositive ? 
                      <TrendingUp className="w-5 h-5 text-green-500" /> :
                      <TrendingDown className="w-5 h-5 text-red-500" />
                  ) : null;
                })()}
              </div>
              <div className="text-gray-600 text-sm mb-1">Số lớp đang dạy</div>
              <div className="text-gray-900">{currentMonthData.soLopDangDay} lớp</div>
              {(() => {
                const diff = calculateDifference(currentMonthData.soLopDangDay, previousMonthData?.soLopDangDay);
                return diff && diff.value > 0 ? (
                  <div className={`text-xs mt-1 ${diff.isPositive ? 'text-green-600' : 'text-red-600'}`}>
                    {diff.isPositive ? '+' : '-'}{diff.value} so với tháng trước
                  </div>
                ) : <div className="text-xs text-gray-500 mt-1">Không đổi</div>;
              })()}
            </Card>

            <Card className="p-6 border-l-4 border-l-green-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-green-100 p-3 rounded-lg">
                  <Users className="w-6 h-6 text-green-600" />
                </div>
                {(() => {
                  const diff = calculateDifference(currentMonthData.tongHocVien, previousMonthData?.tongHocVien);
                  return diff && diff.value > 0 ? (
                    diff.isPositive ? 
                      <TrendingUp className="w-5 h-5 text-green-500" /> :
                      <TrendingDown className="w-5 h-5 text-red-500" />
                  ) : null;
                })()}
              </div>
              <div className="text-gray-600 text-sm mb-1">Tổng học viên</div>
              <div className="text-gray-900">{currentMonthData.tongHocVien} học viên</div>
              {(() => {
                const diff = calculateDifference(currentMonthData.tongHocVien, previousMonthData?.tongHocVien);
                return diff && diff.value > 0 ? (
                  <div className={`text-xs mt-1 ${diff.isPositive ? 'text-green-600' : 'text-red-600'}`}>
                    {diff.isPositive ? '+' : '-'}{diff.value} so với tháng trước
                  </div>
                ) : <div className="text-xs text-gray-500 mt-1">Không đổi</div>;
              })()}
            </Card>

            <Card className="p-6 border-l-4 border-l-purple-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-purple-100 p-3 rounded-lg">
                  <Award className="w-6 h-6 text-purple-600" />
                </div>
                {(() => {
                  const diff = calculateDifference(currentMonthData.hopDongKyTrongThang || 0, previousMonthData?.hopDongKyTrongThang || 0);
                  return diff && diff.value > 0 ? (
                    diff.isPositive ? 
                      <TrendingUp className="w-5 h-5 text-green-500" /> :
                      <TrendingDown className="w-5 h-5 text-red-500" />
                  ) : null;
                })()}
              </div>
              <div className="text-gray-600 text-sm mb-1">Hợp đồng</div>
              <div className="text-gray-900">{currentMonthData.hopDongKyTrongThang || 0} hợp đồng</div>
              <div className="text-xs text-gray-500 mt-1">Trong tháng {currentMonthData.thang}</div>
            </Card>

            <Card className="p-6 border-l-4 border-l-yellow-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-yellow-100 p-3 rounded-lg">
                  <DollarSign className="w-6 h-6 text-yellow-600" />
                </div>
                {(() => {
                  const diff = calculateDifference(currentMonthData.doanhThuDuKien, previousMonthData?.doanhThuDuKien);
                  return diff && diff.value > 0 ? (
                    diff.isPositive ? 
                      <TrendingUp className="w-5 h-5 text-green-500" /> :
                      <TrendingDown className="w-5 h-5 text-red-500" />
                  ) : null;
                })()}
              </div>
              <div className="text-gray-600 text-sm mb-1">Doanh thu dự kiến</div>
              <div className="text-gray-900">
                {(currentMonthData.doanhThuDuKien / 1000000).toFixed(1)}M VNĐ
              </div>
              {(() => {
                const diff = calculateDifference(currentMonthData.doanhThuDuKien, previousMonthData?.doanhThuDuKien);
                return diff && diff.value > 0 ? (
                  <div className={`text-xs mt-1 ${diff.isPositive ? 'text-green-600' : 'text-red-600'}`}>
                    {diff.isPositive ? '+' : '-'}{(diff.value / 1000000).toFixed(1)}M so với tháng trước
                  </div>
                ) : <div className="text-xs text-gray-500 mt-1">Không đổi</div>;
              })()}
            </Card>
          </div>

          {/* Charts Section */}
          <Card className="p-6">
            <h3 className="text-gray-900 mb-4">Xu hướng theo tháng</h3>
            <ResponsiveContainer width="100%" height={350}>
              <LineChart data={getMonthlyPerformanceData()}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="thang" />
                <YAxis yAxisId="left" />
                <YAxis yAxisId="right" orientation="right" domain={[0, 10]} />
                <Tooltip />
                <Legend />
                <Line 
                  yAxisId="left"
                  type="monotone" 
                  dataKey="hocVien" 
                  stroke="#3B82F6" 
                  strokeWidth={2}
                  name="Số học viên"
                />
                <Line 
                  yAxisId="left"
                  type="monotone" 
                  dataKey="lop" 
                  stroke="#F59E0B" 
                  strokeWidth={2}
                  name="Số lớp"
                />
                <Line 
                  yAxisId="right"
                  type="monotone" 
                  dataKey="diemChatLuong" 
                  stroke="#10B981" 
                  strokeWidth={2}
                  name="Điểm chất lượng"
                />
              </LineChart>
            </ResponsiveContainer>
          </Card>

          {/* Revenue Breakdown */}
          <Card className="p-6">
            <h3 className="text-gray-900 mb-4">Chi tiết doanh thu dự kiến - Tháng {currentMonthData.thang}</h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="bg-blue-50 p-4 rounded-lg">
                <div className="text-blue-600 text-sm mb-1">Tổng doanh thu</div>
                <div className="text-gray-900">
                  {currentMonthData.doanhThuDuKien.toLocaleString('vi-VN')} VNĐ
                </div>
              </div>
              <div className="bg-green-50 p-4 rounded-lg">
                <div className="text-green-600 text-sm mb-1">Trung bình/lớp</div>
                <div className="text-gray-900">
                  {(currentMonthData.doanhThuDuKien / currentMonthData.soLopDangDay).toLocaleString('vi-VN')} VNĐ
                </div>
              </div>
              <div className="bg-purple-50 p-4 rounded-lg">
                <div className="text-purple-600 text-sm mb-1">Trung bình/học viên</div>
                <div className="text-gray-900">
                  {(currentMonthData.doanhThuDuKien / currentMonthData.tongHocVien).toLocaleString('vi-VN')} VNĐ
                </div>
              </div>
            </div>
          </Card>

          {/* Performance Details */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Đánh giá chất lượng</h3>
              <div className="space-y-4">
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-gray-600 text-sm">Điểm chất lượng tổng thể</span>
                    <span className="text-gray-900">{currentMonthData.diemChatLuong}/10</span>
                  </div>
                  <Progress value={getQualityPercentage(currentMonthData.diemChatLuong)} className="h-2" />
                </div>
                
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-gray-600 text-sm">Xếp hạng</span>
                    <Badge className={getXepHangColor(currentMonthData.xepHang)}>
                      {currentMonthData.xepHang}
                    </Badge>
                  </div>
                </div>
              </div>
            </Card>

            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Thống kê nhanh</h3>
              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <span className="text-gray-600">Trung bình học viên/lớp</span>
                  <span className="text-gray-900">
                    {(currentMonthData.tongHocVien / currentMonthData.soLopDangDay).toFixed(1)} học viên
                  </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <span className="text-gray-600">Thu nhập trung bình/lớp</span>
                  <span className="text-gray-900">
                    {(currentMonthData.doanhThuDuKien / currentMonthData.soLopDangDay / 1000000).toFixed(1)}M VNĐ
                  </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <span className="text-gray-600">Hợp đồng trong tháng</span>
                  <span className="text-blue-600">{currentMonthData.hopDongKyTrongThang || 0}</span>
                </div>
              </div>
            </Card>
          </div>

          {/* Feedback Card */}
          <Card className="p-6">
            <h3 className="text-gray-900 mb-3">Nhận xét và đánh giá</h3>
            <div className="bg-blue-50 border-l-4 border-l-blue-500 p-4 rounded">
              <p className="text-gray-800">{currentMonthData.nhanXet}</p>
            </div>
          </Card>

          {/* Action Buttons */}
          <div className="flex gap-3">
            <Button 
              onClick={() => {
                setReportData([]);
                setGiaSuId("");
              }} 
              variant="outline"
              className="flex-1"
            >
              Quay lại danh sách
            </Button>
            <Button 
              onClick={handleExportPDF}
              disabled={isExporting}
              className="flex-1 bg-blue-500 hover:bg-blue-600"
            >
              {isExporting ? 'Đang xuất...' : 'Xuất báo cáo PDF'}
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}