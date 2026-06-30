<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ulasan" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ulasan & Rating - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>

<div class="page-loader" id="pageLoader"></div>

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
    <div class="logo"><i class="fa-solid fa-book-open-reader"></i> <span>LibraryPro</span></div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp"><i class="fa-solid fa-book-open"></i> Katalog Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/favorit"><i class="fa-solid fa-star"></i> Favorit Saya</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan" class="active"><i class="fa-solid fa-comments"></i> Ulasan & Rating Saya</a></li>
    </ul>
    <div class="sidebar-footer">
        <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Profil">
        <div class="user-info">
            <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
            <small>Anggota</small>
        </div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button" aria-label="Toggle sidebar"><i class="fa-solid fa-bars"></i></button>
        <h2><%= (bukuMauDiulas != null) ? (editUlasan != null ? "Edit Ulasan Buku" : "Tulis Ulasan Buku") : "History Ulasan Anda" %></h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger" role="button" tabindex="0" aria-haspopup="true" aria-expanded="false">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Foto Profil">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
                <i class="fa-solid fa-chevron-down chevron-icon"></i>
            </div>
            <ul class="dropdown-menu" id="dropdownMenu" role="menu">
                <li><a href="<%=request.getContextPath()%>/profile" role="menuitem"><i class="fa-solid fa-user-gear"></i> Profil Saya</a></li>
                <li class="divider" role="separator"></li>
                <li><a href="#" class="logout-link" id="logoutTrigger" role="menuitem"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        
        <% if (bukuMauDiulas != null) { %>
            <div class="table-header">
                <div class="table-title"><%= editUlasan != null ? "Perbarui Penilaian Anda" : "Berikan Penilaian Anda" %></div>
            </div>
            
            <div class="form-card">
                <h3><%= StringUtils.escapeHtml(bukuMauDiulas.getJudul()) %></h3>
                <p>Karya: <%= StringUtils.escapeHtml(bukuMauDiulas.getPenulis()) %></p>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div>
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
                    
                    <div>
                        <button type="submit" class="btn-add">
                            <i class="fa-solid fa-paper-plane"></i> <%= editUlasan != null ? "Perbarui Ulasan" : "Kirim Ulasan" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/ulasan" class="status-badge badge-waiting">
                            Batal
                        </a>
                    </div>
                </form>
            </div>

        <% } else { %>
            <div class="table-header">
                <div class="table-title">Semua Ulasan yang Pernah Anda Kirim</div>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Judul Buku</th>
                            <th>Rating</th>
                            <th>Isi Ulasan / Komentar</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (historyUlasan != null && !historyUlasan.isEmpty()) {
                                int no = 1;
                                for (Ulasan u : historyUlasan) {
                        %>
                        <tr>
                            <td><%= no++ %></td>
                            <td>
                                <%= StringUtils.escapeHtml(u.getJudulBuku() != null ? u.getJudulBuku() : "ID Buku: " + u.getIdBuku()) %>
                            </td>
                            <td>
                                <div class="stars-orange">
                                    <% for(int i = 1; i <= u.getRating(); i++) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } %>
                                    <% for(int i = u.getRating() + 1; i <= 5; i++) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                "<%= StringUtils.escapeHtml(u.getUlasan()) %>"
                            </td>
                            <td>
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

<div class="modal-overlay" id="logoutModal" role="dialog" aria-modal="true">
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
        var pageLoader = document.getElementById("pageLoader");
        if (pageLoader) {
            pageLoader.classList.add("active");
            setTimeout(function () {
                pageLoader.classList.remove("active");
            }, 800);
        }

        // Scroll reveal
        if ("IntersectionObserver" in window) {
            var revealObserver = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("revealed");
                        revealObserver.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });

            document.querySelectorAll(".scroll-reveal").forEach(function (el) {
                revealObserver.observe(el);
            });
        } else {
            document.querySelectorAll(".scroll-reveal").forEach(function (el) {
                el.classList.add("revealed");
            });
        }

        // Profile dropdown
        var profileTrigger = document.getElementById("profileTrigger");
        var dropdownMenu = document.getElementById("dropdownMenu");

        if (profileTrigger && dropdownMenu) {
            profileTrigger.addEventListener("click", function (e) {
                e.stopPropagation();
                var isOpen = dropdownMenu.classList.toggle("show");
                profileTrigger.setAttribute("aria-expanded", isOpen);
            });

            document.addEventListener("click", function (e) {
                if (!profileTrigger.contains(e.target) && !dropdownMenu.contains(e.target)) {
                    dropdownMenu.classList.remove("show");
                    profileTrigger.setAttribute("aria-expanded", "false");
                }
            });

            profileTrigger.addEventListener("keydown", function (e) {
                if (e.key === "Enter" || e.key === " ") {
                    e.preventDefault();
                    var isOpen = dropdownMenu.classList.toggle("show");
                    profileTrigger.setAttribute("aria-expanded", isOpen);
                }
            });
        }

        // Logout modal
        var logoutTrigger = document.getElementById("logoutTrigger");
        var logoutModal = document.getElementById("logoutModal");
        var btnCancelLogout = document.getElementById("btnCancelLogout");

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
            if (e.target === logoutModal) logoutModal.classList.remove("show");
        });

        // Escape key
        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape") {
                document.querySelectorAll(".modal-overlay.show").forEach(function (modal) {
                    modal.classList.remove("show");
                });
            }
        });

        // Toast notification
        var urlParams = new URLSearchParams(window.location.search);
        var status = urlParams.get('status');
        
        var toastBox = document.getElementById("toastBox");
        var toastIcon = document.getElementById("toastIcon");
        var toastMessage = document.getElementById("toastMessage");

        if (status && toastBox) {
            if (status === "success") {
                toastBox.classList.remove("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-check"></i>';
                toastMessage.innerText = "Berhasil memproses ulasan buku!";
                toastBox.classList.add("show");
            } else if (status === "fail") {
                toastBox.classList.add("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-circle-xmark"></i>';
                toastMessage.innerText = "Gagal memproses ulasan.";
                toastBox.classList.add("show");
            } else if (status === "duplicate") {
                toastBox.classList.add("toast-error");
                toastIcon.innerHTML = '<i class="fa-solid fa-triangle-exclamation"></i>';
                toastMessage.innerText = "Anda sudah pernah mengulas buku ini! Silakan gunakan fitur Edit.";
                toastBox.classList.add("show");
            }

            setTimeout(function () {
                toastBox.classList.remove("show");
                var cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            }, 3500);
        }
    });
</script>

<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>
