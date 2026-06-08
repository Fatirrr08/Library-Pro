<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Kategori" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Kategori - LibraryPro</title>
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

    Kategori editKategori = (Kategori) request.getAttribute("editKategori");
    List<Kategori> daftarKategori = (List<Kategori>) request.getAttribute("daftarKategori");
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
            <a href="<%=request.getContextPath()%>/kategori" class="active">
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
            <h1>Manajemen Kategori</h1>
            <p>Kelola klasifikasi kategori buku perpustakaan.</p>
        </div>

        <!-- FORM BOX -->
        <div class="form-box" style="max-width: 500px;">
            <div class="table-title" style="margin-bottom: 20px;">
                <%= editKategori != null ? "Edit Kategori" : "Tambah Kategori Baru" %>
            </div>

            <form action="<%=request.getContextPath()%>/kategori" method="post">
                <% if (editKategori != null) { %>
                    <input type="hidden" name="idKategori" value="<%= editKategori.getIdKategori() %>">
                    <input type="hidden" name="action" value="update">
                <% } %>

                <div class="form-group">
                    <label>Nama Kategori</label>
                    <input type="text" name="namaKategori" value="<%= editKategori != null ? editKategori.getNamaKategori() : "" %>" required placeholder="Contoh: Fiksi Sains">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn-add">
                        <i class="fa-solid fa-floppy-disk"></i> <%= editKategori != null ? "Perbarui Kategori" : "Simpan Kategori" %>
                    </button>
                    <% if (editKategori != null) { %>
                        <a href="<%=request.getContextPath()%>/kategori" class="btn-add" style="background-color: var(--text-muted);">
                            Batal
                        </a>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- TABLE OF CATEGORIES -->
        <div class="table-container" style="max-width: 700px;">
            <div class="table-header">
                <div class="table-title">Daftar Kategori Buku</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th style="width: 100px;">ID Kategori</th>
                    <th>Nama Kategori</th>
                    <th style="width: 250px;">Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (daftarKategori != null && !daftarKategori.isEmpty()) {
                        for (Kategori k : daftarKategori) {
                %>
                <tr>
                    <td><%= k.getIdKategori() %></td>
                    <td style="font-weight: 600;"><%= k.getNamaKategori() %></td>
                    <td>
                        <a href="<%=request.getContextPath()%>/kategori?action=edit&id=<%= k.getIdKategori() %>" class="btn-sm btn-warning">
                            <i class="fa-solid fa-pen-to-square"></i> Edit
                        </a>
                        <a href="<%=request.getContextPath()%>/kategori?action=delete&id=<%= k.getIdKategori() %>" class="btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus kategori ini?')">
                            <i class="fa-solid fa-trash"></i> Hapus
                        </a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="3" class="empty">Belum ada data kategori.</td>
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
