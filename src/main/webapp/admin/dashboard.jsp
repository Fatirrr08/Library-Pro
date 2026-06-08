<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - LibraryPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"admin".equalsIgnoreCase(loggedUser.getLevel())) {
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
            <a href="<%=request.getContextPath()%>/buku">
                <i class="fa-solid fa-book"></i> Buku
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/kategori">
                <i class="fa-solid fa-layer-group"></i> Kategori
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/user">
                <i class="fa-solid fa-users"></i> User
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/peminjaman">
                <i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman
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
        <h2>Library Management System</h2>
        <div class="admin-profile">
            <img src="https://i.pravatar.cc/100?img=33" alt="Admin">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Dashboard Admin</h1>
            <p>Kelola seluruh data perpustakaan dari satu tempat.</p>
        </div>

        <div class="cards">
            <!-- TOTAL BUKU -->
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

            <!-- TOTAL KATEGORI -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-layer-group"></i>
                </div>
                <div>
                    <h4>Total Kategori</h4>
                    <h1>
                        <%= request.getAttribute("totalKategori") == null ? 0 : request.getAttribute("totalKategori") %>
                    </h1>
                </div>
            </div>

            <!-- TOTAL USER -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div>
                    <h4>Total User</h4>
                    <h1>
                        <%= request.getAttribute("totalUser") == null ? 0 : request.getAttribute("totalUser") %>
                    </h1>
                </div>
            </div>

            <!-- TOTAL PEMINJAMAN -->
            <div class="card">
                <div class="card-icon">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i>
                </div>
                <div>
                    <h4>Total Peminjaman</h4>
                    <h1>
                        <%= request.getAttribute("totalPeminjaman") == null ? 0 : request.getAttribute("totalPeminjaman") %>
                    </h1>
                </div>
            </div>
        </div>

        <!-- TABEL BUKU -->
        <div class="table-container">
            <div class="table-header">
                <div class="table-title">5 Buku Terbaru</div>
                <a href="<%=request.getContextPath()%>/buku" class="btn-add">
                    <i class="fa-solid fa-list"></i> Lihat Semua Buku
                </a>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID Buku</th>
                    <th>Judul Buku</th>
                    <th>Penulis</th>
                    <th>Penerbit</th>
                    <th>Tahun Terbit</th>
                    <th>Stok Buku</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
                    if (daftarBuku != null && !daftarBuku.isEmpty()) {
                        for (Buku b : daftarBuku) {
                %>
                <tr>
                    <td><%= b.getIdBuku() %></td>
                    <td style="font-weight: 600;"><%= b.getJudul() %></td>
                    <td><%= b.getPenulis() %></td>
                    <td><%= b.getPenerbit() %></td>
                    <td><%= b.getTahunTerbit() %></td>
                    <td>
                        <% if (b.getJmlBuku() > 0) { %>
                            <span class="status available">Tersedia (<%= b.getJmlBuku() %>)</span>
                        <% } else { %>
                            <span class="status borrowed">Habis</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" class="empty">Belum ada data buku terbaru.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>