document.addEventListener("DOMContentLoaded", function () {
    const generateInvoiceBtn = document.getElementById("generateInvoice");
    const invoiceNumberElement = document.getElementById("invNum");

    // Generate a unique invoice number
    let invoiceNumber = Math.floor(1000 + Math.random() * 9000);
    invoiceNumberElement.innerText = invoiceNumber;

    generateInvoiceBtn.addEventListener("click", function () {
        let workEntries = JSON.parse(localStorage.getItem("workEntries")) || [];

        if (workEntries.length === 0) {
            alert("No work entries to generate an invoice.");
            return;
        }

        const { jsPDF } = window.jspdf;
        let doc = new jsPDF();

        // Fetch user profile details (if available)
        let userProfile = JSON.parse(localStorage.getItem("userProfile")) || {};
       
        //Add company details to invoce 
        doc.setFont("helvetica", "bold");
        doc.setFontSize(16);
        doc.text(userProfile.companyName || "Your Company", 60, 20);
        doc.setFontSize(12);
        doc.text(userProfile.companyAddress || "Your Address", 60, 28);
        doc.text(`VAT: ${userProfile.vatNumber || "VAT-123456"}`, 60, 36);
        doc.text(`Issued by: ${userProfile.fullName || "Your Name"}`, 60, 44);

        // Add Logo if available
        if (userProfile.logo) {
            doc.addImage(userProfile.logo, "PNG", 10, 10, 40, 20);
        }

        // Company & User Info
        doc.setFont("helvetica", "bold");
        doc.setFontSize(16);
        doc.text(userProfile.companyName || "Your Company", 60, 20);
        doc.setFontSize(12);
        doc.text(userProfile.companyAddress || "Your Address", 60, 28);
        doc.text(`VAT: ${userProfile.vatNumber || "VAT-123456"}`, 60, 36);
        doc.text(`Issued by: ${userProfile.fullName || "Your Name"}`, 60, 44);

        // Invoice Title & Date
        doc.setFontSize(20);
        doc.text("Invoice", 80, 60);
        doc.setFontSize(12);
        const invoiceDate = new Date().toLocaleDateString();
        doc.text(`Date: ${invoiceDate}`, 10, 70);

        // Table Headers
        let y = 80;
        doc.setFont("helvetica", "bold");
        doc.text("Date", 10, y);
        doc.text("Hours", 50, y);
        doc.text("Rate (£)", 80, y);
        doc.text("Total (£)", 110, y);
        doc.text("Description", 140, y);
        doc.line(10, y + 2, 200, y + 2);

        let totalAmount = 0;
        workEntries.forEach(entry => {
            y += 10;
            doc.setFont("helvetica", "normal");
            doc.text(entry.date, 10, y);
            doc.text(entry.hours.toString(), 50, y);
            doc.text(entry.rate.toFixed(2), 80, y);
            doc.text((entry.hours * entry.rate).toFixed(2), 110, y);
            doc.text(entry.description, 140, y);
            totalAmount += entry.hours * entry.rate;
        });

        

        // Grand Total
        y += 20;
        doc.setFont("helvetica", "bold");
        doc.text(`Total Amount Due: £${totalAmount.toFixed(2)}`, 10, y);
        doc.line(10, y + 2, 200, y + 2);

        doc.save(`Invoice_INV-${invoiceNumber}.pdf`);
    });
});