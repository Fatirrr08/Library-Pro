<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen User - LibraryPro</title>
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

    User editUser = (User) request.getAttribute("editUser");
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
            <a href="<%=request.getContextPath()%>/user" class="active">
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
            <h1>Manajemen User</h1>
            <p>Kelola data admin dan anggota perpustakaan.</p>
        </div>

        <!-- FORM BOX -->
        <div class="form-box">
            <div class="table-title" style="margin-bottom: 20px;">
                <%= editUser != null ? "Edit Data User" : "Tambah User Baru" %>
            </div>

            <form action="<%=request.getContextPath()%>/user" method="post">
                <% if (editUser != null) { %>
                    <input type="hidden" name="idUser" value="<%= editUser.getIdUser() %>">
                    <input type="hidden" name="action" value="update">
                <% } %>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" value="<%= editUser != null ? editUser.getUsername() : "" %>" required placeholder="Contoh: budi123">
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" value="<%= editUser != null ? editUser.getPassword() : "" %>" required placeholder="Masukkan password">
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Nama Lengkap</label>
                        <input type="text" name="namaLengkap" value="<%= editUser != null ? editUser.getNamaLengkap() : "" %>" required placeholder="Contoh: Budi Santoso">
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= editUser != null ? editUser.getEmail() : "" %>" required placeholder="Contoh: budi@gmail.com">
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Level Akses</label>
                        <select name="level" required>
                            <option value="anggota" <%= (editUser != null && "anggota".equalsIgnoreCase(editUser.getLevel())) ? "selected" : "" %>>Anggota</option>
                            <option value="admin" <%= (editUser != null && "admin".equalsIgnoreCase(editUser.getLevel())) ? "selected" : "" %>>Administrator</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Alamat</label>
                        <input type="text" name="alamat" value="<%= editUser != null ? editUser.getAlamat() : "" %>" required placeholder="Contoh: Jl. Telekomunikasi No. 1">
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 10px;">
                    <button type="submit" class="btn-add">
                        <i class="fa-solid fa-floppy-disk"></i> <%= editUser != null ? "Perbarui User" : "Simpan User" %>
                    </button>
                    <% if (editUser != null) { %>
                        <a href="<%=request.getContextPath()%>/user" class="btn-add" style="background-color: var(--text-muted);">
                            Batal
                        </a>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- TABLE OF USERS -->
        <div class="table-container">
            <div class="table-header">
                <div class="table-title">Daftar Pengguna Terdaftar</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Nama Lengkap</th>
                    <th>Email</th>
                    <th>Alamat</th>
                    <th>Role</th>
                    <th>Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (daftarUser != null && !daftarUser.isEmpty()) {
                        for (User u : daftarUser) {
                %>
                <tr>
                    <td><%= u.getIdUser() %></td>
                    <td style="font-weight: 600;"><%= u.getUsername() %></td>
                    <td><%= u.getNamaLengkap() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getAlamat() %></td>
                    <td>
                        <% if ("admin".equalsIgnoreCase(u.getLevel())) { %>
                            <span class="status admin-badge">Admin</span>
                        <% } else { %>
                            <span class="status user-badge">Anggota</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="<%=request.getContextPath()%>/user?action=edit&id=<%= u.getIdUser() %>" class="btn-sm btn-warning">
                            <i class="fa-solid fa-pen-to-square"></i> Edit
                        </a>
                        <a href="<%=request.getContextPath()%>/user?action=delete&id=<%= u.getIdUser() %>" class="btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus user ini?')">
                            <i class="fa-solid fa-trash"></i> Hapus
                        </a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="empty">Belum ada data user terdaftar.</td>
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
