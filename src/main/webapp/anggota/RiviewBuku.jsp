<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.Ulasan" %>
<%@ page import="model.User" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Komunitas - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .profile-dropdown-container {
            position: relative;
            display: inline-block;
        }

        .user-profile {
            display: flex; align-items: center; gap: 10px; cursor: pointer; user-select: none; padding: 6px 12px; border-radius: 8px; transition: background-color 0.3s ease;
        }
        .user-profile:hover { background-color: #f1f5f9; }
        .user-profile img { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
        .user-profile span { font-weight: 500; color: #334155; }

        .dropdown-menu {
            position: absolute; right: 0; top: 55px; background-color: #ffffff; min-width: 180px; box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 8px 0; list-style: none; z-index: 1000; border: 1px solid #e2e8f0; opacity: 0; visibility: hidden; transform: translateY(-10px); transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s;
        }
        .dropdown-menu.show { opacity: 1; visibility: visible; transform: translateY(0); }
        .dropdown-menu li a { color: #334155; padding: 10px 15px; text-decoration: none; display: flex; align-items: center; gap: 10px; font-size: 14px; transition: background-color 0.2s, color 0.2s; }
        .dropdown-menu li a:hover { background-color: #f8fafc; color: #2563eb; }
        .dropdown-menu li a.logout-link:hover { background-color: #fef2f2; color: #dc2626; }
        .dropdown-menu .divider { height: 1px; background-color: #e2e8f0; margin: 6px 0; }

        .stars-orange { color: #eab308; display: inline-flex; gap: 2px; }
        .review-card {
            background: #ffffff; padding: 20px; border-radius: 10px;
            border: 1px solid #e2e8f0; margin-bottom: 15px;
        }
        .review-header { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .user-name { font-weight: 600; color: #1e293b; font-size: 14px; }
        .review-text { color: #475569; font-size: 14px; line-height: 1.5; }
        .rating-badge {
            background: #fef9c3; color: #ca8a04; padding: 4px 10px;
            border-radius: 6px; font-weight: 700; display: inline-block; margin-bottom: 15px;
        }

        /* Hover Kustom Tombol Header */
        .btn-add {
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 6px; font-size: 13px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s ease;
        }
        .btn-add:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.08);
        }

        /* ==================== CORE BASE OVERLAY MODAL SYSTEM ==================== */
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

        .action-modal-box {
            background: #ffffff; width: 90%; max-width: 400px; border-radius: 14px; padding: 24px; text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: scale(0.9); transition: transform 0.25s ease;
        }
        .modal-overlay.show .action-modal-box { transform: scale(1); }
        .logout-warning-icon { font-size: 44px; color: #ef4444; background: #fef2f2; width: 80px; height: 80px; display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; margin-bottom: 16px; }
        .logout-title { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .logout-desc { font-size: 14px; color: #64748b; line-height: 1.5; margin-bottom: 24px; }
        .logout-btn-container { display: flex; gap: 12px; justify-content: center; }
        .btn-confirm-logout { background-color: #ef4444; color: white !important; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; text-decoration: none; flex: 1; text-align: center; }
        .btn-cancel-logout { background-color: #f1f5f9; color: #334155; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; border: none; cursor: pointer; flex: 1; }
        .btn-cancel-logout:hover { background-color: #e2e8f0; }
    </style>
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    Buku b = (Buku) request.getAttribute("buku");
    List<Ulasan> ulasanPublik = (List<Ulasan>) request.getAttribute("ulasanPublik");
    Double rataRata = (Double) request.getAttribute("rataRataRating");
    
    if (b == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>

<div class="sidebar">
    <div class="logo"><i class="fa-solid fa-book-open-reader"></i> <span>LibraryPro</span></div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="active"><i class="fa-solid fa-book-open"></i> Katalog Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/favorit"><i class="fa-solid fa-star"></i> Favorit Saya</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan"><i class="fa-solid fa-comments"></i> Ulasan & Rating Saya</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button"><i class="fa-solid fa-bars"></i></button>
        <h2>Ulasan & Rating Buku</h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Anggota">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
                <i class="fa-solid fa-chevron-down" style="font-size: 11px; color: #64748b;"></i>
            </div>
            
            <ul class="dropdown-menu" id="dropdownMenu">
                <li><a href="<%=request.getContextPath()%>/profile"><i class="fa-solid fa-user-gear"></i> Profil Saya</a></li>
                <li class="divider"></li>
                <li><a href="#" class="logout-link" id="logoutTrigger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="table-header">
            <div class="table-title"><%= StringUtils.escapeHtml(b.getJudul()) %></div>
            <a href="<%= request.getContextPath() %>/anggota/katalog.jsp" class="btn-add" style="background-color: #64748b; text-decoration: none;">
                <i class="fa-solid fa-arrow-left"></i> Kembali ke Katalog
            </a>
        </div>

        <div style="background: white; padding: 25px; border-radius: 12px; border: 1px solid #e2e8f0; margin-top: 20px;">
            <div class="rating-badge">
                <i class="fa-solid fa-star"></i> Komunitas Rating: <%= (rataRata != null && rataRata > 0) ? String.format("%.1f", rataRata) + " / 5.0" : "Belum dinilai" %>
            </div>
            
            <p style="margin-bottom: 8px;"><b>Penulis:</b> <%= StringUtils.escapeHtml(b.getPenulis()) %></p>
            <p style="margin-bottom: 8px;"><b>Penerbit:</b> <%= StringUtils.escapeHtml(b.getPenerbit()) %></p>
            <p style="margin-bottom: 8px;"><b>Tahun Terbit:</b> <%= b.getTahunTerbit() %></p>
            <p style="margin-bottom: 18px;"><b>ISBN / ISSN:</b> <%= StringUtils.escapeHtml(b.getIsbn() != null ? b.getIsbn() : "-") %></p>
            
            <div style="border-top: 1px solid #e2e8f0; padding-top: 15px;">
                <h4 style="margin-bottom: 8px; color: #1e293b;">Abstraksi / Sinopsis:</h4>
                <p style="color: #475569; line-height: 1.6; font-style: italic;"><%= StringUtils.escapeHtml(b.getAbstraksi() != null ? b.getAbstraksi() : "Sinopsis belum tersedia.") %></p>
            </div>
        </div>

        <div class="table-header" style="margin-top: 40px;">
            <div class="table-title">Daftar Komentar Pembaca (<%= ulasanPublik != null ? ulasanPublik.size() : 0 %>)</div>
            <a href="<%= request.getContextPath() %>/ulasan?idBuku=<%= b.getIdBuku() %>" class="btn-add" style="text-decoration: none;">
                <i class="fa-solid fa-pen-to-square"></i> Tulis Ulasan Anda
            </a>
        </div>

        <div style="margin-top: 20px;">
            <%
                if (ulasanPublik != null && !ulasanPublik.isEmpty()) {
                    for (Ulasan u : ulasanPublik) {
            %>
                <div class="review-card">
                    <div class="review-header">
                        <div class="user-name"><i class="fa-solid fa-circle-user"></i> <%= StringUtils.escapeHtml(u.getNamaLengkap() != null ? u.getNamaLengkap() : u.getUsername()) %></div>
                        <div class="stars-orange">
                            <% for(int i = 1; i <= u.getRating(); i++) { %><i class="fa-solid fa-star"></i><% } %>
                            <% for(int i = u.getRating() + 1; i <= 5; i++) { %><i class="fa-solid fa-star" style="color: #cbd5e1;"></i><% } %>
                        </div>
                    </div>
                    <div class="review-text">"<%= StringUtils.escapeHtml(u.getUlasan()) %>"</div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="empty">Belum ada ulasan untuk buku ini.</div>
            <%
                }
            %>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="action-modal-box">
        <div class="logout-warning-icon">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari akun LibraryPro saat ini? Anda harus login kembali untuk mengakses layanan.</div>
        <div class="logout-btn-container">
            <button type="button" class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
            <a href="<%=request.getContextPath()%>/logout" class="btn-confirm-logout">Ya, Keluar</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 1. FIXED LOGIKA: Mengaktifkan fungsionalitas dropdown menu profil harian
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

        // 2. Logika Modal Konfirmasi Logout
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

        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });
    });
</script>

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>