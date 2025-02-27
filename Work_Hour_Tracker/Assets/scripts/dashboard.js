document.addEventListener("DOMContentLoaded", function () {
    const workForm = document.getElementById("workForm");
    const tableBody = document.querySelector("#workTable tbody");
    const logoutButton = document.getElementById("logoutButton");

    let workEntries = JSON.parse(localStorage.getItem("workEntries")) || [];

    function renderTable() {
        tableBody.innerHTML = "";

        if (workEntries.length === 0) {
            let row = tableBody.insertRow();
            row.insertCell(0).colSpan = 6;
            row.cells[0].textContent = "No work entries found.";
            return;
        }

        workEntries.forEach((entry, index) => {
            let row = tableBody.insertRow();
            row.innerHTML = `
                <td>${entry.date}</td>
                <td>${entry.hours}</td>
                <td>£${entry.rate.toFixed(2)}</td>
                <td>£${(entry.hours * entry.rate).toFixed(2)}</td>
                <td>${entry.description}</td>
                <td><button class="delete-btn" data-index="${index}">Delete</button></td>
            `;
        });

        document.querySelectorAll(".delete-btn").forEach(button => {
            button.addEventListener("click", function () {
                let index = this.getAttribute("data-index");
                workEntries.splice(index, 1);
                localStorage.setItem("workEntries", JSON.stringify(workEntries));
                renderTable();
            });
        });

        document.addEventListener("DOMContentLoaded", function () {
            if (!localStorage.getItem("loggedInUser")) {
                window.location.href = "login.html";
            }
        
            const logoutButton = document.getElementById("logoutButton");
            logoutButton.addEventListener("click", function () {
                localStorage.removeItem("loggedInUser");
                window.location.href = "login.html";
            });
        });
    }

    workForm.addEventListener("submit", function (event) {
        event.preventDefault();

        let newEntry = {
            date: document.getElementById("date").value,
            hours: parseFloat(document.getElementById("hours").value),
            rate: parseFloat(document.getElementById("rate").value),
            description: document.getElementById("description").value
        };

        workEntries.push(newEntry);
        localStorage.setItem("workEntries", JSON.stringify(workEntries));

        workForm.reset();
        renderTable();
    });

    logoutButton.addEventListener("click", function () {
        localStorage.removeItem("loggedInUser");
        window.location.href = "login.html";
    });

    renderTable();
});