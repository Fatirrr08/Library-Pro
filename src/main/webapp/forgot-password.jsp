<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.StringUtils" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lupa Password - LibraryPro</title>
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-auth.css">
</head>
<body class="auth-page">
<div class="page-loader" id="pageLoader"><div class="loader-spinner"></div></div>

<%
    String step = (String) request.getAttribute("step");
    if (step == null) step = "1";
    String error = (String) request.getAttribute("error");
%>

<div class="auth-container">
    <div class="auth-card">

        <div class="auth-header">
            <div class="icon-wrapper">
                <i class="fa-solid fa-key"></i>
            </div>
            <h2>Lupa Password</h2>
            <p>
                <% if ("1".equals(step)) { %>
                    Masukkan username untuk memulai reset password.
                <% } else if ("2".equals(step)) { %>
                    Jawab pertanyaan keamanan untuk verifikasi.
                <% } else { %>
                    Masukkan password baru Anda.
                <% } %>
            </p>
        </div>

        <% if (error != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span><%= StringUtils.escapeHtml(error) %></span>
        </div>
        <% } %>

        <%-- STEP 1: Masukkan Username --%>
        <% if ("1".equals(step)) { %>
        <form action="<%=request.getContextPath()%>/forgot-password" method="post" class="auth-form">
            <input type="hidden" name="step" value="1">

            <div class="input-group">
                <label for="username">Username</label>
                <div class="input-wrapper">
                    <i class="fa-regular fa-user input-icon"></i>
                    <input type="text" id="username" name="username" placeholder="Masukkan username Anda" required>
                </div>
            </div>

            <button type="submit" class="btn btn-accent">
                Verifikasi Username <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>

        <%-- STEP 2: Jawab Pertanyaan Keamanan --%>
        <% } else if ("2".equals(step)) { %>
        <form action="<%=request.getContextPath()%>/forgot-password" method="post" class="auth-form">
            <input type="hidden" name="step" value="2">

            <div class="input-group">
                <label>Username</label>
                <div class="input-wrapper" style="background: #f8fafc;">
                    <i class="fa-regular fa-user input-icon"></i>
                    <input type="text" value="<%= StringUtils.escapeHtml((String) request.getAttribute("resetUsername")) %>" disabled>
                </div>
            </div>

            <div class="input-group">
                <label>Pertanyaan Keamanan</label>
                <div class="input-wrapper" style="background: #f8fafc;">
                    <i class="fa-solid fa-shield-halved input-icon"></i>
                    <input type="text" value="<%= StringUtils.escapeHtml((String) request.getAttribute("securityQuestion")) %>" disabled>
                </div>
            </div>

            <div class="input-group">
                <label for="answer">Jawaban Anda</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-pencil input-icon"></i>
                    <input type="text" id="answer" name="answer" placeholder="Tulis jawaban pertanyaan di atas" required>
                </div>
            </div>

            <button type="submit" class="btn btn-accent">
                Verifikasi Jawaban <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>

        <%-- STEP 3: Reset Password --%>
        <% } else if ("3".equals(step)) { %>
        <form action="<%=request.getContextPath()%>/forgot-password" method="post" class="auth-form">
            <input type="hidden" name="step" value="3">

            <div class="input-group">
                <label>Username</label>
                <div class="input-wrapper" style="background: #f8fafc;">
                    <i class="fa-regular fa-user input-icon"></i>
                    <input type="text" value="<%= StringUtils.escapeHtml((String) request.getAttribute("resetUsername")) %>" disabled>
                </div>
            </div>

            <div class="input-group">
                <label for="newPassword">Password Baru</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock input-icon"></i>
                    <input type="password" id="newPassword" name="newPassword" placeholder="Minimal 3 karakter" required minlength="3">
                </div>
            </div>

            <div class="input-group">
                <label for="confirmPassword">Konfirmasi Password</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock input-icon"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Ketik ulang password baru" required minlength="3">
                </div>
            </div>

            <button type="submit" class="btn btn-accent">
                Reset Password <i class="fa-solid fa-check"></i>
            </button>
        </form>
        <% } %>

        <div class="auth-footer">
            <p><a href="<%=request.getContextPath()%>/login.jsp"><i class="fa-solid fa-arrow-left"></i> Kembali ke Login</a></p>
        </div>

    </div>
</div>

<script src="<%=request.getContextPath()%>/js/icon-fallback.js"></script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>
