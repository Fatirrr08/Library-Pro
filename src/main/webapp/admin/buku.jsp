<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.Kategori" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Buku - LibraryPro</title>
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

    Buku editBuku = (Buku) request.getAttribute("editBuku");
    List<Kategori> daftarKategori = (List<Kategori>) request.getAttribute("daftarKategori");
    List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
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
            <a href="<%=request.getContextPath()%>/buku" class="active">
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
            <h1>Manajemen Buku</h1>
            <p>Kelola koleksi buku perpustakaan secara real-time.</p>
        </div>

        <!-- FORM BOX -->
        <div class="form-box">
            <div class="table-title" style="margin-bottom: 20px;">
                <%= editBuku != null ? "Edit Data Buku" : "Tambah Buku Baru" %>
            </div>
            
            <form action="<%=request.getContextPath()%>/buku" method="post">
                <% if (editBuku != null) { %>
                    <input type="hidden" name="idBuku" value="<%= editBuku.getIdBuku() %>">
                    <input type="hidden" name="action" value="update">
                <% } %>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Judul Buku</label>
                        <input type="text" name="judul" value="<%= editBuku != null ? editBuku.getJudul() : "" %>" required placeholder="Contoh: Belajar Java Dasar">
                    </div>
                    <div class="form-group">
                        <label>Penulis</label>
                        <input type="text" name="penulis" value="<%= editBuku != null ? editBuku.getPenulis() : "" %>" required placeholder="Contoh: Rinaldi Munir">
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Penerbit</label>
                        <input type="text" name="penerbit" value="<%= editBuku != null ? editBuku.getPenerbit() : "" %>" required placeholder="Contoh: Penerbit Informatika">
                    </div>
                    <div class="form-group">
                        <label>Tahun Terbit</label>
                        <input type="number" name="tahun" value="<%= editBuku != null ? editBuku.getTahunTerbit() : "" %>" required placeholder="Contoh: 2023">
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Jumlah Buku (Stok)</label>
                        <input type="number" name="jumlah" value="<%= editBuku != null ? editBuku.getJmlBuku() : "" %>" required placeholder="Contoh: 10">
                    </div>
                    <div class="form-group">
                        <label>Kategori</label>
                        <select name="idKategori" required>
                            <option value="">-- Pilih Kategori --</option>
                            <% 
                                if (daftarKategori != null) {
                                    for (Kategori k : daftarKategori) {
                                        boolean selected = editBuku != null && editBuku.getIdKategori() == k.getIdKategori();
                            %>
                                <option value="<%= k.getIdKategori() %>" <%= selected ? "selected" : "" %>><%= k.getNamaKategori() %></option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 10px;">
                    <button type="submit" class="btn-add">
                        <i class="fa-solid fa-floppy-disk"></i> <%= editBuku != null ? "Perbarui Buku" : "Simpan Buku" %>
                    </button>
                    <% if (editBuku != null) { %>
                        <a href="<%=request.getContextPath()%>/buku" class="btn-add" style="background-color: var(--text-muted);">
                            Batal
                        </a>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- TABLE OF BOOKS -->
        <div class="table-container">
            <div class="table-header">
                <div class="table-title">Daftar Buku Terdaftar</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Judul Buku</th>
                    <th>Penulis</th>
                    <th>Penerbit</th>
                    <th>Tahun</th>
                    <th>Stok</th>
                    <th>Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
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
                    <td>
                        <a href="<%=request.getContextPath()%>/buku?action=edit&id=<%= b.getIdBuku() %>" class="btn-sm btn-warning">
                            <i class="fa-solid fa-pen-to-square"></i> Edit
                        </a>
                        <a href="<%=request.getContextPath()%>/buku?action=delete&id=<%= b.getIdBuku() %>" class="btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus buku ini?')">
                            <i class="fa-solid fa-trash"></i> Hapus
                        </a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="empty">Belum ada data buku terdaftar.</td>
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
