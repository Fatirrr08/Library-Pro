<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.StringUtils" %>
<%
    request.setAttribute("pageTitle", "Login");
    request.setAttribute("extraCss", "style-auth.css");
%>
<%@ include file="/WEB-INF/components/header.jsp" %>

<div class="auth-page">
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
</div>

<%@ include file="/WEB-INF/components/footer.jsp" %>
