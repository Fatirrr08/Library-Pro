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

        /* ==================== STYLE ANIMASI POP-UP TOAST ==================== */
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
            border-left: 6px solid #10b981; /* Default sukses (Hijau) */
            
            /* Animasi geser masuk dari kanan */
            transform: translateX(120%);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .toast-notification.toast-error {
            border-left-color: #ef4444; /* Gagal (Merah) */
        }

        .toast-notification.show {
            transform: translateX(0);
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
                <i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/favorit">
                <i class="fa-solid fa-star"></i> Favorit Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/ulasan">
                <i class="fa-solid fa-comments"></i> Ulasan & Rating Saya
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Riwayat Peminjaman Anda</h2>
        
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Anggota">
                <span><%= loggedUser.getNamaLengkap() %></span>
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
            <h1>Riwayat Peminjaman</h1>
            <p>Lihat status buku yang Anda pinjam dan lakukan pengembalian secara mandiri.</p>
        </div>

        <%
            String statusParam = request.getParameter("status");
            if ("success".equals(statusParam)) {
        %>
            <div class="toast-notification toast-success" id="popupToast">
                <div class="toast-icon"><i class="fa-solid fa-circle-check"></i></div>
                <div class="toast-message">Peminjaman buku berhasil dicatat! Selamat membaca!</div>
            </div>
        <%
            } else if ("fail".equals(statusParam)) {
        %>
            <div class="toast-notification toast-error" id="popupToast">
                <div class="toast-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div class="toast-message">Gagal melakukan peminjaman. Stok buku habis!</div>
            </div>
        <%
            }
        %>

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
                            <a href="<%=request.getContextPath()%>/peminjaman?action=kembalikan&id=<%= p.getIdPeminjaman() %>" class="btn-sm btn-success" style="text-decoration: none;">
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

<script src="<%=request.getContextPath()%>/js/script.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 1. Logika Dropdown Profil
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

        // 2. LOGIKA ANIMASI POP-UP TOAST SLIDE IN-OUT
        const popupToast = document.getElementById("popupToast");
        if (popupToast) {
            // Memunculkan pop-up dengan delay halus (100ms) setelah page load
            setTimeout(() => {
                popupToast.classList.add("show");
            }, 100);

            // Menyembunyikan pop-up kembali setelah 4 detik (4000ms)
            setTimeout(() => {
                popupToast.classList.remove("show");
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
</script>

</body>
</html>