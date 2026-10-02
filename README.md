# Smart CRM – Mekong Mobile · Luồng L2: Tiếp nhận và phân loại yêu cầu bảo hành

Chuyên đề tốt nghiệp 1 – Trường ĐH Văn Lang. Track SE. Sinh viên: [Họ và tên] – [MSSV].

## 1. Giới thiệu và phạm vi

**Phạm vi (một câu):** Quản lý tiếp nhận và phân loại yêu cầu bảo hành: nhân viên tiếp nhận tra cứu khách hàng theo số điện thoại, ghi nhận thiết bị và mô tả lỗi để lập phiếu bảo hành; hệ thống phân loại nhóm sự cố, đề xuất mức ưu tiên, sinh hạn cam kết và ghi lại trạng thái phiếu đến khi đóng.

**Không làm (WON'T):** phân công kỹ thuật viên (L4), kho linh kiện (L5), khảo sát hài lòng (L8), phân loại bằng học máy (L10), mở lại phiếu đã đóng, gửi SMS/Zalo, gộp hồ sơ trùng (L1).

## 2. Tài liệu (thư mục `docs/`)

| File | Nội dung |
|---|---|
| `srs.md` | Bản SRS rút gọn (nguồn của file PDF) |
| `usecase.drawio` | Use Case Diagram (file gốc) |
| `architecture.drawio` | Sơ đồ kiến trúc (file gốc) |
| `erd.drawio`, `schema.sql` | ERD 6 bảng và SQL DDL skeleton |
| `wireframe.png` | Wireframe 3 màn hình |
| `api-contract.md` | Hợp đồng API (track SE) |
| `ai-disclosure.md` | Bảng khai báo sử dụng công cụ AI |

## 3. Cách chạy

Chưa có mã ở BT1. Sẽ bổ sung ở BT2 (thư mục `src/`, `tests/`). Sao chép `.env.example` thành `.env` khi cần.

## 4. Dữ liệu mẫu

Dùng `tickets_history.csv`, `service_centers.csv` từ LMS. Không commit dữ liệu lớn; chỉ commit vài trăm dòng trong `data/sample/`. Dữ liệu sinh thêm phải ghi seed: seed = 42 (`gen_sample.py`).

## 5. Quy ước Git

Commit theo dạng `type(scope): mô tả`, ví dụ `docs(srs): thêm bảng truy vết`, `docs(erd): thêm bảng employee`, `docs(api): thêm endpoint phê duyệt bảo hành`.

## 6. Khai báo AI và thay đổi

Xem `docs/ai-disclosure.md`. Nhật ký thay đổi so với bản trước: BT1 là bản đầu tiên, chưa có thay đổi.
