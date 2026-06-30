# 📋 Technical Audit Report — LibraryPro

> **Project**: LibraryPro (Sistem Manajemen Perpustakaan)
> **Auditor**: Senior Software Engineer & Technical Auditor
> **Date**: July 2026
> **Purpose**: Final OOP (PBO) Presentation Preparation

---

## 1. System Architecture & Tech Stack

### 1.1 Architecture Pattern: **MVC + DAO Layered Architecture**

```
Browser → AuthFilter (/*) intercepts ALL requests
              ↓
         Controller Layer (13 Servlets) → DAO Layer (6 DAOs) → Database
              ↓
         View Layer (JSP Pages) ← Model Layer (POJOs + Enums)
```

| Layer | Package | Responsibility |
|-------|---------|----------------|
| **Model** | `model/`, `model/enums/` | POJOs (Buku, User, Admin, Anggota, Peminjaman...) + Enums |
| **View** | `webapp/` | JSP pages rendering HTML UI |
| **Controller** | `controller/` | 13 Jakarta Servlets — HTTP routing & business logic |
| **DAO** | `dao/` | 6 DAO classes — database CRUD via JDBC |
| **Config** | `config/` | Database connection (environment-based) |
| **Filter** | `filter/` | AuthFilter — authentication & role-based authorization |
| **Exception** | `exception/` | Custom domain exceptions (BookNotFound, InsufficientStock) |

### 1.2 Tech Stack

| Component | Technology | Version |
|-----------|------------|---------|
| **Language** | Java | 17 |
| **Web Framework** | Jakarta Servlet API | 6.0.0 |
| **View Engine** | Jakarta JSP API | 3.1.1 |
| **Database** | MySQL / MariaDB | — |
| **DB Connector** | MySQL Connector/J | 9.3.0 |
| **Build Tool** | Apache Maven | — |
| **App Server** | Apache Tomcat 10.x | — |
| **Password Hashing** | jBCrypt | 0.4 |
| **Deployment** | Docker + Railway | — |

---

## 2. OOP Concepts Implementation

### 2.1 🔒 Encapsulation

**Definition**: Bundling data and methods within a class, restricting direct access via `private` access modifiers.

| Where | File(s) | How It's Applied |
|-------|---------|------------------|
| All Model classes | `model/User.java`, `model/Buku.java`, `model/Peminjaman.java`, `model/Admin.java`, `model/Anggota.java` dsb. | **All fields are `private`**; accessed only through `public` getters/setters |
| Database config | `config/DBConnection.java` | Connection details hidden; only `getConnection()` exposed |
| BaseDAO | `dao/BaseDAO.java` | `protected` methods (`getConnection()`, `closeResources()`) — accessible to subclasses, hidden from outside |
| Custom Exceptions | `exception/BookNotFoundException.java` | `private final int bookId` — immutable encapsulated field with only getter |
| Enum fields | `model/enums/StatusPeminjaman.java` | `private final String value` — enum constants protect internal value |

> **📌 Best for Slide**: `User.java` — 8 private fields with public getters/setters. Password excluded from `toString()` for security.

```java
// From User.java — Encapsulation
private int idUser;
private String username;
private String password;
private String email;
private String namaLengkap;
private String alamat;
private String level;
private String fotoProfil;

public String getUsername() { return username; }
public void setUsername(String username) { this.username = username; }
// Password getter ada tapi toString() tidak menampilkan password — keamanan!
```

---

### 2.2 🧬 Inheritance

**Definition**: A subclass derives from a superclass, inheriting fields and methods while adding or specializing behavior.

#### Active Inheritance Hierarchy — Model Layer

```
User (superclass)
├── Admin extends User     — adds canManageBooks(), canApproveReturn(), getDashboardPath()
└── Anggota extends User   — adds getMaxBorrowLimit(), isEligibleToBorrow(), getDashboardPath()
```

| Superclass → Subclass | Files | What's Inherited / Added |
|-----------------------|-------|--------------------------|
| **`User` → `Admin`** | `model/User.java` → `model/Admin.java` | Inherits ALL User fields; adds `canManageBooks()`, `canApproveReturn()`, overrides `toString()` |
| **`User` → `Anggota`** | `model/User.java` → `model/Anggota.java` | Inherits ALL User fields; adds `getMaxBorrowLimit()` (returns 3), `isEligibleToBorrow()` |
| **`RuntimeException` → `BookNotFoundException`** | `exception/BookNotFoundException.java` | Inherits RuntimeException behavior; adds `bookId` field + constructor overloading |
| **`RuntimeException` → `InsufficientStockException`** | `exception/InsufficientStockException.java` | Adds `bookId` + `availableStock` fields |
| **`BaseDAO` → All 6 DAO classes** | `dao/BaseDAO.java` → `BukuDAO`, `UserDAO`, `KategoriDAO`, `PeminjamanDAO`, `UlasanDAO`, `FavoritDAO` | Inherits `getConnection()`, `closeResources()`; must override `getEntityName()` |
| **`HttpServlet` → All 13 Servlets** | All files in `controller/` | Inherits servlet lifecycle; overrides `doGet()` / `doPost()` |

> **📌 Best for Slide**: `User → Admin / Anggota` hierarchy adalah contoh paling jelas.

```java
// From Admin.java
public class Admin extends User {
    public Admin() {
        super();                    // memanggil constructor User()
        this.setLevel("admin");     // memakai setter warisan dari User
    }

    public boolean canManageBooks() { return true; }

    @Override
    public String toString() {
        return "Admin{id=" + getIdUser() + ", username='" + getUsername() + "'}";
    }
}
```

---

### 2.3 🔄 Polymorphism

**Definition**: Different classes respond to the same method call in their own way.

#### A. Runtime Polymorphism (Method Overriding)

| Method | Where Overridden | Explanation |
|--------|-----------------|-------------|
| `toString()` | `Admin`, `Anggota` override `User.toString()` | Each produces different format |
| `getEntityName()` | All 6 DAOs override `BaseDAO.getEntityName()` | Each returns its entity name |
| `doGet()` / `doPost()` | All 13 Servlets override `HttpServlet` | Each handles its own URL routing |
| `pinjam()`, `kembalikan()` | `PeminjamanDAO` implements `Transaksi` interface | Concrete transaction logic |

#### B. Compile-time Polymorphism (Method Overloading)

| Method | File | Overloaded Variants |
|--------|------|-------------------|
| `closeResources()` | `BaseDAO.java` | 3 params vs 2 params |
| Constructor | `BookNotFoundException.java` | `BookNotFoundException(int bookId)` vs `BookNotFoundException(String message)` |

#### C. Polymorphic Object Instantiation (di Runtime)

Ini **contoh terkuat** — dipakai di login flow:

```java
// Dari UserDAO.login() — Runtime Polymorphism
User user;  // declared sebagai supertype

if (UserLevel.ADMIN.getValue().equalsIgnoreCase(levelStr)) {
    user = new Admin();      // ← di-instantiate sebagai Admin
} else {
    user = new Anggota();    // ← di-instantiate sebagai Anggota
}
// Kedua-duanya disimpan sebagai 'User' — POLYMORPHISM!
```

Kemudian di `LoginServlet.java`:

```java
// Downcasting + polymorphic call
if (user instanceof Admin) {
    Admin admin = (Admin) user;                            // downcasting
    session.setAttribute("canManageBooks", admin.canManageBooks());
    response.sendRedirect(admin.getDashboardPath());       // method spesifik Admin
} else if (user instanceof Anggota) {
    Anggota anggota = (Anggota) user;
    session.setAttribute("maxBorrow", anggota.getMaxBorrowLimit());
    response.sendRedirect(anggota.getDashboardPath());     // method spesifik Anggota
}
```

> **📌 Best for Slide**: Flow `UserDAO.login()` → `LoginServlet`. Demonstrasikan `instanceof`, downcasting, dan polymorphic method calls — semua dalam satu workflow nyata.

---

### 2.4 🎭 Abstraction

**Definition**: Menyembunyikan detail implementasi kompleks di balik interface dan abstract class yang sederhana.

| Mechanism | File | Details |
|-----------|------|---------|
| **Interface**: `Transaksi` | `interfaces/Transaksi.java` | Mendefinisikan kontrak `pinjam(int, int)` dan `kembalikan(int)` |
| **Abstract Class**: `BaseDAO` | `dao/BaseDAO.java` | `abstract` dengan abstract method `getEntityName()` + shared methods |
| **Enum as Abstraction** | `model/enums/StatusPeminjaman.java`, `model/enums/UserLevel.java` | Type-safe constants; `fromValue()` encapsulates lookup logic |

**Abstraction chain:**

```
Transaksi (interface — kontrak pinjam() dan kembalikan())
       ↓ implements
BaseDAO (abstract class — shared DB utilities + abstract getEntityName())
       ↓ extends + implements Transaksi
PeminjamanDAO (concrete — implementasi SQL lengkap)
```

```java
// Transaksi.java — Pure abstraction via interface
public interface Transaksi {
    boolean pinjam(int idUser, int idBuku);
    boolean kembalikan(int idPeminjaman);
}

// PeminjamanDAO.java — Implementasi konkrit
public class PeminjamanDAO extends BaseDAO implements Transaksi {
    @Override
    public boolean pinjam(int idUser, int idBuku) {
        // 50+ baris SQL transaksional, validasi stok, custom exceptions...
    }
}
```

---

## 3. Business Logic & Data Flow

### 3.1 Core Workflow

```
Anggota:
  Browse/Search → Pinjam (status: menunggu) → Admin Approve (status: disetujui) → Kembalikan → Denda dihitung
  Tulis Review & Rating
  Toggle Favorit

Admin:
  CRUD Buku & Kategori
  CRUD User
  Approve / Tolak Peminjaman
  Moderasi Review
```

### 3.2 Complete Data Flow — Peminjaman Buku

```
1. User klik "Pinjam" di katalog
        ↓
2. GET /peminjaman?action=pinjam&idBuku=8
        ↓
3. AuthFilter intercepts — cek session & role
        ↓
4. PeminjamanServlet.doGet()
   ├── Extract action + idBuku
   └── panggil peminjamanDAO.pinjam(userId, idBuku)
        ↓
5. PeminjamanDAO.pinjam() [implements Transaksi]
   ├── conn.setAutoCommit(false) — TRANSACTION
   ├── Cek stok: throws BookNotFoundException/InsufficientStockException
   ├── Insert record status = 'menunggu'
   ├── conn.commit() / rollback()
   └── Return boolean
        ↓
6. Redirect ke /peminjaman?status=success
        ↓
7. Admin login → lihat pending → approve (/peminjaman?action=setujui&id=X)
        ↓
8. PeminjamanDAO.verifikasiPeminjaman() — set tanggal_tenggat (1 bulan), kurangi stok
        ↓
9. User kembalikan → PeminjamanDAO.kembalikan()
   ├── Hitung denda: Rp 1.000 × hari terlambat (ChronoUnit.DAYS)
   └── Set status = 'dikembalikan', tambah stok +1
```

### 3.3 Entity Relationship

```
USER ──borrows──> PEMINJAMAN
USER ──favorites──> FAVORIT
USER ──reviews──> ULASAN
BUKU ──<── PEMINJAMAN
BUKU ──<── FAVORIT
BUKU ──<── ULASAN
KATEGORI ──<── BUKU
```

### 3.4 Key Business Rules

| Business Rule | Implementation | File |
|---------------|---------------|------|
| **Denda**: Rp 1.000/hari setelah tenggat | `ChronoUnit.DAYS.between()` × 1000 | `PeminjamanDAO.kembalikan()` |
| **Validasi stok**: throws jika buku habis | `BookNotFoundException` + `InsufficientStockException` | `PeminjamanDAO.pinjam()` |
| **Stok auto**: -1 di approve, +1 di return | Transactional SQL with rollback | `PeminjamanDAO` |
| **Masa pinjam**: 30 hari | `LocalDate.now().plusMonths(1)` | `PeminjamanDAO.verifikasiPeminjaman()` |
| **Role-based access** | `AuthFilter` + path separation | `filter/AuthFilter.java` |
| **One review per user per book** | UNIQUE KEY(id_user, id_buku) di DB + cek di servlet | `UlasanServlet.java` |
| **Cascading delete** | Hapus ulasan → favorit → peminjaman sebelum hapus buku | `BukuDAO.delete()` |

---

## 4. Design Patterns

| Pattern | File | How It's Applied |
|---------|------|------------------|
| **DAO Pattern** | `dao/BaseDAO` + 6 DAOs | Setiap entity punya DAO sendiri, enkapsulasi SQL |
| **Template Method** | `dao/BaseDAO.java` | Abstract class defines skeleton (`getConnection`, `closeResources`), subclasses fill in (`getEntityName`) |
| **Factory-Style Polymorphism** | `dao/UserDAO.login()` | `login()` dynamically creates `Admin` or `Anggota` based on DB level column |
| **Front Controller** | `filter/AuthFilter.java` | `@WebFilter("/*")` intercepts ALL requests — centralized security gate |
| **MVC Pattern** | All layers | Model (POJOs) → View (JSP) → Controller (Servlets) separation |

---

## 5. Project Highlights & Strengths 🏆

### 🥇 Highlight 1: Inheritance + Polymorphism di Login Flow

`User → Admin / Anggota` hierarchy **dipakai secara aktif**:
1. `UserDAO.login()` baca `level` dari DB → instantiate subclass yang tepat (`new Admin()` / `new Anggota()`)
2. `LoginServlet` pakai `instanceof` → downcasting → panggil method spesifik subclass
3. `getDashboardPath()` dipanggil secara polymorphic — method sama, behavior beda

### 🥈 Highlight 2: Transaksional + Custom Exceptions

`PeminjamanDAO` mempraktekkan enterprise Java:
- **Database transactions**: `setAutoCommit(false)`, `commit()`, `rollback()`
- **Custom exceptions**: `BookNotFoundException`, `InsufficientStockException` — bawa context (book ID, stock)
- **Enum-based status**: `StatusPeminjaman.fromValue()` — type-safe
- **Stock management otomatis**: -1 approve, +1 return

### 🥉 Highlight 3: Password Security

`PasswordUtils.java` — bcrypt hashing via jBCrypt:
- `hash()` — salt + hash otomatis
- `verify()` — backward compatible dengan legacy plaintext
- `isHashed()` — deteksi format hash vs plaintext

---

## 6. File Inventory

```
src/main/java/
├── config/
│   └── DBConnection.java                 ← Environment-based DB connection
├── controller/                           ← 13 Servlets
│   ├── LoginServlet.java                 ← Polymorphic login ⭐
│   ├── LogoutServlet.java
│   ├── RegisterServlet.java
│   ├── DashboardServlet.java             ← Routes admin/anggota dinamis
│   ├── BukuServlet.java                  ← Book CRUD
│   ├── KategoriServlet.java              ← Category CRUD
│   ├── UserServlet.java                  ← User CRUD (admin)
│   ├── PeminjamanServlet.java            ← Borrow flow
│   ├── AdminPeminjamanServlet.java       ← Admin approve/tolak
│   ├── FavoritServlet.java               ← Toggle favorites
│   ├── UlasanServlet.java                ← Reviews
│   ├── ReviewBukuServlet.java            ← Public review viewer
│   └── ProfileServlet.java              ← Profile + Base64 photo upload
├── dao/
│   ├── BaseDAO.java                      ← Abstract class ⭐
│   ├── BukuDAO.java
│   ├── FavoritDAO.java
│   ├── KategoriDAO.java
│   ├── PeminjamanDAO.java                ← Implements Transaksi + transactions ⭐
│   ├── UlasanDAO.java
│   └── UserDAO.java                      ← Polymorphic instantiation ⭐
├── exception/
│   ├── BookNotFoundException.java        ← Custom exception
│   └── InsufficientStockException.java   ← Custom exception with context
├── filter/
│   └── AuthFilter.java                  ← Role-based security
├── interfaces/
│   └── Transaksi.java                   ← Transaction contract interface
└── model/
    ├── Admin.java                        ← extends User ⭐
    ├── Anggota.java                      ← extends User ⭐
    ├── Buku.java
    ├── Favorit.java
    ├── Kategori.java
    ├── Peminjaman.java
    ├── Ulasan.java
    ├── User.java                         ← Base class ⭐
    └── enums/
        ├── StatusPeminjaman.java         ← Type-safe enum
        └── UserLevel.java               ← Type-safe enum
```

## 7. Railway Deployment

```
git push fork main → railway up
         ↓
   Dockerfile build (multi-stage)
         ↓
   wait-for-mysql.sh: tunggu MySQL ready → import schema.sql
         ↓
   Tomcat start → app live di https://librarypro.up.railway.app
```
