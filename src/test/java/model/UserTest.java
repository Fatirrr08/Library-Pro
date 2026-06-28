package model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("User & Subclass Inheritance Test")
class UserTest {

    @Test
    @DisplayName("Admin harus instanceof User (inheritance)")
    void testAdminIsUser() {
        Admin admin = new Admin();
        assertInstanceOf(User.class, admin,
            "[OOP: Inheritance] Admin harus merupakan subtype dari User");
    }

    @Test
    @DisplayName("Anggota harus instanceof User (inheritance)")
    void testAnggotaIsUser() {
        Anggota anggota = new Anggota();
        assertInstanceOf(User.class, anggota,
            "[OOP: Inheritance] Anggota harus merupakan subtype dari User");
    }

    @Test
    @DisplayName("Admin.canManageBooks() harus return true")
    void testAdminCanManageBooks() {
        Admin admin = new Admin();
        assertTrue(admin.canManageBooks(),
            "[OOP: Subclass method] Admin memiliki privilege canManageBooks");
    }

    @Test
    @DisplayName("Anggota.getMaxBorrowLimit() harus return 3")
    void testAnggotaBorrowLimit() {
        Anggota anggota = new Anggota();
        assertEquals(3, anggota.getMaxBorrowLimit(),
            "[OOP: Subclass method] Anggota maksimal meminjam 3 buku");
    }

    @Test
    @DisplayName("Admin.toString() harus menyebut 'Admin'")
    void testAdminToString() {
        Admin admin = new Admin();
        assertTrue(admin.toString().contains("Admin"));
    }

    @Test
    @DisplayName("Polymorphism: User variable bisa hold Admin object")
    void testPolymorphism() {
        User user = new Admin(); // [OOP: Polymorphism]
        assertInstanceOf(Admin.class, user);

        // downcasting
        Admin admin = (Admin) user; // [OOP: Downcasting]
        assertTrue(admin.canManageBooks());
    }
}
