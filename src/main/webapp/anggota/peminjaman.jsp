<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Peminjaman" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peminjaman Saya - LibraryPro</title>
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

    List<Peminjaman> daftarPeminjaman = (List<Peminjaman>) request.getAttribute("daftarPeminjaman");
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
            <a href="<%=request.getContextPath()%>/peminjaman" class="active">
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
        <h2>Riwayat Peminjaman Anda</h2>
        <div class="admin-profile">
            <img src="https://i.pravatar.cc/100?img=12" alt="Anggota">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Riwayat Peminjaman</h1>
            <p>Lihat status buku yang Anda pinjam dan lakukan pengembalian secara mandiri.</p>
        </div>

        <%
            String statusParam = request.getParameter("status");
            if ("success".equals(statusParam)) {
        %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> Peminjaman buku berhasil dicatat! Selamat membaca!
            </div>
        <%
            } else if ("fail".equals(statusParam)) {
        %>
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation"></i> Gagal melakukan peminjaman. Stok buku habis!
            </div>
        <%
            }
        %>

        <!-- TABLE OF BORROWINGS -->
        <div class="table-container">
            <div class="table-header">
                <div class="table-title">Daftar Peminjaman Saya</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID Pinjam</th>
                    <th>Judul Buku</th>
                    <th>Tanggal Pinjam</th>
                    <th>Tanggal Pengembalian</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (daftarPeminjaman != null && !daftarPeminjaman.isEmpty()) {
                        for (Peminjaman p : daftarPeminjaman) {
                %>
                <tr>
                    <td><%= p.getIdPeminjaman() %></td>
                    <td style="font-weight: 600;"><%= p.getJudulBuku() %></td>
                    <td><%= p.getTanggalPinjam() %></td>
                    <td><%= p.getTanggalKembali() != null ? p.getTanggalKembali() : "-" %></td>
                    <td>
                        <% if ("dipinjam".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status borrowed">Sedang Dipinjam</span>
                        <% } else { %>
                            <span class="status returned">Sudah Dikembalikan</span>
                        <% } %>
                    </td>
                    <td>
                        <% if ("dipinjam".equalsIgnoreCase(p.getStatus())) { %>
                            <a href="<%=request.getContextPath()%>/peminjaman?action=kembalikan&id=<%= p.getIdPeminjaman() %>" class="btn-sm btn-success">
                                <i class="fa-solid fa-arrow-left-long"></i> Kembalikan Buku
                            </a>
                        <% } else { %>
                            <span style="color: var(--text-muted); font-size: 0.85rem;"><i class="fa-solid fa-circle-check"></i> Selesai</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" class="empty">Anda belum meminjam buku apa pun. Silakan cari buku di katalog.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
