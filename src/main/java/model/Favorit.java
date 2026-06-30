package model;

public class Favorit {
    private int idFavorit;
    private int idUser;
    private int idBuku;

    // Join fields for display
    private String judulBuku;
    private String penulis;
    private String penerbit;
    private String fotoBuku;

    public Favorit() {}

    public int getIdFavorit() {
        return idFavorit;
    }

    public void setIdFavorit(int idFavorit) {
        this.idFavorit = idFavorit;
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

    public String getJudulBuku() {
        return judulBuku;
    }

    public void setJudulBuku(String judulBuku) {
        this.judulBuku = judulBuku;
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

    public String getFotoBuku() {
        return fotoBuku;
    }

    public void setFotoBuku(String fotoBuku) {
        this.fotoBuku = fotoBuku;
    }

    // [OOP: Method Overriding] Override toString() dari Object untuk representasi bermakna
    @Override
    public String toString() {
        return "Favorit{id=" + idFavorit + ", idUser=" + idUser + ", idBuku=" + idBuku + "}";
    }
}
