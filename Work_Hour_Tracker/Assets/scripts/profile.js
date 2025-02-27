document.addEventListener("DOMContentLoaded", function () {
    const profileForm = document.getElementById("profileForm");
    const backToDashboardBtn = document.getElementById("backToDashboard");
    const logoUpload = document.getElementById("logoUpload");
    const logoPreview = document.getElementById("logoPreview");

    // Check if the user is logged in
    const loggedInUser = localStorage.getItem("loggedInUser");

    if (!loggedInUser) {
        alert("You must be logged in to access your profile.");
        window.location.href = "login.html";
        return;
    }

    // Load saved profile details
    let userProfile = JSON.parse(localStorage.getItem("userProfile")) || {};

    document.getElementById("fullName").value = userProfile.fullName || "";
    document.getElementById("companyName").value = userProfile.companyName || "";
    document.getElementById("companyAddress").value = userProfile.companyAddress || "";
    document.getElementById("vatNumber").value = userProfile.vatNumber || "";

    if (userProfile.logo) {
        logoPreview.src = userProfile.logo;
    }

    profileForm.addEventListener("submit", function (event) {
        event.preventDefault();

        let updatedProfile = {
            fullName: document.getElementById("fullName").value.trim(),
            companyName: document.getElementById("companyName").value.trim(),
            companyAddress: document.getElementById("companyAddress").value.trim(),
            vatNumber: document.getElementById("vatNumber").value.trim(),
            logo: logoPreview.src
        };

        // Ensure no empty fields are saved
        if (!updatedProfile.fullName || !updatedProfile.companyName || !updatedProfile.companyAddress) {
            alert("Please fill in all required fields.");
            return;
        }

        localStorage.setItem("userProfile", JSON.stringify(updatedProfile));

        alert("Profile updated successfully!");
    });

    logoUpload.addEventListener("change", function (event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                logoPreview.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    backToDashboardBtn.addEventListener("click", function () {
        window.location.href = "dashboard.html";
    });
});