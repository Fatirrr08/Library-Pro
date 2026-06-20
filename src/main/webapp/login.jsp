<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LibraryPro</title>
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

        .login-container {
            width: 100%;
            max-width: 440px;
            background: rgba(255, 255, 255, 0.98);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logo {
            font-size: 3.5rem;
            margin-bottom: 15px;
            color: var(--primary);
        }

        h1 {
            color: var(--bg-dark);
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        p {
            color: var(--text-muted);
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        .input-group {
            text-align: left;
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .input-group label {
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--text-dark);
        }

        .input-group-with-icon {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-group-with-icon i {
            position: absolute;
            left: 14px;
            color: var(--text-muted);
            font-size: 1rem;
        }

        .input-group-with-icon input {
            width: 100%;
            padding: 12px 14px 12px 42px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 0.95rem;
            outline: none;
            transition: var(--transition);
        }

        .input-group-with-icon input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }

        .btn-login {
            width: 100%;
            background: var(--primary);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            margin-top: 10px;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .btn-login:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.35);
        }

        .register {
            margin-top: 25px;
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .register a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
        }

        .register a:hover {
            color: var(--primary-hover);
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="logo">
        <i class="fa-solid fa-book-open-reader"></i>
    </div>

    <h1>LibraryPro</h1>
    <p>Silakan masuk ke akun Anda</p>

    <%-- Alert Notification --%>
    <%
        String error = (String) request.getAttribute("error");
        String registerSuccess = request.getParameter("registerSuccess");
        if (error != null) {
    %>
        <div class="alert alert-danger">
            <i class="fa-solid fa-triangle-exclamation"></i> <%= error %>
        </div>
    <%
        }
        if ("true".equals(registerSuccess)) {
    %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> Registrasi berhasil! Silakan login.
        </div>
    <%
        }
    %>

    <form action="<%=request.getContextPath()%>/login" method="post">
        <div class="input-group">
            <label>Username</label>
            <div class="input-group-with-icon">
                <i class="fa-solid fa-user"></i>
                <input type="text" name="username" placeholder="Masukkan username" required>
            </div>
        </div>

        <div class="input-group">
            <label>Password</label>
            <div class="input-group-with-icon">
                <i class="fa-solid fa-lock"></i>
                <input type="password" name="password" placeholder="Masukkan password" required>
            </div>
        </div>

        <button type="submit" class="btn-login">
            Masuk <i class="fa-solid fa-arrow-right-to-bracket" style="margin-left: 8px;"></i>
        </button>
    </form>

    <div class="register">
        Belum punya akun? <a href="<%=request.getContextPath()%>/register.jsp">Daftar Sekarang</a>
    </div>
</div>

</body>
</html>
