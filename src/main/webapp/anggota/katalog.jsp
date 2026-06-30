<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Buku" %>
<%@ page import="model.Kategori" %>
<%@ page import="model.User" %>
<%@ page import="dao.BukuDAO" %>
<%@ page import="dao.KategoriDAO" %>
<%@ page import="dao.FavoritDAO" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Katalog Buku - LibraryPro</title>
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
        .dropdown-menu li a { color: #334155; padding: 10px 15px; text-decoration: none; display: flex; align-items: center; gap: 10px; font-size: 14px; }
        .dropdown-menu li a:hover { background-color: #f8fafc; color: #2563eb; }
        .dropdown-menu li a.logout-link:hover { background-color: #fef2f2; color: #dc2626; }
        .dropdown-menu .divider { height: 1px; background-color: #e2e8f0; margin: 6px 0; }

        .filter-select {
            padding: 10px 15px; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; font-size: 14px; color: #334155; background-color: #ffffff; min-width: 160px; cursor: pointer;
        }
        .filter-select:focus { border-color: #2563eb; }
        .btn-fav.active { background-color: #fef9c3; color: #eab308 !important; border: 1px solid #fde047; }
        
        /* MENGUBAH CARD BUKU AGAR BISA DIKLIK */
        .book-card {
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .book-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        /* Mencegah penekanan tombol aksi memicu klik card detail */
        .book-actions, .book-info a {
            position: relative;
            z-index: 10;
        }

        /* ==================== STYLE MODAL DETAIL BUKU ==================== */
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
        .modal-box {
            background: #ffffff;
            width: 90%; max-width: 650px;
            border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            padding: 30px;
            position: relative;
            transform: scale(0.9);
            transition: transform 0.3s ease;
        }
        .modal-overlay.show .modal-box {
            transform: scale(1);
        }
        .modal-close {
            position: absolute; top: 20px; right: 25px;
            font-size: 24px; color: #64748b; cursor: pointer;
            transition: color 0.2s;
        }
        .modal-close:hover { color: #1e293b; }
        
        .modal-title {
            font-size: 22px; font-weight: 700; color: #1e293b; margin-bottom: 5px; padding-right: 30px;
        }
        .modal-category {
            display: inline-block; background: #eff6ff; color: #2563eb; font-size: 12px; font-weight: 600; padding: 4px 10px; border-radius: 6px; margin-bottom: 20px;
        }
        .modal-grid-info {
            display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 20px; background: #f8fafc; padding: 15px; border-radius: 10px; border: 1px solid #f1f5f9;
        }
        .info-item { font-size: 14px; color: #334155; }
        .info-item strong { display: block; color: #64748b; font-size: 12px; margin-bottom: 2px; text-transform: uppercase; letter-spacing: 0.5px;}
        
        .modal-abstract {
            font-size: 14px; color: #475569; line-height: 1.6; margin-top: 15px; border-top: 1px solid #e2e8f0; padding-top: 15px;
        }
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

    String query = request.getParameter("q");
    String kategoriParam = request.getParameter("kategori");

    BukuDAO bukuDAO = new BukuDAO();
    KategoriDAO kategoriDAO = new KategoriDAO();
    FavoritDAO favoritDAO = new FavoritDAO();

    List<Kategori> listKategori = kategoriDAO.getAllKategori();
    
    Map<Integer, String> kategoriMap = new HashMap<>();
    if (listKategori != null) {
        for (Kategori k : listKategori) {
            kategoriMap.put(k.getIdKategori(), k.getNamaKategori());
        }
    }

    List<Buku> listBuku = bukuDAO.getAllBuku();
    if (kategoriParam != null && !kategoriParam.trim().isEmpty() && !kategoriParam.equals("all")) {
        int idKategori = Integer.parseInt(kategoriParam);
        listBuku.removeIf(b -> b.getIdKategori() != idKategori);
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
        <h2>Katalog Buku Perpustakaan</h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Profile">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
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
            <h1>Cari & Pinjam Buku</h1>
            <p>Jelajahi berbagai judul buku yang tersedia untuk dipinjam.</p>
        </div>

        <form action="katalog.jsp" method="get" class="search-container" id="searchForm" style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;" onsubmit="return false;">
            <input type="text" id="searchInput" name="q" value="<%= StringUtils.escapeHtml(query != null ? query : "") %>" placeholder="Ketik satu huruf untuk mencari otomatis..." style="flex: 1; min-width: 250px;">
            <select name="kategori" class="filter-select" onchange="window.location.href='katalog.jsp?kategori=' + this.value;">
                <option value="all">Semua Kategori</option>
                <%
                    if (listKategori != null) {
                        for (Kategori k : listKategori) {
                            String selected = (kategoriParam != null && kategoriParam.equals(String.valueOf(k.getIdKategori()))) ? "selected" : "";
                %>
                    <option value="<%= k.getIdKategori() %>" <%= selected %>><%= StringUtils.escapeHtml(k.getNamaKategori()) %></option>
                <%
                        }
                    }
                %>
            </select>
            <a href="katalog.jsp" class="btn-add" style="background-color: #64748b; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; height: 38px;">Reset</a>
        </form>

        <div class="catalog-grid" id="catalogGrid" style="margin-top: 30px;">
            <%
                if (listBuku != null && !listBuku.isEmpty()) {
                    for (Buku b : listBuku) {
                        String katNama = kategoriMap.get(b.getIdKategori());
                        if (katNama == null) katNama = "Tidak berkategori";
                        boolean isFav = favoritDAO.isFavorit(loggedUser.getIdUser(), b.getIdBuku());
                        
                        // Menangani data kosong/null agar aman saat dibaca JavaScript
                        String absText = (b.getAbstraksi() != null) ? b.getAbstraksi().replace("\"", "&quot;") : "Abstraksi belum tersedia untuk buku ini.";
                        String isbnText = (b.getIsbn() != null && !b.getIsbn().isEmpty()) ? b.getIsbn() : "-";
            %>
            <div class="book-card" 
                 data-judul="<%= StringUtils.escapeHtml(b.getJudul().toLowerCase()) %>" 
                 data-realjudul="<%= StringUtils.escapeHtml(b.getJudul()) %>"
                 data-penulis="<%= StringUtils.escapeHtml(b.getPenulis()) %>" 
                 data-penerbit="<%= StringUtils.escapeHtml(b.getPenerbit()) %>"
                 data-tahun="<%= b.getTahunTerbit() %>"
                 data-kategori="<%= StringUtils.escapeHtml(katNama) %>"
                 data-isbn="<%= StringUtils.escapeHtml(isbnText) %>"
                 data-abstraksi="<%= StringUtils.escapeHtml(absText) %>">
                 
                <div class="book-info">
                    <div class="book-category"><%= StringUtils.escapeHtml(katNama) %></div>
                    <div class="book-title"><%= StringUtils.escapeHtml(b.getJudul()) %></div>
                    <div class="book-meta">Penulis: <span><%= StringUtils.escapeHtml(b.getPenulis()) %></span></div>
                    <div class="book-meta">Penerbit: <span><%= StringUtils.escapeHtml(b.getPenerbit()) %></span></div>
                    <div class="book-meta">Tahun: <span><%= b.getTahunTerbit() %></span></div>
                    
                    <div style="margin-top: 15px; font-size: 0.85rem;">
                        <a href="<%=request.getContextPath()%>/review-buku?idBuku=<%= b.getIdBuku() %>" style="color: var(--primary); text-decoration: none; font-weight: 600;">
                            <i class="fa-solid fa-comments"></i> Lihat Ulasan & Rating
                        </a>
                    </div>
                </div>
                <div class="book-actions">
                    <% if (b.getJmlBuku() > 0) { %>
                        <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= b.getIdBuku() %>" class="btn-sm btn-primary" style="text-align: center; justify-content: center; text-decoration: none;">
                            <i class="fa-solid fa-book-reader"></i> Pinjam Buku
                        </a>
                    <% } else { %>
                        <span class="status borrowed" style="flex: 1; text-align: center; justify-content: center; height: 35px; align-items: center;">Stok Habis</span>
                    <% } %>
                    
                    <% if (isFav) { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= b.getIdBuku() %>" class="btn-fav active" style="text-decoration: none;">
                            <i class="fa-solid fa-star" style="color: #eab308;"></i>
                        </a>
                    <% } else { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=add&idBuku=<%= b.getIdBuku() %>" class="btn-fav" style="text-decoration: none;">
                            <i class="fa-regular fa-star"></i>
                        </a>
                    <% } %>
                </div>
            </div>
            <%
                    }
                }
            %>
            <div id="emptyMessage" style="grid-column: 1 / -1; display: none;" class="empty">Tidak ditemukan buku yang cocok dengan pencarian Anda.</div>
        </div>
    </div>
</div>

<div class="modal-overlay" id="detailModal">
    <div class="modal-box">
        <span class="modal-close" id="closeModal">&times;</span>
        <div class="modal-category" id="mdKategori">Kategori</div>
        <div class="modal-title" id="mdJudul">Judul Buku Terkait</div>
        
        <div class="modal-grid-info">
            <div class="info-item"><strong style="color: #4b69c4;"><i class="fa-solid fa-feather"></i> Penulis</strong> <span id="mdPenulis">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-building"></i> Penerbit</strong> <span id="mdPenerbit">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-calendar-days"></i> Tahun Terbit</strong> <span id="mdTahun">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-barcode"></i> ISBN / ISSN</strong> <span id="mdIsbn">-</span></div>
        </div>
        
        <div class="modal-abstract">
            <h4><i class="fa-solid fa-align-left"></i> Abstraksi / Sinopsis</h4>
            <p id="mdAbstraksi">Isi deskripsi cerita atau rangkuman abstrak buku di sini...</p>
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
        // 1. Logika Dropdown Profil
        const profileTrigger = document.getElementById("profileTrigger");
        const dropdownMenu = document.getElementById("dropdownMenu");

        if (profileTrigger && dropdownMenu) {
            profileTrigger.addEventListener("click", function (e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle("show");
            });
            document.addEventListener("click", function (e) {
                if (!profileTrigger.contains(e.target) && !dropdownMenu.contains(e.target)) {
                    dropdownMenu.classList.remove("show");
                }
            });
        }

        // 2. Logika Live Search Instan
        const searchInput = document.getElementById("searchInput");
        const bookCards = document.querySelectorAll(".book-card");
        const emptyMessage = document.getElementById("emptyMessage");

        if (searchInput) {
            searchInput.addEventListener("input", function () {
                const keyword = this.value.toLowerCase().trim();
                let visibleCount = 0;

                bookCards.forEach(card => {
                    const judul = card.getAttribute("data-judul");
                    const penulis = card.getAttribute("data-penulis").toLowerCase();
                    const penerbit = card.getAttribute("data-penerbit").toLowerCase();

                    if (judul.startsWith(keyword) || judul.includes(" " + keyword) || penulis.startsWith(keyword) || penerbit.startsWith(keyword)) {
                        card.style.display = "flex";
                        visibleCount++;
                    } else {
                        card.style.display = "none";
                    }
                });
                emptyMessage.style.display = (visibleCount === 0 && bookCards.length > 0) ? "block" : "none";
            });
        }

        // 3. LOGIKA INTERAKTIF MODAL DETAIL BUKU
        const detailModal = document.getElementById("detailModal");
        const closeModal = document.getElementById("closeModal");
        
        // Element Pengisi Konten Modal
        const mdJudul = document.getElementById("mdJudul");
        const mdKategori = document.getElementById("mdKategori");
        const mdPenulis = document.getElementById("mdPenulis");
        const mdPenerbit = document.getElementById("mdPenerbit");
        const mdTahun = document.getElementById("mdTahun");
        const mdIsbn = document.getElementById("mdIsbn");
        const mdAbstraksi = document.getElementById("mdAbstraksi");

        bookCards.forEach(card => {
            card.addEventListener("click", function (e) {
                // JIKA YANG DIKLIK TOMBOL PINJAM / TOMBOL FAVORIT, JANGAN BUKA MODAL DETAIL
                if (e.target.closest('.book-actions') || e.target.closest('.book-info a')) {
                    return; 
                }

                // Ambil data dari atribut card yang di-klik
                const judul = this.getAttribute("data-realjudul");
                const kategori = this.getAttribute("data-kategori");
                const penulis = this.getAttribute("data-penulis");
                const penerbit = this.getAttribute("data-penerbit");
                const tahun = this.getAttribute("data-tahun");
                const isbn = this.getAttribute("data-isbn");
                const abstraksi = this.getAttribute("data-abstraksi");

                // Masukkan data ke dalam element Modal Pop-up
                mdJudul.innerText = judul;
                mdKategori.innerText = kategori;
                mdPenulis.innerText = penulis;
                mdPenerbit.innerText = penerbit;
                mdTahun.innerText = tahun;
                mdIsbn.innerText = isbn;
                mdAbstraksi.innerText = abstraksi;

                // Tampilkan Modal
                detailModal.classList.add("show");
            });
        });

        // Event Menutup Modal saat menekan tanda silang (X)
        closeModal.addEventListener("click", function () {
            detailModal.classList.remove("show");
        });

        // Event Menutup Modal saat mengklik area kosong di luar kotak modal
        window.addEventListener("click", function (e) {
            if (e.target === detailModal) {
                detailModal.classList.remove("show");
            }
        });

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
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });
    });
</script>

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>