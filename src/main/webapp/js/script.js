(function(){
  var sidebarToggle = document.getElementById("sidebarToggle");
  var sidebar = document.querySelector(".sidebar");
  var overlay = document.querySelector(".sidebar-overlay");

  if (!overlay && sidebar) {
    overlay = document.createElement("div");
    overlay.className = "sidebar-overlay";
    document.body.appendChild(overlay);
  }

  function toggleSidebar(show) {
    if (!sidebar) return;
    if (show === undefined) {
      var isActive = sidebar.classList.contains("active") || sidebar.classList.contains("open");
      show = !isActive;
    }
    sidebar.classList.toggle("active", show);
    sidebar.classList.toggle("open", show);
    if (overlay) overlay.classList.toggle("show", show);
    if (show) document.body.style.overflow = "hidden";
    else document.body.style.overflow = "";
  }

  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener("click", function(e) {
      e.stopPropagation();
      toggleSidebar();
    });
    document.addEventListener("click", function(e) {
      if (sidebar.classList.contains("active") && !sidebar.contains(e.target) && e.target !== sidebarToggle && !sidebarToggle.contains(e.target)) {
        toggleSidebar(false);
      }
    });
  }

  if (overlay) {
    overlay.addEventListener("click", function() { toggleSidebar(false); });
  }

  // Page loader fade-out
  var loader = document.getElementById("pageLoader") || document.querySelector(".page-loader");
  if (loader) {
    window.addEventListener("load", function() {
      setTimeout(function() { loader.classList.add("hidden"); }, 200);
    });
    setTimeout(function() {
      if (loader && !loader.classList.contains("hidden")) {
        loader.classList.add("hidden");
      }
    }, 5000);
  }
})();
