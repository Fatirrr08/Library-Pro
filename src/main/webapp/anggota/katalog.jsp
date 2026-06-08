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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Katalog Buku - LibraryPro</title>
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

    String query = request.getParameter("q");
    BukuDAO bukuDAO = new BukuDAO();
    KategoriDAO kategoriDAO = new KategoriDAO();
    FavoritDAO favoritDAO = new FavoritDAO();

    List<Buku> listBuku = (query != null && !query.trim().isEmpty()) ? bukuDAO.searchBuku(query) : bukuDAO.getAllBuku();
    List<Kategori> listKategori = kategoriDAO.getAllKategori();
    
    Map<Integer, String> kategoriMap = new HashMap<>();
    if (listKategori != null) {
        for (Kategori k : listKategori) {
            kategoriMap.put(k.getIdKategori(), k.getNamaKategori());
        }
    }
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
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="active">
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
            <a href="<%=request.getContextPath()%>/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Katalog Buku Perpustakaan</h2>
        <div class="admin-profile">
            <img src="https://i.pravatar.cc/100?img=12" alt="Anggota">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Cari & Pinjam Buku</h1>
            <p>Jelajahi berbagai judul buku yang tersedia untuk dipinjam.</p>
        </div>

        <!-- SEARCH BAR -->
        <form action="katalog.jsp" method="get" class="search-container">
            <input type="text" name="q" value="<%= query != null ? query : "" %>" placeholder="Cari berdasarkan judul, penulis, atau penerbit...">
            <button type="submit" class="btn-add">
                <i class="fa-solid fa-magnifying-glass"></i> Cari
            </button>
            <% if (query != null && !query.isEmpty()) { %>
                <a href="katalog.jsp" class="btn-add" style="background-color: var(--text-muted);">Reset</a>
            <% } %>
        </form>

        <!-- BOOK GRID -->
        <div class="catalog-grid">
            <%
                if (listBuku != null && !listBuku.isEmpty()) {
                    for (Buku b : listBuku) {
                        String katNama = kategoriMap.get(b.getIdKategori());
                        if (katNama == null) katNama = "Tidak berkategori";
                        boolean isFav = favoritDAO.isFavorit(loggedUser.getIdUser(), b.getIdBuku());
            %>
            <div class="book-card">
                <div class="book-info">
                    <div class="book-category"><%= katNama %></div>
                    <div class="book-title"><%= b.getJudul() %></div>
                    <div class="book-meta">Penulis: <span><%= b.getPenulis() %></span></div>
                    <div class="book-meta">Penerbit: <span><%= b.getPenerbit() %></span></div>
                    <div class="book-meta">Tahun: <span><%= b.getTahunTerbit() %></span></div>
                    
                    <div style="margin-top: 15px; font-size: 0.85rem;">
                        <a href="<%=request.getContextPath()%>/ulasan?idBuku=<%= b.getIdBuku() %>" style="color: var(--primary); text-decoration: none; font-weight: 600;">
                            <i class="fa-solid fa-comments"></i> Lihat Ulasan & Rating
                        </a>
                    </div>
                </div>
                <div class="book-actions">
                    <% if (b.getJmlBuku() > 0) { %>
                        <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= b.getIdBuku() %>" class="btn-sm btn-primary" style="text-align: center; justify-content: center;">
                            <i class="fa-solid fa-book-reader"></i> Pinjam Buku
                        </a>
                    <% } else { %>
                        <span class="status borrowed" style="flex: 1; text-align: center; justify-content: center; height: 35px; align-items: center;">Stok Habis</span>
                    <% } %>
                    
                    <% if (isFav) { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= b.getIdBuku() %>" class="btn-fav active">
                            <i class="fa-solid fa-star"></i>
                        </a>
                    <% } else { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=add&idBuku=<%= b.getIdBuku() %>" class="btn-fav">
                            <i class="fa-solid fa-star"></i>
                        </a>
                    <% } %>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div style="grid-column: 1 / -1;" class="empty">Tidak ditemukan buku yang cocok dengan pencarian Anda.</div>
            <%
                }
            %>
        </div>
    </div>
</div>

</body>
</html>
