package model;

public class Kategori {
    private int idKategori;
    private String namaKategori;

    public Kategori() {}

    public Kategori(int idKategori, String namaKategori) {
        this.idKategori = idKategori;
        this.namaKategori = namaKategori;
    }

    public int getIdKategori() {
        return idKategori;
    }

    public void setIdKategori(int idKategori) {
        this.idKategori = idKategori;
    }

    public String getNamaKategori() {
        return namaKategori;
    }

    public void setNamaKategori(String namaKategori) {
        this.namaKategori = namaKategori;
    }

    // [OOP: Method Overriding] Override toString() dari Object untuk representasi bermakna
    @Override
    public String toString() {
        return "Kategori{id=" + idKategori + ", nama='" + namaKategori + "'}";
    }
}
