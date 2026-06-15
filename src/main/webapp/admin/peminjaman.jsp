<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Peminjaman" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Peminjaman - LibraryPro</title>
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

        /* Custom Badge Warna Status Verifikasi & Sirkulasi */
        .status.waiting { background-color: #fef3c7; color: #d97706; } /* Kuning Mas */
        .status.rejected { background-color: #fee2e2; color: #ef4444; } /* Merah Cerah */
        
        .btn-action-container { display: flex; gap: 6px; }
        .denda-active { color: #dc2626; font-weight: 700; }

        /* Efek Hover Kustom untuk Tombol Setujui (Hijau) */
        .btn-action-setujui {
            text-decoration: none; 
            background-color: #10b981; 
            color: #ffffff !important; 
            padding: 6px 12px; 
            border-radius: 6px; 
            font-weight: 600; 
            font-size: 13px; 
            display: inline-flex; 
            align-items: center; 
            gap: 4px; 
            border: none;
            transition: background-color 0.2s ease, transform 0.1s ease;
        }

        .btn-action-setujui:hover {
            background-color: #059669 !important; /* Warna hijau berubah lebih gelap saat di-hover */
            transform: translateY(-1px); /* Efek sedikit terangkat */
        }

        /* Efek Hover Kustom untuk Tombol Tolak (Merah) */
        .btn-action-tolak {
            text-decoration: none; 
            background-color: #ef4444; 
            color: #ffffff !important; 
            padding: 6px 12px; 
            border-radius: 6px; 
            font-weight: 600; 
            font-size: 13px; 
            display: inline-flex; 
            align-items: center; 
            gap: 4px; 
            border: none;
            transition: background-color 0.2s ease, transform 0.1s ease;
        }

        .btn-action-tolak:hover {
            background-color: #dc2626 !important; /* Warna merah berubah lebih gelap saat di-hover */
            transform: translateY(-1px); /* Efek sedikit terangkat */
        }

        /* Style Modal Konfirmasi Logout */
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
    </style>
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
    
    // Format Mata Uang Rupiah
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
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
        <li><a href="<%=request.getContextPath()%>/peminjaman" class="active"><i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
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
            <h1>Manajemen & Validasi Peminjaman</h1>
            <p>Otorisasi permintaan sirkulasi buku baru serta pantau akumulasi denda keterlambatan pengembalian (Maks 1 Bulan, Rp 1.000/hari).</p>
        </div>

        <div class="form-box">
            <div class="table-title" style="margin-bottom: 20px;">Catat Peminjaman Langsung (Otomatis Disetujui)</div>
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

                <button type="submit" class="btn-add" style="margin-top: 10px; border:none; cursor:pointer;">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i> Daftarkan Peminjaman
                </button>
            </form>
        </div>

        <div class="table-container">
            <div class="table-header">
                <div class="table-title">Daftar Peminjaman Buku Keseluruhan</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama Anggota</th>
                    <th>Judul Buku</th>
                    <th>Tanggal Pinjam</th>
                    <th style="color: #e28743;">Batas Pengembalian</th> <th>Tanggal Kembali</th>    
                    <th>Status</th>
                    <th>Total Denda</th>
                    <th style="text-align: center;">Aksi Otoritas</th>
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
                    <td><%= p.getTanggalPinjam() != null ? p.getTanggalPinjam() : "-" %></td>
                    <td style="font-weight: 600; color: #334155;"><%= p.getTanggalTenggat() != null ? p.getTanggalTenggat() : "-" %></td> <td><%= p.getTanggalKembali() != null ? p.getTanggalKembali() : "-" %></td>
                    <td>
                        <% if ("menunggu".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status waiting">Menunggu Validasi</span>
                        <% } else if ("disetujui".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status borrowed">Sedang Dipinjam</span>
                        <% } else if ("ditolak".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status rejected">Ditolak Admin</span>
                        <% } else { %>
                            <span class="status returned">Dikembalikan</span>
                        <% } %>
                    </td>
                    <td>
                        <span class="<%= (p.getDenda() > 0) ? "denda-active" : "" %>">
                            <%= rpFormat.format(p.getDenda()) %>
                        </span>
                    </td>
                    <td style="text-align: center;">
                        <% if ("menunggu".equalsIgnoreCase(p.getStatus())) { %>
                            <div class="btn-action-container" style="display: flex; gap: 6px; justify-content: center;">
                                <a href="<%=request.getContextPath()%>/peminjaman?action=setujui&id=<%= p.getIdPeminjaman() %>" 
                                class="btn-action-setujui"
                                onclick="return confirm('Apakah Anda yakin ingin MENYETUJUI permintaan peminjaman buku untuk \nAnggota: <%= p.getNamaLengkap() %> \nBuku: <%= p.getJudulBuku() %>?');">
                                    <i class="fa-solid fa-check"></i> Setujui
                                </a>
                                <a href="<%=request.getContextPath()%>/peminjaman?action=tolak&id=<%= p.getIdPeminjaman() %>" 
                                class="btn-action-tolak"
                                onclick="return confirm('Apakah Anda yakin ingin MENOLAK permintaan peminjaman buku untuk \nAnggota: <%= p.getNamaLengkap() %> \nBuku: <%= p.getJudulBuku() %>?');">
                                    <i class="fa-solid fa-xmark"></i> Tolak
                                </a>
                            </div>
                        <% } else if ("disetujui".equalsIgnoreCase(p.getStatus())) { %>
                            <a href="<%=request.getContextPath()%>/peminjaman?action=kembalikan&id=<%= p.getIdPeminjaman() %>" class="btn-sm btn-success" style="text-decoration: none;">
                                <i class="fa-solid fa-arrow-left-long"></i> Tandai Kembali
                            </a>
                        <% } else { %>
                            <span style="color: var(--text-muted); font-size: 0.85rem;"><i class="fa-solid fa-lock"></i> Selesai</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9" class="empty">Belum ada riwayat transaksi sirkulasi peminjaman.</td>
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
        // 1. Logika Toggle Dropdown Profil Atas
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

        // 2. Logika Pop-up Dialog Konfirmasi Logout
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

        // Klik Area Luar untuk Menutup Modal
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });
    });
</script>

</body>
</html>