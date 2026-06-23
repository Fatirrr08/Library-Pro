<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen User - LibraryPro</title>
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

        /* ==================== STYLING ANIMASI FLASH POP-UP NOTIFIKASI ==================== */
        .toast-notification {
            position: fixed; top: 25px; right: 25px; 
            padding: 16px 22px; border-radius: 10px; 
            background: #ffffff; box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            display: flex; align-items: center; gap: 12px; z-index: 3000;
            border-left: 5px solid #10b981;
            transform: translateX(120%); transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        .toast-notification.show { transform: translateX(0); }
        .toast-notification.toast-error { border-left-color: #ef4444; }
        .toast-icon { font-size: 20px; color: #10b981; }
        .toast-error .toast-icon { color: #ef4444; }
        .toast-message { font-size: 14px; font-weight: 600; color: #1e293b; }

        /* Styling Umum Tombol Aksi Tabel User */
        .btn-action-table {
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-table-edit {
            background-color: #f59e0b;
            color: #ffffff !important;
        }
        .btn-table-edit:hover {
            background-color: #d97706;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(217, 119, 6, 0.2);
        }
        .btn-table-delete {
            background-color: #ef4444;
            color: #ffffff !important;
        }
        .btn-table-delete:hover {
            background-color: #dc2626;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(220, 38, 38, 0.2);
        }
        .action-cell-container {
            display: flex;
            justify-content: center;
            gap: 8px;
        }

        /* Style Modal Konfirmasi General */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 2000; opacity: 0; visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        .modal-overlay.show { opacity: 1; visibility: visible; }
        .logout-modal-box {
            background: #ffffff; width: 90%; max-width: 400px; border-radius: 14px; padding: 24px; text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: scale(0.9); transition: transform 0.25s ease;
        }
        .modal-overlay.show .logout-modal-box { transform: scale(1); }
        .logout-warning-icon { font-size: 44px; color: #ef4444; background: #fef2f2; width: 80px; height: 80px; display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; margin-bottom: 16px; }
        .logout-title { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .logout-desc { font-size: 14px; color: #64748b; line-height: 1.5; margin-bottom: 24px; }
        .logout-btn-container { display: flex; gap: 12px; justify-content: center; }
        .btn-confirm-logout { background-color: #ef4444; color: white !important; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; text-decoration: none; flex: 1; text-align: center; }
        .btn-cancel-logout { background-color: #f1f5f9; color: #334155; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; border: none; cursor: pointer; flex: 1; }
        .btn-cancel-logout:hover { background-color: #e2e8f0; }

        /* Badge Kustom untuk Level Akses */
        /* .status.admin-badge { background-color: #e0f2fe; color: #0369a1; font-weight: 700; padding: 4px 10px; border-radius: 6px; }
        .status.user-badge { background-color: #f1f5f9; color: #475569; font-weight: 600; padding: 4px 10px; border-radius: 6px; } */

        /* Core Styling untuk Badge Status Modern */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 9999px; /* Membuat bentuk pil/capsule sempurna */
            font-size: 12px;
            font-weight: 600;
            line-height: 1;
            text-transform: capitalize;
        }

        /* 1. Status: Menunggu Validasi (Kuning Amber Pastel) */
        .status-badge.badge-waiting {
            background-color: #fef3c7;
            color: #d97706;
        }

        /* 2. Status: Sedang Dipinjam / Aktif (Biru Sky Pastel) */
        .status-badge.badge-borrowed {
            background-color: #e0f2fe;
            color: #0369a1;
        }

        /* 3. Status: Dikembalikan / Tersedia (Hijau Emerald Pastel) */
        .status-badge.badge-returned {
            background-color: #dcfce7;
            color: #15803d;
        }

        /* 4. Status: Ditolak / Stok Habis (Merah Rose Pastel) */
        .status-badge.badge-rejected {
            background-color: #fef2f2;
            color: #ef4444;
        }
    </style>
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
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/buku"><i class="fa-solid fa-book"></i> Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/kategori"><i class="fa-solid fa-layer-group"></i> Kategori</a></li>
        <li><a href="<%=request.getContextPath()%>/user" class="active"><i class="fa-solid fa-users"></i> User</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan"><i class="fa-solid fa-comments"></i> Lihat Ulasan User</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button"><i class="fa-solid fa-bars"></i></button>
        <h2>Library Management System</h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Admin">
                <span><%= loggedUser.getNamaLengkap() %></span>
                <i class="fa-solid fa-chevron-down" style="font-size: 11px; color: #64748b;"></i>
            </div>
            <ul class="dropdown-menu" id="dropdownMenu">
                <li><a href="<%=request.getContextPath()%>/profile"><i class="fa-solid fa-user-gear"></i> Profil Saya</a></li>
                <li class="divider"></li>
                <li><a href="#" class="logout-link" id="logoutTrigger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Manajemen User</h1>
            <p>Kelola data kredensial administrator serta entri keanggotaan perpustakaan secara aman.</p>
        </div>

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
                    <button type="submit" class="btn-add" style="border: none; cursor: pointer;">
                        <i class="fa-solid fa-floppy-disk"></i> <%= editUser != null ? "Perbarui User" : "Simpan User" %>
                    </button>
                    <% if (editUser != null) { %>
                        <a href="<%=request.getContextPath()%>/user" class="btn-add" style="background-color: #94a3b8; text-decoration: none; display: inline-flex; align-items: center;">
                            Batal
                        </a>
                    <% } %>
                </div>
            </form>
        </div>

        <div class="table-container" style="margin-top: 30px;">
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
                    <th style="text-align: center;">Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (daftarUser != null && !daftarUser.isEmpty()) {
                        for (User u : daftarUser) {
                %>
                <tr>
                    <td><%= u.getIdUser() %></td>
                    <td style="font-weight: 600; color: #1e293b;"><%= u.getUsername() %></td>
                    <td><%= u.getNamaLengkap() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getAlamat() %></td>
                    <td>
                        <% if ("admin".equalsIgnoreCase(u.getLevel())) { %>
                            <span class="status-badge badge-borrowed">
                                <i class="fa-solid fa-user-shield"></i> Admin
                            </span>
                        <% } else { %>
                            <span class="status-badge badge-waiting" style="background-color: #f1f5f9; color: #475569;">
                                <i class="fa-solid fa-user"></i> Anggota
                            </span>
                        <% } %>
                    </td>
                    <td>
                        <div class="action-cell-container">
                            <a href="<%=request.getContextPath()%>/user?action=edit&id=<%= u.getIdUser() %>" class="btn-action-table btn-table-edit">
                                <i class="fa-solid fa-pen-to-square"></i> Edit
                            </a>
                            <button type="button" 
                                    class="btn-action-table btn-table-delete btn-delete-user-trigger" 
                                    data-id="<%= u.getIdUser() %>" 
                                    data-nama="<%= u.getNamaLengkap() %>">
                                <i class="fa-solid fa-trash"></i> Hapus
                            </button>
                        </div>
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

<div class="toast-notification" id="toastBox">
    <div class="toast-icon" id="toastIcon"></div>
    <div class="toast-message" id="toastMessage">Proses Berhasil!</div>
</div>

<div class="modal-overlay" id="deleteUserModal">
    <div class="logout-modal-box">
        <div class="logout-warning-icon" style="background-color: #fef2f2; color: #ef4444;">
            <i class="fa-solid fa-user-xmark"></i>
        </div>
        <div class="logout-title">Hapus Pengguna Permanen?</div>
        <div class="logout-desc">
            Apakah Anda yakin ingin menghapus akun milik <br>
            <strong id="deleteTargetUser" style="color: #1e293b;">[Nama Lengkap]</strong> secara permanen dari sistem?
        </div>
        <div class="logout-btn-container">
            <button class="btn-cancel-logout" id="btnCancelUserDelete">Batal</button>
            <a href="#" class="btn-confirm-logout" id="btnConfirmUserDelete" style="background-color: #ef4444;">Ya, Hapus</a>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="logout-warning-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari panel admin LibraryPro?</div>
        <div class="logout-btn-container">
            <button class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
            <a href="<%=request.getContextPath()%>/logout" class="btn-confirm-logout">Ya, Keluar</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        
        const toastBox = document.getElementById("toastBox");
        const toastIcon = document.getElementById("toastIcon");
        const toastMessage = document.getElementById("toastMessage");

        // 1. Logika Toast Pop-up Status Transaksi
        if (status && toastBox) {
            if (status === "success") {
                toastBox.classList.remove("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-check"></i>';
                toastMessage.innerText = "Data user berhasil disimpan!";
                toastBox.classList.add("show");
            } else if (status === "deleted") { 
                toastBox.classList.remove("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-check"></i>';
                toastMessage.innerText = "Akun user berhasil dihapus!";
                toastBox.classList.add("show");
            } else if (status === "fail") {
                toastBox.classList.add("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-xmark"></i>';
                toastMessage.innerText = "Gagal memproses data user.";
                toastBox.classList.add("show");
            }

            setTimeout(() => {
                toastBox.classList.remove("show");
                const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            }, 3500);
        }

        // 2. Dropdown Profile Navigasi Topbar
        const profileTrigger = document.getElementById("profileTrigger");
        const dropdownMenu = document.getElementById("dropdownMenu");

        if (profileTrigger && dropdownMenu) {
            profileTrigger.addEventListener("click", function (event) {
                event.stopPropagation();
                dropdownMenu.classList.toggle("show");
            });
            document.addEventListener("click", function (event) {
                if (!profileTrigger.contains(event.target) && !dropdownMenu.contains(event.target)) {
                    dropdownMenu.classList.remove("show");
                }
            });
        }

        // 3. Logika Dialog Modal Hapus User Kustom
        const deleteTriggers = document.querySelectorAll(".btn-delete-user-trigger");
        const deleteUserModal = document.getElementById("deleteUserModal");
        const deleteTargetUser = document.getElementById("deleteTargetUser");
        const btnConfirmUserDelete = document.getElementById("btnConfirmUserDelete");
        const btnCancelUserDelete = document.getElementById("btnCancelUserDelete");

        deleteTriggers.forEach(btn => {
            btn.addEventListener("click", function () {
                const idUser = this.getAttribute("data-id");
                const namaUser = this.getAttribute("data-nama");
                
                deleteTargetUser.innerText = "» " + namaUser;
                btnConfirmUserDelete.setAttribute("href", "<%=request.getContextPath()%>/user?action=delete&id=" + idUser);
                
                deleteUserModal.classList.add("show");
            });
        });

        if (btnCancelUserDelete) {
            btnCancelUserDelete.addEventListener("click", function () {
                deleteUserModal.classList.remove("show");
            });
        }

        // 4. Logika Dialog Konfirmasi Logout
        const logoutTrigger = document.getElementById("logoutTrigger");
        const logoutModal = document.getElementById("logoutModal");
        const btnCancelLogout = document.getElementById("btnCancelLogout");

        if (logoutTrigger && logoutModal && btnCancelLogout) {
            logoutTrigger.addEventListener("click", function (e) {
                e.preventDefault();
                dropdownMenu.classList.remove("show");
                logoutModal.classList.add("show");
            });
            btnCancelLogout.addEventListener("click", function () {
                logoutModal.classList.remove("show");
            });
        }

        // Global Event: Tutup modal saat klik area overlay kosong di luar boks
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) logoutModal.classList.remove("show");
            if (e.target === deleteUserModal) deleteUserModal.classList.remove("show");
        });
    });
</script>

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>