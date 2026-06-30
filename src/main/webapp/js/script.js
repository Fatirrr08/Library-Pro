document.addEventListener("DOMContentLoaded", function () {
    var sidebarToggle = document.getElementById("sidebarToggle");
    var sidebar = document.querySelector(".sidebar");
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener("click", function (e) {
            e.stopPropagation();
            sidebar.classList.toggle("active");
        });
        document.addEventListener("click", function (e) {
            if (sidebar.classList.contains("active") && !sidebar.contains(e.target) && e.target !== sidebarToggle && !sidebarToggle.contains(e.target)) {
                sidebar.classList.remove("active");
            }
        });
    }
});
