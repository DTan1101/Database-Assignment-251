import { useState } from "react";
import { Sidebar } from "./Sidebar";
import { QuizList } from "./QuizList";
import { ReportPage } from "./ReportPage";
import { ScorePage } from "./ScorePage";

export function QuizDashboard() {
  const [currentPage, setCurrentPage] = useState("home");

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar currentPage={currentPage} onPageChange={setCurrentPage} />
      <div className="flex-1 flex flex-col">
        <main className="flex-1">
          {currentPage === "home" && <QuizList />}
          {currentPage === "reports" && <ReportPage />}
          {currentPage === "scores" && <ScorePage />}
        </main>
      </div>
    </div>
  );
}