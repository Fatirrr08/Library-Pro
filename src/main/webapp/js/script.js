document.addEventListener("DOMContentLoaded", function () {
    // Mobile Sidebar Toggling Logic
    const sidebarToggle = document.getElementById("sidebarToggle");
    const sidebar = document.querySelector(".sidebar");
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener("click", function (event) {
            event.stopPropagation();
            sidebar.classList.toggle("active");
        });

        // Close sidebar when clicking outside of it
        document.addEventListener("click", function (event) {
            if (sidebar.classList.contains("active") && 
                !sidebar.contains(event.target) && 
                event.target !== sidebarToggle && 
                !sidebarToggle.contains(event.target)) {
                sidebar.classList.remove("active");
            }
        });
    }
});