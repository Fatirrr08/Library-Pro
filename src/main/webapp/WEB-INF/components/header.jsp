<%-- header.jsp — Global <head> + Opening body + Sidebar (for internal pages) --%>
<%@ page import="model.User" %>
<%@ page import="util.StringUtils" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    boolean isInternal = loggedUser != null;
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " - LibraryPro" : "LibraryPro" %></title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-global.css">
    <%
        String extraCss = (String) request.getAttribute("extraCss");
        if (extraCss != null) {
    %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/<%= extraCss %>">
    <%
        }
    %>
</head>
<body>

<% if (isInternal) { %>
<div class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-book-open-reader"></i>
        <span>LibraryPro</span>
    </div>
    <ul class="menu">
        <li>
            <a href="<%=request.getContextPath()%>/dashboard" class="<%= "dashboard".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>
        </li>
        <% if ("admin".equalsIgnoreCase(loggedUser.getLevel())) { %>
        <li>
            <a href="<%=request.getContextPath()%>/buku" class="<%= "buku".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-book"></i> Buku
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/kategori" class="<%= "kategori".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-layer-group"></i> Kategori
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/user" class="<%= "user".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-users"></i> User
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/peminjaman" class="<%= "peminjaman".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/ulasan" class="<%= "ulasan".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-comments"></i> Ulasan
            </a>
        </li>
        <% } else { %>
        <li>
            <a href="<%=request.getContextPath()%>/katalog" class="<%= "katalog".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-book"></i> Katalog
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/peminjaman" class="<%= "peminjaman".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/favorit" class="<%= "favorit".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-heart"></i> Favorit
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/ulasan" class="<%= "ulasan".equals(request.getAttribute("activeMenu")) ? "active" : "" %>">
                <i class="fa-solid fa-star"></i> Ulasan Saya
            </a>
        </li>
        <% } %>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <button class="sidebar-toggle-btn" id="sidebarToggle" type="button">
            <i class="fa-solid fa-bars"></i>
        </button>
        <h2>Library Management System</h2>
        <div class="profile-dropdown-container">
            <div class="user-profile" id="profileTrigger">
                <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Profile">
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
<% } %>
