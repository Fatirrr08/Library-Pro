-- SQL Database Script for LibraryManagementSystem
CREATE DATABASE IF NOT EXISTS management_system;
USE management_system;

-- 1. Table: kategori
CREATE TABLE IF NOT EXISTS kategori (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Table: user
CREATE TABLE IF NOT EXISTS user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nama_lengkap VARCHAR(150) NOT NULL,
    alamat TEXT,
    level VARCHAR(20) NOT NULL DEFAULT 'anggota'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Table: buku
CREATE TABLE IF NOT EXISTS buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    penulis VARCHAR(150) NOT NULL,
    penerbit VARCHAR(150) NOT NULL,
    tahun_terbit INT NOT NULL,
    jml_buku INT NOT NULL DEFAULT 0,
    id_kategori INT,
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Table: peminjaman
CREATE TABLE IF NOT EXISTS peminjaman (
    id_peminjaman INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_buku INT NOT NULL,
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE DEFAULT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'dipinjam',
    FOREIGN KEY (id_user) REFERENCES user(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Table: favorit
CREATE TABLE IF NOT EXISTS favorit (
    id_favorit INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_buku INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE,
    UNIQUE KEY unique_user_book (id_user, id_buku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Table: ulasan
CREATE TABLE IF NOT EXISTS ulasan (
    id_ulasan INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_buku INT NOT NULL,
    ulasan TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (id_user) REFERENCES user(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Data (using INSERT IGNORE or ON DUPLICATE KEY to allow safe multiple runs)
INSERT INTO kategori (id_kategori, nama_kategori) VALUES
(1, 'Novel'),
(2, 'Komik'),
(3, 'Pendidikan'),
(4, 'Teknologi')
ON DUPLICATE KEY UPDATE nama_kategori=VALUES(nama_kategori);

INSERT INTO user (id_user, username, password, email, nama_lengkap, alamat, level) VALUES
(1, 'admin', 'admin123', 'admin@library.com', 'Administrator Perpustakaan', 'Gedung Rektorat Lt. 2', 'admin'),
(2, 'anggota', 'user123', 'anggota@gmail.com', 'Budi Santoso', 'Jl. Sukabirus No. 10', 'anggota')
ON DUPLICATE KEY UPDATE username=VALUES(username);

INSERT INTO buku (id_buku, judul, penulis, penerbit, tahun_terbit, jml_buku, id_kategori) VALUES
(1, 'Pemrograman Berorientasi Objek dengan Java', 'Dr. Eng. Rinaldi Munir', 'Informatika', 2021, 15, 4),
(2, 'Laskar Pelangi', 'Andrea Hirata', 'Bentang Pustaka', 2005, 5, 1),
(3, 'Doraemon Petualangan Vol. 5', 'Fujiko F. Fujio', 'Elex Media Komputindo', 2012, 8, 2),
(4, 'Fisika Dasar untuk Universitas', 'Halliday & Resnick', 'Erlangga', 2018, 10, 3)
ON DUPLICATE KEY UPDATE judul=VALUES(judul);
