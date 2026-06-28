package model;

public class Admin extends User {
    public Admin() {
        super();
        this.setLevel("admin");
    }

    // [OOP: Method Overriding] Override toString() dari User
    @Override
    public String toString() {
        return "Admin{id=" + getIdUser() + ", username='" + getUsername() + "'}";
    }

    // [OOP: Subclass-specific method] Method yang hanya dimiliki Admin
    public boolean canManageBooks() {
        return true; // [ponytail: simple boolean, cukup untuk demonstrasi OOP]
    }

    public boolean canApproveReturn() {
        return true;
    }

    public String getDashboardPath() {
        return "/dashboard"; // ponytail: sesuaikan path redirect dengan servlet yang ada
    }
}
