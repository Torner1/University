document.addEventListener("DOMContentLoaded", function () {
    const registerForm = document.getElementById("registerForm");

    registerForm.addEventListener("submit", async function (event) {
        event.preventDefault();

        const username = document.getElementById("reg-username").value.trim();
        const password = document.getElementById("reg-password").value;
        const confirmPassword = document.getElementById("confirm-password").value;

        if (password !== confirmPassword) {
            alert("Passwords do not match!");
            return;
        }

        let users = JSON.parse(localStorage.getItem("users")) || {};

        if (users[username]) {
            alert("Username already exists!");
            return;
        }

        // Hash the password before storing it
        const hashedPassword = await hashPassword(password);

        // Save the hashed password
        users[username] = { password: hashedPassword };
        localStorage.setItem("users", JSON.stringify(users));

        alert("Registration successful! Please log in.");
        window.location.href = "login.html";
    });

    async function hashPassword(password) {
        const encoder = new TextEncoder();
        const data = encoder.encode(password);
        const hash = await crypto.subtle.digest("SHA-256", data);
        return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('');
    }
});