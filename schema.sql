-- PostgreSQL – Luồng L2. Xem docs/schema.sql
CREATE TABLE employee (
  employee_id BIGSERIAL PRIMARY KEY,
  full_name   VARCHAR(120) NOT NULL,
  role        VARCHAR(30)  NOT NULL CHECK (role IN ('NHAN_VIEN_TIEP_NHAN','KY_THUAT_VIEN','QUAN_LY_TRUNG_TAM')),
  center_id   INT          NOT NULL,   -- danh mục trung tâm nằm ngoài phạm vi ERD
  is_active   BOOLEAN      NOT NULL DEFAULT true
);
CREATE TABLE customer (
  customer_id BIGSERIAL PRIMARY KEY,
  full_name   VARCHAR(120) NOT NULL,
  phone       VARCHAR(20)  NOT NULL UNIQUE CHECK (phone ~ '^0[0-9]{9}$'),   -- QT-01, QT-02
  email       VARCHAR(120),
  address     VARCHAR(255),
  is_active   BOOLEAN      NOT NULL DEFAULT true,                            -- QT-13
  created_at  TIMESTAMP    NOT NULL DEFAULT now()
);
CREATE TABLE device (
  device_id       BIGSERIAL PRIMARY KEY,
  customer_id     BIGINT       NOT NULL REFERENCES customer(customer_id),
  device_name     VARCHAR(120) NOT NULL,
  serial_no       VARCHAR(50)  NOT NULL UNIQUE,                              -- QT-03
  purchase_date   DATE,                                                      -- NULL = chưa biết ngày mua
  warranty_months SMALLINT     NOT NULL DEFAULT 12
);
CREATE TABLE issue_category (
  category_id      SERIAL PRIMARY KEY,
  category_name    VARCHAR(60)  NOT NULL UNIQUE,   -- MAN_HINH / PIN / SAC / PHAN_MEM / NUOC_VAO / KHAC
  keywords         VARCHAR(255),                   -- từ khóa cách nhau bằng dấu phẩy
  default_priority VARCHAR(10)  NOT NULL CHECK (default_priority IN ('CAO','TRUNG_BINH','THAP')),
  is_active        BOOLEAN      NOT NULL DEFAULT true
);
CREATE TABLE ticket (
  ticket_id         BIGSERIAL PRIMARY KEY,
  ticket_code       VARCHAR(20)  NOT NULL UNIQUE,                            -- BH-000231/2026
  customer_id       BIGINT       NOT NULL REFERENCES customer(customer_id),
  device_id         BIGINT       NOT NULL REFERENCES device(device_id),
  center_id         INT          NOT NULL,
  issue_desc        TEXT         NOT NULL CHECK (char_length(issue_desc) BETWEEN 10 AND 2000),
  accessories       VARCHAR(60),                                             -- SAC,TAI_NGHE,HOP,KHAC
  category_id       INT          REFERENCES issue_category(category_id),
  priority          VARCHAR(10)  NOT NULL CHECK (priority IN ('CAO','TRUNG_BINH','THAP')),
  status            VARCHAR(20)  NOT NULL DEFAULT 'MOI' CHECK (status IN
                    ('MOI','DA_PHAN_CONG','DANG_XU_LY','CHO_LINH_KIEN','HOAN_TAT','DA_DONG','DA_HUY')),
  received_by       BIGINT       NOT NULL REFERENCES employee(employee_id),
  received_at       TIMESTAMP    NOT NULL,
  due_date          TIMESTAMP    NOT NULL,                                   -- QT-04
  closed_at         TIMESTAMP,
  is_warranty       BOOLEAN      NOT NULL,
  warranty_verified BOOLEAN      NOT NULL DEFAULT true,                      -- QT-05
  is_overdue        BOOLEAN      NOT NULL DEFAULT false,
  is_active         BOOLEAN      NOT NULL DEFAULT true                       -- QT-13
);
CREATE INDEX idx_ticket_status_due ON ticket(status, due_date);              -- NFR3
CREATE UNIQUE INDEX ux_ticket_device_open ON ticket(device_id)               -- QN-01
  WHERE status NOT IN ('DA_DONG','DA_HUY') AND is_active;
CREATE TABLE ticket_status_log (
  log_id      BIGSERIAL PRIMARY KEY,
  ticket_id   BIGINT      NOT NULL REFERENCES ticket(ticket_id),
  from_status VARCHAR(20),                                                   -- NULL ở lần đầu
  to_status   VARCHAR(20) NOT NULL,
  changed_at  TIMESTAMP   NOT NULL DEFAULT now(),
  changed_by  BIGINT      NOT NULL REFERENCES employee(employee_id),
  note        VARCHAR(255)
);
