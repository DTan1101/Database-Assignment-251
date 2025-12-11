# CSDL Frontend - Hướng dẫn chạy ứng dụng

## Giới thiệu
Ứng dụng Frontend cho hệ thống quản lý Quiz và báo cáo học viên/gia sư.

## Yêu cầu hệ thống
- **Node.js**: v18.0.0 trở lên
- **npm**: v9.0.0 trở lên (hoặc yarn/pnpm)
- **Trình duyệt**: Chrome, Firefox, Edge (phiên bản mới nhất)

## Cài đặt

### 1. Cài đặt các thư viện cần thiết
```bash
npm install
```

Hoặc nếu dùng yarn:
```bash
yarn install
```

Hoặc nếu dùng pnpm:
```bash
pnpm install
```

### 2. Cấu hình Backend API URL (nếu cần)
Mở file `src/api/quizApi.ts` và kiểm tra `baseURL`:
```typescript
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api', // Đổi URL nếu backend chạy ở port khác
  timeout: 10000,
});
```

## Chạy ứng dụng

### Chế độ Development (phát triển)
```bash
npm run dev
```

Ứng dụng sẽ chạy tại: **http://localhost:5173**

### Preview bản build
```bash
npm run preview
```

## Cấu trúc thư mục
```
CSDL_FE/
├── public/              # File tĩnh
├── src/
│   ├── api/            # API clients (quizApi, reportApi)
│   ├── assets/         # Hình ảnh, fonts
│   ├── components/     # React components
│   │   ├── ui/        # UI components (button, card, dialog, etc.)
│   │   ├── QuizDashboard.tsx
│   │   ├── QuizList.tsx
│   │   ├── StudentReport.tsx
│   │   ├── TutorReport.tsx
│   │   └── ...
│   ├── types/         # TypeScript types
│   ├── styles/        # CSS files
│   ├── App.jsx        # Main App component
│   └── main.jsx       # Entry point
├── index.html
├── package.json
├── vite.config.js
└── tailwind.config.js
```

## Các thư viện chính đã sử dụng

### Core
- **React 18** - UI Framework
- **TypeScript** - Type safety
- **Vite** - Build tool

### UI Components
- **Radix UI** - Headless UI components
- **Tailwind CSS** - Utility-first CSS
- **Lucide React** - Icons

### Charts & Visualization
- **Recharts** - Biểu đồ (Bar, Pie, Line charts)

### Form & State
- **React Hook Form** - Form management
- **Axios** - HTTP client

### Others
- **Sonner** - Toast notifications
- **date-fns** - Date utilities

## Tính năng chính

### 1. Quản lý Quiz
- Xem danh sách quiz
- Tạo quiz mới
- Chỉnh sửa quiz
- Xóa quiz
- Làm quiz và xem điểm

### 2. Báo cáo Học viên
- Chọn học viên và lớp học
- Xem tiến độ học tập
- Biểu đồ phân tích:
  - Phân bố điểm số (Bar chart)
  - Tình trạng làm bài (Pie chart)
  - Phân bố xếp loại (Pie chart)
- Cảnh báo và xu hướng

### 3. Báo cáo Gia sư
- Chọn gia sư và tháng/năm
- Xem hiệu quả giảng dạy
- Thống kê lớp học và học viên
- Doanh thu và xếp hạng
- Xuất báo cáo PDF

## API Endpoints

### Quiz APIs
- `GET /api/quiz` - Lấy danh sách quiz
- `POST /api/quiz` - Tạo quiz mới
- `PUT /api/quiz/:id` - Cập nhật quiz
- `DELETE /api/quiz/:id` - Xóa quiz
- `GET /api/quiz/:id/do` - Lấy quiz để làm bài
- `POST /api/quiz/:id/submit` - Nộp bài quiz

### Report APIs
- `GET /api/report/students` - Danh sách học viên
- `GET /api/report/tutors` - Danh sách gia sư
- `GET /api/classes?hocVienId={id}` - Lớp học của học viên
- `GET /api/report/student?hocVienId={id}&lopHocId={id}` - Báo cáo học viên
- `GET /api/report/tutor?giaSuId={id}&thang={m}&nam={y}` - Báo cáo gia sư

