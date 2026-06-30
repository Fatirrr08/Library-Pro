<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.StringUtils" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Anggota - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-global.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style-auth.css">
</head>
<body class="auth-page">

<div class="auth-container">
    <div class="auth-card">

        <div class="auth-header">
            <div class="icon-wrapper">
                <i class="fa-solid fa-user-plus"></i>
            </div>
            <h2>Daftar Anggota</h2>
            <p>Buat akun perpustakaan baru dan mulai pinjam koleksi buku terbaik kami.</p>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span><%= StringUtils.escapeHtml(error) %></span>
        </div>
        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/register" method="post" class="auth-form">

            <div class="input-group">
                <label for="nama">Nama Lengkap</label>
                <div class="input-wrapper">
                    <i class="fa-regular fa-id-card input-icon"></i>
                    <input type="text" id="nama" name="nama" placeholder="Masukkan nama lengkap Anda" required>
                </div>
            </div>

            <div class="input-group">
                <label for="username">Username</label>
                <div class="input-wrapper">
                    <i class="fa-regular fa-user input-icon"></i>
                    <input type="text" id="username" name="username" placeholder="Pilih username unik" required>
                </div>
            </div>

            <div class="input-group">
                <label for="email">Email</label>
                <div class="input-wrapper">
                    <i class="fa-regular fa-envelope input-icon"></i>
                    <input type="email" id="email" name="email" placeholder="contoh@email.com" required>
                </div>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" placeholder="Buat password yang kuat" required>
                </div>
            </div>

            <div class="input-group">
                <label for="alamat">Alamat Lengkap</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-location-dot input-icon" style="top: 16px; transform: none;"></i>
                    <textarea id="alamat" name="alamat" placeholder="Masukkan alamat lengkap domisili" rows="3" required></textarea>
                </div>
            </div>

            <button type="submit" class="btn btn-accent">
                Daftar Akun Sekarang <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>

        <div class="auth-footer">
            <p>Sudah punya akun? <a href="<%=request.getContextPath()%>/login">Masuk di sini</a></p>
        </div>

    </div>
</div>

</body>
</html>
