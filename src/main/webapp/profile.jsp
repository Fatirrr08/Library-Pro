<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="util.StringUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Saya - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">

    <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" media="print" onload="this.media='all'">

    <link rel="preload" as="style" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"></noscript>

    <link rel="preload" as="style" href="<%=request.getContextPath()%>/css/style-global.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-global.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.1/cropper.min.css">
    
    <style>
        .profile-dropdown-container {
            position: relative;
            display: inline-block;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            user-select: none;
            padding: 6px 12px;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        .user-profile:hover {
            background-color: #f1f5f9;
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-profile span {
            font-weight: 500;
            color: #334155;
        }

        /* Menu Dropdown Profil di Topbar */
        .dropdown-menu {
            position: absolute;
            right: 0;
            top: 55px;
            background-color: #ffffff;
            min-width: 180px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            padding: 8px 0;
            list-style: none;
            z-index: 1000;
            border: 1px solid #e2e8f0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s;
        }

        .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-menu li a {
            color: #334155;
            padding: 10px 15px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }

        .dropdown-menu li a:hover {
            background-color: #f8fafc;
            color: #2563eb;
        }

        .dropdown-menu li a.logout-link:hover {
            background-color: #fef2f2;
            color: #dc2626;
        }

        .dropdown-menu .divider {
            height: 1px;
            background-color: #e2e8f0;
            margin: 6px 0;
        }

        .profile-container {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 32px;
            align-items: start;
        }
        .profile-card {
            background-color: white;
            border-radius: var(--radius);
            padding: 32px 24px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 16px;
        }
        .profile-avatar-wrapper {
            position: relative;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid var(--primary-light);
            box-shadow: var(--shadow-md);
            margin-bottom: 8px;
        }
        .profile-avatar-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .profile-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--bg-dark);
        }
        .profile-role {
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            padding: 4px 12px;
            border-radius: 9999px;
            background-color: var(--primary-light);
            color: var(--primary);
            display: inline-block;
        }
        .profile-role.admin {
            background-color: var(--danger-light);
            color: var(--danger);
        }
        .profile-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            width: 100%;
            margin-top: 8px;
        }
        
        /* Crop Modal Styling */
        .crop-modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
        }
        .crop-modal-content {
            background-color: white;
            padding: 24px;
            border-radius: var(--radius);
            max-width: 450px;
            width: 90%;
            box-shadow: var(--shadow-lg);
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .crop-container {
            width: 100%;
            height: 300px;
            overflow: hidden;
            border-radius: 8px;
            background-color: #f1f5f9;
        }
        .crop-container img {
            max-width: 100%;
            display: block;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 8px;
        }

        /* ==================== STYLE ANIMASI POP-UP TOAST PREMIUM ==================== */
        .toast-notification {
            position: fixed;
            top: 25px;
            right: 25px;
            background: #ffffff;
            padding: 16px 22px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 9999;
            border-left: 6px solid #10b981; /* Garis Sukses Hijau */
            
            /* Sembunyi di luar layar kanan */
            transform: translateX(120%);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .toast-notification.toast-error {
            border-left-color: #ef4444; /* Garis Gagal Merah */
        }

        .toast-notification.show {
            transform: translateX(0); /* Meluncur masuk */
        }

        .toast-icon {
            font-size: 20px;
        }
        .toast-success .toast-icon { color: #10b981; }
        .toast-error .toast-icon { color: #ef4444; }

        .toast-message {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
        }

        /* ==================== DIATUR: STYLE OVERLAY MODAL BASE ==================== */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 2000;
            opacity: 0; visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        .modal-overlay.show {
            opacity: 1; visibility: visible;
        }

        /* ==================== STYLE MODAL KONFIRMASI LOGOUT ==================== */
        .logout-modal-box {
            background: #ffffff;
            width: 90%;
            max-width: 400px;
            border-radius: 14px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transform: scale(0.9);
            transition: transform 0.25s ease;
        }
        .modal-overlay.show .logout-modal-box {
            transform: scale(1);
        }
        .logout-warning-icon {
            font-size: 44px;
            color: #ef4444;
            background: #fef2f2;
            width: 80px;
            height: 80px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-bottom: 16px;
        }
        .logout-title {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }
        .logout-desc {
            font-size: 14px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 24px;
        }
        .logout-btn-container {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        .btn-confirm-logout {
            background-color: #ef4444;
            color: white !important;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: background-color 0.2s;
            flex: 1;
        }
        .btn-confirm-logout:hover { background-color: #dc2626; }
        .btn-cancel-logout {
            background-color: #f1f5f9;
            color: #334155;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s;
            flex: 1;
        }
        .btn-cancel-logout:hover { background-color: #e2e8f0; }
    </style>
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
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
        <% if ("admin".equalsIgnoreCase(loggedUser.getLevel())) { %>
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
                <a href="<%=request.getContextPath()%>/peminjaman">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman
                </a>
            </li>
        <% } else { %>
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
                    <i class="fa-solid fa-clock-rotate-left"></i> Peminjaman Saya
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/favorit">
                    <i class="fa-solid fa-star"></i> Favorit Saya
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/ulasan">
                    <i class="fa-solid fa-comments"></i> History Ulasan
                </a>
            </li>
        <% } %>
        <li>
            <a href="<%=request.getContextPath()%>/profile" class="active">
                <i class="fa-solid fa-user-gear"></i> Profil Saya
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button"><i class="fa-solid fa-bars"></i></button>
        <h2>Profil Saya</h2>
        
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="User">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
                <i class="fa-solid fa-chevron-down" style="font-size: 11px; color: #64748b;"></i>
            </div>
            
            <ul class="dropdown-menu" id="dropdownMenu">
                <li>
                    <a href="<%=request.getContextPath()%>/profile">
                        <i class="fa-solid fa-user-gear"></i> Profil Saya
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <a href="#" class="logout-link" id="logoutTrigger">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Kelola Profil</h1>
            <p>Perbarui informasi akun dan foto profil Anda.</p>
        </div>

        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
            <div class="toast-notification toast-success" id="profileToast">
                <div class="toast-icon"><i class="fa-solid fa-circle-check"></i></div>
                <div class="toast-message">Profil berhasil diperbarui!</div>
            </div>
        <%
            } else if ("photo_deleted".equals(status)) {
        %>
            <div class="toast-notification toast-success" id="profileToast">
                <div class="toast-icon"><i class="fa-solid fa-circle-check"></i></div>
                <div class="toast-message">Foto profil berhasil dihapus!</div>
            </div>
        <%
            } else if ("invalid_input".equals(status)) {
        %>
            <div class="toast-notification toast-error" id="profileToast">
                <div class="toast-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div class="toast-message">Nama dan Email tidak boleh kosong!</div>
            </div>
        <%
            } else if ("invalid_type".equals(status)) {
        %>
            <div class="toast-notification toast-error" id="profileToast">
                <div class="toast-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div class="toast-message">Format foto tidak valid (harus JPG, JPEG, atau PNG)!</div>
            </div>
        <%
            } else if ("file_too_large".equals(status)) {
        %>
            <div class="toast-notification toast-error" id="profileToast">
                <div class="toast-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div class="toast-message">Ukuran foto terlalu besar (maksimal 2MB)!</div>
            </div>
        <%
            } else if ("error".equals(status)) {
        %>
            <div class="toast-notification toast-error" id="profileToast">
                <div class="toast-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div class="toast-message">Terjadi kesalahan saat memperbarui profil!</div>
            </div>
        <%
            }
        %>

        <div class="profile-container">
            <div class="profile-card">
                <div class="profile-avatar-wrapper">
                    <img id="avatarPreview" src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Foto Profil">
                </div>
                <div>
                    <div class="profile-name"><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></div>
                    <div class="mt-1">
                        <span class="profile-role <%= "admin".equalsIgnoreCase(loggedUser.getLevel()) ? "admin" : "" %>">
                            <%= StringUtils.escapeHtml(loggedUser.getLevel()) %>
                        </span>
                    </div>
                </div>

                <div class="profile-actions">
                    <input type="file" id="avatarInput" accept="image/png, image/jpeg, image/jpg" style="display: none;">
                    <button type="button" class="btn-add justify-center" onclick="document.getElementById('avatarInput').click()">
                        <i class="fa-solid fa-camera"></i> Pilih Foto Baru
                    </button>
                    
                    <% if (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) { %>
                        <form action="<%= request.getContextPath() %>/profile" method="post" class="w-full">
                            <input type="hidden" name="action" value="delete_photo">
                            <button type="submit" class="btn-add w-full justify-center" style="background-color: var(--danger-light); color: var(--danger); box-shadow: none;">
                                <i class="fa-solid fa-trash-can"></i> Hapus Foto
                            </button>
                        </form>
                    <% } %>
                </div>
            </div>

            <div class="form-box" style="margin-bottom: 0;">
                <h3 class="table-title mb-5"><i class="fa-solid fa-user-edit"></i> Edit Informasi Profil</h3>
                
                <form action="<%= request.getContextPath() %>/profile" method="post" id="profileForm">
                    <input type="hidden" name="croppedImage" id="croppedImage">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Username (Tidak dapat diubah)</label>
                            <input type="text" value="<%= StringUtils.escapeHtml(loggedUser.getUsername()) %>" disabled style="background-color: #f1f5f9; color: var(--text-muted);">
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <input type="text" value="<%= StringUtils.escapeHtml(loggedUser.getLevel().toUpperCase()) %>" disabled style="background-color: #f1f5f9; color: var(--text-muted);">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Nama Lengkap</label>
                            <input type="text" name="namaLengkap" value="<%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %>" required placeholder="Masukkan nama lengkap Anda">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="text" name="email" value="<%= StringUtils.escapeHtml(loggedUser.getEmail()) %>" required placeholder="Masukkan email Anda">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Password Baru (Kosongkan jika tidak diubah)</label>
                            <input type="password" name="password" placeholder="Masukkan password baru">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Alamat</label>
                            <textarea name="alamat" rows="3" placeholder="Masukkan alamat Anda"><%= StringUtils.escapeHtml(loggedUser.getAlamat()) %></textarea>
                        </div>
                    </div>

                    <div class="mt-6 text-right">
                        <button type="submit" class="btn-add">
                            <i class="fa-solid fa-floppy-disk"></i> Simpan Profil
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="crop-modal" id="cropModal">
    <div class="crop-modal-content">
        <h3><i class="fa-solid fa-crop"></i> Potong Foto Profil</h3>
        <p style="color: var(--text-muted); font-size: 0.85rem;">Sesuaikan foto Anda agar presisi di area lingkaran.</p>
        
        <div class="crop-container">
            <img id="cropImage" src="" alt="Image to crop">
        </div>
        
        <div class="modal-footer">
            <button type="button" class="btn-add" id="btnCancelCrop" style="background-color: var(--text-muted); box-shadow: none;">
                Batal
            </button>
            <button type="button" class="btn-add" id="btnSaveCrop">
                Potong & Gunakan
            </button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="logout-warning-icon">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari akun LibraryPro saat ini? Anda harus login kembali untuk mengakses layanan.</div>
        <div class="logout-btn-container">
            <button class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
            <a href="<%=request.getContextPath()%>/logout" class="btn-confirm-logout">Ya, Keluar</a>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.1/cropper.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 1. Logika Dropdown Profil Atas
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

        // 2. TRIGGER ANIMASI POP-UP TOAST SELEPAS SUBMIT PROFIL
        const profileToast = document.getElementById("profileToast");
        if (profileToast) {
            // Muncul pelan-pelan (100ms) setelah muat halaman lengkap
            setTimeout(() => {
                profileToast.classList.add("show");
            }, 100);

            // Sembunyi kembali setelah 4 detik
            setTimeout(() => {
                profileToast.classList.remove("show");
            }, 4000);
        }

        // 3. LOGIKA INTERAKTIF MODAL KONFIRMASI LOGOUT
        const logoutTrigger = document.getElementById("logoutTrigger");
        const logoutModal = document.getElementById("logoutModal");
        const btnCancelLogout = document.getElementById("btnCancelLogout");

        if (logoutTrigger && logoutModal && btnCancelLogout) {
            logoutTrigger.addEventListener("click", function (e) {
                e.preventDefault(); // Menahan link '#' agar tidak scroll ke atas
                dropdownMenu.classList.remove("show"); // Sembunyikan menu dropdown profil terlebih dahulu
                logoutModal.classList.add("show"); // Tampilkan pop-up konfirmasi logout
            });

            btnCancelLogout.addEventListener("click", function () {
                logoutModal.classList.remove("show"); // Sembunyikan pop-up jika menekan tombol Batal
            });
        }

        // Global Event: Klik area luar untuk menutup modal apa pun yang sedang aktif
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });
    });

    // Logika Pemotongan Gambar (Cropper.js murni)
    let cropper;
    const avatarInput = document.getElementById('avatarInput');
    const cropModal = document.getElementById('cropModal');
    const cropImage = document.getElementById('cropImage');
    const croppedImageInput = document.getElementById('croppedImage');
    const avatarPreview = document.getElementById('avatarPreview');

    avatarInput.addEventListener('change', function(e) {
        const files = e.target.files;
        if (files && files.length > 0) {
            const file = files[0];
            
            if (!['image/jpeg', 'image/jpg', 'image/png'].includes(file.type)) {
                alert('Format file harus JPG, JPEG, atau PNG!');
                avatarInput.value = '';
                return;
            }
            
            if (file.size > 2 * 1024 * 1024) {
                alert('Ukuran file maksimal adalah 2MB!');
                avatarInput.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(event) {
                cropImage.src = event.target.result;
                cropModal.style.display = 'flex';
                
                if (cropper) {
                    cropper.destroy();
                }
                
                cropper = new Cropper(cropImage, {
                    aspectRatio: 1,
                    viewMode: 2,
                    autoCropArea: 0.8,
                    dragMode: 'move',
                    background: false,
                    cropBoxMovable: true,
                    cropBoxResizable: true
                });
            };
            reader.readAsDataURL(file);
        }
    });

    document.getElementById('btnCancelCrop').addEventListener('click', function() {
        cropModal.style.display = 'none';
        avatarInput.value = '';
        if (cropper) {
            cropper.destroy();
        }
    });

    document.getElementById('btnSaveCrop').addEventListener('click', function() {
        if (cropper) {
            const canvas = cropper.getCroppedCanvas({
                width: 300,
                height: 300
            });
            const dataURL = canvas.toDataURL('image/png');
            croppedImageInput.value = dataURL;
            avatarPreview.src = dataURL;
            cropModal.style.display = 'none';
        }
    });
</script>
<script src="<%=request.getContextPath()%>/js/icon-fallback.js"></script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
<div class="dark-mode-toggle" onclick="toggleDarkMode()" title="Toggle Dark Mode">
    <i class="fa-solid fa-moon"></i>
</div>
<script>
function toggleDarkMode() {
    var html = document.documentElement;
    var toggle = document.querySelector(".dark-mode-toggle i");
    if (html.getAttribute("data-theme") === "dark") {
        html.removeAttribute("data-theme");
        toggle.className = "fa-solid fa-moon";
        localStorage.setItem("theme", "light");
    } else {
        html.setAttribute("data-theme", "dark");
        toggle.className = "fa-solid fa-sun";
        localStorage.setItem("theme", "dark");
    }
}
(function () {
    var saved = localStorage.getItem("theme");
    if (saved === "dark") {
        document.documentElement.setAttribute("data-theme", "dark");
        var toggle = document.querySelector(".dark-mode-toggle i");
        if (toggle) toggle.className = "fa-solid fa-sun";
    }
})();
</script>
</body>
</html>