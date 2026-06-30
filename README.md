# 📚 LibraryPro — Library Management System

**Sistem Informasi Manajemen Perpustakaan Berbasis Web** — Java Web (JSP & Servlets), MVC Architecture, MySQL.

> 🚀 **Live Demo:** [https://librarypro.up.railway.app](https://librarypro.up.railway.app)

---

## ✨ Fitur Utama

### 🛡️ Admin (Pustakawan)
- **Dashboard Analitik** — statistik real-time total buku, peminjaman aktif, validasi pending
- **Manajemen Katalog** — CRUD buku + kategori (dengan upload sampul buku)
- **Manajemen Pengguna** — kelola data anggota
- **Validasi Peminjaman** — setujui/tolak pinjaman, stok otomatis
- **Moderasi Ulasan** — monitoring & hapus ulasan

### 👥 Anggota (Pembaca)
- **Katalog + Sampul Buku** — setiap buku menampilkan gambar sampul (jika diunggah)
- **Katalog + Fuzzy Search** — cari buku dengan toleransi typo (Levenshtein)
- **Peminjaman** — ajukan pinjam, riwayat, denda Rp1.000/hari
- **Favorit** — wishlist buku
- **Ulasan & Rating** — rating 1-5, 1 ulasan per buku (anti-spam)
- **Profil** — edit data + foto (cropper.js) + **deteksi alamat otomatis** (geolocation)
- **Lupa Password** — reset password via pertanyaan keamanan (3-step flow)

---

## 🛠️ Tech Stack

| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| Java | 17 | Bahasa utama |
| Jakarta Servlet | 6.0 | Controller |
| JSP | 3.1 | View template |
| MySQL / MariaDB | — | Database |
| Tomcat | 10.x | App server |
| Maven | — | Build tool |
| jBCrypt | 0.4 | Password hashing |
| FontAwesome 6 | 6.5.1 | Ikon (SVG/JS — tanpa web font) |
| Docker | — | Containerization |
| Railway | — | Cloud hosting |

---

## 🧱 Struktur Proyek

```
src/main/java/
├── config/DBConnection.java       ← Koneksi DB (environment-based)
├── controller/                    ← 13 Servlets
│   ├── LoginServlet.java          ← Auth + polymorphic Admin/Anggota
│   ├── RegisterServlet.java       ← Daftar anggota baru
│   ├── DashboardServlet.java      ← Routing dashboard (role-aware)
│   ├── BukuServlet.java           ← CRUD buku
│   ├── KategoriServlet.java       ← CRUD kategori
│   ├── UserServlet.java           ← CRUD user (admin)
│   ├── PeminjamanServlet.java     ← Flow peminjaman
│   ├── AdminPeminjamanServlet.java
│   ├── FavoritServlet.java        ← Toggle favorit
│   ├── UlasanServlet.java         ← Review system
│   ├── ReviewBukuServlet.java     ← Public review viewer
│   ├── ProfileServlet.java        ← Profil + foto (Base64)
│   └── LogoutServlet.java
├── dao/                           ← 6 DAO + BaseDAO (abstract)
│   ├── BaseDAO.java               ← Abstract class (template)
│   ├── UserDAO.java               ← Polymorphic login ⭐
│   ├── BukuDAO.java
│   ├── KategoriDAO.java
│   ├── PeminjamanDAO.java         ← implements Transaksi + transactions
│   ├── FavoritDAO.java
│   └── UlasanDAO.java
├── model/                         ← POJOs + Enums
│   ├── User.java                  ← Superclass
│   ├── Admin.java                 ← extends User
│   ├── Anggota.java               ← extends User
│   ├── Buku.java, Peminjaman.java, Ulasan.java, Favorit.java, Kategori.java
│   └── enums/
│       ├── StatusPeminjaman.java
│       └── UserLevel.java
├── filter/AuthFilter.java         ← Security gate (/*)
├── interfaces/Transaksi.java      ← Interface (pinjam + kembalikan)
└── exception/                     ← Custom exceptions
    ├── BookNotFoundException.java
    └── InsufficientStockException.java

src/main/webapp/
├── admin/                         ← 6 JSP (dashboard, buku, kategori, user, peminjaman, ulasan)
├── anggota/                       ← 6 JSP (dashboard, katalog, peminjaman, favorit, ulasan, RiviewBuku)
├── css/
│   ├── style-global.css           ← Design system (variables, utility, motion)
│   ├── style.css                  ← Layouts (sidebar, cards, tables, modals)
│   └── style-auth.css             ← Login/register styling
├── js/
│   ├── script.js                  ← Sidebar toggle, page loader
│   ├── icon-fallback.js           ← FA fallback (Unicode + multi-CDN)
│   └── search.js                  ← Fuzzy search (Levenshtein)
├── login.jsp, register.jsp, profile.jsp
└── WEB-INF/web.xml
```

---

## 🏗️ OOP Features (for PBO Presentation)

| Konsep | Implementasi | Contoh |
|--------|-------------|--------|
| **Encapsulation** | Semua field `private`, getter/setter | `User.java` — 8 private fields |
| **Inheritance** | `User → Admin`, `User → Anggota` | `Admin extends User` |
| **Polymorphism** | `User user = new Admin()` | `UserDAO.login()` ⭐ |
| **Abstraction** | `Transaksi` interface, `BaseDAO` abstract | `implements Transaksi` |
| **Method Overriding** | `toString()`, `getEntityName()` | Semua model override toString |
| **Method Overloading** | `closeResources()` | 2 params vs 3 params |
| **Custom Exception** | 2 custom unchecked exceptions | `BookNotFoundException` |
| **Enum** | Type-safe constants | `StatusPeminjaman`, `UserLevel` |

---

## 🚀 Panduan Instalasi

### Prasyarat
- Java 17+
- Maven 3.9+
- MySQL / MariaDB
- Tomcat 10 (atau pakai Cargo plugin embedded)

### 1. Clone & Database
```bash
git clone https://github.com/Fatirrr08/Library-Pro.git
mysql -u root -p < librarymanagamentsystem.sql
```

### 2. Jalankan dengan Embedded Tomcat
```bash
export MYSQL_HOST=localhost
export MYSQL_PORT=3306
export MYSQL_DB=librarymanagamentsystem
export MYSQL_USER=root
export MYSQL_PASSWORD=

mvn clean package cargo:run
```

Akses di: `http://localhost:8080/LibraryManagementSystem`

### 🔐 Akun Demo
| Role | Username | Password |
|------|----------|----------|
| **Admin** | admin | 123 |
| **Anggota** | maruf | 123 |

---

## 🐳 Deployment (Railway)

Proyek ini di-deploy ke Railway menggunakan Docker multi-stage build:

```bash
git push fork main
railway up
```

**URL:** [https://librarypro.up.railway.app](https://librarypro.up.railway.app)

### Environment Variables
| Variable | Contoh |
|----------|--------|
| `MYSQL_HOST` | `containers-us-west-xxx.railway.app` |
| `MYSQL_PORT` | `3306` |
| `MYSQL_DB` | `librarymanagamentsystem` |
| `MYSQL_USER` | `root` |
| `MYSQL_PASSWORD` | `xxx` |

---

## 📊 Database Schema

6 tabel aktif:

- **`user`** — accounts (id_user, username, password(bcrypt), email, nama_lengkap, alamat, level, foto_profil)
- **`buku`** — books (id_buku, judul, penulis, penerbit, tahun_terbit, jml_buku, isbn, abstraksi, foto_buku, id_kategori FK)
- **`kategori`** — categories (id_kategori, nama_kategori)
- **`peminjaman`** — borrows (id_peminjaman, id_user FK, id_buku FK, tanggal_pinjam, tanggal_tenggat, tanggal_kembali, status ENUM, denda)
- **`favorit`** — favorites (id_favorit, id_user FK, id_buku FK)
- **`ulasan`** — reviews (id_ulasan, id_user FK, id_buku FK, ulasan, rating) — UNIQUE(id_user, id_buku)

---

## 📄 Dokumen Terkait

- [`TECHNICAL.md`](TECHNICAL.md) — Technical audit & OOP analysis detail
- [`ppt.md`](ppt.md) — Presentasi (format Marp)

---

## 📝 Lisensi

Proyek ini dibuat untuk tujuan edukasi — Final Project PBO (Pemrograman Berorientasi Objek).
