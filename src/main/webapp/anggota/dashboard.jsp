<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Anggota - LibraryPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
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
        <li>
            <a href="<%=request.getContextPath()%>/dashboard" class="active">
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
                <i class="fa-solid fa-clock-history"></i> Peminjaman Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/favorit">
                <i class="fa-solid fa-star"></i> Favorit Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/profile">
                <i class="fa-solid fa-user-gear"></i> Profil Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Perpustakaan Digital</h2>
        <div class="admin-profile">
            <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Anggota">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Selamat Datang, <%= loggedUser.getNamaLengkap() %>!</h1>
            <p>Temukan ribuan buku berkualitas dan catat peminjaman Anda di sini.</p>
        </div>

        <div class="cards">
            <!-- TOTAL BUKU PERPUSTAKAAN -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-book"></i>
                </div>
                <div>
                    <h4>Total Buku</h4>
                    <h1>
                        <%= request.getAttribute("totalBuku") == null ? 0 : request.getAttribute("totalBuku") %>
                    </h1>
                </div>
            </div>

            <!-- PINJAMAN AKTIF SAYA -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i>
                </div>
                <div>
                    <h4>Pinjaman Aktif</h4>
                    <h1>
                        <%= request.getAttribute("totalPinjamSaya") == null ? 0 : request.getAttribute("totalPinjamSaya") %>
                    </h1>
                </div>
            </div>

            <!-- FAVORIT SAYA -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-star"></i>
                </div>
                <div>
                    <h4>Buku Favorit</h4>
                    <h1>
                        <%= request.getAttribute("totalFavoritSaya") == null ? 0 : request.getAttribute("totalFavoritSaya") %>
                    </h1>
                </div>
            </div>

            <!-- ULASAN SAYA -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-comments"></i>
                </div>
                <div>
                    <h4>Ulasan Saya</h4>
                    <h1>
                        <%= request.getAttribute("totalUlasanSaya") == null ? 0 : request.getAttribute("totalUlasanSaya") %>
                    </h1>
                </div>
            </div>
        </div>

        <!-- RECENT BOOKS GRID FOR MEMBER -->
        <div class="table-header" style="margin-top: 40px;">
            <div class="table-title">Rekomendasi Buku Terbaru</div>
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="btn-add">
                <i class="fa-solid fa-magnifying-glass"></i> Cari Buku Lainnya
            </a>
        </div>

        <div class="catalog-grid" style="margin-top: 20px;">
            <%
                List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
                if (daftarBuku != null && !daftarBuku.isEmpty()) {
                    for (Buku b : daftarBuku) {
            %>
            <div class="book-card">
                <div class="book-info">
                    <div class="book-title"><%= b.getJudul() %></div>
                    <div class="book-meta">Penulis: <span><%= b.getPenulis() %></span></div>
                    <div class="book-meta">Penerbit: <span><%= b.getPenerbit() %></span></div>
                    <div class="book-meta">Tahun: <span><%= b.getTahunTerbit() %></span></div>
                </div>
                <div class="book-actions">
                    <% if (b.getJmlBuku() > 0) { %>
                        <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= b.getIdBuku() %>" class="btn-sm btn-primary" style="text-align: center; justify-content: center;">
                            <i class="fa-solid fa-book-reader"></i> Pinjam
                        </a>
                    <% } else { %>
                        <span class="status borrowed" style="flex: 1; text-align: center; justify-content: center; height: 35px; align-items: center;">Habis</span>
                    <% } %>
                    <a href="<%=request.getContextPath()%>/favorit?action=add&idBuku=<%= b.getIdBuku() %>" class="btn-fav">
                        <i class="fa-solid fa-star"></i>
                    </a>
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

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>
