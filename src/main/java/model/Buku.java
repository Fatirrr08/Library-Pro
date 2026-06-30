package model;

public class Buku {

    private int idBuku;
    private String judul;
    private String penulis;
    private String penerbit;
    private int tahunTerbit;
    private int jmlBuku;
    private int idKategori;
    private String abstraksi;
    private String isbn;
    private String fotoBuku;

    public Buku() {}

    public int getIdBuku() {
        return idBuku;
    }

    public void setIdBuku(int idBuku) {
        this.idBuku = idBuku;
    }

    public String getJudul() {
        return judul;
    }

    public void setJudul(String judul) {
        this.judul = judul;
    }

    public String getPenulis() {
        return penulis;
    }

    public void setPenulis(String penulis) {
        this.penulis = penulis;
    }

    public String getPenerbit() {
        return penerbit;
    }

    public void setPenerbit(String penerbit) {
        this.penerbit = penerbit;
    }

    public int getTahunTerbit() {
        return tahunTerbit;
    }

    public void setTahunTerbit(int tahunTerbit) {
        this.tahunTerbit = tahunTerbit;
    }

    public int getJmlBuku() {
        return jmlBuku;
    }

    public void setJmlBuku(int jmlBuku) {
        this.jmlBuku = jmlBuku;
    }

    public int getIdKategori() {
        return idKategori;
    }

    public void setIdKategori(int idKategori) {
        this.idKategori = idKategori;
    }
    // Getter dan Setter untuk abstraksi
    public String getAbstraksi() {
        return abstraksi;
    }
    public void setAbstraksi(String abstraksi) {
        this.abstraksi = abstraksi;
    }

    // Getter dan Setter untuk isbn
    public String getIsbn() {
        return isbn;
    }
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getFotoBuku() {
        return fotoBuku;
    }

    public void setFotoBuku(String fotoBuku) {
        this.fotoBuku = fotoBuku;
    }

    // [OOP: Method Overriding] Override toString() dari Object untuk representasi bermakna
    @Override
    public String toString() {
        return "Buku{id=" + idBuku + ", judul='" + judul + "', penulis='" + penulis + "'}";
    }
}