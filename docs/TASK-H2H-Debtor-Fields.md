# Task: H2H Debtor Fields – Excel Upload & Multi-Select Payment Type

## Location of the interface

| What | Path |
|---|---|
| Page to change | **BankHub > Configuration > Debtor Field** (H2H Debtor Fields) |
| Reference for the upload flow | **Report (SSRS example) > Third-Party Payment > Create Third-Party > Upload** |
| Reference for template download (SSRS) | `StatutoryPaymentTask.aspx` |

---

## Task 1 – Bulk upload of Debtor Fields from Excel

**Goal:** Users can download an Excel template, fill it in, upload it, and have the rows saved to the database.

### Steps

- [ ] **1.1 Add an `UPLOAD` button** next to the existing **Admin Log** button.
- [ ] **1.2 Open an upload panel** when the button is clicked. Use the same style as the existing **Add** section (an inline table/input section).
- [ ] **1.3 Show the 6-step instructions** in the panel (draft wording, confirm with the business):
  1. Click **Download Template** to get the Excel file.
  2. Fill in one row per debtor field. Do not change or reorder the header row.
  3. Enter the **Company Name** and **Payment Type** exactly as they appear in the system.
  4. Save the file as `.xlsx`.
  5. Click **Choose File** and select the completed template.
  6. Click **Upload**, then check the results shown on the page.
- [ ] **1.4 Make the template downloadable.** Generate it through the SSRS report, using the same approach as `StatutoryPaymentTask.aspx`.
- [ ] **1.5 Accept the uploaded file.** Allow `.xlsx` only, and check the file size and that it is not empty.
- [ ] **1.6 Read and validate the data:**
  - The header row must match the template exactly.
  - Required fields must not be blank.
  - Each **Company Name** must exist. Look it up to get the **CompanyID**.
  - Each **Payment Type** must exist and must be allowed for that company. Look it up to get the **PaymentTypeID**.
  - Flag duplicate rows, both inside the file and against rows already in the database.
  - Report errors per row, for example "Row 5: Company 'ABC' not found".
- [ ] **1.7 Insert into the database.** Save the **IDs**, not the names, into `tblH2HDebtorFields`. Use a single transaction, so if any row fails, nothing is saved.
- [ ] **1.8 Refresh the page** after a successful upload so the grid reloads.
- [ ] **1.9 Show the information:** in the grid, display the **Company Name** (joined from the company table), while the database stores the **CompanyID**.
- [ ] **1.10 Write to the Admin Log** for the upload action, if the existing Add/Update actions are logged.

> **Rule:** Display the company **name**, but save the **CompanyID**.

---

## Task 2 – Payment Type as a multi-select dropdown (Add & Update)

**Goal:** Replace the single-select Payment Type dropdown with a multi-select dropdown list.

### Steps

- [ ] **2.1** In both the **Add** and **Update** sections, change the **Payment Type** control from a single dropdown to a **multi-select dropdown list** (checkbox list or ListBox with multiple selection).
- [ ] **2.2 Filter by company.** Only show the payment types that are available for the selected company:
  - Company Name → CompanyID, from the company table.
  - CompanyID → allowed payment types, from the company/payment-type relationship table.
  - Payment type names and IDs come from `TBLPAYMENTTYPE`.
  - Reload the list whenever the Company selection changes (AutoPostBack or AJAX).
- [ ] **2.3 Save one row per selected payment type.** If the user selects more than one, insert one row into `tblH2HDebtorFields` for each payment type. All other field values stay the same.
- [ ] **2.4 Define how Update behaves** (confirm with the business):
  - Option A: the selection is the full set. Add rows for newly checked types and delete or deactivate rows for unchecked types.
  - Option B: Update edits only the current row's single payment type. Multi-select applies only to Add.
- [ ] **2.5 Prevent duplicates.** Do not create a row if the same Company + Payment Type + field already exists.
- [ ] **2.6** Apply the same company → payment type check in the Excel upload (Task 1, step 1.6).

---

## Open questions (must be answered before development)

| # | Question | Answer |
|---|---|---|
| Q1 | What is the **Excel template layout** (table header / column names and order)? | _TBD_ |
| Q2 | Does `tblH2HDebtorFields` contain **everything** shown on the H2H Debtor Fields page, or are some values joined from other tables? | _TBD_ |
| Q3 | Which table maps **PaymentType ↔ numeric ID**? (expected: `TBLPAYMENTTYPE`) | _TBD_ |
| Q4 | Which table maps **CompanyName ↔ numeric ID (CompanyID)**? | _TBD_ |
| Q5 | How is the data saved: what are the **column names and types** in `tblH2HDebtorFields`? | _TBD_ |
| Q6 | Which table holds the **relationship between PaymentType and Company** (which payment types each company can use)? | _TBD_ |
| Q7 | What should **Update** do with multi-select (Option A or B in step 2.4)? | _TBD_ |
| Q8 | Is the 6-step instruction wording in step 1.3 approved? | _TBD_ |

### SQL queries to help answer the questions

```sql
-- Q2 / Q5: columns of tblH2HDebtorFields
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblH2HDebtorFields'
ORDER BY ORDINAL_POSITION;

-- Q2: foreign keys from tblH2HDebtorFields to other tables
SELECT fk.name AS FK, OBJECT_NAME(fk.parent_object_id) AS FromTable,
       COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS FromColumn,
       OBJECT_NAME(fk.referenced_object_id) AS ToTable,
       COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ToColumn
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'tblH2HDebtorFields';

-- Q3: payment type table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TBLPAYMENTTYPE';

-- Q4: candidate company tables
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Company%'
ORDER BY TABLE_NAME;

-- Q6: tables that have BOTH a company column and a payment type column (likely the link table)
SELECT c1.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS c1
JOIN INFORMATION_SCHEMA.COLUMNS c2 ON c1.TABLE_NAME = c2.TABLE_NAME
WHERE c1.COLUMN_NAME LIKE '%Company%'
  AND c2.COLUMN_NAME LIKE '%PaymentType%'
GROUP BY c1.TABLE_NAME;

-- Also check the stored procedures the current Debtor Field page uses
SELECT OBJECT_NAME(object_id) AS ProcName
FROM sys.sql_modules
WHERE definition LIKE '%tblH2HDebtorFields%';
```

---

## Definition of done

- [ ] The UPLOAD button, the panel, the 6-step instructions, the template download, and the file upload all work.
- [ ] Valid rows are saved with IDs. Invalid files are rejected with clear row-level errors.
- [ ] The grid refreshes after upload and shows company **names**.
- [ ] Payment Type is multi-select in both Add and Update, and is filtered by company.
- [ ] Selecting several payment types creates one row per type, with no duplicates.
- [ ] Every open question above has an answer.
