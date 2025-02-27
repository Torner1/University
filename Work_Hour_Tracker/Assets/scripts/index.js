console.log("index.js is loaded successfully!");

document.addEventListener("DOMContentLoaded", function () {
    const getStartedBtn = document.getElementById("getStarted");

    // Redirect logged-in users to dashboard
    if (localStorage.getItem("loggedInUser")) {
        window.location.href = "dashboard.html";
    }

    if (getStartedBtn) {
        getStartedBtn.addEventListener("click", function () {
            window.location.href = "login.html";
        });
    }
    if (window.location.hostname !== "localhost") {
        console.log = function () {};
    }
});