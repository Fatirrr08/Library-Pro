# TECHNICAL AUDIT — LibraryPro

## Overview

| Attribute | Value |
|-----------|-------|
| **Stack** | Jakarta EE 10 (Servlet 6.0, JSP 3.1) |
| **Runtime** | Tomcat 10.1 + MySQL/MariaDB |
| **Java** | 17 (source/target) |
| **Build** | Maven (WAR packaging) |
| **Deploy** | Docker multi-stage → Railway |
| **Password** | BCrypt (jBCrypt 0.4) |

---

## Directory Structure

```
src/main/
├── java/
│   ├── config/DBConnection.java
│   ├── controller/          (13 servlets)
│   ├── dao/                 (6 DAOs)
│   ├── exception/           (2 custom exceptions)
│   ├── filter/AuthFilter.java
│   ├── interfaces/Transaksi.java
│   ├── model/               (6 models + enums/)
│   └── util/                (2 utilities)
├── webapp/
│   ├── WEB-INF/
│   │   ├── components/      header.jsp, footer.jsp (unused)
│   │   └── web.xml
│   ├── css/                 style.css(36KB), style-global.css(22KB), style-auth.css(3.4KB)
│   ├── js/                  script.js, icon-fallback.js, search.js
│   ├── uploads/profile/     default.png
│   ├── index.jsp (redirect)
│   ├── login.jsp
│   ├── register.jsp
│   ├── profile.jsp
│   ├── admin/               (6 JSPs)
│   └── anggota/             (6 JSPs)
```

---

## Database (`librarymanagamentsystem`)

### Tables

| Table | Description | Key Columns |
|-------|-------------|-------------|
| `user` | Accounts | id_user, username, password(bcrypt), email, nama_lengkap, alamat, level(admin/anggota), foto_profil |
| `buku` | Books | id_buku, judul, penulis, penerbit, tahun_terbit, jml_buku(stok), isbn, abstraksi, id_kategori(FK) |
| `kategori` | Categories | id_kategori, nama_kategori |
| `peminjaman` | Borrowings | id_peminjaman, id_user(FK), id_buku(FK), tanggal_pinjam, tanggal_kembali, tanggal_tenggat, status(enum), denda |
| `favorit` | Favorites | id_favorit, id_user(FK), id_buku(FK) |
| `ulasan` | Reviews | id_ulasan, id_user(FK), id_buku(FK), ulasan, rating; UNIQUE(user,book) |

### Seed accounts
- `admin` / `123` (level: admin)
- `ida` / `123` (level: anggota)
- `maruf` / `123` (level: anggota)

---

## Architecture (MVC)

```
Browser → AuthFilter (/*)
           ↓
         Servlet (Controller) → DAO → DB
           ↓
         JSP (View) + CSS/JS
```

### AuthFilter (`/*`)
- Public: `/css/`, `/js/`, `/login`, `/register`, `/`
- Admin-only: `/admin/*`, `/buku`, `/kategori`, `/user`
- Anggota-only: `/anggota/*`, `/favorit`
- Shared: `/ulasan`, `/dashboard`, `/profile`, `/peminjaman`

### Controllers

| Servlet | Route | Description |
|---------|-------|-------------|
| `LoginServlet` | `/login` | Auth via `UserDAO.login()`, polymorphic Admin/Anggota |
| `LogoutServlet` | `/logout` | Invalidate session |
| `RegisterServlet` | `/register` | New user (level=anggota) |
| `DashboardServlet` | `/dashboard` | Stats + recent books (role-aware) |
| `BukuServlet` | `/buku` | Book CRUD (admin) |
| `KategoriServlet` | `/kategori` | Category CRUD (admin) |
| `UserServlet` | `/user` | User CRUD (admin) |
| `PeminjamanServlet` | `/peminjaman` | Borrow flow (admin: approve/reject; anggota: pinjam/kembali) |
| `FavoritServlet` | `/favorit` | Toggle favorites (anggota) |
| `UlasanServlet` | `/ulasan` | Reviews (admin: moderate; anggota: create/edit) |
| `ReviewBukuServlet` | `/review-buku` | Public book review viewer |
| `ProfileServlet` | `/profile` | Profile + photo upload (cropper.js + Base64) |

---

## OOP Features

| Concept | Implementation |
|---------|---------------|
| Inheritance | `Admin extends User`, `Anggota extends User` |
| Polymorphism | `UserDAO.login()` instantiates subclass based on DB level |
| Encapsulation | All fields private with public getters/setters |
| Abstract class | `BaseDAO` (template for all DAOs) |
| Interface | `Transaksi` (contract: pinjam + kembalikan) |
| Enums | `StatusPeminjaman`, `UserLevel` with `fromValue()` factory |
| Custom exceptions | `BookNotFoundException`, `InsufficientStockException` |
| Method overloading | `BaseDAO.closeResources()` overloads for 1-3 resources |
| Method overriding | `toString()`, `getDashboardPath()`, `canManageBooks()` |

---

## Key Frontend Decisions

| Concern | Choice |
|---------|--------|
| Icons | FontAwesome 6.5.1 (SVG/JS via jsDelivr + cdnjs backup + Unicode fallback) |
| Fonts | Plus Jakarta Sans (Google Fonts) |
| CSS architecture | `style-global.css` (design system) + `style.css` (page layouts) + `style-auth.css` (login/register) |
| Search | Custom fuzzy search (`js/search.js`): Levenshtein + token scoring + debounce |
| Dark mode | CSS variables `[data-theme="dark"]`, persisted via `localStorage` |
| Geolocation | OpenStreetMap Nominatim (free, no API key) — on register & profile |
| Image upload | Cropper.js + Base64 → servlet → filesystem |
| Responsive | CSS media queries (1024/768/480px), mobile sidebar overlay |
| Page loader | Full-screen spinner, fades out on `window.load` + 5s safety timeout |

---

## Known Issues & TODOs

1. **No book cover images** — `buku` table has no cover column. All books show CSS gradient placeholder.
2. **`/uploads/` NOT whitelisted in AuthFilter** — unauthenticated requests to profile images will be blocked.
3. **`WEB-INF/components/` dead code** — `header.jsp` and `footer.jsp` are never included by any page.
4. **Inline CSS duplication** — Each JSP duplicates dropdown/logout-modal/dark-mode CSS inline instead of in shared files.
5. **Logout modal inline styles** — Not using the design system's modal/card classes.
6. **No tests in active use** — JUnit dependencies exist but no meaningful test coverage.
7. **Ephemeral uploads on Railway** — Profile photos are lost on every deploy (filesystem storage inside container).
8. **`base`** — No `<base>` tag in `<head>`, relying fully on `request.getContextPath()` which is consistent but fragile.

---

## Railway Deployment

```mermaid
flowchart LR
    A[git push fork main] --> B[railway up]
    B --> C[Dockerfile build]
    C --> D[wait-for-mysql.sh: wait + import schema.sql]
    D --> E[Tomcat starts → app live]
```

- **URL**: https://librarypro.up.railway.app
- **Healthcheck**: `/login.jsp` (120s timeout)
- **Env vars**: `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DB`, `MYSQL_USER`, `MYSQL_PASSWORD`
