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
│   ├── controller/      → 13 Servlets
│   ├── dao/             → 7 DAO classes
│   ├── model/           → 10 Model classes + Enums
│   ├── exception/       → 2 Custom Exceptions
│   ├── filter/          → AuthFilter.java
│   ├── interfaces/      → Transaksi.java
│   └── util/            → PasswordUtils, StringUtils
├── main/webapp/
│   ├── admin/           → 6 JSP pages
│   ├── anggota/         → 6 JSP pages
│   ├── css/             → style.css
│   ├── js/              → script.js
│   └── *.jsp            → login, register, profile
└── test/java/           → 6 Unit Tests
```

---

# 👑 Fitur Admin

### Dashboard Analitik
- **Total Buku**, **Total User**, **Total Peminjaman**
- **Peminjaman Aktif** & **Menunggu Validasi**
- **5 Buku Terbaru** tampil otomatis

### Manajemen Katalog
- **CRUD Buku** — Tambah, Edit, Hapus buku
- **CRUD Kategori** — Kelola kategori buku
- Upload **ISBN & Abstraksi**

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
- **Live Search** — cari real-time berdasarkan judul/penulis/penerbit
- **Filter Kategori** — sortir buku berdasarkan kategori
- **Modal Detail** — lihat informasi lengkap buku
- **Lihat Ulasan & Rating** publik

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
- Edit **nama, email, password**
- Upload **foto profil** dengan **cropper.js**
- Hapus foto profil

---

# 🗄️ Entity Relationship Diagram

### 6 Tabel Aktif + 1 Legacy

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
🔹 Tabel `tabel_buku` (legacy) tidak digunakan dalam kode

---

# 🔐 Alur Autentikasi & Otorisasi

```
Request Masuk
     │
     ▼
┌─────────────────┐
│   AuthFilter    │──► Static assets? → Allow
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
┌──────────────────────┐
│  Otorisasi Halaman   │
│  /admin/*  → Admin   │
│  /anggota/* → Anggota│
│  /ulasan   → Both    │
└──────────────────────┘
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
| **Cropper.js** | 1.6 | Crop foto profil |
| **FontAwesome** | 6.5 | Icon library |
| **Cargo Plugin** | 1.10 | Embedded Tomcat |

---

# 🧪 Implementasi OOP

| Konsep OOP | Implementasi |
|-----------|--------------|
| **Inheritance** | `Admin extends User`, `Anggota extends User`, `BukuDAO extends BaseDAO` |
| **Polymorphism** | `User user = new Admin()` / `new Anggota()` berdasarkan level |
| **Abstract Class** | `BaseDAO` — template method `getEntityName()` |
| **Interface** | `Transaksi` — kontrak `pinjam()` dan `kembalikan()` |
| **Encapsulation** | Semua field model `private`, akses via getter/setter |
| **Custom Exception** | `BookNotFoundException`, `InsufficientStockException` |
| **Enum** | `StatusPeminjaman`, `UserLevel` — type-safe constants |

---

# 🔒 Keamanan

### ✅ Sudah Diimplementasikan
- **Session-based Authentication** — login/logout dengan HttpSession
- **Filter Authorization** — `AuthFilter` proteksi halaman per role
- **SQL Injection Prevention** — PreparedStatement di semua query
- **Password Hashing** — bcrypt via jBCrypt
- **XSS Prevention** — escaping output dengan `StringUtils.escapeHtml()`
- **Upload Validation** — whitelist extension (JPG/PNG), max 2MB

### Alur Validasi Peminjaman
1. Anggota ajukan pinjam → status **menunggu**
2. Admin **setujui/tolak** → stok berubah otomatis
3. Buku **dikembalikan** → stok pulih, denda dihitung

---

# 🔍 Arsitektur MVC

```
┌──────────────────────────────────────────────────┐
│                    VIEW (JSP)                     │
│  katalog.jsp, peminjaman.jsp, ulasan.jsp, dll    │
└──────────────────────┬───────────────────────────┘
                       │ HTTP Request/Response
                       ▼
┌──────────────────────────────────────────────────┐
│              CONTROLLER (Servlet)                 │
│  LoginServlet, BukuServlet, PeminjamanServlet    │
│  UlasanServlet, FavoritServlet, ProfileServlet   │
└──────────────────────┬───────────────────────────┘
                       │ Method Calls
                       ▼
┌──────────────────────────────────────────────────┐
│               MODEL (DAO + POJO)                  │
│  UserDAO, BukuDAO, PeminjamanDAO, UlasanDAO      │
│  User, Buku, Peminjaman, Ulasan, Kategori        │
└──────────────────────┬───────────────────────────┘
                       │ JDBC
                       ▼
┌──────────────────────────────────────────────────┐
│                   DATABASE                        │
│            MySQL / MariaDB                        │
└──────────────────────────────────────────────────┘
```

---

# 📦 Database Schema

### Tabel `user`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id_user | INT (PK) | Auto increment |
| username | VARCHAR(50) | Unique |
| password | VARCHAR(255) | bcrypt hash |
| email | VARCHAR(100) | |
| nama_lengkap | VARCHAR(100) | |
| alamat | TEXT | |
| level | VARCHAR(20) | admin / anggota |
| foto_profil | VARCHAR(255) | Path file |

### Tabel `buku`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id_buku | INT (PK) | Auto increment |
| judul | VARCHAR(100) | |
| penulis | VARCHAR(50) | |
| penerbit | VARCHAR(50) | |
| tahun_terbit | INT | |
| jml_buku | INT | Stok tersedia |
| isbn | VARCHAR(50) | |
| abstraksi | TEXT | Sinopsis |
| id_kategori | INT (FK) → kategori |

---

# 📦 Database Schema (Lanjutan)

### Tabel `peminjaman`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id_peminjaman | INT (PK) | Auto increment |
| id_user | INT (FK) → user | |
| id_buku | INT (FK) → buku | |
| tanggal_pinjam | DATE | |
| tanggal_tenggat | DATE | +1 bulan dari acc |
| tanggal_kembali | DATE | Null jika belum |
| status | ENUM | 'menunggu', 'disetujui', 'ditolak', 'dikembalikan' |
| denda | DECIMAL(10,2) | Rp1.000/hari telat |

### Tabel `ulasan`
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| id_ulasan | INT (PK) | Auto increment |
| id_user | INT (FK) → user | |
| id_buku | INT (FK) → buku | |
| ulasan | TEXT | Komentar |
| rating | INT | 1-5 |

🔒 **Unique Constraint:** `(id_user, id_buku)` — 1 ulasan per anggota per buku

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

# 🎨 Fitur UI/UX Unggulan

### ✨ Frontend Features
- **Live Search** — filter buku real-time tanpa reload
- **Cropper.js** — crop & preview foto profil interaktif
- **Toast Notifications** — animasi sukses/gagal premium
- **Logout Confirmation Modal** — cegah logout tidak sengaja
- **Detail Buku Modal** — lihat info buku tanpa pindah halaman
- **Star Rating** — input rating dengan visual bintang interaktif
- **Dropdown Profil** — akses cepat menu profil & logout
- **Responsive Sidebar** — navigasi yang rapi dan intuitif

### 🎨 Design System
- Gradien warna biru/indigo modern
- FontAwesome 6 icons
- Card-based layout
- Smooth transitions & hover effects
- Color-coded status badges

---

# 🧪 Pengujian

### Unit Test (JUnit 5)
| Test | Deskripsi |
|------|-----------|
| `BukuDAOTest` | Integration test untuk BukuDAO (getAll, insert, getById) |
| `BukuTest` | Model unit test |
| `PeminjamanTest` | Model unit test |
| `UserTest` | Model unit test |
| `BookNotFoundExceptionTest` | Custom exception test |
| `InsufficientStockExceptionTest` | Custom exception test |

### Ruang Lingkup Pengujian
- ✅ Validasi login/logout
- ✅ CRUD buku dan kategori
- ✅ Alur peminjaman (ajukan → setujui → kembali)
- ✅ Sistem ulasan (tambah, edit, duplicate prevention)
- ✅ Fitur favorit
- ✅ Upload foto profil
- ✅ Otorisasi role (admin vs anggota)

---

# 🐳 Deployment

### Docker
```dockerfile
# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21-jammy AS build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM tomcat:10.1-jdk21-openjdk-slim
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

### Local Development
```bash
# 1. Import database
mysql -u root -p < librarymanagamentsystem.sql

# 2. Set environment variables
export MYSQL_HOST=localhost
export MYSQL_PORT=3306
export MYSQL_DB=librarymanagamentsystem
export MYSQL_USER=root
export MYSQL_PASSWORD=

# 3. Jalankan dengan embedded Tomcat
mvn cargo:run

# Build WAR
mvn clean package

# Akses di browser
http://localhost:8080/LibraryManagementSystem
```

### 🔐 Akun Demo
| Role | Username | Password |
|------|----------|----------|
| **Admin** | admin | 123 |
| **Anggota** | maruf | 123 |
| **Anggota** | (daftar baru) | (terserah) |

---

# 📊 Statistik Proyek

| Metrik | Jumlah |
|--------|--------|
| **File Java** | ~37 source files |
| **File JSP** | 16 pages |
| **CSS/JS** | style.css + script.js |
| **DAO Classes** | 7 |
| **Model Classes** | 10 (incl. enums) |
| **Servlet Controllers** | 13 |
| **Tabel Database** | 7 |
| **Unit Tests** | 6 |

---

# 🔮 Pengembangan Selanjutnya

### Potential Enhancements
- 📱 **Responsive Mobile** — tampilan mobile-first yang lebih optimal
- 📧 **Email Notification** — notifikasi status peminjaman via email
- 📊 **Grafik Dashboard** — chart.js untuk visualisasi data
- 🔍 **Pagination** — untuk daftar buku & peminjaman yang besar
- 🌐 **REST API** — endpoint JSON untuk integrasi aplikasi lain
- 📖 **Barcode Scanner** — scan ISBN untuk input buku cepat
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
