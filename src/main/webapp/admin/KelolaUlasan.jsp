<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ulasan" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Ulasan User - LibraryPro</title>
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

        /* Rating Star Emas */
        .stars-orange {
            color: #eab308;
            gap: 2px;
            display: inline-flex;
        }

        /* Tombol Aksi Moderasi Hapus */
        .btn-action-table {
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s ease;
        }
        .btn-table-delete {
            background-color: #fee2e2; color: #ef4444 !important;
        }
        .btn-table-delete:hover {
            background-color: #fca5a5; transform: translateY(-1px);
        }

        /* Base Overlay Modal System */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 2000; opacity: 0; visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        .modal-overlay.show { opacity: 1; visibility: visible; }
        .action-modal-box {
            background: #ffffff; width: 90%; max-width: 400px; border-radius: 14px; padding: 24px; text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: scale(0.9); transition: transform 0.25s ease;
        }
        .modal-overlay.show .action-modal-box { transform: scale(1); }
        .logout-warning-icon { font-size: 44px; color: #ef4444; background: #fef2f2; width: 80px; height: 80px; display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; margin-bottom: 16px; }
        .logout-title { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .logout-desc { font-size: 14px; color: #64748b; line-height: 1.5; margin-bottom: 24px; }
        .logout-btn-container { display: flex; gap: 12px; justify-content: center; }
        .btn-confirm-logout { background-color: #ef4444; color: white !important; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; text-decoration: none; flex: 1; text-align: center; }
        .btn-cancel-logout { background-color: #f1f5f9; color: #334155; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; border: none; cursor: pointer; flex: 1; }
        .btn-cancel-logout:hover { background-color: #e2e8f0; }

        /* Style Animasi Toast Pop-Up */
        .toast-notification {
            position: fixed; top: 25px; right: 25px; padding: 16px 22px; border-radius: 12px; background: #ffffff; box-shadow: 0 10px 25px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 12px; z-index: 3000; border-left: 5px solid #10b981; transform: translateX(120%); transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        .toast-notification.show { transform: translateX(0); }
        .toast-notification.toast-error { border-left-color: #ef4444; }
        .toast-icon { font-size: 20px; color: #10b981; }
        .toast-error .toast-icon { color: #ef4444; }
        .toast-message { font-size: 14px; font-weight: 600; color: #1e293b; }
    </style>
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
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/buku"><i class="fa-solid fa-book"></i> Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/kategori"><i class="fa-solid fa-layer-group"></i> Kategori</a></li>
        <li><a href="<%=request.getContextPath()%>/user"><i class="fa-solid fa-users"></i> User</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan" class="active"><i class="fa-solid fa-comments"></i> Lihat Ulasan User</a></li>
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
            <h1>Moderasi Ulasan Komunitas</h1>
            <p>Pantau seluruh opini pembaca perpustakaan dan bersihkan komentar berbau spam atau toxic.</p>
        </div>

        <div class="table-container" style="margin-top: 32px;">
            <div class="table-header">
                <div class="table-title">Daftar Semua Ulasan Pembaca</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th style="width: 60px; text-align: center;">No</th>
                    <th>Nama Pembaca</th>
                    <th>Judul Buku</th>
                    <th style="width: 130px;">Rating</th>
                    <th>Isi Ulasan / Komentar</th>
                    <th style="width: 120px; text-align: center;">Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Ulasan> semuaUlasan = (List<Ulasan>) request.getAttribute("semuaUlasan");
                    if (semuaUlasan != null && !semuaUlasan.isEmpty()) {
                        int no = 1;
                        for (Ulasan u : semuaUlasan) {
                %>
                <tr>
                    <td style="text-align: center;"><%= no++ %></td>
                    <td style="font-weight: 600; color: #1e293b;">
                        <i class="fa-regular fa-user" style="font-size: 12px; color: #64748b; margin-right: 4px;"></i>
                        <%= u.getNamaLengkap() != null ? u.getNamaLengkap() : u.getUsername() %>
                    </td>
                    <td style="font-weight: 500; color: #2563eb;"><%= u.getJudulBuku() %></td>
                    <td>
                        <div class="stars-orange">
                            <% for(int i = 1; i <= u.getRating(); i++) { %><i class="fa-solid fa-star"></i><% } %>
                            <% for(int i = u.getRating() + 1; i <= 5; i++) { %><i class="fa-solid fa-star" style="color: #cbd5e1;"></i><% } %>
                        </div>
                    </td>
                    <td style="color: #475569; font-style: italic; max-width: 350px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                        "<%= u.getUlasan() %>"
                    </td>
                    <td style="text-align: center;">
                        <button type="button" 
                                class="btn-action-table btn-table-delete btn-trigger-delete" 
                                data-id="<%= u.getIdUlasan() %>">
                            <i class="fa-solid fa-trash-can"></i> Hapus
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" class="empty">Belum ada ulasan yang diposting oleh anggota perpustakaan.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal-overlay" id="deleteUlasanModal">
    <div class="action-modal-box">
        <div class="logout-warning-icon">
            <i class="fa-solid fa-trash-can" style="color: #ef4444;"></i>
        </div>
        <div class="logout-title">Konfirmasi Hapus Ulasan</div>
        <div class="logout-desc">Apakah Anda yakin ingin menghapus ulasan dari pembaca ini? Tindakan moderasi ini bersifat permanen di dalam database.</div>
        <div class="logout-btn-container">
            <button type="button" class="btn-cancel-logout" id="btnCancelDelete">Batal</button>
            <a href="#" class="btn-confirm-logout" id="btnConfirmDelete">Ya, Hapus</a>
        </div>
    </div>
</div>

<div class="toast-notification" id="toastBox">
    <div class="toast-icon" id="toastIcon"></div>
    <div class="toast-message" id="toastMessage">Proses Berhasil!</div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="action-modal-box">
        <div class="logout-warning-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari panel admin LibraryPro?</div>
        <div class="logout-btn-container">
            <button type="button" class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
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

        // 1. Logika Notifikasi Toast Hasil Moderasi Hapus
        if (status && toastBox) {
            if (status === "deleted") {
                toastBox.classList.remove("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-check" style="color: #10b981;"></i>';
                toastMessage.innerText = "Ulasan berhasil dihapus dari sistem!";
                toastBox.classList.add("show");
            } else if (status === "fail") {
                toastBox.classList.add("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-xmark" style="color: #ef4444;"></i>';
                toastMessage.innerText = "Gagal memproses moderasi ulasan.";
                toastBox.classList.add("show");
            }

            setTimeout(() => {
                toastBox.classList.remove("show");
                const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            }, 3500);
        }

        // 2. Logika Dropdown Profil Atas
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

        // 3. Logika Pop-up Modal Konfirmasi Logout
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

        // 🌟 4. LOGIKA JAVASCRIPT CUSTOM MODAL HAPUS ULASAN
        const deleteUlasanModal = document.getElementById("deleteUlasanModal");
        const btnCancelDelete = document.getElementById("btnCancelDelete");
        const btnConfirmDelete = document.getElementById("btnConfirmDelete");
        const deleteButtons = document.querySelectorAll(".btn-trigger-delete");

        deleteButtons.forEach(button => {
            button.addEventListener("click", function () {
                const idUlasan = this.getAttribute("data-id");
                // Set parameter href tujuan penghapusan secara dinamis ke tag <a> di dalam modal
                btnConfirmDelete.href = "<%= request.getContextPath() %>/ulasan?action=delete&id=" + idUlasan;
                deleteUlasanModal.classList.add("show");
            });
        });

        if (btnCancelDelete) {
            btnCancelDelete.addEventListener("click", function () {
                deleteUlasanModal.classList.remove("show");
            });
        }

        // Klik area luar untuk menutup kedua jenis modal box
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) {
                logoutModal.getContextPath().remove("show");
            }
            if (e.target === deleteUlasanModal) {
                deleteUlasanModal.classList.remove("show");
            }
        });
    });
</script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>