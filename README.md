# 🎓 Student Management System - Java MVC Project

> Một ứng dụng quản lý sinh viên toàn diện được xây dựng theo mô hình **MVC (Model-View-Controller)** chuẩn, sử dụng công nghệ Java Servlet/JSP và cơ sở dữ liệu MySQL.

<img width="100%" alt="Student Management System Landing Page" src="https://github.com/user-attachments/assets/40425479-dffe-4f05-aab4-744036bf0362" />

## 📖 Giới thiệu

Dự án này là một hệ thống quản lý thông tin sinh viên chuyên sâu, tập trung vào tính chính xác của dữ liệu và trải nghiệm người dùng. Hệ thống tích hợp các tính năng thực tế như **Phân trang thông minh**, **Tìm kiếm nâng cao**, **Mã hóa bảo mật MD5** và **Xuất dữ liệu ra file CSV**.

## 🛠 Tech Stack

* **Backend:** Java Servlet, JSP, JDBC, JSTL.
* **Database:** MySQL (Sử dụng PreparedStatement chống SQL Injection).
* **Frontend:** HTML5, CSS3 (Custom Gradient), JavaScript, **Bootstrap 5** (Responsive).
* **Security:** MD5 Hashing, AuthFilter, Session Management.
* **Kiến trúc:** Mô hình MVC (Model-View-Controller).

## 🚀 Tính năng nổi bật

### 🔐 1. Bảo mật & Xác thực (Security)
* **Authentication:** Đăng nhập thông qua tài khoản lưu trong Database với mật khẩu băm **MD5**.
* **AuthFilter:** Bảo vệ toàn bộ hệ thống, tự động điều hướng người dùng chưa đăng nhập về trang login.
* **Session Fixation Protection:** Hủy Session cũ khi đăng nhập mới để ngăn chặn tấn công chiếm quyền.

### 👨‍🎓 2. Quản lý Sinh viên (CRUD & Search)
* **Tìm kiếm nâng cao:** Tìm kiếm linh hoạt theo 4 tiêu chí: Tên, Email, Số điện thoại hoặc Lớp học.
* **Phân trang (Smart Pagination):** Tự động chia 8 sinh viên/trang, hỗ trợ điều hướng thông minh.
* **Avatar tự động:** Tự động tạo Avatar dựa trên chữ cái đầu của tên sinh viên.
* **Validation:** Kiểm tra dữ liệu 2 lớp (Client-side & Server-side). Kiểm tra định dạng Email, Số điện thoại VN (10 số), và chặn ngày sinh ở tương lai.

### 📊 3. Dashboard & Thống kê
* Thẻ thống kê nhanh: Tổng số sinh viên, số lượng sinh viên Nam/Nữ.
* Theo dõi trạng thái kết nối Database và thông tin hệ thống thời gian thực.

### 📤 4. Export Data
* Xuất toàn bộ danh sách sinh viên ra file **CSV** chuẩn UTF-8 (hỗ trợ hiển thị đúng tiếng Việt trên Excel).

## 🗄️ Cấu trúc Database

Hệ thống sử dụng cơ sở dữ liệu MySQL gồm 2 bảng chính:
1. **users:** Quản lý tài khoản admin (id, username, password, full_name, role).
2. **students:** Quản lý thông tin sinh viên (id, name, email, dob, gender, class_name, phone, address).

## 📁 Cấu trúc thư mục MVC

* **src/java/controller/**: Xử lý Business Logic (5 Servlet: Login, Logout, Student, Dashboard, Export).
* **src/java/dao/**: Thao tác trực tiếp với Database (StudentDAO, UserDAO).
* **src/java/filter/**: Bộ lọc bảo vệ route (AuthFilter).
* **src/java/model/**: Đối tượng dữ liệu (Student, User).
* **src/java/util/**: Tiện ích (DBConnection, PasswordUtil).
* **web/views/**: Chứa các file giao diện JSP.
* **web/assets/**: Tài nguyên tĩnh (CSS, JS, Images).

## ⚙️ Hướng dẫn cài đặt (Installation)

1. **Clone dự án:** `git clone https://github.com/username/student-management.git`

2. **Cấu hình Database:**
   * Bước 1: Tạo database tên `student_db` trong MySQL.
   * Bước 2: Import file SQL đi kèm dự án để tạo bảng và dữ liệu mẫu.
   * Bước 3: Cập nhật thông số kết nối (URL, User, Pass) tại file `src/java/util/DBConnection.java`.

3. **Mở dự án & Chạy:**
   * Bước 1: Sử dụng NetBeans hoặc IntelliJ chọn **Open Project**.
   * Bước 2: Thực hiện **Clean and Build** project.
   * Bước 3: Nhấn **F6** (hoặc nút Run) để khởi chạy trên Tomcat server.

4. **Tài khoản đăng nhập mặc định:**
   * **Username:** `admin`
   * **Password:** `admin123`

---
*Created by Hiệu.*
