<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>
<%@ page import="dao.FavoritDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Anggota - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://imgur.com/a/aK1yydG">
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

        /* Gaya Menu Dropdown Profil */
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

        /* Efek Hover untuk Kartu Statistik Berbasis Onclick */
        .cards .card {
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
        }

        .cards .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
            border-color: #cbd5e1;
        }

        .catalog-grid .book-card {
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .catalog-grid .book-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .book-actions {
            position: relative;
            z-index: 10;
        }

        .btn-fav {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 35px;
            height: 35px;
            border-radius: 6px;
            background-color: #f1f5f9;
            color: #64748b;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-fav:hover {
            background-color: #e2e8f0;
            color: #eab308;
        }

        .btn-fav.active {
            background-color: #fef9c3;
            color: #eab308 !important;
            border: 1px solid #fde047;
        }

        /* STYLE DETAIL MODAL BUKU */
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
        .modal-overlay.show { opacity: 1; visibility: visible; }
        .modal-box {
            background: #ffffff; width: 90%; max-width: 650px; border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); padding: 30px; position: relative;
            transform: scale(0.9); transition: transform 0.3s ease;
        }
        .modal-overlay.show .modal-box { transform: scale(1); }
        .modal-close { position: absolute; top: 20px; right: 25px; font-size: 24px; color: #64748b; cursor: pointer; }
        .modal-title { font-size: 22px; font-weight: 700; color: #1e293b; margin-bottom: 20px; padding-right: 30px; }
        .modal-grid-info { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 20px; background: #f8fafc; padding: 15px; border-radius: 10px; border: 1px solid #f1f5f9; }
        .info-item { font-size: 14px; color: #334155; }
        .info-item strong { display: block; color: #64748b; font-size: 12px; margin-bottom: 2px; text-transform: uppercase; }
        .modal-abstract { font-size: 14px; color: #475569; line-height: 1.6; margin-top: 15px; border-top: 1px solid #e2e8f0; padding-top: 15px; }
        .modal-abstract h4 { color: #1e293b; margin-bottom: 8px; font-size: 15px; }

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
%>

<div class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-book-open-reader"></i>
        <span>LibraryPro</span>
    </div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard" class="active"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp"><i class="fa-solid fa-book-open"></i> Katalog Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/favorit"><i class="fa-solid fa-star"></i> Favorit Saya</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan"><i class="fa-solid fa-comments"></i> Ulasan & Rating Saya</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Perpustakaan Digital</h2>
        
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Anggota">
                <span><%= loggedUser.getNamaLengkap() %></span>
                <i class="fa-solid fa-chevron-down" style="font-size: 11px; color: #64748b;"></i>
            </div>
            
            <ul class="dropdown-menu" id="dropdownMenu">
                <li><a href="<%=request.getContextPath()%>/profile"><i class="fa-solid fa-user-gear"></i> Profil Saya</a></li>
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
            <h1>Selamat Datang, <%= loggedUser.getNamaLengkap() %>!</h1>
            <p>Temukan ribuan buku berkualitas dan catat peminjaman Anda di sini.</p>
        </div>

        <div class="cards">
            <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/anggota/katalog.jsp';">
                <div class="card-icon"><i class="fa-solid fa-book"></i></div>
                <div>
                    <h4>Total Buku</h4>
                    <h1><%= request.getAttribute("totalBuku") == null ? 0 : request.getAttribute("totalBuku") %></h1>
                </div>
            </div>

            <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/peminjaman';">
                <div class="card-icon"><i class="fa-solid fa-arrow-right-arrow-left"></i></div>
                <div>
                    <h4>Pinjaman Aktif</h4>
                    <h1><%= request.getAttribute("totalPinjamSaya") == null ? 0 : request.getAttribute("totalPinjamSaya") %></h1>
                </div>
            </div>

            <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/favorit';">
                <div class="card-icon"><i class="fa-solid fa-star"></i></div>
                <div>
                    <h4>Buku Favorit</h4>
                    <h1><%= request.getAttribute("totalFavoritSaya") == null ? 0 : request.getAttribute("totalFavoritSaya") %></h1>
                </div>
            </div>

            <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/ulasan';">
                <div class="card-icon"><i class="fa-solid fa-comments"></i></div>
                <div>
                    <h4>Ulasan Saya</h4>
                    <h1><%= request.getAttribute("totalUlasanSaya") == null ? 0 : request.getAttribute("totalUlasanSaya") %></h1>
                </div>
            </div>
        </div>

        <div class="table-header" style="margin-top: 40px;">
            <div class="table-title">Rekomendasi Buku Terbaru</div>
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="btn-add"><i class="fa-solid fa-magnifying-glass"></i> Cari Buku Lainnya</a>
        </div>

        <div class="catalog-grid" style="margin-top: 20px;">
            <%
                List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
                FavoritDAO favoritDAO = (FavoritDAO) request.getAttribute("favoritDAO");

                if (daftarBuku != null && !daftarBuku.isEmpty()) {
                    for (Buku b : daftarBuku) {
                        boolean isBookFav = false;
                        if (favoritDAO != null && loggedUser != null) {
                            isBookFav = favoritDAO.isFavorit(loggedUser.getIdUser(), b.getIdBuku());
                        }
                        String absText = (b.getAbstraksi() != null) ? b.getAbstraksi().replace("\"", "&quot;") : "Abstraksi belum tersedia untuk buku ini.";
                        String isbnText = (b.getIsbn() != null && !b.getIsbn().isEmpty()) ? b.getIsbn() : "-";
            %>
            <div class="book-card" data-realjudul="<%= b.getJudul() %>" data-penulis="<%= b.getPenulis() %>" data-penerbit="<%= b.getPenerbit() %>" data-tahun="<%= b.getTahunTerbit() %>" data-isbn="<%= isbnText %>" data-abstraksi="<%= absText %>">
                <div class="book-info">
                    <div class="book-title"><%= b.getJudul() %></div>
                    <div class="book-meta">Penulis: <span><%= b.getPenulis() %></span></div>
                    <div class="book-meta">Penerbit: <span><%= b.getPenerbit() %></span></div>
                    <div class="book-meta">Tahun: <span><%= b.getTahunTerbit() %></span></div>
                </div>
                <div class="book-actions">
                    <% if (b.getJmlBuku() > 0) { %>
                        <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= b.getIdBuku() %>" class="btn-sm btn-primary" style="text-align: center; justify-content: center; text-decoration: none;"><i class="fa-solid fa-book-reader"></i> Pinjam</a>
                    <% } else { %>
                        <span class="status borrowed" style="flex: 1; text-align: center; justify-content: center; height: 35px; align-items: center;">Habis</span>
                    <% } %>
                    
                    <% if (isBookFav) { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= b.getIdBuku() %>" class="btn-fav active" title="Hapus dari Favorit" style="text-decoration: none;"><i class="fa-solid fa-star" style="color: #eab308;"></i></a>
                    <% } else { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=add&idBuku=<%= b.getIdBuku() %>" class="btn-fav" title="Tambah ke Favorit" style="text-decoration: none;"><i class="fa-regular fa-star"></i></a>
                    <% } %>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div style="grid-column: 1 / -1;" class="empty">Tidak ada rekomendasi buku saat ini.</div>
            <%
                }
            %>
        </div>
    </div>
</div>

<div class="modal-overlay" id="detailModal">
    <div class="modal-box">
        <span class="modal-close" id="closeModal">&times;</span>
        <div class="modal-title" id="mdJudul">Judul Buku Rekomendasi</div>
        <div class="modal-grid-info">
            <div class="info-item"><strong><i class="fa-solid fa-feather"></i> Penulis</strong> <span id="mdPenulis">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-building"></i> Penerbit</strong> <span id="mdPenerbit">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-calendar-days"></i> Tahun Terbit</strong> <span id="mdTahun">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-barcode"></i> ISBN / ISSN</strong> <span id="mdIsbn">-</span></div>
        </div>
        <div class="modal-abstract">
            <h4><i class="fa-solid fa-align-left"></i> Abstraksi / Sinopsis</h4>
            <p id="mdAbstraksi">Deskripsi sinopsis buku...</p>
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

<script src="<%=request.getContextPath()%>/js/script.js"></script>
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

        // 2. LOGIKA DETAIL DIALOG POP-UP BUKU DASHBOARD
        const detailModal = document.getElementById("detailModal");
        const closeModal = document.getElementById("closeModal");
        const bookCards = document.querySelectorAll(".catalog-grid .book-card");

        const mdJudul = document.getElementById("mdJudul");
        const mdPenulis = document.getElementById("mdPenulis");
        const mdPenerbit = document.getElementById("mdPenerbit");
        const mdTahun = document.getElementById("mdTahun");
        const mdIsbn = document.getElementById("mdIsbn");
        const mdAbstraksi = document.getElementById("mdAbstraksi");

        bookCards.forEach(card => {
            card.addEventListener("click", function (e) {
                if (e.target.closest('.book-actions')) return;

                mdJudul.innerText = this.getAttribute("data-realjudul");
                mdPenulis.innerText = this.getAttribute("data-penulis");
                mdPenerbit.innerText = this.getAttribute("data-penerbit");
                mdTahun.innerText = this.getAttribute("data-tahun");
                mdIsbn.innerText = this.getAttribute("data-isbn");
                mdAbstraksi.innerText = this.getAttribute("data-abstraksi");

                detailModal.classList.add("show");
            });
        });

        if (closeModal) {
            closeModal.addEventListener("click", function () {
                detailModal.classList.remove("show");
            });
        }

        // 3. LOGIKA INTERAKTIF MODAL KONFIRMASI LOGOUT
        const logoutTrigger = document.getElementById("logoutTrigger");
        const logoutModal = document.getElementById("logoutModal");
        const btnCancelLogout = document.getElementById("btnCancelLogout");

        if (logoutTrigger && logoutModal && btnCancelLogout) {
            logoutTrigger.addEventListener("click", function (e) {
                e.preventDefault(); // Menahan link '#' agar tidak scroll ke atas
                dropdownMenu.classList.remove("show"); // Sembunyikan menu dropdown profil terlebih dahulu
                logoutModal.classList.add("show"); // Tampilkan pop-up konfirmasi logout
            });

            btnCancelLogout.addEventListener("click", function () {
                logoutModal.classList.remove("show"); // Sembunyikan pop-up jika menekan tombol Batal
            });
        }

        // Global Event: Klik area luar untuk menutup modal apa pun yang sedang aktif
        window.addEventListener("click", function (e) {
            if (e.target === detailModal) detailModal.classList.remove("show");
            if (e.target === logoutModal) logoutModal.classList.remove("show");
        });
    });
</script>

</body>
</html>