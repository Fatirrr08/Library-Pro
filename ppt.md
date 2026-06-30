---
marp: true
theme: uncover
class:
  - lead
  - invert
paginate: true
---

<!-- _class: lead invert -->

# **📚 LibraryPro**
### Sistem Informasi Manajemen Perpustakaan Berbasis Web

**Java Web (JSP & Servlets) | MVC Architecture | MySQL**

---

# 👥 Anggota Kelompok

| Nama | Peran |
|------|-------|
| **[Nama 1]** | Project Lead / Fullstack Developer |
| **[Nama 2]** | Backend Developer (DAO & Servlets) |
| **[Nama 3]** | Frontend Developer (JSP, CSS, JS) |
| **[Nama 4]** | Database Designer & Tester |

---

# 🎯 Latar Belakang

- Perpustakaan masih menggunakan sistem **manual** (buku tamu, katalog cetak)
- Sirkulasi peminjaman **tidak terpantau** secara real-time
- Tidak ada **sistem ulasan & rating** untuk komunitas pembaca
- Data buku dan anggota **rentan hilang** karena catatan fisik

Diperlukan sistem digital yang **terintegrasi, terotomatisasi, dan mudah diakses**

---

# 🏗️ Tujuan Proyek

1. **Digitalisasi** sirkulasi buku dan peminjaman
2. **Dashboard analitik** real-time untuk pustakawan
3. **Sistem ulasan & rating** berbasis komunitas
4. **Manajemen stok** buku otomatis
5. **Validasi peminjaman** dengan workflow yang jelas

---

# 🛠️ Arsitektur Sistem

```
┌──────────────────────────────────────────────────┐
│                 Client (Browser)                  │
├──────────────────────────────────────────────────┤
│              Jakarta Servlet (Controller)          │
├──────────────────────────────────────────────────┤
│         DAO Layer (Data Access Object)             │
├──────────────────────────────────────────────────┤
│            MySQL / MariaDB Database                │
└──────────────────────────────────────────────────┘
```

**Pola Desain:** MVC (Model-View-Controller) + DAO

---

# 🧱 Struktur Project

```
src/
├── main/java/
│   ├── config/          → DBConnection.java
│   ├── controller/      → 14 Servlets (+ ForgotPasswordServlet)
│   ├── dao/             → 7 DAO classes
│   ├── model/           → 10 Model classes + Enums
│   ├── exception/       → 2 Custom Exceptions
│   ├── filter/          → AuthFilter.java
│   ├── interfaces/      → Transaksi.java
│   └── util/            → PasswordUtils, StringUtils
├── main/webapp/
│   ├── admin/           → 6 JSP pages
│   ├── anggota/         → 6 JSP pages
│   ├── css/             → 3 stylesheets
│   ├── js/              → 3 JS files
│   └── *.jsp            → login, register, profile, forgot-password
└── test/java/           → 6 Unit Tests
```

---

# 👑 Fitur Admin

### Dashboard Analitik
- **Total Buku**, **Total User**, **Total Peminjaman**
- **Peminjaman Aktif** & **Menunggu Validasi**
- **5 Buku Terbaru** tampil otomatis

### Manajemen Katalog
- **CRUD Buku** — Tambah, Edit, Hapus buku (plus upload sampul buku)
- **CRUD Kategori** — Kelola kategori buku
- Upload **ISBN & Abstraksi & Sampul Buku**

---

# 👑 Fitur Admin (Lanjutan)

### Manajemen User
- Lihat daftar seluruh anggota
- Edit data pengguna

### Validasi Peminjaman
- ✅ **Setujui** — stok buku berkurang otomatis
- ❌ **Tolak** — status diubah
- 🔄 **Kembalikan** — stok pulih, denda terhitung

### Moderasi Ulasan
- Monitor semua ulasan dari anggota
- **Hapus** ulasan spam/tidak pantas

---

# 👥 Fitur Anggota

### Katalog Buku
- **Live Fuzzy Search** — cari real-time dengan toleransi typo (Levenshtein distance)
- **Filter Kategori** — sortir buku berdasarkan kategori
- **Modal Detail** — lihat informasi lengkap buku + ulasan publik
- **Sampul Buku** — cover image di setiap kartu buku

### Peminjaman
- **Ajukan Pinjam** — status otomatis "menunggu"
- **Riwayat Peminjaman** — lihat status, tenggat, denda
- Denda dihitung **Rp1.000/hari** keterlambatan

---

# 👥 Fitur Anggota (Lanjutan)

### Koleksi Favorit
- **Tambah/Hapus** buku favorit (wishlist)
- Tampilan khusus daftar favorit

### Ulasan & Rating ⭐
- **Rating 1-5 bintang** dengan input visual
- **1 anggota = 1 ulasan** per buku (anti-spam)
- **Edit** ulasan yang sudah dikirim
- **Unique Constraint** di level database

### Profil Pengguna
- Edit **nama, email, password, alamat**
- **Deteksi Lokasi Otomatis** — isi alamat pakai geolocation + OpenStreetMap
- Upload **foto profil** dengan **cropper.js** (crop + preview)

### 🔑 Lupa Password
- **3-step flow**: Username → Pertanyaan Keamanan → Reset Password
- Pertanyaan keamanan ditentukan saat registrasi
- Password di-hash dengan bcrypt sebelum disimpan
- Anti-brute force dengan verifikasi jawaban case-insensitive

---

# 🎨 Fitur UI/UX Unggulan

### ✨ Frontend Features
- **Upload Sampul Buku** — admin dapat upload cover image buku (JPG/PNG, max 2MB)
- **Fuzzy Search** — filter buku dengan toleransi kesalahan ketik
- **Cropper.js** — crop & preview foto profil interaktif
- **Dark Mode** — toggle tema gelap/terang, persist via localStorage
- **Toast Notifications** — animasi sukses/gagal premium
- **Auto-Detect Address** — geolocation + Nominatim reverse geocoding
- **Page Loader** — spinner animasi saat halaman dimuat
- **Logout Confirmation Modal** — cegah logout tidak sengaja
- **Detail Buku Modal** — lihat info buku tanpa pindah halaman
- **Star Rating** — input rating dengan visual bintang interaktif
- **Responsive Sidebar** — overlay mobile dengan backdrop
- **Skeleton Loading** — shimmer effect untuk placeholder

### 🎨 Design System
- Gradien warna biru/indigo modern
- FontAwesome 6 (SVG/JS — tidak pakai web font, anti tofu!)
- Card-based layout dengan glassmorphism
- Smooth transitions & hover effects
- Color-coded status badges
- Mobile-first responsive breakpoints (1024/768/480px)

---

# 🗄️ Entity Relationship Diagram

### 6 Tabel Aktif

```
┌─────────┐    ┌──────────────┐    ┌───────────┐
│  user   │◄───│  peminjaman  │───►│   buku    │
└─────────┘    └──────────────┘    └───────────┘
     │                                  │
     │    ┌───────────┐                 │
     ├───►│  ulasan   │◄────────────────┘
     │    └───────────┘
     │    ┌───────────┐
     └───►│  favorit  │◄────────────────┘
          └───────────┘
                              ┌───────────┐
                              │ kategori  │◄──── buku
                              └───────────┘
```
🔹 Relasi foreign key dengan CASCADE DELETE
🔹 Unique Constraint `(id_user, id_buku)` di tabel `ulasan` — anti-spam

---

# 🔐 Alur Autentikasi & Otorisasi

```
Request Masuk
     │
     ▼
┌─────────────────┐
│   AuthFilter    │──► Static assets (/css/, /js/)? → Allow
│   @WebFilter    │──► Login/Register? → Allow
│     ("/*")      │──► Lainnya? → Cek Session
└─────────────────┘
     │
     ▼
┌─────────────────┐
│  Cek Session    │──► Tidak ada sesi → Redirect login
│  (user object)  │
└─────────────────┘
     │
     ▼
┌──────────────────────────┐
│     Otorisasi Halaman    │
│  /admin/*  → Admin only  │
│  /anggota/* → Anggota    │
│  /buku, /kategori → Admin│
│  /ulasan   → Both roles  │
└──────────────────────────┘
```

---

# 💻 Teknologi

| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| **Java** | 17+ | Bahasa pemrograman utama |
| **Jakarta Servlet** | 6.0 | Framework web (Controller) |
| **JSP** | 3.1 | Template view (View) |
| **MySQL** | 8+ / MariaDB | Database |
| **Maven** | 3.9+ | Build tool & dependency |
| **Tomcat** | 10.x | Application server |
| **jBCrypt** | 0.4 | Hashing password |
| **Docker** | — | Container deployment |
| **Railway** | — | Cloud hosting |

---

# 💻 Teknologi Frontend

| Teknologi | Kegunaan |
|-----------|----------|
| **FontAwesome 6 (SVG/JS)** | Ikon — inline SVG, tanpa web font 📌 |
| **Plus Jakarta Sans** | Font utama (Google Fonts) |
| **Cropper.js** | Crop foto profil |
| **OpenStreetMap Nominatim** | Reverse geocoding (deteksi alamat) |
| **Custom Fuzzy Search** | Levenshtein + token scoring |
| **CSS Custom Properties** | Dark mode via `[data-theme]` |
| **CSS Animations** | Page loader, stagger, hover lift |

---

# 🧪 Implementasi OOP

| Konsep OOP | Implementasi |
|-----------|--------------|
| **Inheritance** | `Admin extends User`, `Anggota extends User`, `BukuDAO extends BaseDAO` |
| **Polymorphism** | `User user = new Admin()` / `new Anggota()` berdasarkan level dari DB ⭐ |
| **Abstract Class** | `BaseDAO` — template `getConnection()`, abstract `getEntityName()` |
| **Interface** | `Transaksi` — kontrak `pinjam()` dan `kembalikan()` |
| **Encapsulation** | Semua field model `private`, akses via getter/setter |
| **Custom Exception** | `BookNotFoundException`, `InsufficientStockException` |
| **Enum** | `StatusPeminjaman`, `UserLevel` — type-safe constants |
| **Method Overloading** | `closeResources()` overload 2 parameter vs 3 parameter |

---

# 🔒 Keamanan

### ✅ Sudah Diimplementasikan
- **Session-based Authentication** — login/logout dengan HttpSession
- **Filter Authorization** — `AuthFilter` proteksi halaman per role
- **SQL Injection Prevention** — PreparedStatement di semua query
- **Password Hashing** — bcrypt via jBCrypt (backward compatible)
- **XSS Prevention** — escaping output dengan `StringUtils.escapeHtml()`
- **Upload Validation** — whitelist extension (JPG/PNG), max 2MB
- **Lupa Password** — 3-step flow: username → security question → reset password

### Alur Validasi Peminjaman
1. Anggota ajukan pinjam → status **menunggu**
2. Admin **setujui/tolak** → stok berubah otomatis
3. Buku **dikembalikan** → stok pulih, denda dihitung

---

# 🔄 Flow Peminjaman

```
Anggota                        Admin                       Sistem
   │                            │                           │
   ├── Ajukan Pinjam ──────────►│                           │
   │                            │        Cek Stok Buku ◄────┤
   │                            │                           │
   │                            ├── Setujui ───────────────►│
   │                            │        Stok -1            │
   │                            │        Tenggat +1 bulan   │
   │                            │                           │
   │◄──── Status "disetujui" ───┤                           │
   │                            │                           │
   │                            ├── Tolak ─────────────────►│
   │◄──── Status "ditolak" ─────┤                           │
   │                            │                           │
   │                            │                           │
   ├── Kembalikan Buku ────────►│                           │
   │                            ├── Proses Kembali ────────►│
   │                            │        Stok +1            │
   │                            │        Hitung Denda       │
   │◄──── Status "dikembalikan" ─┤                           │
```

---

# 🧪 Pengujian

### Unit Test (JUnit 5)
| Test | Deskripsi |
|------|-----------|
| `BukuDAOTest` | Integration test untuk BukuDAO |
| `BukuTest` | Model unit test |
| `PeminjamanTest` | Model unit test |
| `UserTest` | Model unit test |
| `BookNotFoundExceptionTest` | Custom exception test |
| `InsufficientStockExceptionTest` | Custom exception test |

### Cakupan
- ✅ Validasi login/logout
- ✅ CRUD buku dan kategori
- ✅ Alur peminjaman (ajukan → setujui → kembali)
- ✅ Sistem ulasan (tambah, edit, duplicate prevention)
- ✅ Fitur favorit
- ✅ Upload foto profil
- ✅ Otorisasi role (admin vs anggota)

---

# 🐳 Deployment — Railway

### Docker Multi-Stage Build
```dockerfile
# Stage 1: Build WAR
FROM maven:3.9.6-eclipse-temurin-21-jammy AS build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run di Tomcat
FROM tomcat:10.1-jdk21-openjdk-slim
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
COPY librarymanagamentsystem.sql /schema.sql
COPY wait-for-mysql.sh /usr/local/bin/
CMD ["wait-for-mysql.sh"]
```

### Deploy
```bash
git push fork main
railway up
```

**Live URL:** https://librarypro.up.railway.app

---

# 🐳 Local Development

```bash
# 1. Import database
mysql -u root -p < librarymanagamentsystem.sql

# 2. Set environment variables
export MYSQL_HOST=localhost
export MYSQL_PORT=3306
export MYSQL_DB=librarymanagamentsystem
export MYSQL_USER=root
export MYSQL_PASSWORD=

# 3. Jalankan
mvn cargo:run

# Build WAR
mvn clean package

# Akses
http://localhost:8080/LibraryManagementSystem
```

### 🔐 Akun Demo
| Role | Username | Password |
|------|----------|----------|
| **Admin** | admin | 123 |
| **Anggota** | maruf | 123 |

---

# 📊 Statistik Proyek

| Metrik | Jumlah |
|--------|--------|
| **File Java** | ~37 source files |
| **File JSP** | 16 pages |
| **CSS Files** | 3 (22KB + 36KB + 3.4KB) |
| **JS Files** | 3 (search, script, icon-fallback) |
| **DAO Classes** | 6 + 1 abstract |
| **Model Classes** | 9 (incl. enums) |
| **Servlet Controllers** | 13 |
| **Tabel Database** | 6 aktif |
| **Unit Tests** | 6 |

---

# 🔮 Pengembangan Selanjutnya

### Potential Enhancements
- 📱 **Responsive Mobile** — tampilan mobile-first yang lebih optimal
- 📧 **Email Notification** — notifikasi status peminjaman via email
- 📊 **Grafik Dashboard** — chart.js untuk visualisasi data
- 🔍 **Pagination** — untuk daftar buku & peminjaman yang besar
- 📖 **Sampul Buku** — upload & tampilkan cover buku
- 🌐 **REST API** — endpoint JSON untuk integrasi
- 📝 **Export Report** — export data peminjaman ke PDF/Excel
- 🔐 **2FA** — two-factor authentication untuk admin

---

# 🙏 Penutup

### Terima Kasih!

LibraryPro hadir sebagai solusi manajemen perpustakaan modern yang:

✅ **Mudah digunakan** — interface intuitif dan responsif
✅ **Aman** — proteksi role, password hashing, XSS prevention
✅ **Terstruktur** — menerapkan OOP dan MVC dengan baik
✅ **Dapat dikembangkan** — arsitektur modular dan extensible

---

# 📋 Q & A

### Pertanyaan?
<!-- Silakan bertanya -->

---

<!-- _class: lead invert -->
# **Demo Aplikasi** 🚀
