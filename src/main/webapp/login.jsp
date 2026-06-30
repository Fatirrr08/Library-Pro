<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.StringUtils" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LibraryPro</title>
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-auth.css">
</head>
<body class="auth-page">
<div class="page-loader" id="pageLoader"><div class="loader-spinner"></div></div>


<div class="auth-container">
    <div class="auth-card">

        <div class="auth-header">
            <div class="icon-wrapper">
                <i class="fa-solid fa-book-open-reader"></i>
            </div>
            <h2>LibraryPro</h2>
            <p>Silakan masuk ke akun Anda</p>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            String registerSuccess = request.getParameter("registerSuccess");
            if (error != null) {
        %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span><%= StringUtils.escapeHtml(error) %></span>
        </div>
        <%
            }
            if ("true".equals(registerSuccess)) {
        %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>Registrasi berhasil! Silakan login.</span>
        </div>
        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/login" method="post" class="auth-form">
            <div class="input-group">
                <label for="username">Username</label>
                <div class="input-wrapper">
                    <i class="fa-regular fa-user input-icon"></i>
                    <input type="text" id="username" name="username" placeholder="Masukkan username" required>
                </div>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" placeholder="Masukkan password" required>
                </div>
            </div>

            <button type="submit" class="btn btn-accent">
                Masuk <i class="fa-solid fa-arrow-right-to-bracket"></i>
            </button>
        </form>

        <div class="auth-footer">
            <p>Belum punya akun? <a href="<%=request.getContextPath()%>/register">Daftar Sekarang</a></p>
        </div>

    </div>
</div>

<script src="<%=request.getContextPath()%>/js/icon-fallback.js"></script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>
