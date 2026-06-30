<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ulasan" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ulasan & Rating - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    
    <style>
        /* Gaya Dropdown Profil di Topbar */
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
            transition: background-color 0.2s, color 0.2s;
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

        /* Desain bintang emas untuk rating */
        .stars-orange {
            color: #eab308;
            gap: 2px;
            display: inline-flex;
        }
        
        /* ==================== FORM RATING INPUT RADIO STAR ==================== */
        .rating-input-container {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 6px;
            margin: 10px 0 20px 0;
        }
        .rating-input-container input {
            display: none;
        }
        .rating-input-container label {
            font-size: 28px;
            color: #cbd5e1;
            cursor: pointer;
            transition: color 0.15s ease, transform 0.1s ease;
        }
        .rating-input-container label:hover {
            transform: scale(1.15);
        }
        .rating-input-container input:checked ~ label,
        .rating-input-container label:hover,
        .rating-input-container label:hover ~ label {
            color: #eab308;
        }
        
        /* Form Card Layout */
        .form-card {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            max-width: 600px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #334155;
        }
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-family: inherit;
            resize: vertical;
            min-height: 120px;
            outline: none;
        }
        .form-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        /* Tombol Aksi Tabel Modern */
        .btn-action-table {
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-table-edit {
            background-color: #3b82f6;
            color: #ffffff !important;
        }
        .btn-table-edit:hover {
            background-color: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.2);
        }

        /* ==================== STYLE ANIMASI FLASH POP-UP NOTIFIKASI TOAST ==================== */
        .toast-notification {
            position: fixed; top: 25px; right: 25px; 
            padding: 16px 22px; border-radius: 12px; 
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

        /* ==================== BASE OVERLAY MODAL SYSTEM ==================== */
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

        .status-badge {
            display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; border-radius: 9999px; font-size: 12px; font-weight: 600; line-height: 1; text-transform: capitalize; text-decoration: none;
        }
        .status-badge.badge-waiting { background-color: #f1f5f9; color: #475569; }
    </style>
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"anggota".equalsIgnoreCase(loggedUser.getLevel())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Buku bukuMauDiulas = (Buku) request.getAttribute("buku");
    List<Ulasan> historyUlasan = (List<Ulasan>) request.getAttribute("historyUlasan");
    
    // 🌟 CAPTURE ATRIBUT BARU: Tangkap objek ulasan jika dipicu dari aksi=edit
    Ulasan editUlasan = (Ulasan) request.getAttribute("editUlasan");
%>

<div class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-book-open-reader"></i>
        <span>LibraryPro</span>
    </div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp"><i class="fa-solid fa-book-open"></i> Katalog Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/favorit"><i class="fa-solid fa-star"></i> Favorit Saya</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan" class="active"><i class="fa-solid fa-comments"></i> Ulasan & Rating Saya</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button"><i class="fa-solid fa-bars"></i></button>
        <h2><%= (bukuMauDiulas != null) ? (editUlasan != null ? "Edit Ulasan Buku" : "Tulis Ulasan Buku") : "History Ulasan Anda" %></h2>
        
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Anggota">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
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
        
        <% if (bukuMauDiulas != null) { %>
            <div class="table-header">
                <div class="table-title"><%= editUlasan != null ? "Perbarui Penilaian Anda" : "Berikan Penilaian Anda" %></div>
            </div>
            
            <div class="form-card" style="margin-top: 20px;">
                <h3 style="color: #1e293b; margin-bottom: 5px;"><%= StringUtils.escapeHtml(bukuMauDiulas.getJudul()) %></h3>
                <p style="color: #64748b; font-size: 14px; margin-bottom: 25px;">Karya: <%= StringUtils.escapeHtml(bukuMauDiulas.getPenulis()) %></p>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div style="background-color: #fef2f2; color: #dc2626; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
                        <%= StringUtils.escapeHtml(request.getAttribute("errorMessage")) %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/ulasan" method="POST">
                    <input type="hidden" name="idBuku" value="<%= bukuMauDiulas.getIdBuku() %>">
                    
                    <% if (editUlasan != null) { %>
                        <input type="hidden" name="idUlasan" value="<%= editUlasan.getIdUlasan() %>">
                    <% } %>
                    
                    <div class="form-group">
                        <label>Rating Buku</label>
                        <div class="rating-input-container">
                            <% int ratingLama = (editUlasan != null) ? editUlasan.getRating() : 0; %>
                            <input type="radio" id="star5" name="rating" value="5" required <%= ratingLama == 5 ? "checked" : "" %>/><label for="star5" class="fa-solid fa-star"></label>
                            <input type="radio" id="star4" name="rating" value="4" <%= ratingLama == 4 ? "checked" : "" %>/><label for="star4" class="fa-solid fa-star"></label>
                            <input type="radio" id="star3" name="rating" value="3" <%= ratingLama == 3 ? "checked" : "" %>/><label for="star3" class="fa-solid fa-star"></label>
                            <input type="radio" id="star2" name="rating" value="2" <%= ratingLama == 2 ? "checked" : "" %>/><label for="star2" class="fa-solid fa-star"></label>
                            <input type="radio" id="star1" name="rating" value="1" <%= ratingLama == 1 ? "checked" : "" %>/><label for="star1" class="fa-solid fa-star"></label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="ulasanText">Ulasan / Komentar Anda</label>
                        <textarea id="ulasanText" name="ulasan" placeholder="Tulis pendapat jujur Anda mengenai isi buku ini..." required><%= StringUtils.escapeHtml(editUlasan != null ? editUlasan.getUlasan() : "") %></textarea>
                    </div>
                    
                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn-add" style="border: none; cursor: pointer; height: 40px; padding: 0 20px;">
                            <i class="fa-solid fa-paper-plane"></i> <%= editUlasan != null ? "Perbarui Ulasan" : "Kirim Ulasan" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/ulasan" class="status-badge badge-waiting" style="height: 40px; padding: 0 20px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px;">
                            Batal
                        </a>
                    </div>
                </form>
            </div>

        <% } else { %>
            <div class="table-header">
                <div class="table-title">Semua Ulasan yang Pernah Anda Kirim</div>
            </div>

            <div class="table-container" style="margin-top: 20px;">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 50px; text-align: center;">No</th>
                            <th>Judul Buku</th>
                            <th style="width: 130px;">Rating</th>
                            <th>Isi Ulasan / Komentar</th>
                            <th style="width: 140px; text-align: center;">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (historyUlasan != null && !historyUlasan.isEmpty()) {
                                int no = 1;
                                for (Ulasan u : historyUlasan) {
                        %>
                        <tr>
                            <td style="text-align: center;"><%= no++ %></td>
                            <td style="font-weight: 600; color: #1e293b;">
                                <%= StringUtils.escapeHtml(u.getJudulBuku() != null ? u.getJudulBuku() : "ID Buku: " + u.getIdBuku()) %>
                            </td>
                            <td>
                                <div class="stars-orange">
                                    <% for(int i = 1; i <= u.getRating(); i++) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } %>
                                    <% for(int i = u.getRating() + 1; i <= 5; i++) { %>
                                        <i class="fa-solid fa-star" style="color: #cbd5e1;"></i>
                                    <% } %>
                                </div>
                            </td>
                            <td style="color: #475569; font-style: italic;">
                                "<%= StringUtils.escapeHtml(u.getUlasan()) %>"
                            </td>
                            <td style="text-align: center;">
                                <a href="<%= request.getContextPath() %>/ulasan?action=edit&idBuku=<%= u.getIdBuku() %>" class="btn-action-table btn-table-edit">
                                    <i class="fa-solid fa-pen-to-square"></i> Edit Ulasan
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5" class="empty">Anda belum pernah memberikan ulasan pada buku apa pun.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        <% } %>

    </div>
</div>

<div class="toast-notification" id="toastBox">
    <div class="toast-icon" id="toastIcon"></div>
    <div class="toast-message" id="toastMessage">Proses Berhasil!</div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="action-modal-box">
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        
        const toastBox = document.getElementById("toastBox");
        const toastIcon = document.getElementById("toastIcon");
        const toastMessage = document.getElementById("toastMessage");

        // 1. Logika Pemicu Animasi Pop-up Toast Sukses/Gagal Kirim Ulasan
        if (status && toastBox) {
            if (status === "success") {
                toastBox.classList.remove("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-check" style="color: #10b981;"></i>';
                toastMessage.innerText = "Berhasil memproses ulasan buku!";
                toastBox.classList.add("show");
            } else if (status === "fail") {
                toastBox.classList.add("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-xmark" style="color: #ef4444;"></i>';
                toastMessage.innerText = "Gagal memproses ulasan.";
                toastBox.classList.add("show");
            } 
            // 🌟 TAMBAHAN POP-UP KHUSUS JIKA TERDETEKSI DUPLIKAT DATA
            else if (status === "duplicate") {
                toastBox.classList.add("toast-error"); // Menggunakan border merah
                toastIcon.innerHTML = '<i class="fa-solid fa-triangle-exclamation" style="color: #ef4444;"></i>';
                toastMessage.innerText = "Anda sudah pernah mengulas buku ini! Silakan gunakan fitur Edit.";
                toastBox.classList.add("show");
            }

            // Sembunyikan otomatis dalam 3.5 detik dan bersihkan parameter URL
            setTimeout(() => {
                toastBox.classList.remove("show");
                const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            }, 3500);
        }

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

        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });
    });
</script>

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>