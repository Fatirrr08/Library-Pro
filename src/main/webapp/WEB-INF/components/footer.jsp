<%-- footer.jsp — Closing tags + Scripts --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    boolean isInternal = loggedUser != null;
%>

<% if (isInternal) { %>
    </div>
</div>

<div class="modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="logout-warning-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="logout-title">Konfirmasi Logout</div>
        <div class="logout-desc">Apakah Anda yakin ingin keluar dari LibraryPro?</div>
        <div class="logout-btn-container">
            <button class="btn-cancel-logout" id="btnCancelLogout">Batal</button>
            <a href="<%=request.getContextPath()%>/logout" class="btn-confirm-logout">Ya, Keluar</a>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // Profile dropdown
    var profileTrigger = document.getElementById("profileTrigger");
    var dropdownMenu = document.getElementById("dropdownMenu");
    if (profileTrigger && dropdownMenu) {
        profileTrigger.addEventListener("click", function (e) {
            e.stopPropagation();
            dropdownMenu.classList.toggle("show");
        });
        document.addEventListener("click", function () {
            dropdownMenu.classList.remove("show");
        });
    }

    // Logout modal
    var logoutTrigger = document.getElementById("logoutTrigger");
    var logoutModal = document.getElementById("logoutModal");
    var btnCancelLogout = document.getElementById("btnCancelLogout");
    if (logoutTrigger && logoutModal && btnCancelLogout) {
        logoutTrigger.addEventListener("click", function (e) {
            e.preventDefault();
            if (dropdownMenu) dropdownMenu.classList.remove("show");
            logoutModal.classList.add("show");
        });
        btnCancelLogout.addEventListener("click", function () {
            logoutModal.classList.remove("show");
        });
        window.addEventListener("click", function (e) {
            if (e.target === logoutModal) logoutModal.classList.remove("show");
        });
    }

    // Sidebar toggle
    var sidebarToggle = document.getElementById("sidebarToggle");
    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", function () {
            document.querySelector(".sidebar").classList.toggle("collapsed");
            document.querySelector(".main-content").classList.toggle("expanded");
        });
    }
});
</script>
<script src="<%=request.getContextPath()%>/js/script.js"></script>
<% } %>

</body>
</html>
