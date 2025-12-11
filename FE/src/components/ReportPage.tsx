import { useState } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { TutorReport } from "./TutorReport";
import { StudentReport } from "./StudentReport";

export function ReportPage() {
  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-gray-900 mb-2">Báo cáo</h1>
        <p className="text-gray-600">Xem báo cáo chi tiết về gia sư và học viên</p>
      </div>

      <Tabs defaultValue="tutor" className="w-full">
        <TabsList className="mb-6">
          <TabsTrigger value="tutor">Báo cáo về Gia sư</TabsTrigger>
          <TabsTrigger value="student">Báo cáo về Học viên</TabsTrigger>
        </TabsList>

        <TabsContent value="tutor">
          <TutorReport />
        </TabsContent>

        <TabsContent value="student">
          <StudentReport />
        </TabsContent>
      </Tabs>
    </div>
  );
}
