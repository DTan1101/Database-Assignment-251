import { SlidersHorizontal, ArrowUpDown } from "lucide-react";
import { Button } from "./ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "./ui/select";

export function Header() {
  return (
    <header className="bg-white border-b border-gray-200 px-6 py-4">
      <div className="flex items-center gap-4">
        <div className="flex items-center gap-2">
          <SlidersHorizontal className="w-5 h-5 text-gray-600" />
          <span className="text-gray-700">Lọc và sắp xếp:</span>
        </div>

        <Select defaultValue="all">
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Trạng thái" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tất cả trạng thái</SelectItem>
            <SelectItem value="open">Đang mở</SelectItem>
            <SelectItem value="closed">Đã đóng</SelectItem>
          </SelectContent>
        </Select>

        <Select defaultValue="newest">
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Sắp xếp theo" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="newest">Mới nhất</SelectItem>
            <SelectItem value="oldest">Cũ nhất</SelectItem>
            <SelectItem value="name">Tên A-Z</SelectItem>
            <SelectItem value="attempts">Số lần làm</SelectItem>
          </SelectContent>
        </Select>

        <Select defaultValue="all-subjects">
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Môn học" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all-subjects">Tất cả môn</SelectItem>
            <SelectItem value="math">Toán học</SelectItem>
            <SelectItem value="physics">Vật lý</SelectItem>
            <SelectItem value="programming">Lập trình</SelectItem>
            <SelectItem value="english">Tiếng Anh</SelectItem>
            <SelectItem value="chemistry">Hóa học</SelectItem>
          </SelectContent>
        </Select>

        <Button variant="outline" className="gap-2">
          <ArrowUpDown className="w-4 h-4" />
          Sắp xếp
        </Button>
      </div>
    </header>
  );
}