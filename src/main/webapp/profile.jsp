<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Saya - LibraryPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.1/cropper.min.css">
    <style>
        .profile-container {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 32px;
            align-items: start;
        }
        .profile-card {
            background-color: white;
            border-radius: var(--radius);
            padding: 32px 24px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 16px;
        }
        .profile-avatar-wrapper {
            position: relative;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid var(--primary-light);
            box-shadow: var(--shadow-md);
            margin-bottom: 8px;
        }
        .profile-avatar-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .profile-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--bg-dark);
        }
        .profile-role {
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            padding: 4px 12px;
            border-radius: 9999px;
            background-color: var(--primary-light);
            color: var(--primary);
            display: inline-block;
        }
        .profile-role.admin {
            background-color: var(--danger-light);
            color: var(--danger);
        }
        .profile-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            width: 100%;
            margin-top: 8px;
        }
        /* Crop Modal Styling */
        .crop-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
        }
        .crop-modal-content {
            background-color: white;
            padding: 24px;
            border-radius: var(--radius);
            max-width: 450px;
            width: 90%;
            box-shadow: var(--shadow-lg);
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .crop-container {
            width: 100%;
            height: 300px;
            overflow: hidden;
            border-radius: 8px;
            background-color: #f1f5f9;
        }
        .crop-container img {
            max-width: 100%;
            display: block;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 8px;
        }
    </style>
</head>
<body>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-book-open-reader"></i>
        <span>LibraryPro</span>
    </div>
    <ul class="menu">
        <% if ("admin".equalsIgnoreCase(loggedUser.getLevel())) { %>
            <li>
                <a href="<%=request.getContextPath()%>/dashboard">
                    <i class="fa-solid fa-chart-line"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/buku">
                    <i class="fa-solid fa-book"></i> Buku
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/kategori">
                    <i class="fa-solid fa-layer-group"></i> Kategori
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/user">
                    <i class="fa-solid fa-users"></i> User
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/peminjaman">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i> Peminjaman
                </a>
            </li>
        <% } else { %>
            <li>
                <a href="<%=request.getContextPath()%>/dashboard">
                    <i class="fa-solid fa-chart-line"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/anggota/katalog.jsp">
                    <i class="fa-solid fa-book-open"></i> Katalog Buku
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/peminjaman">
                    <i class="fa-solid fa-clock-history"></i> Peminjaman Saya
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/favorit">
                    <i class="fa-solid fa-star"></i> Favorit Saya
                </a>
            </li>
        <% } %>
        <li>
            <a href="<%=request.getContextPath()%>/profile" class="active">
                <i class="fa-solid fa-user-gear"></i> Profil Saya
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
    <div class="topbar">
        <h2>Profil Saya</h2>
        <div class="admin-profile">
            <img src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="User">
            <span><%= loggedUser.getNamaLengkap() %></span>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome">
            <h1>Kelola Profil</h1>
            <p>Perbarui informasi akun dan foto profil Anda.</p>
        </div>

        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> Profil berhasil diperbarui!
            </div>
        <%
            } else if ("photo_deleted".equals(status)) {
        %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> Foto profil berhasil dihapus!
            </div>
        <%
            } else if ("invalid_input".equals(status)) {
        %>
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation"></i> Nama dan Email tidak boleh kosong!
            </div>
        <%
            } else if ("invalid_type".equals(status)) {
        %>
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation"></i> Format foto tidak valid (harus JPG, JPEG, atau PNG)!
            </div>
        <%
            } else if ("file_too_large".equals(status)) {
        %>
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation"></i> Ukuran foto terlalu besar (maksimal 2MB)!
            </div>
        <%
            } else if ("error".equals(status)) {
        %>
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation"></i> Terjadi kesalahan saat memperbarui profil!
            </div>
        <%
            }
        %>

        <div class="profile-container">
            <!-- Left Side: Profile Picture -->
            <div class="profile-card">
                <div class="profile-avatar-wrapper">
                    <img id="avatarPreview" src="<%= (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) ? request.getContextPath() + "/uploads/profile/" + loggedUser.getFotoProfil() : request.getContextPath() + "/uploads/profile/default.png" %>" alt="Foto Profil">
                </div>
                <div>
                    <div class="profile-name"><%= loggedUser.getNamaLengkap() %></div>
                    <div style="margin-top: 5px;">
                        <span class="profile-role <%= "admin".equalsIgnoreCase(loggedUser.getLevel()) ? "admin" : "" %>">
                            <%= loggedUser.getLevel() %>
                        </span>
                    </div>
                </div>

                <div class="profile-actions">
                    <input type="file" id="avatarInput" accept="image/png, image/jpeg, image/jpg" style="display: none;">
                    <button type="button" class="btn-add" style="justify-content: center;" onclick="document.getElementById('avatarInput').click()">
                        <i class="fa-solid fa-camera"></i> Pilih Foto Baru
                    </button>
                    
                    <% if (loggedUser.getFotoProfil() != null && !loggedUser.getFotoProfil().isEmpty()) { %>
                        <form action="<%= request.getContextPath() %>/profile" method="post" style="width: 100%;">
                            <input type="hidden" name="action" value="delete_photo">
                            <button type="submit" class="btn-add" style="background-color: var(--danger-light); color: var(--danger); width: 100%; justify-content: center; box-shadow: none;">
                                <i class="fa-solid fa-trash-can"></i> Hapus Foto
                            </button>
                        </form>
                    <% } %>
                </div>
            </div>

            <!-- Right Side: Edit Form -->
            <div class="form-box" style="margin-bottom: 0;">
                <h3 class="table-title" style="margin-bottom: 20px;"><i class="fa-solid fa-user-edit"></i> Edit Informasi Profil</h3>
                
                <form action="<%= request.getContextPath() %>/profile" method="post" id="profileForm">
                    <input type="hidden" name="croppedImage" id="croppedImage">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Username (Tidak dapat diubah)</label>
                            <input type="text" value="<%= loggedUser.getUsername() %>" disabled style="background-color: #f1f5f9; color: var(--text-muted);">
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <input type="text" value="<%= loggedUser.getLevel().toUpperCase() %>" disabled style="background-color: #f1f5f9; color: var(--text-muted);">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Nama Lengkap</label>
                            <input type="text" name="namaLengkap" value="<%= loggedUser.getNamaLengkap() %>" required placeholder="Masukkan nama lengkap Anda">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="<%= loggedUser.getEmail() %>" required placeholder="Masukkan email Anda">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Password Baru (Kosongkan jika tidak diubah)</label>
                            <input type="password" name="password" placeholder="Masukkan password baru">
                        </div>
                    </div>

                    <div style="margin-top: 24px; text-align: right;">
                        <button type="submit" class="btn-add">
                            <i class="fa-solid fa-floppy-disk"></i> Simpan Profil
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Cropper Modal -->
<div class="crop-modal" id="cropModal">
    <div class="crop-modal-content">
        <h3><i class="fa-solid fa-crop"></i> Potong Foto Profil</h3>
        <p style="color: var(--text-muted); font-size: 0.85rem;">Sesuaikan foto Anda agar presisi di area lingkaran.</p>
        
        <div class="crop-container">
            <img id="cropImage" src="" alt="Image to crop">
        </div>
        
        <div class="modal-footer">
            <button type="button" class="btn-add" id="btnCancelCrop" style="background-color: var(--text-muted); box-shadow: none;">
                Batal
            </button>
            <button type="button" class="btn-add" id="btnSaveCrop">
                Potong & Gunakan
            </button>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.1/cropper.min.js"></script>
<script>
    let cropper;
    const avatarInput = document.getElementById('avatarInput');
    const cropModal = document.getElementById('cropModal');
    const cropImage = document.getElementById('cropImage');
    const croppedImageInput = document.getElementById('croppedImage');
    const avatarPreview = document.getElementById('avatarPreview');

    avatarInput.addEventListener('change', function(e) {
        const files = e.target.files;
        if (files && files.length > 0) {
            const file = files[0];
            
            // Validasi format file
            if (!['image/jpeg', 'image/jpg', 'image/png'].includes(file.type)) {
                alert('Format file harus JPG, JPEG, atau PNG!');
                avatarInput.value = '';
                return;
            }
            
            // Validasi ukuran file (2MB)
            if (file.size > 2 * 1024 * 1024) {
                alert('Ukuran file maksimal adalah 2MB!');
                avatarInput.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(event) {
                cropImage.src = event.target.result;
                cropModal.style.display = 'flex';
                
                if (cropper) {
                    cropper.destroy();
                }
                
                // Inisialisasi Cropper.js
                cropper = new Cropper(cropImage, {
                    aspectRatio: 1,
                    viewMode: 2,
                    autoCropArea: 0.8,
                    dragMode: 'move',
                    background: false,
                    cropBoxMovable: true,
                    cropBoxResizable: true
                });
            };
            reader.readAsDataURL(file);
        }
    });

    document.getElementById('btnCancelCrop').addEventListener('click', function() {
        cropModal.style.display = 'none';
        avatarInput.value = '';
        if (cropper) {
            cropper.destroy();
        }
    });

    document.getElementById('btnSaveCrop').addEventListener('click', function() {
        if (cropper) {
            // Dapatkan hasil crop
            const canvas = cropper.getCroppedCanvas({
                width: 300,
                height: 300
            });
            const dataURL = canvas.toDataURL('image/png');
            croppedImageInput.value = dataURL;
            avatarPreview.src = dataURL;
            cropModal.style.display = 'none';
        }
    });
</script>
</body>
</html>
