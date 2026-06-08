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
                <i class="fa-solid fa-clock-history"></i> Peminjaman Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/favorit" class="active">
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
        <h2>Buku Terfavorit Anda</h2>
        <div class="admin-profile">
            <img src="https://i.pravatar.cc/100?img=12" alt="Anggota">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Buku Favorit Saya</h1>
            <p>Daftar buku yang Anda tandai sebagai favorit untuk dipinjam di lain waktu.</p>
        </div>

        <!-- FAVORITES GRID -->
        <div class="catalog-grid">
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
                        <a href="<%=request.getContextPath()%>/ulasan?idBuku=<%= f.getIdBuku() %>" style="color: var(--primary); text-decoration: none; font-weight: 600;">
                            <i class="fa-solid fa-comments"></i> Lihat Ulasan & Rating
                        </a>
                    </div>
                </div>
                <div class="book-actions">
                    <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= f.getIdBuku() %>" class="btn-sm btn-primary" style="text-align: center; justify-content: center; flex: 1;">
                        <i class="fa-solid fa-book-reader"></i> Pinjam Buku
                    </a>
                    
                    <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= f.getIdBuku() %>" class="btn-fav active" title="Hapus dari Favorit" style="flex: 0 0 42px;">
                        <i class="fa-solid fa-star"></i>
                    </a>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div style="grid-column: 1 / -1;" class="empty">
                Belum ada buku terfavorit. <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" style="color: var(--primary); font-weight: 600;">Telusuri Katalog</a> untuk menambahkan.
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>

</body>
</html>
