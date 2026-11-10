# Library Management System (LMS) Database

A group assignment for **Database Systems (XDCS1054N)**. It covers the design and implementation of a Library Management System database in MySQL, from the ERD through normalization to SQL objects such as views, functions, stored procedures and triggers.

**Group 2**
- George Tang Yunn Shun
- Jordan Lim Min Yong
- Edison Tan Zy Young
- Muhammad Zahran
- Gee Lok Thim

**Lecturer:** Ms Norsyela

## Overview

The LMS manages a library's books, authors, genres, members and loans. It tracks which books are available (by ISBN, title, author and so on), which members have borrowed them, the loan and due dates, and any penalty charged for late returns.

## Database Design

### Entities and Relationships
- An author can write many books, and a book can have many authors (many-to-many, resolved with the `bookAuthor` junction table).
- A genre can have many books.
- A member can have many loans, and each loan belongs to one member.
- A member can borrow many books, and each book belongs to one member (as modelled in the report).

### Tables

| Table | Columns |
|---|---|
| `genre` | **genreID**, genreName |
| `book` | **isbn**, bookName, genreID (FK), publicationYear, memberID (FK) |
| `author` | **authorID**, authorName, nationality |
| `members` | **memberID**, memberName, phoneNum, birthDate, age (derived) |
| `loan` | **loanID**, loanDate, dueDate, returnDate, penaltyPrice, memberID (FK) |
| `bookAuthor` | isbn (PK, FK), authorID (PK, FK) |

### Normalization
The design started from a Chen notation ERD and was normalized as follows:
- **1NF:** no multivalued attributes, so no changes.
- **2NF:** `genreName` depended only on `genreID`, so it moved into a separate `genre` table. The many-to-many link between book and author was resolved with `bookAuthor`.
- **3NF:** no transitive dependencies, so no further changes.

A crow's foot diagram was then drawn from the 3NF result.

## SQL Features

The script `Group_Assignment_SQL.sql` includes:

- **DDL:** database and table creation, plus `ALTER TABLE` statements for foreign keys
- **CRUD:** `INSERT`, `SELECT`, `UPDATE` and `DELETE` examples
- **View:** `book_genre_view` joins books with their genre names *(Jordan)*
- **Function:** `GetMembersAge(birthDate)` calculates a member's age from their birth date *(Zahran)*
- **Stored procedure:** `addAuthor` inserts a new author *(Lok Thim)*
- **Trigger:** `after_member_insert` logs new members to a `member_log` table *(Edison)*
- **Trigger:** `set_penalty_before_update` sets `penaltyPrice` at RM1.50 per late day when a loan is returned after its due date *(George)*
- **Restricting and sorting:** `LIKE` and `ORDER BY` queries
- **Single-row functions:** `UPPER` and `SUBSTRING`

## Real-World Example and Suggested Improvements

The report looks at **Universiti Malaya Library**, which uses the Virtua ILS system on a relational DBMS. It identifies three limitations: scalability, limited integration, and high maintenance costs. It proposes two enhancements: migrating to a cloud database and implementing APIs.

For this project's own design, it suggests:
1. Adding a separate `Penalty` table with a penalty reason.
2. Adding a `loanStatus` attribute to `loan` (loaned, returned, overdue).

## Repository Contents

| File | Description |
|---|---|
| `Group_Assignment_SQL.sql` | Database schema and all SQL commands |
| `LMS_Database_System_Report_Group_2.pdf` | Written report |
| `DBS_Presentation_Group_2.pdf` | Presentation slides |
| `LMS-Normalization.xlsx` | Normalization tables |
| `Entity_Attribute.xlsx` | Entity and attribute tables |

## How to Run

1. Install MySQL and MySQL Workbench (this project was built with MySQL Workbench 8.0 CE).
2. Open `Group_Assignment_SQL.sql` in Workbench.
3. Run the script, preferably in sections, in the order it is written.

## Known Issues

- The `after_member_insert` trigger writes to a `member_log` table that the script does not create. Create it first, for example:
  ```sql
  CREATE TABLE member_log (
      logID INT AUTO_INCREMENT PRIMARY KEY,
      memberID VARCHAR(50),
      memberName VARCHAR(100),
      action_type VARCHAR(20)
  );
  ```
- In the script, the `ALTER TABLE book ... FOREIGN KEY (memberID)` statement appears before the `ADD memberID` statement. Swap them so the column exists before the constraint is added.
- `age` is stored in `members` even though it can be derived from `birthDate` with `GetMembersAge`.

## Disclaimer

This project was created for educational purposes as part of a university course.
