import { useState } from "react";
import { Search, ArrowUpDown, ChevronLeft, ChevronRight, TrendingUp, Award, Clock } from "lucide-react";
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
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "./ui/table";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
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

interface ScoreData {
  id: number;
  lopHocId: number;
  tenQuiz: string;
  lan: number;
  diem: number;
  thoiGianBatDau: string;
  thoiGianKetThuc: string;
  hocVienId: number;
  tenHocVien?: string;
}

// Mock data
const mockScoreData: ScoreData[] = [
  {
    id: 1,
    lopHocId: 1,
    tenQuiz: "Kiểm tra giữa kỳ Toán học",
    lan: 1,
    diem: 8.5,
    thoiGianBatDau: "2024-12-01T09:00:00",
    thoiGianKetThuc: "2024-12-01T10:30:00",
    hocVienId: 201,
    tenHocVien: "Trần Thị Bình",
  },
  {
    id: 2,
    lopHocId: 1,
    tenQuiz: "Kiểm tra giữa kỳ Toán học",
    lan: 2,
    diem: 9.0,
    thoiGianBatDau: "2024-12-02T09:00:00",
    thoiGianKetThuc: "2024-12-02T10:30:00",
    hocVienId: 201,
    tenHocVien: "Trần Thị Bình",
  },
  {
    id: 3,
    lopHocId: 1,
    tenQuiz: "Bài tập Vật lý lượng tử",
    lan: 1,
    diem: 7.5,
    thoiGianBatDau: "2024-12-03T14:00:00",
    thoiGianKetThuc: "2024-12-03T15:00:00",
    hocVienId: 202,
    tenHocVien: "Nguyễn Minh Châu",
  },
  {
    id: 4,
    lopHocId: 2,
    tenQuiz: "Quiz Lập trình C++",
    lan: 1,
    diem: 6.5,
    thoiGianBatDau: "2024-12-04T10:00:00",
    thoiGianKetThuc: "2024-12-04T11:30:00",
    hocVienId: 203,
    tenHocVien: "Lê Hoàng Duy",
  },
  {
    id: 5,
    lopHocId: 2,
    tenQuiz: "Quiz Lập trình C++",
    lan: 2,
    diem: 7.0,
    thoiGianBatDau: "2024-12-05T10:00:00",
    thoiGianKetThuc: "2024-12-05T11:30:00",
    hocVienId: 203,
    tenHocVien: "Lê Hoàng Duy",
  },
  {
    id: 6,
    lopHocId: 1,
    tenQuiz: "Trắc nghiệm Tiếng Anh",
    lan: 1,
    diem: 9.5,
    thoiGianBatDau: "2024-12-06T08:00:00",
    thoiGianKetThuc: "2024-12-06T09:00:00",
    hocVienId: 204,
    tenHocVien: "Phạm Thu Hà",
  },
  {
    id: 7,
    lopHocId: 3,
    tenQuiz: "Bài kiểm tra Hóa học hữu cơ",
    lan: 1,
    diem: 8.0,
    thoiGianBatDau: "2024-12-07T13:00:00",
    thoiGianKetThuc: "2024-12-07T14:30:00",
    hocVienId: 205,
    tenHocVien: "Võ Đình Khoa",
  },
  {
    id: 8,
    lopHocId: 1,
    tenQuiz: "Kiểm tra giữa kỳ Toán học",
    lan: 1,
    diem: 5.5,
    thoiGianBatDau: "2024-12-01T09:00:00",
    thoiGianKetThuc: "2024-12-01T10:30:00",
    hocVienId: 203,
    tenHocVien: "Lê Hoàng Duy",
  },
  {
    id: 9,
    lopHocId: 1,
    tenQuiz: "Bài tập Vật lý lượng tử",
    lan: 1,
    diem: 9.8,
    thoiGianBatDau: "2024-12-03T14:00:00",
    thoiGianKetThuc: "2024-12-03T15:00:00",
    hocVienId: 206,
    tenHocVien: "Đinh Thảo My",
  },
  {
    id: 10,
    lopHocId: 2,
    tenQuiz: "Quiz Lập trình C++",
    lan: 1,
    diem: 8.8,
    thoiGianBatDau: "2024-12-04T10:00:00",
    thoiGianKetThuc: "2024-12-04T11:30:00",
    hocVienId: 201,
    tenHocVien: "Trần Thị Bình",
  },
  {
    id: 11,
    lopHocId: 1,
    tenQuiz: "Trắc nghiệm Tiếng Anh",
    lan: 1,
    diem: 7.2,
    thoiGianBatDau: "2024-12-06T08:00:00",
    thoiGianKetThuc: "2024-12-06T09:00:00",
    hocVienId: 202,
    tenHocVien: "Nguyễn Minh Châu",
  },
  {
    id: 12,
    lopHocId: 3,
    tenQuiz: "Bài kiểm tra Hóa học hữu cơ",
    lan: 1,
    diem: 6.8,
    thoiGianBatDau: "2024-12-07T13:00:00",
    thoiGianKetThuc: "2024-12-07T14:30:00",
    hocVienId: 201,
    tenHocVien: "Trần Thị Bình",
  },
];

export function ScorePage() {
  const [lopHocId, setLopHocId] = useState("all");
  const [tenQuiz, setTenQuiz] = useState("");
  const [hocVienId, setHocVienId] = useState("all");
  const [page, setPage] = useState(0);
  const [size, setSize] = useState(10);
  const [sortBy, setSortBy] = useState("thoiGianBatDau");
  const [sortDirection, setSortDirection] = useState("DESC");
  const [filteredData, setFilteredData] = useState<ScoreData[]>([]);
  const [showResults, setShowResults] = useState(false);

  const handleSearch = () => {
    let results = [...mockScoreData];

    // Apply filters
    if (lopHocId && lopHocId !== "all") {
      results = results.filter(item => item.lopHocId === parseInt(lopHocId));
    }
    if (tenQuiz) {
      results = results.filter(item => 
        item.tenQuiz.toLowerCase().includes(tenQuiz.toLowerCase())
      );
    }
    if (hocVienId && hocVienId !== "all") {
      results = results.filter(item => item.hocVienId === parseInt(hocVienId));
    }

    // Apply sorting
    results.sort((a, b) => {
      let aVal, bVal;
      
      switch (sortBy) {
        case "id":
          aVal = a.id;
          bVal = b.id;
          break;
        case "diem":
          aVal = a.diem;
          bVal = b.diem;
          break;
        case "lan":
          aVal = a.lan;
          bVal = b.lan;
          break;
        case "thoiGianBatDau":
        default:
          aVal = new Date(a.thoiGianBatDau).getTime();
          bVal = new Date(b.thoiGianBatDau).getTime();
      }

      return sortDirection === "ASC" ? aVal - bVal : bVal - aVal;
    });

    setFilteredData(results);
    setShowResults(true);
    setPage(0);
  };

  const formatDateTime = (dateTime: string) => {
    const date = new Date(dateTime);
    return date.toLocaleString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const formatDuration = (start: string, end: string) => {
    const startTime = new Date(start);
    const endTime = new Date(end);
    const durationMs = endTime.getTime() - startTime.getTime();
    const minutes = Math.floor(durationMs / 60000);
    return `${minutes} phút`;
  };

  const getScoreColor = (score: number) => {
    if (score >= 8.5) return "text-green-600 bg-green-50";
    if (score >= 7.0) return "text-blue-600 bg-blue-50";
    if (score >= 5.5) return "text-yellow-600 bg-yellow-50";
    return "text-red-600 bg-red-50";
  };

  const getScoreLevel = (score: number) => {
    if (score >= 8.5) return "Giỏi";
    if (score >= 7.0) return "Khá";
    if (score >= 5.5) return "Trung bình";
    return "Yếu";
  };

  // Pagination
  const totalPages = Math.ceil(filteredData.length / size);
  const paginatedData = filteredData.slice(page * size, (page + 1) * size);

  // Statistics
  const getStatistics = () => {
    if (filteredData.length === 0) return null;
    
    const avgScore = filteredData.reduce((sum, item) => sum + item.diem, 0) / filteredData.length;
    const maxScore = Math.max(...filteredData.map(item => item.diem));
    const minScore = Math.min(...filteredData.map(item => item.diem));
    const passRate = (filteredData.filter(item => item.diem >= 5.0).length / filteredData.length) * 100;

    return { avgScore, maxScore, minScore, passRate };
  };

  const stats = getStatistics();

  // Chart data
  const getScoreDistributionData = () => {
    const distribution = [
      { range: "9-10", count: 0 },
      { range: "8-8.9", count: 0 },
      { range: "7-7.9", count: 0 },
      { range: "6-6.9", count: 0 },
      { range: "5-5.9", count: 0 },
      { range: "<5", count: 0 },
    ];

    filteredData.forEach(item => {
      if (item.diem >= 9) distribution[0].count++;
      else if (item.diem >= 8) distribution[1].count++;
      else if (item.diem >= 7) distribution[2].count++;
      else if (item.diem >= 6) distribution[3].count++;
      else if (item.diem >= 5) distribution[4].count++;
      else distribution[5].count++;
    });

    return distribution;
  };

  const getScoreLevelDistribution = () => {
    const distribution = [
      { name: "Giỏi", value: 0, color: "#10B981" },
      { name: "Khá", value: 0, color: "#3B82F6" },
      { name: "Trung bình", value: 0, color: "#EAB308" },
      { name: "Yếu", value: 0, color: "#EF4444" },
    ];

    filteredData.forEach(item => {
      if (item.diem >= 8.5) distribution[0].value++;
      else if (item.diem >= 7.0) distribution[1].value++;
      else if (item.diem >= 5.5) distribution[2].value++;
      else distribution[3].value++;
    });

    return distribution;
  };

  const getQuizCompletionData = () => {
    // Count completed quizzes
    const completedCount = filteredData.length;
    
    // Calculate missed quizzes (assume 20% of total available quizzes are missed)
    const missedCount = Math.round(completedCount * 0.25);
    
    return [
      { name: "Đã làm", value: completedCount, color: "#10B981" },
      { name: "Bỏ lỡ", value: missedCount, color: "#EF4444" },
    ];
  };

  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-gray-900 mb-2">Điểm số</h1>
        <p className="text-gray-600">Tra cứu và quản lý điểm số của học viên</p>
      </div>

      {/* Search Form */}
      <Card className="p-6 mb-6 bg-gradient-to-br from-green-50 to-white">
        <h3 className="text-gray-900 mb-4">Tìm kiếm điểm số</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 mb-4">
          <div>
            <Label htmlFor="lopHocId">ID Lớp học</Label>
            <Select value={lopHocId} onValueChange={setLopHocId}>
              <SelectTrigger id="lopHocId">
                <SelectValue placeholder="Tất cả" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả</SelectItem>
                <SelectItem value="1">Lớp 1 - Toán Nâng cao</SelectItem>
                <SelectItem value="2">Lớp 2 - Lập trình</SelectItem>
                <SelectItem value="3">Lớp 3 - Hóa học</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div>
            <Label htmlFor="tenQuiz">Tên Quiz</Label>
            <Input
              id="tenQuiz"
              type="text"
              placeholder="Tìm theo tên quiz"
              value={tenQuiz}
              onChange={(e) => setTenQuiz(e.target.value)}
            />
          </div>

          <div>
            <Label htmlFor="hocVienId">ID Học viên</Label>
            <Select value={hocVienId} onValueChange={setHocVienId}>
              <SelectTrigger id="hocVienId">
                <SelectValue placeholder="Tất cả" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả</SelectItem>
                <SelectItem value="201">201 - Trần Thị Bình</SelectItem>
                <SelectItem value="202">202 - Nguyễn Minh Châu</SelectItem>
                <SelectItem value="203">203 - Lê Hoàng Duy</SelectItem>
                <SelectItem value="204">204 - Phạm Thu Hà</SelectItem>
                <SelectItem value="205">205 - Võ Đình Khoa</SelectItem>
                <SelectItem value="206">206 - Đinh Thảo My</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div>
            <Label htmlFor="sortBy">Sắp xếp theo</Label>
            <Select value={sortBy} onValueChange={setSortBy}>
              <SelectTrigger id="sortBy">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="thoiGianBatDau">Thời gian</SelectItem>
                <SelectItem value="diem">Điểm số</SelectItem>
                <SelectItem value="lan">Số lần</SelectItem>
                <SelectItem value="id">ID</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div>
            <Label htmlFor="sortDirection">Thứ tự</Label>
            <Select value={sortDirection} onValueChange={setSortDirection}>
              <SelectTrigger id="sortDirection">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="DESC">Giảm dần</SelectItem>
                <SelectItem value="ASC">Tăng dần</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        <div className="flex gap-3">
          <Button 
            onClick={handleSearch} 
            className="bg-green-500 hover:bg-green-600 gap-2"
          >
            <Search className="w-4 h-4" />
            Tìm kiếm
          </Button>
          <Button 
            variant="outline"
            onClick={() => {
              setLopHocId("all");
              setTenQuiz("");
              setHocVienId("all");
              setShowResults(false);
            }}
          >
            Đặt lại
          </Button>
        </div>
      </Card>

      {/* Statistics Cards */}
      {showResults && stats && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
          <Card className="p-6 border-l-4 border-l-blue-500">
            <div className="flex items-start justify-between mb-3">
              <div className="bg-blue-100 p-3 rounded-lg">
                <TrendingUp className="w-6 h-6 text-blue-600" />
              </div>
            </div>
            <div className="text-gray-600 text-sm mb-1">Điểm trung bình</div>
            <div className="text-gray-900">{stats.avgScore.toFixed(2)}/10</div>
          </Card>

          <Card className="p-6 border-l-4 border-l-green-500">
            <div className="flex items-start justify-between mb-3">
              <div className="bg-green-100 p-3 rounded-lg">
                <Award className="w-6 h-6 text-green-600" />
              </div>
            </div>
            <div className="text-gray-600 text-sm mb-1">Điểm cao nhất</div>
            <div className="text-green-600">{stats.maxScore.toFixed(2)}/10</div>
          </Card>

          <Card className="p-6 border-l-4 border-l-red-500">
            <div className="flex items-start justify-between mb-3">
              <div className="bg-red-100 p-3 rounded-lg">
                <Award className="w-6 h-6 text-red-600" />
              </div>
            </div>
            <div className="text-gray-600 text-sm mb-1">Điểm thấp nhất</div>
            <div className="text-red-600">{stats.minScore.toFixed(2)}/10</div>
          </Card>

          <Card className="p-6 border-l-4 border-l-purple-500">
            <div className="flex items-start justify-between mb-3">
              <div className="bg-purple-100 p-3 rounded-lg">
                <Clock className="w-6 h-6 text-purple-600" />
              </div>
            </div>
            <div className="text-gray-600 text-sm mb-1">Tỷ lệ đạt</div>
            <div className="text-purple-600">{stats.passRate.toFixed(1)}%</div>
          </Card>
        </div>
      )}

      {/* Chart */}
      {showResults && filteredData.length > 0 && hocVienId !== "all" && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
          <Card className="p-6">
            <h3 className="text-gray-900 mb-4">Phân bố điểm số</h3>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={getScoreDistributionData()}>
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
                  label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
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
      )}

      {/* Results Table */}
      {showResults && (
        <Card className="p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-gray-900">
              Kết quả tìm kiếm ({filteredData.length} bản ghi)
            </h3>
            <Select value={size.toString()} onValueChange={(val) => setSize(parseInt(val))}>
              <SelectTrigger className="w-32">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="5">5 / trang</SelectItem>
                <SelectItem value="10">10 / trang</SelectItem>
                <SelectItem value="20">20 / trang</SelectItem>
                <SelectItem value="50">50 / trang</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Học viên</TableHead>
                  <TableHead>Lớp học</TableHead>
                  <TableHead>Tên Quiz</TableHead>
                  <TableHead>Lần</TableHead>
                  <TableHead>Điểm</TableHead>
                  <TableHead>Xếp loại</TableHead>
                  <TableHead>Thời gian bắt đầu</TableHead>
                  <TableHead>Thời gian kết thúc</TableHead>
                  <TableHead>Thời lượng</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {paginatedData.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell>{item.id}</TableCell>
                    <TableCell>
                      <div>
                        <div className="text-gray-900">{item.tenHocVien}</div>
                        <div className="text-gray-500 text-sm">ID: {item.hocVienId}</div>
                      </div>
                    </TableCell>
                    <TableCell>{item.lopHocId}</TableCell>
                    <TableCell className="max-w-xs">
                      <div className="truncate">{item.tenQuiz}</div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">Lần {item.lan}</Badge>
                    </TableCell>
                    <TableCell>
                      <span className={`px-2 py-1 rounded ${getScoreColor(item.diem)}`}>
                        {item.diem.toFixed(1)}
                      </span>
                    </TableCell>
                    <TableCell>
                      <Badge className={
                        item.diem >= 8.5 ? "bg-green-500" :
                        item.diem >= 7.0 ? "bg-blue-500" :
                        item.diem >= 5.5 ? "bg-yellow-500" : "bg-red-500"
                      }>
                        {getScoreLevel(item.diem)}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-sm">
                      {formatDateTime(item.thoiGianBatDau)}
                    </TableCell>
                    <TableCell className="text-sm">
                      {formatDateTime(item.thoiGianKetThuc)}
                    </TableCell>
                    <TableCell className="text-sm">
                      {formatDuration(item.thoiGianBatDau, item.thoiGianKetThuc)}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="flex items-center justify-between mt-4">
              <div className="text-gray-600 text-sm">
                Trang {page + 1} / {totalPages}
              </div>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setPage(Math.max(0, page - 1))}
                  disabled={page === 0}
                >
                  <ChevronLeft className="w-4 h-4" />
                  Trước
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setPage(Math.min(totalPages - 1, page + 1))}
                  disabled={page === totalPages - 1}
                >
                  Sau
                  <ChevronRight className="w-4 h-4" />
                </Button>
              </div>
            </div>
          )}
        </Card>
      )}

      {showResults && filteredData.length === 0 && (
        <Card className="p-8">
          <div className="text-center text-gray-600">
            Không tìm thấy kết quả phù hợp. Vui lòng thử lại với bộ lọc khác.
          </div>
        </Card>
      )}

      {!showResults && (
        <Card className="p-8">
          <div className="text-center text-gray-600">
            Vui lòng nhập thông tin tìm kiếm và nhấn nút "Tìm kiếm"
          </div>
        </Card>
      )}
    </div>
  );
}