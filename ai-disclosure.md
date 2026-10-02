# Bảng khai báo sử dụng công cụ AI

<!-- Chỉ giữ những gì em THỰC SỰ đã làm ở cột "Đã kiểm chứng thế nào". Khai báo trung thực không bị trừ điểm. -->

| Công cụ | Dùng vào việc gì | Áp dụng ở phần nào | Đã kiểm chứng thế nào |
|---|---|---|---|
| Claude (Anthropic) | Đọc đề bài và case study, đề xuất khung SRS, danh sách FR, NFR, User Story, bảng truy vết | Mục 1 – SRS | Đối chiếu từng FR và quy tắc với case study (Mục 2, 4, 6, 9); tự xét lại ngưỡng NFR; kiểm mã FR/US/UC bằng Ctrl+F |
| Claude (Anthropic) | Soạn Use Case Diagram và đặc tả UC3, UC7 | Mục 2 – Use Case | Đối chiếu với 7 lỗi thường gặp ở buổi 4; mở lại file .drawio để chỉnh; đối chiếu bước 4 và bước 9 của quy trình 6.1 |
| Claude (Anthropic) | Đề xuất kiến trúc phân lớp và 4 câu lập luận theo khuôn NFR – quyết định – đánh đổi | Mục 3 – Kiến trúc | Kiểm từng câu có mã NFR và ngưỡng; tự nêu lại đánh đổi bằng lời của mình |
| Claude (Anthropic) | Thiết kế ERD, SQL DDL skeleton, hợp đồng API | Mục 4 – Mô hình dữ liệu; docs/schema.sql; docs/api-contract.md | Đối chiếu với từ điển dữ liệu case study; chạy thử DDL trên PostgreSQL cục bộ; kiểm mỗi endpoint nối về một User Story |
| Claude (Anthropic) | Vẽ wireframe 3 màn hình | Mục 5 – Wireframe | Kiểm mọi trường hiển thị có trong ERD và nhãn khớp bảng thuật ngữ |
| — tự làm hoàn toàn — | Chọn luồng L2, đọc case study, quyết định phạm vi và WON'T, rà soát cuối theo 11 mục kiểm chứng | Toàn bộ | Không áp dụng |

**Tôi xác nhận đã đọc, hiểu và chịu trách nhiệm về toàn bộ nội dung nộp.**

Họ tên: [Họ và tên] · MSSV: [MSSV] · Ngày: [dd/mm/2026]
