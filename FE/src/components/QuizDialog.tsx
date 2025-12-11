import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "./ui/dialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Loader2 } from "lucide-react";
import type { Quiz, QuizRequest } from "../types/quiz";

interface QuizDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  quiz?: Quiz | null;
  onSubmit: (data: QuizRequest) => Promise<void>;
  mode: "create" | "edit";
}

export function QuizDialog({ open, onOpenChange, quiz, onSubmit, mode }: QuizDialogProps) {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState<QuizRequest>({
    lopHocId: null,
    tenQuiz: null,
    soLanDuocLam: null,
    thoiGianMo: null,
    thoiGianDong: null,
  });

  // Reset form when dialog opens with quiz data
  useEffect(() => {
    if (open) {
      if (mode === "edit" && quiz) {
        // Convert ISO datetime to datetime-local format
        const formatDateTimeLocal = (isoString: string) => {
          if (!isoString) return "";
          
          // Handle format: "2025-11-15T12:00:00" or "2025-11-15 12:00:00"
          const date = new Date(isoString.replace(' ', 'T'));
          
          if (isNaN(date.getTime())) {
            console.error('Invalid date:', isoString);
            return "";
          }
          
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const day = String(date.getDate()).padStart(2, '0');
          const hours = String(date.getHours()).padStart(2, '0');
          const minutes = String(date.getMinutes()).padStart(2, '0');
          return `${year}-${month}-${day}T${hours}:${minutes}`;
        };

        const thoiGianMoFormatted = formatDateTimeLocal(quiz.thoiGianMo);
        const thoiGianDongFormatted = formatDateTimeLocal(quiz.thoiGianDong);

        setFormData({
          lopHocId: quiz.lopHocId,
          tenQuiz: quiz.tenQuiz,
          soLanDuocLam: quiz.soLanDuocLam ?? null,
          thoiGianMo: thoiGianMoFormatted,
          thoiGianDong: thoiGianDongFormatted,
          oldName: quiz.tenQuiz, // For update
        });
        console.log('📝 [QuizDialog] Edit mode - loaded quiz data:', {
          original: quiz,
          formatted: {
            lopHocId: quiz.lopHocId,
            tenQuiz: quiz.tenQuiz,
            soLanDuocLam: quiz.soLanDuocLam ?? null,
            thoiGianMo: thoiGianMoFormatted,
            thoiGianDong: thoiGianDongFormatted,
          }
        });
      } else {
        // Reset for create mode - all null
        setFormData({
          lopHocId: null as any,
          tenQuiz: null,
          soLanDuocLam: null as any,
          thoiGianMo: null,
          thoiGianDong: null,
        });
        console.log('➕ [QuizDialog] Create mode - reset to null');
      }
    }
  }, [open, quiz, mode]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      // Convert datetime-local to ISO 8601 format (yyyy-MM-ddTHH:mm:ss)
      const formatToISO = (dateTimeLocal: string | null) => {
        if (!dateTimeLocal) return null;
        return dateTimeLocal + ':00'; // Add seconds
      };

      const submitData: QuizRequest = {
        lopHocId: formData.lopHocId === null || formData.lopHocId === undefined ? null : formData.lopHocId,
        tenQuiz: formData.tenQuiz === null || formData.tenQuiz === undefined || formData.tenQuiz === "" ? null : formData.tenQuiz,
        soLanDuocLam: formData.soLanDuocLam === null || formData.soLanDuocLam === undefined ? null : formData.soLanDuocLam,
        thoiGianMo: formatToISO(formData.thoiGianMo),
        thoiGianDong: formatToISO(formData.thoiGianDong),
        oldName: formData.oldName,
      };

      console.log('📤 [QuizDialog] Form Data:', formData);
      console.log('📤 [QuizDialog] Submit Data:', submitData);
      console.log('📤 [QuizDialog] Mode:', mode);

      await onSubmit(submitData);
      onOpenChange(false);
    } catch (error) {
      console.error("❌ [QuizDialog] Error submitting quiz:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>
            {mode === "create" ? "Tạo Quiz Mới" : "Chỉnh Sửa Quiz"}
          </DialogTitle>
          <DialogDescription>
            {mode === "create"
              ? "Nhập thông tin để tạo quiz mới"
              : "Cập nhật thông tin quiz"}
          </DialogDescription>
        </DialogHeader>

        <form onSubmit={handleSubmit}>
          <div className="grid gap-4 py-4">
            {/* Lớp học ID */}
            <div className="grid gap-2">
              <Label htmlFor="lopHocId">
                Lớp học ID
              </Label>
              <Input
                id="lopHocId"
                type="number"
                disabled={mode === "edit"}
                value={formData.lopHocId ?? ""}
                onChange={(e) => {
                  const val = e.target.value === "" ? null : parseInt(e.target.value);
                  setFormData({ ...formData, lopHocId: (val === null || isNaN(val)) ? null : val });
                }}
                className={mode === "edit" ? "bg-gray-100" : ""}
              />
            </div>

            {/* Tên Quiz */}
            <div className="grid gap-2">
              <Label htmlFor="tenQuiz">
                Tên Quiz
              </Label>
              <Input
                id="tenQuiz"
                type="text"
                disabled={mode === "edit"}
                value={formData.tenQuiz ?? ""}
                onChange={(e) =>
                  setFormData({ ...formData, tenQuiz: e.target.value || null })
                }
                placeholder="Nhập tên quiz"
                className={mode === "edit" ? "bg-gray-100" : ""}
              />
              {mode === "edit" && (
                <p className="text-xs text-gray-500">
                  Không thể thay đổi tên quiz khi chỉnh sửa
                </p>
              )}
            </div>

            {/* Số lần được làm */}
            <div className="grid gap-2">
              <Label htmlFor="soLanDuocLam">
                Số lần được làm
              </Label>
              <Input
                id="soLanDuocLam"
                type="number"
                value={formData.soLanDuocLam ?? ""}
                onChange={(e) => {
                  const val = e.target.value === "" ? null : parseInt(e.target.value);
                  const finalVal = (val === null || isNaN(val)) ? null : val;
                  console.log('🔢 [QuizDialog] soLanDuocLam changed:', {
                    input: e.target.value,
                    parsed: val,
                    final: finalVal
                  });
                  setFormData({ ...formData, soLanDuocLam: finalVal });
                }}
              />
            </div>

            {/* Thời gian mở */}
            <div className="grid gap-2">
              <Label htmlFor="thoiGianMo">
                Thời gian mở
              </Label>
              <Input
                id="thoiGianMo"
                type="datetime-local"
                value={formData.thoiGianMo ?? ""}
                onChange={(e) =>
                  setFormData({ ...formData, thoiGianMo: e.target.value || null })
                }
              />
            </div>

            {/* Thời gian đóng */}
            <div className="grid gap-2">
              <Label htmlFor="thoiGianDong">
                Thời gian đóng
              </Label>
              <Input
                id="thoiGianDong"
                type="datetime-local"
                value={formData.thoiGianDong ?? ""}
                onChange={(e) =>
                  setFormData({ ...formData, thoiGianDong: e.target.value || null })
                }
              />
            </div>
          </div>

          <DialogFooter>
            <Button
              type="button"
              variant="outline"
              onClick={() => onOpenChange(false)}
              disabled={loading}
            >
              Hủy
            </Button>
            <Button type="submit" disabled={loading}>
              {loading ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Đang xử lý...
                </>
              ) : mode === "create" ? (
                "Tạo"
              ) : (
                "Lưu"
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
