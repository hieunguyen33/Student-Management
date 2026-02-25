<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            color: white;
            font-family: 'Segoe UI', sans-serif;
            overflow-x: hidden;
        }

        /* ── Navbar ── */
        .navbar-custom {
            background: rgba(255,255,255,0.06);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding: 1rem 2rem;
        }
        .navbar-brand-text {
            font-size: 1.3rem;
            font-weight: 700;
            color: white !important;
        }
        .btn-login-nav {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 50px;
            padding: .45rem 1.4rem;
            font-weight: 600;
            color: white;
            text-decoration: none;
            transition: all .3s;
            box-shadow: 0 4px 15px rgba(102,126,234,.4);
        }
        .btn-login-nav:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102,126,234,.6);
            color: white;
        }

        /* ── Hero ── */
        .hero {
            min-height: calc(100vh - 68px);
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 4rem 1rem;
            position: relative;
        }
        .hero::before {
            content: '';
            position: absolute;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(102,126,234,.3) 0%, transparent 70%);
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
        }

        .hero-icon {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea, #f093fb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.5rem;
            animation: float 3s ease-in-out infinite;
        }
        @keyframes float {
            0%,100% { transform: translateY(0); }
            50%      { transform: translateY(-12px); }
        }

        .hero h1 {
            font-size: clamp(2.2rem, 5vw, 3.5rem);
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1rem;
        }
        .hero h1 span {
            background: linear-gradient(135deg, #667eea, #f093fb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .hero p {
            font-size: 1.15rem;
            color: rgba(255,255,255,.7);
            max-width: 580px;
            margin: 0 auto 2.5rem;
            line-height: 1.7;
        }

        .btn-hero {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 50px;
            padding: .85rem 2.5rem;
            font-size: 1.05rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .6rem;
            box-shadow: 0 8px 30px rgba(102,126,234,.5);
            transition: all .3s;
        }
        .btn-hero:hover {
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 12px 40px rgba(102,126,234,.7);
            color: white;
        }

        .btn-outline-hero {
            background: transparent;
            border: 2px solid rgba(255,255,255,.35);
            border-radius: 50px;
            padding: .8rem 2.2rem;
            font-size: 1.05rem;
            font-weight: 600;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .6rem;
            transition: all .3s;
        }
        .btn-outline-hero:hover {
            background: rgba(255,255,255,.1);
            border-color: rgba(255,255,255,.7);
            color: white;
            transform: translateY(-2px);
        }

        /* ── Feature Cards ── */
        .features {
            padding: 5rem 2rem;
            background: rgba(0,0,0,.2);
        }
        .feature-card {
            background: rgba(255,255,255,.06);
            border: 1px solid rgba(255,255,255,.1);
            border-radius: 20px;
            padding: 2rem 1.5rem;
            text-align: center;
            transition: all .3s;
            height: 100%;
        }
        .feature-card:hover {
            background: rgba(255,255,255,.1);
            transform: translateY(-6px);
            border-color: rgba(102,126,234,.5);
            box-shadow: 0 10px 40px rgba(102,126,234,.2);
        }
        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: block;
        }
        .feature-card h5 {
            font-weight: 700;
            margin-bottom: .5rem;
        }
        .feature-card p {
            color: rgba(255,255,255,.6);
            font-size: .9rem;
            margin: 0;
        }

        /* ── Stats Bar ── */
        .stats-bar {
            background: rgba(102,126,234,.15);
            border-top: 1px solid rgba(102,126,234,.3);
            border-bottom: 1px solid rgba(102,126,234,.3);
            padding: 2rem;
            text-align: center;
        }
        .stat-num {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea, #f093fb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .stat-label {
            color: rgba(255,255,255,.65);
            font-size: .85rem;
            margin-top: .2rem;
        }

        /* ── Footer ── */
        .footer {
            text-align: center;
            padding: 2rem;
            color: rgba(255,255,255,.4);
            font-size: .85rem;
            border-top: 1px solid rgba(255,255,255,.08);
        }

        /* ── Badge tech ── */
        .tech-badge {
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            background: rgba(255,255,255,.08);
            border: 1px solid rgba(255,255,255,.15);
            border-radius: 50px;
            padding: .35rem .9rem;
            font-size: .8rem;
            color: rgba(255,255,255,.8);
            margin: .25rem;
        }
    </style>
</head>
<body>

<!-- ══════════════ NAVBAR ══════════════ -->
<nav class="navbar-custom d-flex align-items-center justify-content-between">
    <div class="d-flex align-items-center gap-2">
        <i class="bi bi-mortarboard-fill fs-4" style="color:#667eea"></i>
        <span class="navbar-brand-text">StudentMgmt</span>
    </div>
    <div class="d-flex align-items-center gap-3">
        <span class="d-none d-md-inline" style="color:rgba(255,255,255,.55);font-size:.9rem">
            Java Web · MVC · JDBC · MySQL
        </span>
        <a href="<%= request.getContextPath() %>/login" class="btn-login-nav">
            <i class="bi bi-box-arrow-in-right me-1"></i>Sign In
        </a>
    </div>
</nav>

<!-- ══════════════ HERO ══════════════ -->
<section class="hero">
    <div>
        <div class="hero-icon">
            <i class="bi bi-mortarboard-fill"></i>
        </div>
        <h1>Student <span>Management</span><br>System</h1>
        <p>
            Hệ thống quản lý sinh viên toàn diện. Dễ dàng thêm, sửa, xoá và tìm kiếm
            thông tin sinh viên với giao diện hiện đại, bảo mật tốt.
        </p>

        <!-- Tech Badges -->
        <div class="mb-4">
            <span class="tech-badge"><i class="bi bi-cup-hot-fill text-warning"></i>Java 8+</span>
            <span class="tech-badge"><i class="bi bi-filetype-jsp text-info"></i>JSP / Servlet</span>
            <span class="tech-badge"><i class="bi bi-database-fill text-success"></i>MySQL JDBC</span>
            <span class="tech-badge"><i class="bi bi-diagram-3-fill" style="color:#f093fb"></i>MVC</span>
            <span class="tech-badge"><i class="bi bi-bootstrap-fill" style="color:#7952b3"></i>Bootstrap 5</span>
        </div>

        <!-- CTA Buttons -->
        <div class="d-flex gap-3 justify-content-center flex-wrap">
            <a href="<%= request.getContextPath() %>/login" class="btn-hero">
                <i class="bi bi-box-arrow-in-right"></i>
                Đăng Nhập Hệ Thống
            </a>
            <a href="#features" class="btn-outline-hero">
                <i class="bi bi-info-circle"></i>
                Tính Năng
            </a>
        </div>
    </div>
</section>

<!-- ══════════════ STATS BAR ══════════════ -->
<div class="stats-bar">
    <div class="row g-4 justify-content-center">
        <div class="col-6 col-md-3">
            <div class="stat-num">CRUD</div>
            <div class="stat-label">Quản lý đầy đủ</div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-num">100%</div>
            <div class="stat-label">Bảo mật Session</div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-num">MVC</div>
            <div class="stat-label">Kiến trúc chuẩn</div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-num">SQL ✓</div>
            <div class="stat-label">PreparedStatement</div>
        </div>
    </div>
</div>

<!-- ══════════════ FEATURES ══════════════ -->
<section class="features" id="features">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Tính Năng Chính</h2>
            <p style="color:rgba(255,255,255,.6)">Đầy đủ chức năng quản lý sinh viên</p>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <span class="feature-icon">👤</span>
                    <h5>Quản lý Sinh viên</h5>
                    <p>Thêm, sửa, xoá, xem danh sách sinh viên với đầy đủ thông tin cá nhân.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <span class="feature-icon">🔍</span>
                    <h5>Tìm kiếm nhanh</h5>
                    <p>Tìm kiếm sinh viên theo tên realtime, kết quả chính xác và tức thì.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <span class="feature-icon">🔐</span>
                    <h5>Xác thực & Bảo mật</h5>
                    <p>Login/Logout với HttpSession, Filter bảo vệ toàn bộ trang nội bộ.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <span class="feature-icon">🗄️</span>
                    <h5>MySQL + JDBC</h5>
                    <p>Kết nối database MySQL qua JDBC, dùng PreparedStatement chống SQL Injection.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <span class="feature-icon">🏗️</span>
                    <h5>Kiến trúc MVC</h5>
                    <p>Model – View – Controller rõ ràng, dễ bảo trì và mở rộng.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <span class="feature-icon">🎨</span>
                    <h5>Giao diện Bootstrap 5</h5>
                    <p>UI responsive, hiện đại với sidebar, dashboard và form đẹp mắt.</p>
                </div>
            </div>
        </div>

        <div class="text-center mt-5">
            <a href="<%= request.getContextPath() %>/login" class="btn-hero">
                <i class="bi bi-rocket-takeoff-fill"></i>
                Bắt đầu sử dụng ngay
            </a>
        </div>
    </div>
</section>

<!-- ══════════════ FOOTER ══════════════ -->
<div class="footer">
    <i class="bi bi-mortarboard-fill me-2" style="color:#667eea"></i>
    Student Management System &copy; 2024 &nbsp;·&nbsp;
    Built with Java · JSP · Servlet · JDBC · MySQL · Bootstrap 5
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(a => {
        a.addEventListener('click', e => {
            e.preventDefault();
            document.querySelector(a.getAttribute('href'))
                    ?.scrollIntoView({ behavior: 'smooth' });
        });
    });
</script>
</body>
</html>