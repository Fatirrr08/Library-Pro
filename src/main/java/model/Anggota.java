package model;

public class Anggota extends User {
    public Anggota() {
        super();
        this.setLevel("anggota");
    }

    // [OOP: Method Overriding] Override toString() dari User
    @Override
    public String toString() {
        return "Anggota{id=" + getIdUser() + ", username='" + getUsername() + "'}";
    }

    // [OOP: Subclass-specific method] Method yang hanya dimiliki Anggota
    public int getMaxBorrowLimit() {
        return 3; // anggota hanya boleh pinjam maksimal 3 buku
    }

    public boolean isEligibleToBorrow() {
        return true; // ponytail: bisa dikembangkan nanti (cek denda, dll)
    }

    public String getDashboardPath() {
        return "/dashboard"; // ponytail: sesuaikan path redirect dengan servlet yang ada
    }
}
