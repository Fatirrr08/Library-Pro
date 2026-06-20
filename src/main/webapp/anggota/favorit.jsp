<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Favorit" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buku Favorit Saya - LibraryPro</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/uploads/logo/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    
    <style>
        .profile-dropdown-container {
            position: relative;
            display: inline-block;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            user-select: none;
            padding: 6px 12px;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        .user-profile:hover {
            background-color: #f1f5f9;
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-profile span {
            font-weight: 500;
            color: #334155;
        }

        /* Menu Dropdown Profil di Topbar */
        .dropdown-menu {
            position: absolute;
            right: 0;
            top: 55px;
            background-color: #ffffff;
            min-width: 180px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            padding: 8px 0;
            list-style: none;
            z-index: 1000;
            border: 1px solid #e2e8f0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s;
        }

        .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-menu li a {
            color: #334155;
            padding: 10px 15px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            transition: background-color 0.2s, color 0.2s;
        }

        .dropdown-menu li a i {
            font-size: 16px;
            width: 20px;
            text-align: center;
        }

        .dropdown-menu li a:hover {
            background-color: #f8fafc;
            color: #2563eb;
        }

        .dropdown-menu li a.logout-link:hover {
            background-color: #fef2f2;
            color: #dc2626;
        }

        .dropdown-menu .divider {
            height: 1px;
            background-color: #e2e8f0;
            margin: 6px 0;
        }

        /* Sytling Khusus Bintang Favorit Aktif agar Konsisten */
        .btn-fav.active {
            background-color: #fef9c3;
            color: #eab308 !important;
            border: 1px solid #fde047;
        }
        
        .book-info a {
            position: relative;
            z-index: 10;
        }

        /* DESAIN PREMIUM UNTUK EMPTY STATE FAVORIT */
        .premium-empty-container {
            grid-column: 1 / -1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 50px 20px;
            background: #ffffff;
            border-radius: 12px;
            border: 1px dashed #cbd5e1;
            max-width: 500px;
            margin: 30px auto;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .premium-empty-icon {
            font-size: 50px;
            color: #94a3b8;
            background: #f8fafc;
            width: 90px;
            height: 90px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-bottom: 20px;
            border: 4px solid #f1f5f9;
        }

        .premium-empty-title {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .premium-empty-text {
            font-size: 14px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 22px;
            max-width: 340px;
        }

        .premium-empty-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: #2563eb;
            color: #ffffff !important;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);
            transition: all 0.2s ease;
        }

        .premium-empty-btn:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(37, 99, 235, 0.3);
        }

        /* ==================== DIATUR: STYLE OVERLAY MODAL BASE ==================== */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 2000;
            opacity: 0; visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        .modal-overlay.show {
            opacity: 1; visibility: visible;
        }

        /* ==================== STYLE MODAL KONFIRMASI LOGOUT ==================== */
        .logout-modal-box {
            background: #ffffff;
            width: 90%;
            max-width: 400px;
            border-radius: 14px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transform: scale(0.9);
            transition: transform 0.25s ease;
        }
        .modal-overlay.show .logout-modal-box {
            transform: scale(1);
        }
        .logout-warning-icon {
            font-size: 44px;
            color: #ef4444;
            background: #fef2f2;
            width: 80px;
            height: 80px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-bottom: 16px;
        }
        .logout-title {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }
        .logout-desc {
            font-size: 14px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 24px;
        }
        .logout-btn-container {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        .btn-confirm-logout {
            background-color: #ef4444;
            color: white !important;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: background-color 0.2s;
            flex: 1;
        }
        .btn-confirm-logout:hover { background-color: #dc2626; }
        .btn-cancel-logout {
            background-color: #f1f5f9;
            color: #334155;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s;
            flex: 1;
        }
        .btn-cancel-logout:hover { background-color: #e2e8f0; }
    </style>
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"anggota".equalsIgnoreCase(loggedUser.getLevel())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Favorit> daftarFavorit = (List<Favorit>) request.getAttribute("daftarFavorit");
%>

<div class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-book-open-reader"></i>
        <span>LibraryPro</span>
    </div>
    <ul class="menu">
        <li>
            <a href="<%=request.getContextPath()%>/dashboard">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp">
                <i class="fa-solid fa-book-open"></i> Katalog Buku
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/peminjaman">
                <i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/favorit" class="active">
                <i class="fa-solid fa-star"></i> Favorit Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/ulasan">
                <i class="fa-solid fa-comments"></i> Ulasan & Rating Saya
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Buku Terfavorit Anda</h2>
        
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Anggota">
                <span><%= loggedUser.getNamaLengkap() %></span>
                <i class="fa-solid fa-chevron-down" style="font-size: 11px; color: #64748b;"></i>
            </div>
            
            <ul class="dropdown-menu" id="dropdownMenu">
                <li>
                    <a href="<%=request.getContextPath()%>/profile">
                        <i class="fa-solid fa-user-gear"></i> Profil Saya
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <a href="#" class="logout-link" id="logoutTrigger">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Buku Favorit Saya</h1>
            <p>Daftar buku yang Anda tandai sebagai favorit untuk dipinjam di lain waktu.</p>
        </div>

        <div class="catalog-grid" style="margin-top: 30px;">
            <%
                if (daftarFavorit != null && !daftarFavorit.isEmpty()) {
                    for (Favorit f : daftarFavorit) {
            %>
            <div class="book-card">
                <div class="book-info">
                    <div class="book-title"><%= f.getJudulBuku() %></div>
                    <div class="book-meta">Penulis: <span><%= f.getPenulis() %></span></div>
                    <div class="book-meta">Penerbit: <span><%= f.getPenerbit() %></span></div>
                    
                    <div style="margin-top: 15px; font-size: 0.85rem;">
                        <a href="<%=request.getContextPath()%>/review-buku?idBuku=<%= f.getIdBuku() %>" style="color: var(--primary); text-decoration: none; font-weight: 600;">
                            <i class="fa-solid fa-comments"></i> Lihat Ulasan & Rating
                        </a>
                    </div>
                </div>
                <div class="book-actions">
                    <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= f.getIdBuku() %>" class="btn-sm btn-primary" style="text-align: center; justify-content: center; flex: 1; text-decoration: none;">
                        <i class="fa-solid fa-book-reader"></i> Pinjam Buku
                    </a>
                    
                    <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= f.getIdBuku() %>" class="btn-fav active" title="Hapus dari Favorit" style="flex: 0 0 42px; text-decoration: none;">
                        <i class="fa-solid fa-star"></i>
                    </a>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="premium-empty-container">
                <div class="premium-empty-icon">
                    <i class="fa-regular fa-star" style="animation: pulse 2s infinite;"></i>
                </div>
                <div class="premium-empty-title">Belum Ada Buku Favorit</div>
                <div class="premium-empty-text">
                    Tampaknya Anda belum menandai buku mana pun. Ketuk ikon bintang di katalog untuk menyimpannya di sini.
                </div>
                <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="premium-empty-btn">
                    <i class="fa-solid fa-magnifying-glass"></i> Jelajahi Katalog Buku
                </a>
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="logout-warning-icon">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari akun LibraryPro saat ini? Anda harus login kembali untuk mengakses layanan.</div>
        <div class="logout-btn-container">
            <button class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
            <a href="<%=request.getContextPath()%>/logout" class="btn-confirm-logout">Ya, Keluar</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 1. Logika Dropdown Profil Atas
        const profileTrigger = document.getElementById("profileTrigger");
        const dropdownMenu = document.getElementById("dropdownMenu");

        if (profileTrigger && dropdownMenu) {
            profileTrigger.addEventListener("click", function (event) {
                event.stopPropagation();
                dropdownMenu.classList.toggle("show");
            });

            document.addEventListener("click", function (event) {
                if (!profileTrigger.contains(event.target) && !dropdownMenu.contains(event.target)) {
                    dropdownMenu.classList.remove("show");
                }
            });
        }

        // 2. LOGIKA INTERAKTIF MODAL KONFIRMASI LOGOUT
        const logoutTrigger = document.getElementById("logoutTrigger");
        const logoutModal = document.getElementById("logoutModal");
        const btnCancelLogout = document.getElementById("btnCancelLogout");

        if (logoutTrigger && logoutModal && btnCancelLogout) {
            logoutTrigger.addEventListener("click", function (e) {
                e.preventDefault(); 
                dropdownMenu.classList.remove("show"); 
                logoutModal.classList.add("show"); 
            });

            btnCancelLogout.addEventListener("click", function () {
                logoutModal.classList.remove("show"); 
            });
        }

        // PERBAIKAN: Menghapus variabel 'detailModal' yang memicu error crash script
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });
    });
</script>

</body>
</html>