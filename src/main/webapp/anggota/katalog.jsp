<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Buku" %>
<%@ page import="model.Kategori" %>
<%@ page import="model.User" %>
<%@ page import="dao.BukuDAO" %>
<%@ page import="dao.KategoriDAO" %>
<%@ page import="dao.FavoritDAO" %>
<%@ page import="util.StringUtils" %>
<%@ page import="util.Lang" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Katalog Buku - LibraryPro</title>
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
    if (loggedUser == null || !"anggota".equalsIgnoreCase(loggedUser.getLevel())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String query = request.getParameter("q");
    String kategoriParam = request.getParameter("kategori");

    BukuDAO bukuDAO = new BukuDAO();
    KategoriDAO kategoriDAO = new KategoriDAO();
    FavoritDAO favoritDAO = new FavoritDAO();

    List<Kategori> listKategori = kategoriDAO.getAllKategori();
    
    Map<Integer, String> kategoriMap = new HashMap<>();
    if (listKategori != null) {
        for (Kategori k : listKategori) {
            kategoriMap.put(k.getIdKategori(), k.getNamaKategori());
        }
    }

    List<Buku> listBuku = bukuDAO.getAllBuku();
    if (kategoriParam != null && !kategoriParam.trim().isEmpty() && !kategoriParam.equals("all")) {
        int idKategori = Integer.parseInt(kategoriParam);
        listBuku.removeIf(b -> b.getIdKategori() != idKategori);
    }
%>

<div class="sidebar">
    <div class="logo"><i class="fa-solid fa-book-open-reader"></i> <span>LibraryPro</span></div>
    <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/dashboard"><i class="fa-solid fa-chart-line"></i> <%= Lang.get("menu.dashboard", request) %></a></li>
        <li><a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="active"><i class="fa-solid fa-book-open"></i> <%= Lang.get("menu.catalog", request) %></a></li>
        <li><a href="<%=request.getContextPath()%>/peminjaman"><i class="fa-solid fa-clock-rotate-left"></i> <%= Lang.get("menu.history", request) %></a></li>
        <li><a href="<%=request.getContextPath()%>/favorit"><i class="fa-solid fa-star"></i> <%= Lang.get("menu.favorites", request) %></a></li>
        <li><a href="<%=request.getContextPath()%>/ulasan"><i class="fa-solid fa-comments"></i> <%= Lang.get("menu.reviews", request) %></a></li>
    </ul>
    <a href="<%=request.getContextPath()%>/profile" class="sidebar-footer">
        <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Profil" loading="lazy" onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/uploads/profile/default.png'">
        <div class="user-info">
            <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
            <small><%= Lang.get("role.member", request) %></small>
        </div>
    </a>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button" aria-label="Toggle sidebar"><i class="fa-solid fa-bars"></i></button>
        <h2><%= Lang.get("katalog.title", request) %></h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger" role="button" tabindex="0" aria-haspopup="true" aria-expanded="false">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" loading="lazy" onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/uploads/profile/default.png'" alt="Foto Profil">
                <span><%= StringUtils.escapeHtml(loggedUser.getNamaLengkap()) %></span>
                <i class="fa-solid fa-chevron-down chevron-icon"></i>
            </div>
            <ul class="dropdown-menu" id="dropdownMenu" role="menu">
                <li><a href="<%=request.getContextPath()%>/profile" role="menuitem"><i class="fa-solid fa-user-gear"></i> <%= Lang.get("menu.profile", request) %></a></li>
                <li>
                    <a href="<%= request.getContextPath() %>/language?lang=<%= "en".equals(session.getAttribute("lang")) ? "id" : "en" %>" class="lang-toggle-link" role="menuitem">
                        <span><i class="fa-solid fa-globe"></i> <%= Lang.get("menu.lang_switch", request) %></span>
                        <span class="lang-badge"><%= "en".equals(session.getAttribute("lang")) ? "EN" : "ID" %></span>
                    </a>
                </li>
                <li class="divider" role="separator"></li>
                <li>
                    <a href="#" class="logout-link" id="logoutTrigger" role="menuitem">
                        <i class="fa-solid fa-right-from-bracket"></i> <%= Lang.get("menu.logout", request) %>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome animate-fade-in">
            <h1><%= Lang.get("katalog.welcome_title", request) %> <span class="text-gradient">LibraryPro</span></h1>
            <p><%= Lang.get("katalog.welcome_subtitle", request) %></p>
        </div>

        <form action="katalog.jsp" method="get" class="search-container" id="searchForm" onsubmit="return false;">
            <div class="search-wrapper">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <input type="text" id="searchInput" name="q" value="<%= StringUtils.escapeHtml(query != null ? query : "") %>" placeholder="<%= Lang.get("katalog.search_placeholder", request) %>" aria-label="Cari buku">
            </div>
            <select name="kategori" class="filter-select" onchange="window.location.href='katalog.jsp?kategori=' + this.value;" aria-label="Filter kategori">
                <option value="all"><%= Lang.get("katalog.all_categories", request) %></option>
                <%
                    if (listKategori != null) {
                        for (Kategori k : listKategori) {
                            String selected = (kategoriParam != null && kategoriParam.equals(String.valueOf(k.getIdKategori()))) ? "selected" : "";
                %>
                    <option value="<%= k.getIdKategori() %>" <%= selected %>><%= StringUtils.escapeHtml(k.getNamaKategori()) %></option>
                <%
                        }
                    }
                %>
            </select>
            <a href="katalog.jsp" class="btn-reset"><i class="fa-solid fa-rotate-right"></i> Reset</a>
        </form>

        <div class="catalog-grid" id="catalogGrid">
            <%
                if (listBuku != null && !listBuku.isEmpty()) {
                    for (Buku b : listBuku) {
                        String katNama = kategoriMap.get(b.getIdKategori());
                        if (katNama == null) katNama = "Tidak berkategori";
                        boolean isFav = favoritDAO.isFavorit(loggedUser.getIdUser(), b.getIdBuku());
                        
                        String absText = (b.getAbstraksi() != null) ? b.getAbstraksi().replace("\"", "&quot;") : "Abstraksi belum tersedia untuk buku ini.";
                        String isbnText = (b.getIsbn() != null && !b.getIsbn().isEmpty()) ? b.getIsbn() : "-";
            %>
            <div class="book-card scroll-reveal"
                 data-judul="<%= StringUtils.escapeHtml(b.getJudul().toLowerCase()) %>" 
                 data-realjudul="<%= StringUtils.escapeHtml(b.getJudul()) %>"
                 data-penulis="<%= StringUtils.escapeHtml(b.getPenulis()) %>" 
                 data-penerbit="<%= StringUtils.escapeHtml(b.getPenerbit()) %>"
                 data-tahun="<%= b.getTahunTerbit() %>"
                 data-kategori="<%= StringUtils.escapeHtml(katNama) %>"
                 data-isbn="<%= StringUtils.escapeHtml(isbnText) %>"
                 data-abstraksi="<%= StringUtils.escapeHtml(absText) %>">
                  
                <div class="book-cover-placeholder">
                    <% if (b.getFotoBuku() != null && !b.getFotoBuku().isEmpty()) { %>
                        <img src="<%=request.getContextPath()%>/uploads/buku/<%= b.getFotoBuku() %>" 
                             style="width: auto; height: 100%; max-width: 100%; object-fit: contain; border-radius: 6px; box-shadow: 0 4px 8px rgba(0,0,0,0.15); transition: transform 0.3s ease;"
                             loading="lazy"
                             onerror="this.onerror=null;this.parentNode.innerHTML='<i class=\'fa-solid fa-book-open\'></i>';"
                             alt="<%= StringUtils.escapeHtml(b.getJudul()) %>">
                    <% } else { %>
                        <i class="fa-solid fa-book-open"></i>
                    <% } %>
                </div>
                <div class="book-info">
                    <div class="book-category"><%= StringUtils.escapeHtml(katNama) %></div>
                    <div class="book-title"><%= StringUtils.escapeHtml(b.getJudul()) %></div>
                    <div class="book-meta"><i class="fa-solid fa-feather"></i> <span><%= StringUtils.escapeHtml(b.getPenulis()) %></span></div>
                    <div class="book-meta"><i class="fa-solid fa-building"></i> <span><%= StringUtils.escapeHtml(b.getPenerbit()) %></span></div>
                    <div class="book-meta"><i class="fa-solid fa-calendar"></i> <span><%= b.getTahunTerbit() %></span></div>
                    
                    <div class="book-review-link">
                        <a href="<%=request.getContextPath()%>/review-buku?idBuku=<%= b.getIdBuku() %>">
                            <i class="fa-solid fa-comments"></i> Lihat Ulasan & Rating
                        </a>
                    </div>
                </div>
                <div class="book-actions">
                    <% if (b.getJmlBuku() > 0) { %>
                        <a href="<%=request.getContextPath()%>/peminjaman?action=pinjam&idBuku=<%= b.getIdBuku() %>" class="btn-sm btn-primary btn-action-link ripple-btn">
                            <i class="fa-solid fa-book-reader"></i> Pinjam Buku
                        </a>
                    <% } else { %>
                        <span class="status borrowed btn-stok-habis"><i class="fa-solid fa-circle-exclamation"></i> Stok Habis</span>
                    <% } %>
                    
                    <% if (isFav) { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=delete&idBuku=<%= b.getIdBuku() %>" class="btn-fav active" title="Hapus dari Favorit">
                            <i class="fa-solid fa-star"></i>
                        </a>
                    <% } else { %>
                        <a href="<%=request.getContextPath()%>/favorit?action=add&idBuku=<%= b.getIdBuku() %>" class="btn-fav" title="Tambah ke Favorit">
                            <i class="fa-regular fa-star"></i>
                        </a>
                    <% } %>
                </div>
            </div>
            <%
                    }
                }
            %>
            <div id="emptyMessage" class="empty catalog-grid-empty">
                <i class="fa-solid fa-book" style="font-size: 2rem; color: #cbd5e1; margin-bottom: 12px; display: block;"></i>
                Tidak ditemukan buku yang cocok dengan pencarian Anda.
            </div>
        </div>
    </div>
</div>

<div class="modal-overlay" id="detailModal" role="dialog" aria-modal="true" aria-labelledby="mdJudul">
    <div class="modal-box">
        <span class="modal-close" id="closeModal" role="button" tabindex="0" aria-label="Tutup">&times;</span>
        <div class="modal-category" id="mdKategori">Kategori</div>
        <div class="modal-title" id="mdJudul">Judul Buku Terkait</div>
        
        <div class="modal-grid-info">
            <div class="info-item"><strong><i class="fa-solid fa-feather"></i> Penulis</strong> <span id="mdPenulis">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-building"></i> Penerbit</strong> <span id="mdPenerbit">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-calendar-days"></i> Tahun Terbit</strong> <span id="mdTahun">-</span></div>
            <div class="info-item"><strong><i class="fa-solid fa-barcode"></i> ISBN / ISSN</strong> <span id="mdIsbn">-</span></div>
        </div>
        
        <div class="modal-abstract">
            <h4><i class="fa-solid fa-align-left"></i> Abstraksi / Sinopsis</h4>
            <p id="mdAbstraksi">Isi deskripsi cerita atau rangkuman abstrak buku di sini...</p>
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

        var bookCards = document.querySelectorAll(".book-card");

        bookCards.forEach(function (card, index) {
            card.style.animationDelay = (index * 0.06) + "s";
        });

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

        // Live search with FuzzySearch library
        var searchInput = document.getElementById("searchInput");
        var emptyMessage = document.getElementById("emptyMessage");

        if (searchInput && typeof FuzzySearch !== "undefined") {
            var bookData = [];
            bookCards.forEach(function (card, index) {
                bookData.push({
                    element: card,
                    index: index,
                    judul: card.getAttribute("data-judul") || "",
                    penulis: card.getAttribute("data-penulis") || "",
                    penerbit: card.getAttribute("data-penerbit") || "",
                    kategori: card.getAttribute("data-kategori") || ""
                });
            });

            var doSearch = FuzzySearch.debounce(function () {
                var keyword = searchInput.value.trim().toLowerCase();
                var results;

                if (!keyword) {
                    results = bookData;
                } else {
                    results = FuzzySearch.search(keyword, bookData, ["judul", "penulis", "penerbit", "kategori"]);
                }

                var visibleCount = 0;
                var shown = {};
                results.forEach(function (r) {
                    r.element.style.display = "flex";
                    shown[r.index] = true;
                    visibleCount++;
                });
                bookData.forEach(function (r) {
                    if (!shown[r.index]) {
                        r.element.style.display = "none";
                    }
                });
                emptyMessage.style.display = (visibleCount === 0 && bookData.length > 0) ? "block" : "none";
            }, 150);

            searchInput.addEventListener("input", doSearch);
        }

        // Detail modal
        var detailModal = document.getElementById("detailModal");
        var closeModal = document.getElementById("closeModal");

        var mdJudul = document.getElementById("mdJudul");
        var mdKategori = document.getElementById("mdKategori");
        var mdPenulis = document.getElementById("mdPenulis");
        var mdPenerbit = document.getElementById("mdPenerbit");
        var mdTahun = document.getElementById("mdTahun");
        var mdIsbn = document.getElementById("mdIsbn");
        var mdAbstraksi = document.getElementById("mdAbstraksi");

        bookCards.forEach(function (card) {
            card.addEventListener("click", function (e) {
                if (e.target.closest('.book-actions') || e.target.closest('.book-review-link')) {
                    return;
                }

                mdJudul.innerText = this.getAttribute("data-realjudul");
                mdKategori.innerText = this.getAttribute("data-kategori");
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
            if (e.target === detailModal) {
                detailModal.classList.remove("show");
            }
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
            if (e.target === logoutModal) {
                logoutModal.classList.remove("show");
            }
        });

        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape") {
                document.querySelectorAll(".modal-overlay.show").forEach(function (modal) {
                    modal.classList.remove("show");
                });
            }
        });
    });
</script>

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
<script src="<%=request.getContextPath()%>/js/icon-fallback.js"></script>
<script src="<%=request.getContextPath()%>/js/search.js"></script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>
