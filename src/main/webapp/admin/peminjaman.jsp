<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Peminjaman" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Peminjaman - LibraryPro</title>
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

    List<Peminjaman> daftarPeminjaman = (List<Peminjaman>) request.getAttribute("daftarPeminjaman");
    List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
    List<User> daftarUser = (List<User>) request.getAttribute("daftarUser");
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
            <a href="<%=request.getContextPath()%>/peminjaman" class="active">
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
            <h1>Manajemen Peminjaman</h1>
            <p>Catat dan awasi peminjaman buku perpustakaan.</p>
        </div>

        <!-- FORM BOX FOR RECORDING BORROW -->
        <div class="form-box">
            <div class="table-title" style="margin-bottom: 20px;">Catat Peminjaman Baru</div>
            <form action="<%=request.getContextPath()%>/peminjaman" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Pilih Anggota</label>
                        <select name="idUser" required>
                            <option value="">-- Pilih Anggota --</option>
                            <% 
                                if (daftarUser != null) {
                                    for (User u : daftarUser) {
                                        if ("anggota".equalsIgnoreCase(u.getLevel())) {
                            %>
                                <option value="<%= u.getIdUser() %>"><%= u.getNamaLengkap() %> (<%= u.getUsername() %>)</option>
                            <% 
                                        }
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Pilih Buku</label>
                        <select name="idBuku" required>
                            <option value="">-- Pilih Buku --</option>
                            <% 
                                if (daftarBuku != null) {
                                    for (Buku b : daftarBuku) {
                            %>
                                <option value="<%= b.getIdBuku() %>" <%= b.getJmlBuku() <= 0 ? "disabled" : "" %>>
                                    <%= b.getJudul() %> <%= b.getJmlBuku() <= 0 ? "[STOK HABIS]" : "(Stok: " + b.getJmlBuku() + ")" %>
                                </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-add" style="margin-top: 10px;">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i> Catat Peminjaman
                </button>
            </form>
        </div>

        <!-- TABLE OF BORROWINGS -->
        <div class="table-container">
            <div class="table-header">
                <div class="table-title">Daftar Peminjaman Buku</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama Anggota</th>
                    <th>Judul Buku</th>
                    <th>Tanggal Pinjam</th>
                    <th>Tanggal Kembali</th>
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
                    <td>
                        <span style="font-weight: 600;"><%= p.getNamaLengkap() %></span><br>
                        <small style="color: var(--text-muted);">@<%= p.getUsername() %></small>
                    </td>
                    <td style="font-weight: 500;"><%= p.getJudulBuku() %></td>
                    <td><%= p.getTanggalPinjam() %></td>
                    <td><%= p.getTanggalKembali() != null ? p.getTanggalKembali() : "-" %></td>
                    <td>
                        <% if ("dipinjam".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status borrowed">Dipinjam</span>
                        <% } else { %>
                            <span class="status returned">Dikembalikan</span>
                        <% } %>
                    </td>
                    <td>
                        <% if ("dipinjam".equalsIgnoreCase(p.getStatus())) { %>
                            <a href="<%=request.getContextPath()%>/peminjaman?action=kembalikan&id=<%= p.getIdPeminjaman() %>" class="btn-sm btn-success">
                                <i class="fa-solid fa-arrow-left-long"></i> Kembalikan
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
                    <td colspan="7" class="empty">Belum ada riwayat peminjaman.</td>
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
