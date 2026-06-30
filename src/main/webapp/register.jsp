<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.StringUtils" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Anggota - LibraryPro</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">

    <%-- Resource Hints: preconnect for 3rd-party origins --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">

    <%-- Google Fonts (non-render-blocking via preconnect) --%>
    <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" media="print" onload="this.media='all'">

    <%-- FontAwesome 6 --%>
    <link rel="preload" as="style" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"></noscript>
    <script>(function(){var d=document;setTimeout(function(){for(var s=d.styleSheets,i=0;i<s.length;i++){if(s[i].href&&s[i].href.indexOf('font-awesome')>-1)return}var l=d.createElement('link');l.rel='stylesheet';l.href='https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.1/css/all.min.css';d.head.appendChild(l)},2500)})();</script>

    <%-- Application CSS --%>
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
                <button type="button" class="btn btn-outline btn-sm" id="detectLocationBtn" onclick="detectLocation()" style="margin-top: 6px; width: 100%;">
                    <i class="fa-solid fa-location-crosshairs"></i>
                    <span id="detectLocationText">Gunakan Lokasi Saat Ini</span>
                </button>
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

<div class="dark-mode-toggle" onclick="toggleDarkMode()" title="Toggle Dark Mode">
    <i class="fa-solid fa-moon"></i>
</div>

<script src="<%=request.getContextPath()%>/js/icon-fallback.js"></script>
<script>
function detectLocation() {
    var btn = document.getElementById("detectLocationBtn");
    var text = document.getElementById("detectLocationText");
    var textarea = document.getElementById("alamat");

    if (!navigator.geolocation) {
        alert("Browser Anda tidak mendukung Geolocation.");
        return;
    }

    btn.disabled = true;
    text.innerHTML = "Mendeteksi lokasi...";

    navigator.geolocation.getCurrentPosition(
        function (position) {
            var lat = position.coords.latitude;
            var lon = position.coords.longitude;

            fetch("https://nominatim.openstreetmap.org/reverse?format=json&lat=" + lat + "&lon=" + lon + "&accept-language=id")
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    var addr = data.display_name || lat + ", " + lon;
                    textarea.value = addr;
                    text.innerHTML = '<i class="fa-solid fa-check"></i> Lokasi ditemukan';
                    btn.disabled = false;
                    setTimeout(function () {
                        text.innerHTML = "Gunakan Lokasi Saat Ini";
                    }, 3000);
                })
                .catch(function () {
                    textarea.value = lat + ", " + lon;
                    text.innerHTML = "Gagal reverse geocoding, koordinat digunakan";
                    btn.disabled = false;
                });
        },
        function (err) {
            text.innerHTML = "Gunakan Lokasi Saat Ini";
            btn.disabled = false;
            if (err.code === 1) {
                alert("Akses lokasi ditolak. Izinkan akses lokasi di browser Anda.");
            } else {
                alert("Gagal mendapatkan lokasi: " + err.message);
            }
        },
        { enableHighAccuracy: true, timeout: 10000 }
    );
}

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
