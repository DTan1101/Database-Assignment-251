import { useState, useEffect } from "react";
import { Search, TrendingUp, TrendingDown, AlertTriangle, CheckCircle, XCircle } from "lucide-react";
import { Card } from "./ui/card";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Badge } from "./ui/badge";
import { Progress } from "./ui/progress";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "./ui/select";
import {
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";
import { reportApi, PersonDTO, StudentProgressDTO, ClassDTO } from "../api/reportApi";

export function StudentReport() {
  const [students, setStudents] = useState<PersonDTO[]>([]);
  const [classes, setClasses] = useState<ClassDTO[]>([]);
  const [hocVienId, setHocVienId] = useState("");
  const [lopHocId, setLopHocId] = useState("");
  const [reportData, setReportData] = useState<StudentProgressDTO | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Load students on mount
  useEffect(() => {
    const loadStudents = async () => {
      try {
        console.log('🟢 [StudentReport] Calling getAllStudents...');
        const response = await reportApi.getAllStudents();
        console.log('✅ [StudentReport] getAllStudents response:', response);
        console.log('📦 [StudentReport] Response data:', response.data);
        if (response.data) {
          setStudents(response.data);
          console.log('✅ [StudentReport] Students set:', response.data);
        }
      } catch (err) {
        console.error("❌ [StudentReport] Error loading students:", err);
        setError("Không thể tải danh sách học viên");
      }
    };
    loadStudents();
  }, []);

  // Load classes when student is selected
  useEffect(() => {
    const loadClasses = async () => {
      if (!hocVienId) {
        setClasses([]);
        setLopHocId("");
        return;
      }
      
      try {
        console.log('🟢 [StudentReport] Calling getClassesByStudent with hocVienId:', hocVienId);
        const response = await reportApi.getClassesByStudent(parseInt(hocVienId));
        console.log('✅ [StudentReport] getClassesByStudent response:', response);
        console.log('📦 [StudentReport] Classes data:', response.data);
        if (response.data) {
          setClasses(response.data);
          console.log('✅ [StudentReport] Classes set:', response.data);
          // Reset lopHocId when student changes
          setLopHocId("");
        }
      } catch (err) {
        console.error("❌ [StudentReport] Error loading classes:", err);
        setError("Không thể tải danh sách lớp học");
        setClasses([]);
      }
    };
    loadClasses();
  }, [hocVienId]);

  const handleSearch = async () => {
    if (!hocVienId || !lopHocId) return;
    
    setLoading(true);
    setError(null);
    try {
      console.log('🟢 [StudentReport] Calling getStudentProgress with:', { hocVienId, lopHocId });
      const response = await reportApi.getStudentProgress(
        parseInt(hocVienId),
        parseInt(lopHocId)
      );
      console.log('✅ [StudentReport] getStudentProgress response:', response);
      console.log('📦 [StudentReport] Report data:', response.data);
      if (response.data) {
        setReportData(response.data);
        console.log('✅ [StudentReport] Report data set:', response.data);
      }
    } catch (err: any) {
      console.error("❌ [StudentReport] Error fetching student report:", err);
      console.error("❌ [StudentReport] Error response:", err.response);
      setError(err.response?.data?.message || "Không thể tải báo cáo học viên");
      setReportData(null);
    } finally {
      setLoading(false);
    }
  };

  const getXuHuongIcon = (xuHuong: string) => {
    switch (xuHuong) {
      case "Tăng": return <TrendingUp className="w-5 h-5 text-green-500" />;
      case "Giảm": return <TrendingDown className="w-5 h-5 text-red-500" />;
      default: return <div className="w-5 h-5 text-blue-500">→</div>;
    }
  };

  const getXuHuongColor = (xuHuong: string) => {
    switch (xuHuong) {
      case "Tăng": return "bg-green-500";
      case "Giảm": return "bg-red-500";
      default: return "bg-blue-500";
    }
  };

  const getPerformanceLevel = (diem: number) => {
    if (diem >= 8.5) return { level: "Xuất sắc", color: "text-green-600" };
    if (diem >= 7.0) return { level: "Tốt", color: "text-blue-600" };
    if (diem >= 5.5) return { level: "Trung bình", color: "text-yellow-600" };
    return { level: "Yếu", color: "text-red-600" };
  };

  const getScoreHistory = () => {
    if (!reportData?.lichSuDiem) return [];
    return reportData.lichSuDiem
      .split(',')
      .map(s => parseFloat(s.trim()))
      .filter(n => !isNaN(n));
  };

  const getScoreDistribution = () => {
    const scores = getScoreHistory();
    const distribution = [
      { range: "9-10", count: 0 },
      { range: "8-8.9", count: 0 },
      { range: "7-7.9", count: 0 },
      { range: "6-6.9", count: 0 },
      { range: "5-5.9", count: 0 },
      { range: "<5", count: 0 },
    ];

    scores.forEach(score => {
      if (score >= 9) distribution[0].count++;
      else if (score >= 8) distribution[1].count++;
      else if (score >= 7) distribution[2].count++;
      else if (score >= 6) distribution[3].count++;
      else if (score >= 5) distribution[4].count++;
      else distribution[5].count++;
    });

    return distribution;
  };

  const getScoreLevelDistribution = () => {
    const scores = getScoreHistory();
    const levels = {
      gioi: 0,     // >= 8.5
      kha: 0,      // 7.0 - 8.4
      trungBinh: 0, // 5.5 - 6.9
      yeu: 0       // < 5.5
    };

    scores.forEach(score => {
      if (score >= 8.5) levels.gioi++;
      else if (score >= 7.0) levels.kha++;
      else if (score >= 5.5) levels.trungBinh++;
      else levels.yeu++;
    });

    const total = scores.length || 1;
    return [
      { name: "Giỏi", value: levels.gioi, percent: (levels.gioi / total * 100).toFixed(0), color: "#10B981" },
      { name: "Khá", value: levels.kha, percent: (levels.kha / total * 100).toFixed(0), color: "#3B82F6" },
      { name: "Trung bình", value: levels.trungBinh, percent: (levels.trungBinh / total * 100).toFixed(0), color: "#EAB308" },
      { name: "Yếu", value: levels.yeu, percent: (levels.yeu / total * 100).toFixed(0), color: "#EF4444" },
    ].filter(item => item.value > 0);
  };

  const getQuizCompletionData = () => {
    if (!reportData) return [];
    return [
      { name: "Đã làm", value: reportData.soBaiDaLam, color: "#10B981" },
      { name: "Bỏ lỡ", value: reportData.soQuizBiLo, color: "#EF4444" },
    ];
  };

  return (
    <div>
      {/* Search Form */}
      <Card className="p-6 mb-6 bg-gradient-to-br from-purple-50 to-white">
        <h3 className="text-gray-900 mb-4">Thông tin tìm kiếm</h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <Label htmlFor="hocVienId">ID Học viên</Label>
            <Select value={hocVienId} onValueChange={setHocVienId}>
              <SelectTrigger id="hocVienId">
                <SelectValue placeholder="Chọn học viên" />
              </SelectTrigger>
              <SelectContent className="max-h-[300px] overflow-y-auto">
                {students.map((student) => (
                  <SelectItem key={student.id} value={student.id.toString()}>
                    {student.id} - {student.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label htmlFor="lopHocId">ID Lớp học</Label>
            <Select value={lopHocId} onValueChange={setLopHocId} disabled={!hocVienId}>
              <SelectTrigger id="lopHocId">
                <SelectValue placeholder={hocVienId ? "Chọn lớp" : "Chọn học viên trước"} />
              </SelectTrigger>
              <SelectContent>
                {classes.filter(c => c?.lopHocId && c?.thongTin).map((classItem) => (
                  <SelectItem key={classItem.lopHocId} value={classItem.lopHocId.toString()}>
                    {classItem.lopHocId} - {classItem.thongTin}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="flex items-end">
            <Button 
              onClick={handleSearch} 
              className="w-full bg-purple-500 hover:bg-purple-600 gap-2"
              disabled={!hocVienId || !lopHocId || loading}
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

      {!loading && reportData && (
        <div className="space-y-6">
          {/* Header Card */}
          <Card className="p-6 bg-gradient-to-r from-purple-500 to-purple-600 text-white">
            <div className="flex items-center justify-between">
              <div>
                <div className="flex items-center gap-3 mb-2">
                  <h2 className="text-white">{reportData.tenHocVien}</h2>
                  <Badge className={`${getXuHuongColor(reportData.xuHuong)} border-0`}>
                    {getXuHuongIcon(reportData.xuHuong)}
                    {reportData.xuHuong}
                  </Badge>
                </div>
                <p className="text-purple-100">ID: {reportData.hocVienId} | Lớp học: {lopHocId}</p>
              </div>
              <div className="text-right">
                <div className="text-purple-100 text-sm mb-1">Điểm trung bình</div>
                <div className="text-white">
                  {reportData.diemTrungBinh}/10
                </div>
                <div className={`text-sm ${getPerformanceLevel(reportData.diemTrungBinh).color.replace('text-', 'text-white opacity-')}`}>
                  {getPerformanceLevel(reportData.diemTrungBinh).level}
                </div>
              </div>
            </div>
          </Card>

          {/* Alert if exists */}
          {reportData.canhBao && reportData.canhBao.trim() !== "" && (
            <Card className="p-4 bg-red-50 border-l-4 border-l-red-500">
              <div className="flex items-start gap-3">
                <AlertTriangle className="w-6 h-6 text-red-600 flex-shrink-0 mt-1" />
                <div>
                  <h4 className="text-red-900 mb-1">Cảnh báo</h4>
                  <p className="text-red-700">{reportData.canhBao}</p>
                </div>
              </div>
            </Card>
          )}

          {/* Stats Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <Card className="p-6 border-l-4 border-l-blue-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-blue-100 p-3 rounded-lg">
                  <CheckCircle className="w-6 h-6 text-blue-600" />
                </div>
              </div>
              <div className="text-gray-600 text-sm mb-1">Số bài đã làm</div>
              <div className="text-gray-900">{reportData.soBaiDaLam} bài</div>
              <div className="text-xs text-gray-500 mt-1">
                Tỷ lệ: {((reportData.soBaiDaLam / (reportData.soBaiDaLam + reportData.soQuizBiLo)) * 100).toFixed(0)}%
              </div>
            </Card>

            <Card className="p-6 border-l-4 border-l-red-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-red-100 p-3 rounded-lg">
                  <XCircle className="w-6 h-6 text-red-600" />
                </div>
              </div>
              <div className="text-gray-600 text-sm mb-1">Quiz bị lỡ</div>
              <div className="text-gray-900">{reportData.soQuizBiLo} quiz</div>
              {reportData.soQuizBiLo > 2 && (
                <div className="text-xs text-red-600 mt-1">Cần chú ý!</div>
              )}
            </Card>

            <Card className="p-6 border-l-4 border-l-green-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-green-100 p-3 rounded-lg">
                  <TrendingUp className="w-6 h-6 text-green-600" />
                </div>
              </div>
              <div className="text-gray-600 text-sm mb-1">Điểm cao nhất</div>
              <div className="text-gray-900">{reportData.diemCaoNhat}/10</div>
            </Card>

            <Card className="p-6 border-l-4 border-l-yellow-500">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-yellow-100 p-3 rounded-lg">
                  <TrendingDown className="w-6 h-6 text-yellow-600" />
                </div>
              </div>
              <div className="text-gray-600 text-sm mb-1">Điểm thấp nhất</div>
              <div className="text-gray-900">{reportData.diemThapNhat}/10</div>
            </Card>
          </div>

          {/* Performance Details */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Phân tích điểm số</h3>
              <div className="space-y-4">
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-gray-600 text-sm">Điểm trung bình</span>
                    <span className="text-gray-900">{reportData.diemTrungBinh}/10</span>
                  </div>
                  <Progress value={reportData.diemTrungBinh * 10} className="h-2" />
                </div>
                
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-gray-600 text-sm">Điểm cao nhất</span>
                    <span className="text-green-600">{reportData.diemCaoNhat}/10</span>
                  </div>
                  <Progress value={reportData.diemCaoNhat * 10} className="h-2" />
                </div>
                
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-gray-600 text-sm">Điểm thấp nhất</span>
                    <span className="text-red-600">{reportData.diemThapNhat}/10</span>
                  </div>
                  <Progress value={reportData.diemThapNhat * 10} className="h-2" />
                </div>
              </div>
            </Card>

            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Thống kê chi tiết</h3>
              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <span className="text-gray-600">Độ dao động điểm</span>
                  <span className="text-gray-900">
                    {(reportData.diemCaoNhat - reportData.diemThapNhat).toFixed(1)} điểm
                  </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <span className="text-gray-600">Tỷ lệ hoàn thành</span>
                  <span className={reportData.soQuizBiLo === 0 ? "text-green-600" : "text-yellow-600"}>
                    {((reportData.soBaiDaLam / (reportData.soBaiDaLam + reportData.soQuizBiLo)) * 100).toFixed(0)}%
                  </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <span className="text-gray-600">Xu hướng</span>
                  <div className="flex items-center gap-2">
                    {getXuHuongIcon(reportData.xuHuong)}
                    <span className={
                      reportData.xuHuong === "Tăng" ? "text-green-600" :
                      reportData.xuHuong === "Giảm" ? "text-red-600" : "text-blue-600"
                    }>
                      {reportData.xuHuong}
                    </span>
                  </div>
                </div>
              </div>
            </Card>
          </div>

          {/* Charts Section */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Phân bố điểm số</h3>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={getScoreDistribution()}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="range" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="count" fill="#10B981" name="Số lượng" />
                </BarChart>
              </ResponsiveContainer>
            </Card>

            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Tình trạng làm bài</h3>
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={getQuizCompletionData()}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, value, percent }) => `${name}: ${value} (${(percent * 100).toFixed(0)}%)`}
                    outerRadius={100}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {getQuizCompletionData().map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </Card>

            <Card className="p-6">
              <h3 className="text-gray-900 mb-4">Phân bố xếp loại</h3>
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={getScoreLevelDistribution()}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, percent }) => `${name}: ${percent}%`}
                    outerRadius={100}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {getScoreLevelDistribution().map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </Card>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-3">
            <Button 
              onClick={() => setReportData(null)} 
              variant="outline"
              className="flex-1"
            >
              Quay lại danh sách
            </Button>
            <Button className="flex-1 bg-purple-500 hover:bg-purple-600">
              Xuất báo cáo PDF
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}