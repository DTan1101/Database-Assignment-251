# AssignmentCSDL – Hướng dẫn chạy bằng Docker

Project này dùng:

- **Backend:** Spring Boot (Java 21, Maven)
- **Database:** SQL Server 2022 (chạy trong Docker)
- **Kết nối DB:** JDBC + script SQL trong thư mục `SQLServer`
- **Docker:** mọi thứ đóng gói, **không cần cài Java, Maven, SQL Server, IDE** trên máy chỉ để chạy.

---

## 1. Yêu cầu trước khi chạy

Máy người dùng chỉ cần cài:

1. **Docker Desktop** ([Tải tại đây](https://www.docker.com/products/docker-desktop))
2. (Không bắt buộc) Một terminal:
   - Windows: PowerShell / CMD
   - macOS / Linux: Terminal

**Không cần:**

- ❌ Không cần cài JDK
- ❌ Không cần cài Maven
- ❌ Không cần cài SQL Server
- ❌ Không cần IDE (IntelliJ, VS Code, v.v.)

---

## 2. Cấu trúc thư mục chính

Repo này có cấu trúc như sau:

```text
AssignmentCSDL/
├─ src/
├─ pom.xml
├─ Dockerfile
├─ docker-compose.yml
├─ init-db.sh
├─ SQLServer/
│  ├─ V0_DB.sql          # Script tạo DB TutorSS + bảng + dữ liệu
│  ├─ V1_DATA.sql
│  └─ ... (các file .sql khác nếu có)
└─ README.md             # File bạn đang đọc
```

## 3. Chạy lần đầu

### 3.1. Clone hoặc copy project

```bash
git clone <link-repo>
cd AssignmentCSDL
```

### 3.2. Chạy Docker (build + start)

Trong thư mục `AssignmentCSDL`, chạy:

```bash
docker compose up -d --build
```

- `--build`: build lại image của app Java
- `-d`: chạy nền (detached), không spam log

**Lệnh này sẽ:**

1. Build image Spring Boot từ `Dockerfile`
2. Tạo container SQL Server (`AssignmentCSDL-db`)
3. Tạo container app Java (`AssignmentCSDL-app`)
4. Trong container DB:
   - Start SQL Server
   - Chạy script `init-db.sh`
   - Script này sẽ chạy tất cả file `.sql` trong `SQLServer/`

### 3.3. Kiểm tra app đã chạy chưa

Xem log nhanh:

```bash
docker compose logs app
docker compose logs db
```

Nếu mọi thứ OK, log của app sẽ có dạng:

```
Started AssignmentCsdlApplication ...
Tomcat started on port 8082 (http) with context path '/'
```

=> App đang chạy ở: 👉 **http://localhost:8082**

(Port có thể khác nếu bạn sửa trong `application.yml` hoặc `docker-compose.yml`.)

---

## 4. Chạy lại trong những lần sau (không sửa gì)

Nếu **không sửa code Java**, **không sửa file .sql**, chỉ muốn start lại:

```bash
docker compose up -d
```

- Nếu container đã tồn tại → Docker chỉ start lại, không build lại.
- Database trong volume vẫn giữ nguyên.

**Dừng lại khi không dùng nữa:**

```bash
docker compose down
```

⚠️ **Lưu ý:** KHÔNG dùng `-v` nếu bạn không muốn mất toàn bộ DB trong container.

---

## 5. Khi THAY ĐỔI FILE .sql trong thư mục SQLServer

Ví dụ:

- Sửa `V0_DB.sql`
- Thêm bảng mới
- Thêm dữ liệu mẫu
- Thêm file `.sql` mới

### 5.1. Cách script đang hoạt động

Trong `V0_DB.sql` có đoạn:

```sql
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TutorSS')
BEGIN
    ALTER DATABASE TutorSS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TutorSS;
END
GO

CREATE DATABASE TutorSS;
GO

USE TutorSS;
GO

-- CREATE TABLE ..., INSERT ...
```

→ Nên:

- Mỗi lần script này chạy lại:
  1. Drop database `TutorSS` nếu có
  2. Tạo lại `TutorSS` từ đầu theo script
- Các database khác trong instance không bị đụng tới.

### 5.2. Cập nhật DB sau khi sửa SQL

Sau khi sửa xong file `.sql` trong thư mục `SQLServer/`, chạy:

```bash
docker compose restart db
```

**Lệnh này:**

1. Restart container `db`
2. Khi `db` khởi động lại:
   - `init-db.sh` chạy lại
   - Lại execute toàn bộ `.sql` trong `SQLServer/`
   - DB `TutorSS` được drop + tạo lại theo version mới của script

**App Java (`app`) không cần build lại** nếu bạn chỉ sửa SQL.

---

## 6. Khi THAY ĐỔI CODE JAVA (controller, service, repository, ...)

Giả sử bạn sửa code trong `src/` mà không dùng IDE (chỉnh bằng editor bất kỳ).

### 6.1. Build lại & chạy lại app (không đụng DB)

```bash
docker compose up -d --build app
```

- `--build app`: build lại image chỉ của service `app`
- DB (`db`) vẫn giữ nguyên, không xóa data.

---

## 7. Khi SỬA CẢ CODE JAVA VÀ FILE .sql

Trường hợp bạn vừa sửa code Java trong `src/`, vừa sửa script SQL trong `SQLServer/`:

### 7.1. Cách 1: Build lại cả 2 (giữ nguyên data hiện tại trong DB)

```bash
docker compose up -d --build
```

**Lệnh này sẽ:**

1. Build lại image của app Java với code mới
2. Restart container DB
3. `init-db.sh` chạy lại → script SQL mới được execute
4. DB `TutorSS` được drop + tạo lại theo script mới
5. App Java khởi động với code mới

⚠️ **Lưu ý:** Database `TutorSS` sẽ được tạo lại từ script, nhưng các database khác (nếu có) trong volume vẫn giữ nguyên.

### 7.2. Cách 2: Reset toàn bộ và build lại (xóa sạch mọi thứ)

Nếu muốn **reset hoàn toàn** (xóa cả volume, tạo lại từ đầu):

```bash
docker compose down -v
docker compose up -d --build
```

**Khác biệt:**
- Cách 1: Chỉ tạo lại DB `TutorSS`, các DB khác vẫn tồn tại trong volume
- Cách 2: Xóa sạch toàn bộ volume → mọi DB trong SQL Server container đều bị xóa

---

## 8. Reset SẠCH TOÀN BỘ database (trường hợp đặc biệt)

⚠️ **Cảnh báo:** thao tác này sẽ **XÓA TOÀN BỘ database** trong instance SQL Server của container (không chỉ `TutorSS`). Dùng khi:

- Bạn chấp nhận mất toàn bộ dữ liệu trong DB container này,
- Muốn tạo lại mọi thứ 100% theo script SQL trong thư mục `SQLServer/`.

```bash
docker compose down -v
docker compose up -d --build
```

**Giải thích:**

- `down -v`:
  - Xóa container
  - Xóa luôn volume `sqlserver_data` (chứa `/var/opt/mssql` = toàn bộ file `.mdf`/`.ldf`)
- `up -d --build`:
  - Start lại SQL Server
  - `init-db.sh` chạy lại
  - Các script trong `SQLServer/` chạy lại → tạo lại DB (ví dụ: `TutorSS`) từ đầu

---

## 8. Xem log khi cần debug

**Xem log app:**

```bash
docker compose logs -f app
```

**Xem log DB:**

```bash
docker compose logs -f db
```

Thoát khỏi chế độ `-f` (follow) → nhấn `Ctrl + C`.

---

## 9. Kết nối SQL Server từ ngoài (SSMS / DBeaver / Azure Data Studio)

Nếu muốn tự xem DB / chạy query bằng tool ngoài:

- **Host:** `localhost`
- **Port:** `1433` (theo `docker-compose.yml`, map `1433:1433`)
- **User:** `sa`
- **Password:** theo cấu hình trong `docker-compose.yml`, ví dụ:
  ```yaml
  environment:
    SA_PASSWORD: "YourStrong!Passw0rd"
  ```
- **Database** sau khi script chạy: `TutorSS`

---

## 10. Tóm tắt nhanh cho người mới

1. **Cài Docker Desktop.**
2. **Mở terminal, `cd` vào thư mục project `AssignmentCSDL`.**
3. **Lần đầu:**
   ```bash
   docker compose up -d --build
   ```
4. **Mở browser → vào http://localhost:8082** (hoặc port bạn config).

**Sau này:**

| Tình huống | Lệnh |
|------------|------|
| Chỉ muốn chạy lại | `docker compose up -d` |
| Sửa SQL (`SQLServer/*.sql`) | `docker compose restart db` |
| Sửa code Java | `docker compose up -d --build app` |
| Sửa cả SQL và code Java | `docker compose up -d --build` |
| Muốn reset sạch toàn bộ DB (chấp nhận mất hết data) | `docker compose down -v` <br> `docker compose up -d --build` |
| Xem log app | `docker compose logs -f app` |
| Xem log DB | `docker compose logs -f db` |
| Dừng containers | `docker compose down` |

---

## 11. Troubleshooting

### Container không start được?

```bash
docker compose ps
docker compose logs
```

### Port 8082 hoặc 1433 bị chiếm?

Sửa trong `docker-compose.yml`:

```yaml
services:
  app:
    ports:
      - "8083:8082"  # Đổi port ngoài thành 8083
  db:
    ports:
      - "1434:1433"  # Đổi port ngoài thành 1434
```

### Database không có dữ liệu sau khi restart?

- Kiểm tra xem đã dùng `docker compose down -v` chưa → nếu có thì volume bị xóa.
- Nếu muốn giữ data, dùng `docker compose down` (không có `-v`).

---

**Chỉ cần làm đúng như trên, người nhận project không cần cài Java, không cần IDE, không cần SQL Server, chỉ cần Docker là chạy được. ✅**


