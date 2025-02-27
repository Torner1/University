document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById("loginForm");

    loginForm.addEventListener("submit", async function (event) {
        event.preventDefault();

        const username = document.getElementById("username").value.trim();
        const password = document.getElementById("password").value;

        let users = JSON.parse(localStorage.getItem("users")) || {};

        if (!users[username]) {
            alert("Invalid username or password!");
            return;
        }

        const hashedPassword = await hashPassword(password);

        if (users[username].password === hashedPassword) {
            localStorage.setItem("loggedInUser", username);
            window.location.href = "dashboard.html";
        } else {
            alert("Invalid username or password!");
        }
    });

    async function hashPassword(password) {
        const encoder = new TextEncoder();
        const data = encoder.encode(password);
        const hash = await crypto.subtle.digest("SHA-256", data);
        return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('');
    }
});