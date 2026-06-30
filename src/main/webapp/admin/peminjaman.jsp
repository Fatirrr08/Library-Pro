<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Peminjaman" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Peminjaman - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">

    <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" media="print" onload="this.media='all'">

    <link rel="preload" as="style" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"></noscript>
    <script>(function(){var d=document;setTimeout(function(){for(var s=d.styleSheets,i=0;i<s.length;i++){if(s[i].href&&s[i].href.indexOf('font-awesome')>-1)return}var l=d.createElement('link');l.rel='stylesheet';l.href='https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/css/all.min.css';d.head.appendChild(l)},2500)})();</script>

    <link rel="preload" as="style" href="<%=request.getContextPath()%>/css/style-global.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-global.css">
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
        
        .btn-action-container { display: flex; gap: 6px; justify-content: center; }
        .denda-active { color: #dc2626; font-weight: 700; }

        /* ==================== STYLING GENERAL UNTUK TOMBOL AKSI TABEL ==================== */
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

        /* Tombol Setujui (Hijau Emerald) */
        .btn-action-setujui {
            background-color: #10b981;
            color: #ffffff !important;
        }
        .btn-action-setujui:hover {
            background-color: #059669 !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);
        }

        /* Tombol Tolak (Merah Rose) */
        .btn-action-tolak {
            background-color: #ef4444;
            color: #ffffff !important;
        }
        .btn-action-tolak:hover {
            background-color: #dc2626 !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.2);
        }

        /* Tombol Tandai Kembali (Biru Indigo / Sukses Pastel) */
        .btn-table-return {
            background-color: #2563eb;
            color: #ffffff !important;
        }
        .btn-table-return:hover {
            background-color: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
        }

        /* ==================== STYLING MODAL KONFIRMASI SIRKULASI ==================== */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 2000; opacity: 0; visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        .modal-overlay.show { opacity: 1; visibility: visible; }
        .action-modal-box {
            background: #ffffff; width: 90%; max-width: 420px; border-radius: 14px; padding: 24px; text-align: center;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: scale(0.9); transition: transform 0.25s ease;
        }
        .modal-overlay.show .action-modal-box { transform: scale(1); }

        .modal-action-icon { 
            font-size: 44px; width: 80px; height: 80px; 
            display: inline-flex; align-items: center; justify-content: center; 
            border-radius: 50%; margin-bottom: 16px; 
        }
        .modal-action-icon.icon-reject { color: #ef4444; background: #fef2f2; }
        .modal-action-icon.icon-approve { color: #10b981; background: #dcfce7; }

        .modal-action-title { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .modal-action-desc { font-size: 14px; color: #64748b; line-height: 1.6; margin-bottom: 20px; text-align: left; background: #f8fafc; padding: 12px 16px; border-radius: 8px; border: 1px solid #f1f5f9; }
        .modal-action-desc strong { color: #1e293b; font-weight: 600; }

        .modal-btn-container { display: flex; gap: 12px; justify-content: center; margin-top: 24px; }
        .btn-modal-confirm { padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; text-decoration: none; flex: 1; text-align: center; color: white !important; }
        .btn-modal-cancel { background-color: #f1f5f9; color: #334155; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; border: none; cursor: pointer; flex: 1; transition: background-color 0.2s; }
        .btn-modal-cancel:hover { background-color: #e2e8f0; }

        /* Core Styling untuk Badge Status Modern */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 600;
            line-height: 1;
            text-transform: capitalize;
        }
        .status-badge.badge-waiting { background-color: #fef3c7; color: #d97706; }
        .status-badge.badge-borrowed { background-color: #e0f2fe; color: #0369a1; }
        .status-badge.badge-returned { background-color: #dcfce7; color: #15803d; }
        .status-badge.badge-rejected { background-color: #fef2f2; color: #ef4444; }
        /* Tombol Sudah Dibayar (Orange Amber dengan Efek Hover Kustom) */
        .btn-action-dibayar {
            background-color: #ea580c;
            color: #ffffff !important;
        }
        .btn-action-dibayar:hover {
            background-color: #c2410c !important; /* Warna orange agak gelap saat di-hover */
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(234, 88, 12, 0.2);
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

    List<Peminjaman> daftarPeminjaman = (List<Peminjaman>) request.getAttribute("daftarPeminjaman");
    List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
    List<User> daftarUser = (List<User>) request.getAttribute("daftarUser");
    
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
        <li><a href="<%=request.getContextPath()%>/ulasan"><i class="fa-solid fa-comments"></i> Lihat Ulasan User</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button"><i class="fa-solid fa-bars"></i></button>
        <h2>Library Management System</h2>
        
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" loading="lazy" onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/uploads/profile/default.png'" alt="Admin">
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
                                <option value="<%= u.getIdUser() %>"><%= StringUtils.escapeHtml(u.getNamaLengkap()) %> (<%= StringUtils.escapeHtml(u.getUsername()) %>)</option>
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
                                    <%= StringUtils.escapeHtml(b.getJudul()) %> <%= b.getJmlBuku() <= 0 ? "[STOK HABIS]" : "(Stok: " + b.getJmlBuku() + ")" %>
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
                    <th style="color: #e28743;">Batas Pengembalian</th> 
                    <th>Tanggal Kembali</th>    
                    <th>Status</th>
                    <th>Total Denda</th>
                    <th style="text-align: center;">Aksi Otoritas</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (daftarPeminjaman != null && !daftarPeminjaman.isEmpty()) {
                        for (Peminjaman p : daftarPeminjaman) {
                            // 🌟 SOLUSI OPTIMASI: Definisi variabel warna denda untuk membersihkan warning editor
                            String warnaDenda = (p.getDenda() > 0) ? "#ef4444" : "#64748b";
                %>
                <tr>
                    <td><%= p.getIdPeminjaman() %></td>
                    <td>
                        <span style="font-weight: 600; color: #1e293b;"><%= StringUtils.escapeHtml(p.getNamaLengkap()) %></span><br>
                        <small style="color: var(--text-muted);">@<%= StringUtils.escapeHtml(p.getUsername()) %></small>
                    </td>
                    <td style="font-weight: 500;"><%= StringUtils.escapeHtml(p.getJudulBuku()) %></td>
                    <td><%= StringUtils.escapeHtml(p.getTanggalPinjam() != null ? p.getTanggalPinjam() : "-") %></td>
                    <td style="font-weight: 600; color: #ea580c;">
                        <%= StringUtils.escapeHtml(p.getTanggalTenggat() != null ? p.getTanggalTenggat() : "-") %>
                    </td> 
                    <td><%= StringUtils.escapeHtml(p.getTanggalKembali() != null ? p.getTanggalKembali() : "-") %></td>
                    <td>
                        <% if ("menunggu".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status-badge badge-waiting">
                                <i class="fa-regular fa-clock"></i> Menunggu Validasi
                            </span>
                        <% } else if ("disetujui".equalsIgnoreCase(p.getStatus()) || "dipinjam".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status-badge badge-borrowed">
                                <i class="fa-solid fa-book-reader"></i> Sedang Dipinjam
                            </span>
                        <% } else if ("ditolak".equalsIgnoreCase(p.getStatus())) { %>
                            <span class="status-badge badge-rejected">
                                <i class="fa-solid fa-circle-xmark"></i> Ditolak Admin
                            </span>
                        <% } else { %>
                            <span class="status-badge badge-returned">
                                <i class="fa-solid fa-circle-check"></i> Dikembalikan
                            </span>
                        <% } %>
                    </td>
                    <td>
                        <span class="<%= (p.getDenda() > 0) ? "denda-active" : "" %>">
                            <%= rpFormat.format(p.getDenda()) %>
                        </span>
                    </td>
                    <td style="text-align: center;">
                        <% if ("menunggu".equalsIgnoreCase(p.getStatus())) { %>
                            <div class="btn-action-container">
                                <button type="button" 
                                        class="btn-action-table btn-action-setujui btn-approve-modal-trigger"
                                        data-id="<%= p.getIdPeminjaman() %>"
                                        data-anggota="<%= StringUtils.escapeHtml(p.getNamaLengkap()) %>"
                                        data-buku="<%= StringUtils.escapeHtml(p.getJudulBuku()) %>">
                                    <i class="fa-solid fa-check"></i> Setujui
                                </button>
                                
                                <button type="button" 
                                        class="btn-action-table btn-action-tolak btn-reject-modal-trigger"
                                        data-id="<%= p.getIdPeminjaman() %>"
                                        data-anggota="<%= StringUtils.escapeHtml(p.getNamaLengkap()) %>"
                                        data-buku="<%= StringUtils.escapeHtml(p.getJudulBuku()) %>">
                                    <i class="fa-solid fa-xmark"></i> Tolak
                                </button>
                            </div>
                        <% } else if ("disetujui".equalsIgnoreCase(p.getStatus()) || "dipinjam".equalsIgnoreCase(p.getStatus())) { %>
                            <% if (p.getDenda() > 0) { %>
                                <a href="<%=request.getContextPath()%>/peminjaman?action=kembalikan&id=<%= p.getIdPeminjaman() %>" 
                                class="btn-action-table btn-action-dibayar">
                                    <i class="fa-solid fa-money-bill-wave"></i> Sudah Dibayar
                                </a>
                            <% } else { %>
                                <a href="<%=request.getContextPath()%>/peminjaman?action=kembalikan&id=<%= p.getIdPeminjaman() %>" 
                                class="btn-action-table btn-table-return">
                                    <i class="fa-solid fa-arrow-left-long"></i> Tandai Kembali
                                </a>
                            <% } %>
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

<div class="modal-overlay" id="approveModal">
    <div class="action-modal-box">
        <div class="modal-action-icon icon-approve">
            <i class="fa-solid fa-clipboard-check"></i>
        </div>
        <div class="modal-action-title">Setujui Peminjaman Buku?</div>
        <div class="modal-action-desc">
            Konfirmasi otorisasi peminjaman buku untuk:<br>
            • Anggota: <strong id="approveTargetAnggota">-</strong><br>
            • Judul Buku: <strong id="approveTargetBuku">-</strong>
        </div>
        <div style="font-size: 12px; color: #64748b; margin-bottom: 12px; text-align: left; padding: 0 16px;">
            * Stok buku otomatis terpotong 1 buah dan batas pengembalian (+1 Bulan) dihitung dinamis dari tanggal hari ini.
        </div>
        <div class="modal-btn-container">
            <button type="button" class="btn-modal-cancel" id="btnCancelApprove">Batal</button>
            <a href="#" class="btn-modal-confirm" id="btnConfirmApprove" style="background-color: #10b981;">Ya, Setujui</a>
        </div>
    </div>
</div>

<div class="modal-overlay" id="rejectModal">
    <div class="action-modal-box">
        <div class="modal-action-icon icon-reject">
            <i class="fa-solid fa-ban"></i>
        </div>
        <div class="modal-action-title">Tolak Pengajuan Buku?</div>
        <div class="modal-action-desc">
            Apakah Anda yakin ingin <strong style="color: #ef4444;">MENOLAK</strong> permintaan dari:<br>
            • Anggota: <strong id="rejectTargetAnggota">-</strong><br>
            • Judul Buku: <strong id="rejectTargetBuku">-</strong>
        </div>
        <div style="font-size: 12px; color: #64748b; margin-bottom: 12px; text-align: left; padding: 0 16px;">
            * Permintaan akan dibatalkan, status dialihkan menjadi ditolak, dan tidak memotong stok inventaris buku.
        </div>
        <div class="modal-btn-container">
            <button type="button" class="btn-modal-cancel" id="btnCancelReject">Batal</button>
            <a href="#" class="btn-modal-confirm" id="btnConfirmReject" style="background-color: #ef4444;">Ya, Tolak</a>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="action-modal-box">
        <div class="modal-action-icon icon-reject">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <div class="modal-action-title">Konfirmasi Logout</div>
        <div class="modal-action-desc" style="text-align: center;">
            Apakah Anda yakin ingin keluar dari panel admin LibraryPro?
        </div>
        <div class="modal-btn-container">
            <button type="button" class="btn-modal-cancel" id="btnCancelLogout">Batal</button>
            <a href="<%=request.getContextPath()%>/logout" class="btn-modal-confirm" id="btnConfirmLogout" style="background-color: #ef4444;">Ya, Keluar</a>
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

        // 2. Logika Dialog Pop-up Konfirmasi Logout
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

        // 3. Logika Modal Kustom: SETUJUI PEMINJAMAN
        const approveTriggers = document.querySelectorAll(".btn-approve-modal-trigger");
        const approveModal = document.getElementById("approveModal");
        const approveTargetAnggota = document.getElementById("approveTargetAnggota");
        const approveTargetBuku = document.getElementById("approveTargetBuku");
        const btnConfirmApprove = document.getElementById("btnConfirmApprove");
        const btnCancelApprove = document.getElementById("btnCancelApprove");

        approveTriggers.forEach(btn => {
            btn.addEventListener("click", function() {
                const id = this.getAttribute("data-id");
                const anggota = this.getAttribute("data-anggota");
                const buku = this.getAttribute("data-buku");

                approveTargetAnggota.innerText = anggota;
                approveTargetBuku.innerText = "« " + buku + " »";
                btnConfirmApprove.setAttribute("href", "<%=request.getContextPath()%>/peminjaman?action=setujui&id=" + id);
                
                approveModal.classList.add("show");
            });
        });

        if (btnCancelApprove) {
            btnCancelApprove.addEventListener("click", () => approveModal.classList.remove("show"));
        }

        // 4. Logika Modal Kustom: TOLAK PEMINJAMAN
        const rejectTriggers = document.querySelectorAll(".btn-reject-modal-trigger");
        const rejectModal = document.getElementById("rejectModal");
        const rejectTargetAnggota = document.getElementById("rejectTargetAnggota");
        const rejectTargetBuku = document.getElementById("rejectTargetBuku");
        const btnConfirmReject = document.getElementById("btnConfirmReject");
        const btnCancelReject = document.getElementById("btnCancelReject");

        rejectTriggers.forEach(btn => {
            btn.addEventListener("click", function() {
                const id = this.getAttribute("data-id");
                const anggota = this.getAttribute("data-anggota");
                const buku = this.getAttribute("data-buku");

                rejectTargetAnggota.innerText = anggota;
                rejectTargetBuku.innerText = "« " + buku + " »";
                btnConfirmReject.setAttribute("href", "<%=request.getContextPath()%>/peminjaman?action=tolak&id=" + id);
                
                rejectModal.classList.add("show");
            });
        });

        if (btnCancelReject) {
            btnCancelReject.addEventListener("click", () => rejectModal.classList.remove("show"));
        }

        // Global Click Event: Klik area luar boks untuk meruntuhkan/menutup modal aktif
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) logoutModal.classList.remove("show");
            if (e.target === approveModal) approveModal.classList.remove("show");
            if (e.target === rejectModal) rejectModal.classList.remove("show");
        });
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