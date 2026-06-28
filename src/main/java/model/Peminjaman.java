package model;

import java.sql.Date;

public class Peminjaman {
    private int idPeminjaman;
    private int idUser;
    private int idBuku;
    private Date tanggalPinjam;
    private Date tanggalKembali;
    private Date tanggalTenggat; // 🌟 Digunakan untuk menampung batas pengembalian
    private String status;

    // Join fields for UI display
    private long denda; // 🌟 Diubah ke long agar kalkulasi hari perkalian Rp1.000 presisi
    private String username;
    private String namaLengkap;
    private String judulBuku;

    public Peminjaman() {}

    public int getIdPeminjaman() {
        return idPeminjaman;
    }

    public void setIdPeminjaman(int idPeminjaman) {
        this.idPeminjaman = idPeminjaman;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public int getIdBuku() {
        return idBuku;
    }

    public void setIdBuku(int idBuku) {
        this.idBuku = idBuku;
    }

    public Date getTanggalPinjam() {
        return tanggalPinjam;
    }

    public void setTanggalPinjam(Date tanggalPinjam) {
        this.tanggalPinjam = tanggalPinjam;
    }

    public Date getTanggalKembali() {
        return tanggalKembali;
    }

    public void setTanggalKembali(Date tanggalKembali) {
        this.tanggalKembali = tanggalKembali;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getNamaLengkap() {
        return namaLengkap;
    }

    public void setNamaLengkap(String namaLengkap) {
        this.namaLengkap = namaLengkap;
    }

    public String getJudulBuku() {
        return judulBuku;
    }

    public void setJudulBuku(String judulBuku) {
        this.judulBuku = judulBuku;
    }

    public long getDenda() { 
        return denda; 
    }
    
    public void setDenda(long denda) { 
        this.denda = denda; 
    }

    public Date getTanggalTenggat() { 
        return tanggalTenggat; 
    }
    
    public void setTanggalTenggat(Date tanggalTenggat) { 
        this.tanggalTenggat = tanggalTenggat; 
    }

    // [OOP: Method Overriding] Override toString() dari Object untuk representasi bermakna
    @Override
    public String toString() {
        return "Peminjaman{id=" + idPeminjaman + ", idUser=" + idUser +
               ", idBuku=" + idBuku + ", status='" + status + "'}";
    }
}