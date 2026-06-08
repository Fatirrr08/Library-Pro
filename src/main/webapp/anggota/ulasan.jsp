<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Buku" %>
<%@ page import="model.Ulasan" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ulasan & Rating Buku - LibraryPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 5px;
            font-size: 1.5rem;
            margin-top: 5px;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            color: #cbd5e1;
            cursor: pointer;
            transition: var(--transition);
        }
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: var(--warning);
        }
    </style>
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"anggota".equalsIgnoreCase(loggedUser.getLevel())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Buku buku = (Buku) request.getAttribute("buku");
    List<Ulasan> daftarUlasan = (List<Ulasan>) request.getAttribute("daftarUlasan");
    Double ratingRata = (Double) request.getAttribute("ratingRata");
    if (ratingRata == null) ratingRata = 0.0;
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
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="active">
                <i class="fa-solid fa-book-open"></i> Katalog Buku
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/peminjaman">
                <i class="fa-solid fa-clock-history"></i> Peminjaman Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/favorit">
                <i class="fa-solid fa-star"></i> Favorit Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Ulasan & Rating</h2>
        <div class="admin-profile">
            <img src="https://i.pravatar.cc/100?img=12" alt="Anggota">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome" style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <h1>Ulasan & Rating Buku</h1>
                <p>Bagikan pendapat Anda tentang buku ini untuk membantu pembaca lainnya.</p>
            </div>
            <a href="<%=request.getContextPath()%>/anggota/katalog.jsp" class="btn-add" style="background-color: var(--text-muted);">
                <i class="fa-solid fa-arrow-left"></i> Kembali ke Katalog
            </a>
        </div>

        <% if (buku != null) { %>
        <!-- BOOK DETAILS PANEL -->
        <div class="form-box" style="display: flex; justify-content: space-between; align-items: center; background-color: var(--primary-light); border-color: rgba(79, 70, 229, 0.15);">
            <div>
                <h2 style="color: var(--primary); font-size: 1.4rem; margin-bottom: 5px;"><%= buku.getJudul() %></h2>
                <div style="font-size: 0.95rem; color: var(--text-dark);">
                    Penulis: <strong><%= buku.getPenulis() %></strong> | Penerbit: <strong><%= buku.getPenerbit() %></strong> | Tahun: <strong><%= buku.getTahunTerbit() %></strong>
                </div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 0.85rem; text-transform: uppercase; font-weight: 700; color: var(--text-muted);">Rating Rata-Rata</div>
                <div style="font-size: 2.2rem; font-weight: 800; color: var(--bg-dark); line-height: 1;">
                    <%= String.format("%.1f", ratingRata) %> <span style="font-size: 1.5rem; color: var(--warning);"><i class="fa-solid fa-star"></i></span>
                </div>
                <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 3px;">
                    Dari <%= (daftarUlasan != null) ? daftarUlasan.size() : 0 %> ulasan
                </div>
            </div>
        </div>

        <!-- ADD REVIEW FORM -->
        <div class="form-box" style="max-width: 600px;">
            <div class="table-title" style="margin-bottom: 15px;">Tulis Ulasan Anda</div>
            <form action="<%=request.getContextPath()%>/ulasan" method="post">
                <input type="hidden" name="idBuku" value="<%= buku.getIdBuku() %>">
                
                <div class="form-group">
                    <label>Rating Buku</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5" required /><label for="star5" title="Sangat Bagus"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="Bagus"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="Cukup"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="Jelek"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="Sangat Jelek"><i class="fa-solid fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group" style="margin-top: 15px;">
                    <label>Ulasan / Pendapat Anda</label>
                    <textarea name="ulasan" required placeholder="Tulis review Anda secara jujur dan membangun di sini..." style="height: 100px; resize: none;"></textarea>
                </div>

                <button type="submit" class="btn-add" style="margin-top: 15px;">
                    <i class="fa-solid fa-paper-plane"></i> Kirim Ulasan
                </button>
            </form>
        </div>

        <!-- REVIEWS SECTION -->
        <div class="reviews-section">
            <div class="table-title" style="border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 10px;">Semua Ulasan Pembaca</div>
            <%
                if (daftarUlasan != null && !daftarUlasan.isEmpty()) {
                    for (Ulasan ul : daftarUlasan) {
            %>
            <div class="review-card">
                <div class="review-header">
                    <div class="reviewer-name">
                        <%= ul.getNamaLengkap() %> 
                        <span style="font-weight: normal; font-size: 0.8rem; color: var(--text-muted); margin-left: 8px;">@<%= ul.getUsername() %></span>
                    </div>
                    <div class="stars">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <% if (i <= ul.getRating()) { %>
                                <i class="fa-solid fa-star"></i>
                            <% } else { %>
                                <i class="fa-regular fa-star" style="color: #cbd5e1;"></i>
                            <% } %>
                        <% } %>
                    </div>
                </div>
                <div class="review-text" style="display: flex; justify-content: space-between; align-items: flex-start; gap: 20px;">
                    <p style="margin-bottom: 0; color: #475569; flex: 1;"><%= ul.getUlasan() %></p>
                    
                    <% if (ul.getIdUser() == loggedUser.getIdUser()) { %>
                        <a href="<%=request.getContextPath()%>/ulasan?action=delete&id=<%= ul.getIdUlasan() %>&idBuku=<%= buku.getIdBuku() %>" class="btn-sm btn-danger" style="padding: 4px 8px; font-size: 0.75rem;" onclick="return confirm('Apakah Anda yakin ingin menghapus ulasan ini?')">
                            <i class="fa-solid fa-trash"></i> Hapus
                        </a>
                    <% } %>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty" style="padding: 20px 0;">Belum ada ulasan untuk buku ini. Jadilah yang pertama memberikan ulasan!</div>
            <%
                }
            %>
        </div>
        <% } else { %>
        <div class="empty">Data buku tidak ditemukan.</div>
        <% } %>
    </div>
</div>

</body>
</html>
