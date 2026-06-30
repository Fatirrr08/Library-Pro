<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.User" %>
<%@ page import="dao.FavoritDAO" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Anggota - LibraryPro</title>
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
</head>
<body>

<div class="page-loader" id="pageLoader"><div class="loader-spinner"></div></div>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"anggota".equalsIgnoreCase(loggedUser.getLevel())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="sidebar">
    <div class="logo"><i class="fa-solid fa-book-open-reader"></i> <span>LibraryPro</span></div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard" class="active"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp"><i class="fa-solid fa-book-open"></i> Katalog Buku</a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-clock-rotate-left"></i> Riwayat Peminjaman</a></li>
        <li><a href="<%=request.getContextPath()%>/favorit"><i class="fa-solid fa-star"></i> Favorit Saya</a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan"><i class="fa-solid fa-comments"></i> Ulasan & Rating Saya</a></li>
    </ul>
    <div class="sidebar-footer">
        <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" loading="lazy" onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/uploads/profile/default.png'" alt="Profil">
        <div class="user-info">
            <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
            <small>Anggota</small>
        </div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button" aria-label="Toggle sidebar"><i class="fa-solid fa-bars"></i></button>
        <h2>Perpustakaan Digital</h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger" role="button" tabindex="0" aria-haspopup="true" aria-expanded="false">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" loading="lazy" onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/uploads/profile/default.png'" alt="Foto Profil">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
                <i class="fa-solid fa-chevron-down chevron-icon"></i>
            </div>
            <ul class="dropdown-menu" id="dropdownMenu" role="menu">
                <li><a href="<%=request.getContextPath()%>/profile" role="menuitem"><i class="fa-solid fa-user-gear"></i> Profil Saya</a></li>
                <li class="divider" role="separator"></li>
                <li>
                    <a href="#" class="logout-link" id="logoutTrigger" role="menuitem">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome animate-fade-in">
            <h1>Selamat Datang, <%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %>!</h1>
            <p>Temukan ribuan buku berkualitas dan catat peminjaman Anda di sini.</p>
        </div>

        <div class="cards">
            <div class="card scroll-reveal" onclick="window.location.href='<%=request.getContextPath()%>/anggota/katalog.jsp';" style="cursor: pointer;">
                <div class="card-icon"><i class="fa-solid fa-book"></i></div>
                <div>
                    <h4>Total Buku</h4>
                    <h1><%= request.getAttribute("totalBuku") == null ? 0 : request.getAttribute("totalBuku") %></h1>
                </div>
            </div>

            <div class="card scroll-reveal" onclick="window.location.href='<%=request.getContextPath()%>/peminjaman';" style="cursor: pointer;">
                <div class="card-icon"><i class="fa-solid fa-arrow-right-arrow-left"></i></div>
                <div>
                    <h4>Pinjaman Aktif</h4>
                    <h1><%= request.getAttribute("totalPinjamSaya") == null ? 0 : request.getAttribute("totalPinjamSaya") %></h1>
                </div>
            </div>

            <div class="card scroll-reveal" onclick="window.location.href='<%=request.getContextPath()%>/favorit';" style="cursor: pointer;">
                <div class="card-icon"><i class="fa-solid fa-star"></i></div>
                <div>
                    <h4>Buku Favorit</h4>
                    <h1><%= request.getAttribute("totalFavoritSaya") == null ? 0 : request.getAttribute("totalFavoritSaya") %></h1>
                </div>
            </div>

            <div class="card scroll-reveal" onclick="window.location.href='<%=request.getContextPath()%>/ulasan';" style="cursor: pointer;">
                <div class="card-icon"><i class="fa-solid fa-comments"></i></div>
                <div>
                    <h4>Ulasan Saya</h4>
                    <h1><%= request.getAttribute("totalUlasanSaya") == null ? 0 : request.getAttribute("totalUlasanSaya") %></h1>
                </div>
            </div>
        </div>

        <div class="table-header">
            <div class="table-title">Rekomendasi Buku Terbaru</div>
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="btn-add"><i class="fa-solid fa-magnifying-glass"></i> Cari Buku Lainnya</a>
        </div>

        <div class="catalog-grid">
            <%
                List<Buku> daftarBuku = (List<Buku>) request.getAttribute("daftarBuku");
                FavoritDAO favoritDAO = (FavoritDAO) request.getAttribute("favoritDAO");

                if (daftarBuku != null && !daftarBuku.isEmpty()) {
                    for (Buku b : daftarBuku) {
                        boolean isBookFav = false;
                        if (favoritDAO != null && loggedUser != null) {
                            isBookFav = favoritDAO.isFavorit(loggedUser.getIdUser(), b.getIdBuku());
                        }
                        String absText = (b.getAbstraksi() != null) ? b.getAbstraksi().replace("\"", "&quot;") : "Abstraksi belum tersedia untuk buku ini.";
                        String isbnText = (b.getIsbn() != null && !b.getIsbn().isEmpty()) ? b.getIsbn() : "-";
            %>
            <div class="book-card scroll-reveal" data-realjudul="<%= StringUtils.escapeHtml(b.getJudul()) %>" data-penulis="<%= StringUtils.escapeHtml(b.getPenulis()) %>" data-penerbit="<%= StringUtils.escapeHtml(b.getPenerbit()) %>" data-tahun="<%= b.getTahunTerbit() %>" data-isbn="<%= StringUtils.escapeHtml(isbnText) %>" data-abstraksi="<%= StringUtils.escapeHtml(absText) %>">
                <div class="book-cover-placeholder">
                    <i class="fa-solid fa-book-open"></i>
                </div>
                <div class="book-info">
                    <div class="book-title"><%= StringUtils.escapeHtml(b.getJudul()) %></div>
                    <div class="book-meta"><i class="fa-solid fa-feather"></i> <span><%= StringUtils.escapeHtml(b.getPenulis()) %></span></div>
                    <div class="book-meta"><i class="fa-solid fa-building"></i> <span><%= StringUtils.escapeHtml(b.getPenerbit()) %></span></div>
                    <div class="book-meta"><i class="fa-solid fa-calendar"></i> <span><%= b.getTahunTerbit() %></span></div>
                </div>
                <div class="book-actions">
                    <% if (b.getJmlBuku() > 0) { %>
                        <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= b.getIdBuku() %>" class="btn-sm btn-primary btn-action-link"><i class="fa-solid fa-book-reader"></i> Pinjam</a>
                    <% } else { %>
                        <span class="status borrowed btn-stok-habis"><i class="fa-solid fa-circle-exclamation"></i> Habis</span>
                    <% } %>
                    
                    <% if (isBookFav) { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= b.getIdBuku() %>" class="btn-fav active" title="Hapus dari Favorit"><i class="fa-solid fa-star"></i></a>
                    <% } else { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=add&idBuku=<%= b.getIdBuku() %>" class="btn-fav" title="Tambah ke Favorit"><i class="fa-regular fa-star"></i></a>
                    <% } %>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty catalog-grid-empty" style="display: block;">Tidak ada rekomendasi buku saat ini.</div>
            <%
                }
            %>
        </div>
    </div>
</div>

<div class="modal-overlay" id="detailModal" role="dialog" aria-modal="true" aria-labelledby="mdJudul">
    <div class="modal-box">
        <span class="modal-close" id="closeModal" role="button" tabindex="0" aria-label="Tutup">&times;</span>
        <div class="modal-title" id="mdJudul">Judul Buku Rekomendasi</div>
        <div class="modal-grid-info">
            <div class="info-item"><strong><i class="fa-solid fa-feather"></i> Penulis</strong> <span id="mdPenulis">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-building"></i> Penerbit</strong> <span id="mdPenerbit">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-calendar-days"></i> Tahun Terbit</strong> <span id="mdTahun">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-barcode"></i> ISBN / ISSN</strong> <span id="mdIsbn">-</span></div>
        </div>
        <div class="modal-abstract">
            <h4><i class="fa-solid fa-align-left"></i> Abstraksi / Sinopsis</h4>
            <p id="mdAbstraksi">Deskripsi sinopsis buku...</p>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal" role="dialog" aria-modal="true">
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

        // Detail modal
        var detailModal = document.getElementById("detailModal");
        var closeModal = document.getElementById("closeModal");
        var bookCards = document.querySelectorAll(".catalog-grid .book-card");

        bookCards.forEach(function (card, index) {
            card.style.animationDelay = (index * 0.08) + "s";

            var mdJudul = document.getElementById("mdJudul");
            var mdPenulis = document.getElementById("mdPenulis");
            var mdPenerbit = document.getElementById("mdPenerbit");
            var mdTahun = document.getElementById("mdTahun");
            var mdIsbn = document.getElementById("mdIsbn");
            var mdAbstraksi = document.getElementById("mdAbstraksi");

            card.addEventListener("click", function (e) {
                if (e.target.closest('.book-actions')) return;

                mdJudul.innerText = this.getAttribute("data-realjudul");
                mdPenulis.innerText = this.getAttribute("data-penulis");
                mdPenerbit.innerText = this.getAttribute("data-penerbit");
                mdTahun.innerText = this.getAttribute("data-tahun");
                mdIsbn.innerText = this.getAttribute("data-isbn");
                mdAbstraksi.innerText = this.getAttribute("data-abstraksi");

                detailModal.classList.add("show");
            });
        });

        if (closeModal) {
            closeModal.addEventListener("click", function () {
                detailModal.classList.remove("show");
            });
        }

        window.addEventListener("click", function (e) {
            if (e.target === detailModal) detailModal.classList.remove("show");
        });

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
