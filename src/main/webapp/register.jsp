<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LibraryPro - Register</title>
    <link rel="icon" type="image/png" href="https://i.imgur.com/oZIZRfO.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #0f172a, #1e1b4b);
            padding: 20px;
        }

        .register-container {
            width: 100%;
            max-width: 500px;
            background: rgba(255, 255, 255, 0.98);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logo {
            font-size: 3rem;
            margin-bottom: 10px;
            color: var(--primary);
        }

        h2 {
            color: var(--bg-dark);
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        p {
            color: var(--text-muted);
            margin-bottom: 25px;
            font-size: 0.9rem;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
            text-align: left;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--text-dark);
        }

        .input-with-icon {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-with-icon i {
            position: absolute;
            left: 14px;
            color: var(--text-muted);
            font-size: 1rem;
        }

        .input-with-icon input,
        .input-with-icon textarea {
            width: 100%;
            padding: 11px 14px 11px 42px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 0.95rem;
            outline: none;
            transition: var(--transition);
        }

        .input-with-icon textarea {
            padding-left: 42px;
            resize: none;
            height: 70px;
        }

        .input-with-icon input:focus,
        .input-with-icon textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }

        .btn-register {
            width: 100%;
            background: var(--primary);
            color: white;
            border: none;
            padding: 13px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            margin-top: 10px;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
            text-align: center;
        }

        .btn-register:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.35);
        }

        .login-link {
            margin-top: 20px;
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .login-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
        }

        .login-link a:hover {
            color: var(--primary-hover);
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="logo">
        <i class="fa-solid fa-user-plus"></i>
    </div>

    <h2>Daftar Anggota</h2>
    <p>Buat akun perpustakaan baru Anda</p>

    <%-- Alert Notification --%>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="alert alert-danger" style="margin-bottom: 20px; padding: 10px 15px;">
            <i class="fa-solid fa-triangle-exclamation"></i> <%= error %>
        </div>
    <%
        }
    %>

    <form action="<%=request.getContextPath()%>/register" method="post">
        <div class="form-group">
            <label>Nama Lengkap</label>
            <div class="input-with-icon">
                <i class="fa-solid fa-id-card"></i>
                <input type="text" name="nama" placeholder="Masukkan nama lengkap Anda" required>
            </div>
        </div>

        <div class="form-group">
            <label>Username</label>
            <div class="input-with-icon">
                <i class="fa-solid fa-user"></i>
                <input type="text" name="username" placeholder="Masukkan username" required>
            </div>
        </div>

        <div class="form-group">
            <label>Email</label>
            <div class="input-with-icon">
                <i class="fa-solid fa-envelope"></i>
                <input type="email" name="email" placeholder="Masukkan alamat email" required>
            </div>
        </div>

        <div class="form-group">
            <label>Password</label>
            <div class="input-with-icon">
                <i class="fa-solid fa-lock"></i>
                <input type="password" name="password" placeholder="Masukkan password" required>
            </div>
        </div>

        <div class="form-group">
            <label>Alamat</label>
            <div class="input-with-icon">
                <i class="fa-solid fa-location-dot" style="top: 15px;"></i>
                <textarea name="alamat" placeholder="Masukkan alamat lengkap" required></textarea>
            </div>
        </div>

        <button type="submit" class="btn-register">
            Register Akun <i class="fa-solid fa-user-check" style="margin-left: 8px;"></i>
        </button>
    </form>

    <div class="login-link">
        Sudah punya akun? <a href="<%=request.getContextPath()%>/login.jsp">Masuk di sini</a>
    </div>
</div>

</body>
</html>
