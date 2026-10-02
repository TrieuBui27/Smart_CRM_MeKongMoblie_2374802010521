# Bản SRS rút gọn – Luồng L2: Tiếp nhận và phân loại yêu cầu bảo hành

## 1. Giới thiệu và phạm vi

**Bối cảnh.** Mekong Mobile có 6 trung tâm bảo hành, mỗi tháng nhận khoảng 260 phiếu bảo hành ghi trên giấy. Hệ quả: khoảng 15% phiếu quá hạn mà không được cảnh báo (V2) và mô tả lỗi ghi tự do nên không thống kê được nguyên nhân (V8). Nhân viên tiếp nhận cũng mất 5–10 phút gọi cửa hàng để tra ngày mua, và có 30% trường hợp không tra được.

**Luồng nghiệp vụ chọn: L2 – Tiếp nhận và phân loại yêu cầu bảo hành.** Quản lý tiếp nhận và phân loại yêu cầu bảo hành: nhân viên tiếp nhận tra cứu khách hàng theo số điện thoại, ghi nhận thiết bị và mô tả lỗi để lập phiếu bảo hành; hệ thống phân loại nhóm sự cố, đề xuất mức ưu tiên, sinh hạn cam kết và ghi lại trạng thái phiếu đến khi đóng.

**Giả định.** (A1) Người dùng đã đăng nhập; vai trò và trung tâm lấy từ bảng employee. (A2) Hạn cam kết chỉ tính ngày làm việc Thứ Hai đến Thứ Bảy, bỏ qua Chủ nhật (QT-04). (A3) Danh mục trung tâm bảo hành và dữ liệu thiết bị lấy từ dữ liệu mẫu của học phần.

**Điều CHỦ Ý KHÔNG làm (mức WON'T của MoSCoW):** (1) phân công kỹ thuật viên và lịch hẹn (L4); (2) kho linh kiện (L5); (3) khảo sát hài lòng (L8); (4) phân loại bằng học máy (L10) – L2 chỉ dùng luật từ khóa; (5) mở lại phiếu đã đóng; (6) gửi SMS/Zalo cho khách; (7) gộp hồ sơ khách trùng (L1). **COULD:** (a) Quản lý trung tâm phê duyệt hoặc từ chối phiếu "bảo hành chưa xác minh" (ở L2 phiếu chỉ được đánh dấu và hiển thị); (b) cảnh báo thiết bị sửa lặp lại cùng một nhóm sự cố (gợi ý của anh Dũng).

**Bảng thuật ngữ** (mỗi khái niệm chỉ dùng MỘT tên trong SRS, sơ đồ, wireframe và mã nguồn):

| Thuật ngữ | Định nghĩa | Tên kỹ thuật |
|---|---|---|
| Khách hàng | Cá nhân đã mua hoặc sử dụng dịch vụ của Mekong Mobile, nhận diện bằng số điện thoại. | customer |
| Thiết bị | Một máy cụ thể của khách hàng, xác định bằng số serial hoặc IMEI. | device |
| Phiếu bảo hành | Một yêu cầu bảo hành hoặc sửa chữa được ghi nhận, có mã duy nhất và vòng đời trạng thái. | ticket |
| Trạng thái phiếu | Vị trí của phiếu trong vòng đời: Mới → Đã phân công → Đang xử lý → Chờ linh kiện → Hoàn tất → Đã đóng; nhánh Đã hủy. | status |
| Hạn cam kết | Thời điểm chậm nhất phải hoàn tất phiếu, tính từ lúc tiếp nhận theo mức ưu tiên. | due_date |
| Nhóm sự cố | Phân loại nguyên nhân: màn hình, pin, sạc, phần mềm, nước vào, khác. | issue_category |
| Mức ưu tiên | Mức khẩn của phiếu: Cao, Trung bình, Thấp; quyết định hạn cam kết. | priority |
| Phiếu chưa đóng | Phiếu có trạng thái khác Đã đóng và Đã hủy. | status |
| Phiếu quá hạn | Phiếu chưa Hoàn tất, Đã đóng hoặc Đã hủy nhưng đã qua hạn cam kết. | is_overdue |
| Bảo hành chưa xác minh | Phiếu thiếu ngày mua nên chưa biết còn bảo hành; việc phê duyệt thuộc mức COULD. | warranty_verified |
| Nhật ký trạng thái | Bản ghi mỗi lần chuyển trạng thái phiếu, kèm thời điểm và người thực hiện. | ticket_status_log |
| Trung tâm bảo hành | Nơi tiếp nhận và sửa chữa thiết bị. | center_id |
| Nhân viên tiếp nhận | Người lập phiếu tại trung tâm bảo hành. | employee (role NHAN_VIEN_TIEP_NHAN) |
| Quản lý trung tâm | Người theo dõi phiếu và phê duyệt bảo hành chưa xác minh. | employee (role QUAN_LY_TRUNG_TAM) |
| Kỹ thuật viên | Người sửa chữa, cập nhật trạng thái phiếu. Trong L2 chỉ là một vai trò của employee. | employee (role KY_THUAT_VIEN) |

## 2. Các bên liên quan và vai trò

| Vai trò (actor) | Được làm | Không được làm |
|---|---|---|
| Nhân viên tiếp nhận | Tra cứu khách hàng; ghi nhận khách hàng và thiết bị mới; tạo phiếu bảo hành; xem danh sách phiếu của trung tâm mình; chuyển phiếu sang Đã đóng hoặc Đã hủy. | Xem số điện thoại đầy đủ (bị che, QT-15); xem phiếu trung tâm khác (QT-14). |
| Quản lý trung tâm | Xem danh sách và chi tiết phiếu của trung tâm mình; chuyển trạng thái; xem số điện thoại đầy đủ. | Xem phiếu trung tâm khác; xóa phiếu (QT-13). |
| Kỹ thuật viên | Xem phiếu của trung tâm mình; chuyển phiếu sang Đang xử lý, Chờ linh kiện, Hoàn tất. | Tạo phiếu; xem số điện thoại đầy đủ. |
| Bộ lập lịch (actor hệ thống, không phải người) | Định kỳ 15 phút đánh dấu phiếu quá hạn. | Đổi trạng thái phiếu hay sửa dữ liệu khác. |

## 3. Yêu cầu chức năng, User Story và MoSCoW

| Mã | Yêu cầu chức năng (kiểm chứng được) | MoSCoW |
|---|---|---|
| FR1 | Hệ thống chuẩn hóa số điện thoại về 10 chữ số bắt đầu bằng 0 (nhận +84…, 84…, dấu cách, dấu chấm) rồi trả đúng 1 khách hàng kèm danh sách thiết bị; không có thì báo không tìm thấy; số không chuẩn hóa được thì báo lỗi. | MUST |
| FR2 | Hệ thống tạo khách hàng (bắt buộc full_name, phone) và thiết bị của khách (bắt buộc device_name, serial_no); từ chối số điện thoại đã tồn tại (kèm hồ sơ có sẵn) và serial_no đã tồn tại. | SHOULD |
| FR3 | Khi lập phiếu, hệ thống xác định tình trạng bảo hành theo QT-05: còn hạn → is_warranty = true; hết hạn → false (có tính phí); thiếu ngày mua → warranty_verified = false và hiển thị "Bảo hành chưa xác minh". | SHOULD |
| FR4 | Hệ thống tạo phiếu bảo hành khi customer_id, device_id, center_id, issue_desc (10–2000 ký tự) hợp lệ và thiết bị thuộc khách hàng; phiếu có mã duy nhất dạng BH-nnnnnn/năm, trạng thái Mới; từ chối nếu thiết bị đang có phiếu chưa đóng. | MUST |
| FR5 | Hệ thống đề xuất nhóm sự cố bằng cách khớp từ khóa trong issue_desc (bỏ dấu, không phân biệt hoa thường) với issue_category.keywords; mức ưu tiên mặc định lấy từ default_priority của nhóm; không khớp thì chọn nhóm KHAC; nhân viên được sửa cả hai trước khi lưu. | SHOULD |
| FR6 | Hệ thống tự sinh hạn cam kết = thời điểm tiếp nhận + 24 / 72 / 120 giờ theo mức ưu tiên CAO / TRUNG_BINH / THAP, bỏ qua Chủ nhật; người dùng không nhập tay được. | MUST |
| FR7 | Hệ thống trả danh sách phiếu lọc theo trạng thái, trung tâm, quá hạn; sắp theo hạn cam kết tăng dần; phân trang (mặc định 20, tối đa 100) kèm tổng số; trả chi tiết một phiếu; đặt is_overdue cho phiếu quá hạn. | SHOULD |
| FR8 | Hệ thống chỉ cho chuyển trạng thái theo vòng đời (Hình 6.2 case study), không quay lại; mỗi lần chuyển ghi một dòng nhật ký trạng thái gồm trạng thái trước, sau, thời điểm, người thực hiện; chuyển sai thì từ chối và không đổi dữ liệu. | MUST |

**User Story** (chuẩn INVEST; phần "để …" nối về vấn đề V1–V8 của case study; tiêu chí chấp nhận theo Given–When–Then):

| Mã | User Story | MoSCoW | Tiêu chí chấp nhận |
|---|---|---|---|
| US1 | Là nhân viên tiếp nhận, tôi muốn tra cứu khách hàng theo số điện thoại và xem các thiết bị khách đã có, để không phải hỏi lại tên, nơi mua, ngày mua (V2). | MUST | (a) Given số 0901234567 đã có hồ sơ, When nhập "0901 234 567", Then hiện đúng hồ sơ và thiết bị trong ≤ 1 giây. (b) Ngoại lệ: Given nhập "12345", Then báo số điện thoại không hợp lệ. (c) Ngoại lệ: Given số chưa có hồ sơ, Then báo không tìm thấy và mời tạo mới. |
| US2 | Là nhân viên tiếp nhận, tôi muốn tạo hồ sơ khách hàng và thiết bị khi khách chưa có, để lập phiếu ngay tại quầy mà không tạo hồ sơ trùng (V1). | SHOULD | Given số chưa tồn tại, When nhập họ tên, số và serial hợp lệ, Then tạo được khách và thiết bị. Given số đã tồn tại, Then từ chối và hiện hồ sơ có sẵn. |
| US3 | Là nhân viên tiếp nhận, tôi muốn thấy ngay tình trạng bảo hành của thiết bị khi lập phiếu, để không ghi "còn bảo hành" theo cảm tính rồi gây tranh chấp (case study 6.1, bước 4). | SHOULD | (a) Given mua cách 5 tháng, bảo hành 12 tháng, Then hiện Còn bảo hành. (b) Given mua cách 13 tháng, Then hiện Hết bảo hành, có tính phí. (c) Given thiếu ngày mua, Then hiện Bảo hành chưa xác minh. |
| US4 | Là nhân viên tiếp nhận, tôi muốn lập phiếu bảo hành cho một thiết bị kèm mô tả lỗi và phụ kiện, để yêu cầu được ghi ngay trên hệ thống, không phải chép lại cuối ngày (bước 13, mất 40 phút mỗi người mỗi ngày). | MUST | (a) Given dữ liệu hợp lệ, When lưu, Then có phiếu trạng thái Mới với mã BH-nnnnnn/năm. (b) Ngoại lệ: Given mô tả lỗi ngắn hơn 10 ký tự, Then báo lỗi và không lưu. (c) Ngoại lệ: Given thiết bị đang có phiếu chưa đóng, Then từ chối và hiện mã phiếu cũ. |
| US5 | Là nhân viên tiếp nhận, tôi muốn hệ thống đề xuất nhóm sự cố và mức ưu tiên từ mô tả lỗi, để phân loại nhất quán và thống kê được nguyên nhân bảo hành (V8). | SHOULD | Given mô tả chứa "sạc không vào", Then đề xuất nhóm SAC và tôi đổi được sang nhóm khác trước khi lưu. |
| US6 | Là nhân viên tiếp nhận, tôi muốn hệ thống tự sinh hạn cam kết theo mức ưu tiên, để hẹn trả máy đúng quy tắc thay vì ước lượng cảm tính (V2, bước 6). | MUST | (a) Given mức TRUNG_BINH, tiếp nhận Thứ Ba 08/09/2026 14:30, Then hạn là Thứ Sáu 11/09/2026 14:30. (b) Ngoại lệ: Given mức CAO, tiếp nhận Thứ Bảy 14:30, Then hạn là Thứ Hai 14:30 (bỏ Chủ nhật). (c) Ngoại lệ: Given người dùng gửi kèm hạn cam kết, Then hệ thống bỏ qua và dùng hạn tự sinh. |
| US7 | Là quản lý trung tâm, tôi muốn xem danh sách phiếu sắp theo hạn cam kết và thấy phiếu quá hạn, để biết phiếu nào cần xử lý trước (V2). | SHOULD | Given 10.000 phiếu, When mở danh sách, Then trang đầu 20 phiếu hiện ≤ 2 giây, hạn sớm nhất ở trên, phiếu quá hạn có nhãn Quá hạn. |
| US8 | Là kỹ thuật viên, tôi muốn cập nhật trạng thái phiếu theo vòng đời, để cả trung tâm biết phiếu đang ở bước nào, ai làm và lúc nào (V2). | MUST | (a) Given phiếu Đã phân công, When chuyển sang Đang xử lý, Then trạng thái đổi và có thêm một dòng nhật ký. (b) Ngoại lệ: Given phiếu Hoàn tất, When chuyển về Đang xử lý, Then bị từ chối và dữ liệu không đổi. |

## 4. Yêu cầu phi chức năng (có ngưỡng đo được)

| Mã | Yêu cầu | Ngưỡng | Cách đo |
|---|---|---|---|
| NFR1 | Thời gian tra cứu khách theo số điện thoại (FR1) | ≤ 1 giây ở phân vị 95 với 65.000 khách hàng | Kiểm thử tải 100 lần gọi trên dữ liệu mẫu |
| NFR2 | Thời gian tạo phiếu (FR3–FR6) | ≤ 2 giây ở phân vị 95 với 20 người dùng đồng thời | Kiểm thử tải 20 luồng song song |
| NFR3 | Thời gian hiển thị danh sách phiếu (FR7) | ≤ 2 giây với 10.000 phiếu, 20 dòng mỗi trang | Đo phía máy chủ trên 10.000 phiếu sinh mô phỏng |
| NFR4 | Toàn vẹn nhật ký trạng thái (FR8) | 100% lần chuyển trạng thái có đúng 1 dòng nhật ký; 0 phiếu lệch | Truy vấn đối soát ticket ↔ ticket_status_log trả về 0 dòng |
| NFR5 | Độ trễ đánh dấu phiếu quá hạn (FR7) | ≤ 15 phút sau thời điểm hạn cam kết | So sánh due_date với thời điểm is_overdue đổi thành true |
| NFR6 | Che số điện thoại (QT-15) | 100% phản hồi cho vai trò khác Quản lý trung tâm và Ban giám đốc có dạng 090****567 | Kiểm thử tự động trên mọi endpoint trả số điện thoại |

## 5. Ràng buộc và quy tắc nghiệp vụ

| Mã | Quy tắc | Nguồn | Áp dụng |
|---|---|---|---|
| QT-01 | Số điện thoại khách hàng là duy nhất; nhập số đã có thì hiện hồ sơ có sẵn thay vì tạo mới. | Bảng 9.1 | FR1, FR2 |
| QT-02 | Số điện thoại chuẩn hóa về 10 chữ số bắt đầu bằng 0 trước khi lưu. | Bảng 9.1 | FR1, FR2 |
| QT-03 | Thiết bị xác định duy nhất bằng serial hoặc IMEI; một thiết bị chỉ thuộc một khách hàng tại một thời điểm. | Bảng 9.1 | FR2, FR4 |
| QT-04 | Hạn cam kết: CAO = 24 giờ, TRUNG_BINH = 72 giờ, THAP = 120 giờ, chỉ tính Thứ Hai đến Thứ Bảy. | Bảng 9.1 | FR6 |
| QT-05 | Còn bảo hành nếu (ngày tiếp nhận − ngày mua) ≤ số tháng bảo hành; thiếu ngày mua thì đánh dấu chưa xác minh (phê duyệt là COULD). | Bảng 9.1 | FR3 |
| QT-06 | Chỉ chuyển trạng thái theo vòng đời, không quay lại; mọi lần chuyển đều ghi nhật ký. | Bảng 9.1 | FR8 |
| QT-13 | Không xóa vật lý phiếu và hồ sơ khách hàng; chỉ đánh dấu ngừng sử dụng (is_active). | Bảng 9.1 | FR2, FR4 |
| QT-14, QT-15 | Nhân viên chỉ xem dữ liệu trung tâm mình; số điện thoại bị che trừ Quản lý và Ban giám đốc. | Bảng 9.1 | FR7 |
| QN-01 | Một thiết bị tại một thời điểm chỉ có tối đa 1 phiếu chưa đóng, để tránh lập phiếu trùng cho cùng một lỗi. | Phân tích của em (case study 6.1) | FR4 |

## 6. Bảng truy vết yêu cầu

| FR | User Story | Use Case | MoSCoW |
|---|---|---|---|
| FR1 | US1 | UC1 Tra cứu khách hàng theo số điện thoại | MUST |
| FR2 | US2 | UC2 Ghi nhận khách hàng và thiết bị mới | SHOULD |
| FR3 | US3 | UC8 Kiểm tra tình trạng bảo hành | SHOULD |
| FR4 | US4 | UC3 Tạo phiếu bảo hành | MUST |
| FR5 | US5 | UC4 Phân loại nhóm sự cố và mức ưu tiên | SHOULD |
| FR6 | US6 | UC5 Sinh hạn cam kết | MUST |
| FR7 | US7 | UC6 Xem danh sách phiếu bảo hành; UC9 Đánh dấu phiếu quá hạn | SHOULD |
| FR8 | US8 | UC7 Chuyển trạng thái phiếu | MUST |
