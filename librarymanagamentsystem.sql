-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 16 Jun 2026 pada 15.42
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `librarymanagamentsystem`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `penulis` varchar(50) NOT NULL,
  `penerbit` varchar(50) NOT NULL,
  `tahun_terbit` int(11) NOT NULL,
  `jml_buku` int(10) NOT NULL,
  `isbn` varchar(50) DEFAULT '-',
  `abstraksi` text DEFAULT NULL,
  `foto_buku` varchar(255) DEFAULT NULL,
  `id_kategori` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `penulis`, `penerbit`, `tahun_terbit`, `jml_buku`, `isbn`, `abstraksi`, `id_kategori`) VALUES
(8, 'belajar java', 'maruf', 'kampus telkom', 2025, 8, '978-602-03-3160-7', 'Buku ini membahas secara mendalam mengenai konsep pemrograman berbasis objek (OOP) menggunakan bahasa pemrograman Java modern. Pembaca akan dipandu mulai dari pemahaman dasar sintaksis, class, inheritance, polymorphism, hingga implementasi nyata pada arsitektur web berbasis Servlet dan JSP. Sangat direkomendasikan untuk mahasiswa informatika yang ingin memperkuat fondasi logika pemrograman dan konektivitas pangkalan data MySQL.', 3),
(9, 'si kancil', 'maruf', 'maruf', 2025, 7, '978-623-00-2561-3', 'Sebuah panduan komprehensif yang dirancang khusus untuk memandu pengembang sistem dalam merancang arsitektur aplikasi digital yang skalabel. Buku ini mengupas tuntas teknik analisis kebutuhan sistem, pembuatan model diagram UML (Use Case, Class, Sequence Diagram), serta penerapan Clean Code. Cocok sebagai referensi utama dalam membangun platform perpustakaan berbasis web modern.', 1),
(10, 'sastra inggris', 'amel', 'faizz', 2026, 4, '978-602-8512-32-4', 'Buku ini menyajikan pendekatan praktis dalam memahami struktur data dasar dan lanjutan yang krusial bagi seorang software engineer. Topik yang dibahas mencakup pengelolaan memori, implementasi Array, Linked List, Stack, Queue, hingga algoritma pencarian dan pengurutan data (Searching & Sorting). Setiap materi dilengkapi dengan contoh kasus nyata dan latihan kode terstruktur.', 5),
(16, 'Detective Conan', 'Gosho Aoyama', 'Shogakukan', 1994, 5, '978-623-00-3230-1', 'Shinichi Kudo adalah seorang detektif SMA yang terkadang bekerja dengan polisi untuk memecahkan kasus tertentu.[5] Selama penyelidikan, ia disergap dan dilumpuhkan oleh anggota sindikat kejahatan yang dikenal sebagai Organisasi Hitam. Dalam upaya untuk membunuh detektif muda itu, mereka menelan paksa obat percobaan yang berbahaya. Namun, obat tersebut mengubahnya menjadi anak-anak daripada membunuhnya.[6] Mengadopsi nama samaran Conan Edogawa dan merahasiakan identitas aslinya, Kudo tinggal bersama teman masa kecilnya Ran Mouri dan ayahnya Kogoro Mouri, yang merupakan seorang detektif swasta. Sepanjang seri tersebut, ia ikut serta dalam kasus yang ditangani oleh Kogoro.', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `favorit`
--

CREATE TABLE `favorit` (
  `id_favorit` int(10) NOT NULL,
  `id_user` int(10) NOT NULL,
  `id_buku` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `favorit`
--

INSERT INTO `favorit` (`id_favorit`, `id_user`, `id_buku`) VALUES
(1, 3, 8),
(2, 3, 9);

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
(1, 'Novel'),
(2, 'Komik'),
(3, 'Pendidikan'),
(4, 'Teknologi'),
(5, 'Sastra'),
(7, 'Fiksi Ilmiah');

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `tanggal_pinjam` date NOT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `tanggal_tenggat` date DEFAULT NULL,
  `status` enum('menunggu','disetujui','ditolak','dikembalikan') DEFAULT 'menunggu',
  `denda` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_user`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`, `tanggal_tenggat`, `status`, `denda`) VALUES
(2, 3, 8, '2026-06-07', '2026-06-07', NULL, 'dikembalikan', 0.00),
(3, 3, 9, '2026-06-08', NULL, NULL, '', 0.00),
(4, 4, 9, '2026-06-11', '2026-06-11', NULL, 'dikembalikan', 0.00),
(5, 4, 9, '2026-06-11', '2026-06-11', NULL, 'dikembalikan', 0.00),
(6, 4, 8, '2026-06-11', '2026-06-15', NULL, 'dikembalikan', 0.00),
(7, 4, 8, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(8, 4, 8, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(9, 4, 8, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(10, 4, 10, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(11, 4, 10, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(12, 4, 10, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(13, 4, 10, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(14, 4, 8, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(15, 4, 10, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(16, 4, 8, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(17, 4, 8, '2026-06-15', NULL, NULL, '', 0.00),
(18, 4, 9, '2026-06-15', NULL, NULL, '', 0.00),
(19, 4, 10, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(20, 4, 8, '2026-06-15', '2026-06-15', NULL, 'dikembalikan', 0.00),
(21, 4, 8, '0000-00-00', NULL, NULL, 'ditolak', 0.00),
(22, 4, 8, '2026-06-15', '2026-06-16', '2026-07-15', 'dikembalikan', 0.00),
(23, 5, 8, '2026-06-15', NULL, NULL, 'ditolak', 0.00),
(24, 5, 9, '2026-06-16', '2026-06-16', '2026-07-16', 'dikembalikan', 0.00),
(25, 4, 16, '2026-06-16', '2026-06-16', '2026-07-16', 'dikembalikan', 0.00),
(26, 4, 10, '2026-06-16', NULL, NULL, 'ditolak', 0.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tabel_buku`
--

CREATE TABLE `tabel_buku` (
  `id_buku` varchar(255) NOT NULL,
  `judul` varchar(255) DEFAULT NULL,
  `penulis` varchar(255) DEFAULT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `ulasan`
--

CREATE TABLE `ulasan` (
  `id_ulasan` int(10) NOT NULL,
  `id_user` int(10) NOT NULL,
  `id_buku` int(10) NOT NULL,
  `ulasan` text DEFAULT NULL,
  `rating` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `ulasan`
--

INSERT INTO `ulasan` (`id_ulasan`, `id_user`, `id_buku`, `ulasan`, `rating`) VALUES
(1, 3, 8, 'buku nyaa baguss', 5),
(2, 4, 8, 'mantapp', 5),
(3, 4, 9, 'kancil cerdik', 4),
(4, 4, 16, 'Keren banget', 5),
(6, 4, 10, 'good job nice', 4);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id_user` int(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `alamat` text DEFAULT NULL,
  `level` varchar(50) NOT NULL,
  `foto_profil` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id_user`, `username`, `password`, `email`, `nama_lengkap`, `alamat`, `level`, `foto_profil`) VALUES
(1, 'admin', '123', 'admin@gmail.com', 'Administrator', 'Bandung', 'admin', 'admin_029c5fcb-c1a6-4cf7-b135-8cc3aca9252d.png'),
(3, 'ida', '123', 'ida@gmail.com', 'ida', 'purwokerto', 'anggota', NULL),
(4, 'maruf', '123', 'marufsarifudin@gmail.com', 'Ma\'ruf Sarifudin', 'purwokerto', 'anggota', 'maruf_47187c88-c6f3-4542-93f5-64ae9e13f295.png'),
(5, 'Faiz', '123', 'is@gmail.com', 'FaizNrsydn', 'PWT', 'anggota', NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `favorit`
--
ALTER TABLE `favorit`
  ADD PRIMARY KEY (`id_favorit`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `tabel_buku`
--
ALTER TABLE `tabel_buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `ulasan`
--
ALTER TABLE `ulasan`
  ADD PRIMARY KEY (`id_ulasan`),
  ADD UNIQUE KEY `unique_user_buku` (`id_user`,`id_buku`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `favorit`
--
ALTER TABLE `favorit`
  MODIFY `id_favorit` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `ulasan`
--
ALTER TABLE `ulasan`
  MODIFY `id_ulasan` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD CONSTRAINT `buku_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `favorit`
--
ALTER TABLE `favorit`
  ADD CONSTRAINT `favorit_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `favorit_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `ulasan`
--
ALTER TABLE `ulasan`
  ADD CONSTRAINT `ulasan_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `ulasan_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
