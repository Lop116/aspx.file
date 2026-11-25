# H2H Debtor Fields – My Understanding & Questions

**Screen:** BankHub > Configuration > Debtor Field
**Reference screens:** Report (SSRS) > Third-Party Payment > Create Third-Party > Upload, and `StatutoryPaymentTask.aspx` (for the SSRS template download)

---

## Part 1 – What I understood

### Task 1: Upload Debtor Fields from Excel

1. Add an **UPLOAD** button next to the **Admin Log** button.
2. Clicking it opens an input section, like the existing **Add** section.
3. The section shows **6 steps** that tell the user how to upload.
4. The user can **download an Excel template**, produced through SSRS in the same way as `StatutoryPaymentTask.aspx`.
5. The user fills in the template and **uploads** it.
6. The system **reads** the Excel data and **saves** it to the database.
7. The page **refreshes** and shows the new records.
8. The user types the **Company Name**, and the grid shows the **Company Name**, but the database stores the **CompanyID**.

### Task 2: Payment Type becomes multi-select

1. In the **Add** and **Update** sections, the **Payment Type** dropdown becomes a **multi-select dropdown list**.
2. The list only shows the payment types **available for the selected company**. The system finds the CompanyID from the company name, then gets that company's payment types.
3. Payment types come from **TBLPAYMENTTYPE**.
4. If the user selects **more than one** payment type, the system creates **one row per payment type**.

---

## Part 2 – Questions for my mentor

### About the Excel template
1. What columns (table headers) should the Excel template have, and in what order?
2. What are the 6 steps that should appear on the upload section? Is there existing wording I should copy?
3. Should the Excel file contain the **Payment Type name**, with the system converting it to an ID like it does for the company?

### About the database
4. Does **tblH2HDebtorFields** contain all the data for the H2H Debtor Fields page, or does some of it come from other tables?
5. Which table converts **Payment Type ↔ number ID**? Is it TBLPAYMENTTYPE?
6. Which table converts **Company Name ↔ number ID (CompanyID)**?
7. How is the data saved: what are the column names in tblH2HDebtorFields?
8. Which table holds the **relationship between Payment Type and Company** (which payment types each company can use)?

### About the behaviour
9. If one row in the Excel file is wrong (for example, the company doesn't exist), should I **reject the whole file** or **save the good rows and report the bad ones**?
10. If a record already exists (same company, same payment type), should I **skip it**, **update it**, or **show an error**?
11. In **Update**, if the user selects several payment types, should it **add new rows** for the extra ones? If the user unticks a payment type, should that row be **removed**?
12. Should the upload be recorded in the **Admin Log**?
