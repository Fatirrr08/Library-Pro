<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.Ulasan" %>
<%@ page import="model.User" %>
<%@ page import="util.StringUtils" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Komunitas - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">

    <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" media="print" onload="this.media='all'">

    <link rel="preload" as="style" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/css/all.min.css">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"></noscript>
    <script defer src="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/js/all.min.js"></script>
    <script>(function(){var d=document;setTimeout(function(){var s=d.querySelectorAll('i[class*="fa-"]');for(var i=0;i<s.length;i++){if(s[i].tagName==='svg')return}var l=d.createElement('link');l.rel='stylesheet';l.href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css';d.head.appendChild(l)},3000)})();</script>

    <link rel="preload" as="style" href="<%=request.getContextPath()%>/css/style-global.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-global.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>

<div class="page-loader" id="pageLoader"><div class="loader-spinner"></div></div>

<%
    User loggedUser = (User) session.getAttribute("user");
    Buku b = (Buku) request.getAttribute("buku");
    List<Ulasan> ulasanPublik = (List<Ulasan>) request.getAttribute("ulasanPublik");
    Double rataRata = (Double) request.getAttribute("rataRataRating");
    
    if (b == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>

<div class="sidebar">
    <div class="logo"><i class="fa-solid fa-book-open-reader"></i> <span>LibraryPro</span></div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="active"><i class="fa-solid fa-book-open"></i> Katalog Buku</a></li>
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
        <h2>Ulasan & Rating Buku</h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger" role="button" tabindex="0" aria-haspopup="true" aria-expanded="false">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" loading="lazy" onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/uploads/profile/default.png'" alt="Foto Profil">
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
        <div class="table-header">
            <div class="table-title"><%= StringUtils.escapeHtml(b.getJudul()) %></div>
            <a href="<%= request.getContextPath() %>/anggota/katalog.jsp" class="btn-add">
                <i class="fa-solid fa-arrow-left"></i> Kembali ke Katalog
            </a>
        </div>

        <div class="book-detail-card" style="display: flex; gap: 24px; flex-wrap: wrap;">
            <div style="flex-shrink: 0; width: 160px;">
                <% if (b.getFotoBuku() != null && !b.getFotoBuku().isEmpty()) { %>
                    <img src="<%=request.getContextPath()%>/uploads/buku/<%= b.getFotoBuku() %>" 
                         style="width: 100%; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);"
                         onerror="this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='flex';"
                         alt="<%= StringUtils.escapeHtml(b.getJudul()) %>">
                    <div style="display:none;width:100%;height:220px;background:#f1f5f9;border-radius:8px;align-items:center;justify-content:center;">
                        <i class="fa-solid fa-book-open" style="font-size:3rem;color:#94a3b8;"></i>
                    </div>
                <% } else { %>
                    <div style="width:100%;height:220px;background:#f1f5f9;border-radius:8px;display:flex;align-items:center;justify-content:center;">
                        <i class="fa-solid fa-book-open" style="font-size:3rem;color:#94a3b8;"></i>
                    </div>
                <% } %>
            </div>
            <div style="flex: 1; min-width: 200px;">
                <div class="rating-badge">
                    <i class="fa-solid fa-star"></i> Komunitas Rating: <%= (rataRata != null && rataRata > 0) ? String.format("%.1f", rataRata) + " / 5.0" : "Belum dinilai" %>
                </div>
                
                <p><b>Penulis:</b> <%= StringUtils.escapeHtml(b.getPenulis()) %></p>
                <p><b>Penerbit:</b> <%= StringUtils.escapeHtml(b.getPenerbit()) %></p>
                <p><b>Tahun Terbit:</b> <%= b.getTahunTerbit() %></p>
                <p><b>ISBN / ISSN:</b> <%= StringUtils.escapeHtml(b.getIsbn() != null ? b.getIsbn() : "-") %></p>
                
                <div class="book-detail-abstract">
                    <h4>Abstraksi / Sinopsis:</h4>
                    <p><%= StringUtils.escapeHtml(b.getAbstraksi() != null ? b.getAbstraksi() : "Sinopsis belum tersedia.") %></p>
                </div>
            </div>
        </div>

        <div class="table-header">
            <div class="table-title">Daftar Komentar Pembaca (<%= ulasanPublik != null ? ulasanPublik.size() : 0 %>)</div>
            <a href="<%= request.getContextPath() %>/ulasan?idBuku=<%= b.getIdBuku() %>" class="btn-add">
                <i class="fa-solid fa-pen-to-square"></i> Tulis Ulasan Anda
            </a>
        </div>

        <div class="review-list">
            <%
                if (ulasanPublik != null && !ulasanPublik.isEmpty()) {
                    for (Ulasan u : ulasanPublik) {
            %>
                <div class="review-card scroll-reveal">
                    <div class="review-header">
                        <div class="user-name"><i class="fa-solid fa-circle-user"></i> <%= StringUtils.escapeHtml(u.getNamaLengkap() != null ? u.getNamaLengkap() : u.getUsername()) %></div>
                        <div class="stars-orange">
                            <% for(int i = 1; i <= u.getRating(); i++) { %><i class="fa-solid fa-star"></i><% } %>
                            <% for(int i = u.getRating() + 1; i <= 5; i++) { %><i class="fa-regular fa-star" style="color: #cbd5e1;"></i><% } %>
                        </div>
                    </div>
                    <div class="review-text">"<%= StringUtils.escapeHtml(u.getUlasan()) %>"</div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="empty">Belum ada ulasan untuk buku ini.</div>
            <%
                }
            %>
        </div>
    </div>
</div>

<div class="modal-overlay" id="logoutModal" role="dialog" aria-modal="true">
    <div class="action-modal-box">
        <div class="logout-warning-icon">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari akun LibraryPro saat ini? Anda harus login kembali untuk mengakses layanan.</div>
        <div class="logout-btn-container">
            <button type="button" class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
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
