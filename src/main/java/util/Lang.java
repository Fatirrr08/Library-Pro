package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class Lang {
    public static String get(String key, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String lang = (session != null) ? (String) session.getAttribute("lang") : "id";
        if (lang == null) lang = "id";
        return get(key, lang);
    }

    public static String get(String key, String lang) {
        boolean isEn = "en".equalsIgnoreCase(lang);
        switch (key) {
            // Sidebar menu
            case "menu.dashboard": return isEn ? "Dashboard" : "Dashboard";
            case "menu.catalog": return isEn ? "Book Catalog" : "Katalog Buku";
            case "menu.history": return isEn ? "Borrowing History" : "Riwayat Peminjaman";
            case "menu.favorites": return isEn ? "My Favorites" : "Favorit Saya";
            case "menu.reviews": return isEn ? "My Reviews & Ratings" : "Ulasan & Rating Saya";
            case "menu.users": return isEn ? "Manage Users" : "Kelola Anggota";
            case "menu.books": return isEn ? "Manage Books" : "Kelola Buku";
            case "menu.categories": return isEn ? "Manage Categories" : "Kelola Kategori";
            case "menu.loans": return isEn ? "Manage Loans" : "Kelola Peminjaman";
            case "menu.all_reviews": return isEn ? "Manage Reviews" : "Kelola Ulasan";
            case "menu.profile": return isEn ? "My Profile" : "Profil Saya";
            case "menu.logout": return isEn ? "Logout" : "Logout";
            case "menu.lang_switch": return isEn ? "Language" : "Bahasa";
            
            // Topbar
            case "topbar.title": return isEn ? "Digital Library" : "Perpustakaan Digital";
            
            // Roles/Badges
            case "role.member": return isEn ? "Member" : "Anggota";
            case "role.admin": return isEn ? "Admin" : "Admin";
            
            // Page contents (Dashboard)
            case "dashboard.new_recommendations": return isEn ? "Latest Recommendations" : "Rekomendasi Buku Terbaru";
            case "dashboard.search_other": return isEn ? "Search Other Books" : "Cari Buku Lainnya";
            
            // Page contents (Katalog)
            case "katalog.title": return isEn ? "Library Book Catalog" : "Katalog Buku Perpustakaan";
            case "katalog.welcome_title": return isEn ? "Search & Borrow Books" : "Cari & Pinjam Buku";
            case "katalog.welcome_subtitle": return isEn ? "Explore various titles available for borrowing." : "Jelajahi berbagai judul buku yang tersedia untuk dipinjam.";
            case "katalog.search_placeholder": return isEn ? "Type a letter to search automatically..." : "Ketik satu huruf untuk mencari otomatis...";
            case "katalog.all_categories": return isEn ? "All Categories" : "Semua Kategori";
            case "katalog.search_btn": return isEn ? "Search Book" : "Cari Buku";
            case "katalog.reset_btn": return isEn ? "Reset Filter" : "Atur Ulang";
            
            // Page contents (Riwayat Peminjaman)
            case "history.title": return isEn ? "My Borrowing History" : "Riwayat Peminjaman Anda";
            case "history.subtitle": return isEn ? "View the status of your borrowed books and process returns." : "Lihat status buku yang Anda pinjam dan lakukan pengembalian secara mandiri.";
            case "history.badge_pay_counter": return isEn ? "Pay Fine at Counter!" : "Bayar Denda di Loket!";
            
            default: return key;
        }
    }
}
