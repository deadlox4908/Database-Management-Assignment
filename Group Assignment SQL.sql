-- 															Create database 
CREATE DATABASE LMS;

USE lms;

-- 																Create table

CREATE TABLE genre (
	genreID VARCHAR(50) PRIMARY KEY,
    genreName VARCHAR (100) NOT NULL

	);

CREATE TABLE book (
	isbn VARCHAR(50) PRIMARY KEY,
    bookName VARCHAR(100) NOT NULL,
    genreID VARCHAR(50),
    publicationYear INT,
    FOREIGN KEY (genreID) REFERENCES genre(genreID)
    );

CREATE TABLE author (
	authorID VARCHAR(50) PRIMARY KEY,
    authorName VARCHAR(100) NOT NULL,
    nationality VARCHAR (50)
    );

CREATE TABLE members (
	memberID VARCHAR (50) PRIMARY KEY,
    memberName VARCHAR(100) NOT NULL,
    phoneNum VARCHAR(30),
    birthDate DATE,
    age INT
    );


CREATE TABLE loan (
	loanID VARCHAR(50) PRIMARY KEY,
    loanDate DATE NOT NULL,
    dueDate DATE NOT NULL,
    returnDate DATE,
    penaltyPrice DECIMAL
    );
    
    
CREATE TABLE bookAuthor (
	isbn VARCHAR(50),
    authorID VARCHAR(50),
	FOREIGN KEY (isbn) REFERENCES book(isbn),
	FOREIGN KEY (authorID) REFERENCES author(authorID),
	UNIQUE (isbn, authorID)
);

ALTER TABLE book 
ADD CONSTRAINT memberID FOREIGN KEY (memberID) REFERENCES members(memberID);

ALTER TABLE book
ADD memberID VARCHAR(50);

ALTER TABLE loan 
ADD memberID VARCHAR(50),
ADD CONSTRAINT loan_memberID FOREIGN KEY (memberID) REFERENCES members(memberID); 
-- 															DML (Data Manipulative Languange) 
    

-- inserting data into tables (CREATE) 
INSERT INTO members (memberID, memberName, phoneNum, age)
VALUES
('CR001', 'Bobby Meng Leng', '019-2321123', 20),
('CR002', 'Jennifer Lee', '016-9001033', 18);

INSERT INTO author (authorID, authorName, nationality)
VALUES
('RS0001', 'J.K. Rowling', 'United Kingdom'),
('RS0002', 'Stephen King', 'United States'),
('RS0003', 'Victor Axelson', 'Denmark');

-- Viewing the data (READ)
SELECT * FROM members 
WHERE age = 20; 

SELECT * FROM author;

-- Updating the data (UPDATE)
UPDATE members 
SET age = 22 
WHERE memberID = 'CR002';

UPDATE author 
SET nationality = 'France', authorName = 'Jean Paul Gaultier'
WHERE authorID = 'RS0001';

-- Deleting data (DELETE) 
DELETE FROM author 
WHERE authorID = 'RS0003';

DELETE FROM members 
WHERE memberID = 'CR002' ;


-- 															Advanced SQL Commands 

-- Views (Jordan)
CREATE VIEW book_genre_view AS
SELECT book.isbn, book.bookName, genre.genreName
FROM book
JOIN genre ON book.genreID = genre.genreID;

SELECT * FROM book_genre_view;

-- Function (Zahran) 
DELIMITER \\
CREATE FUNCTION GetMembersAge(birthDate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN TIMESTAMPDIFF(YEAR, birthDate, CURDATE());
END\\

DELIMITER ;

-- Stored procedure (Lok Thim)

DELIMITER \\
    
CREATE PROCEDURE addAuthor (
    IN p_authorID VARCHAR(50),
    IN p_authorName VARCHAR(100),
    IN p_nationality VARCHAR (50)
)
BEGIN
    INSERT INTO author (authorID, authorName, nationality)
    VALUES (p_authorID, p_authorName, p_nationality);
END\\

DELIMITER ;

CALL addAuthor ('RS004', 'Stan Lee', 'United States');

-- Trigger (Edison)

DELIMITER \\
CREATE TRIGGER after_member_insert
AFTER INSERT ON members
FOR EACH ROW
BEGIN
  INSERT INTO member_log (memberID, memberName, action_type)
  VALUES (NEW.memberID, NEW.memberName, 'INSERT');
END\\

DELIMITER ;

-- Trigger (George) 

DELIMITER \\
CREATE TRIGGER set_penalty_before_update
BEFORE UPDATE ON loan
FOR EACH ROW
BEGIN
    IF NEW.returnDate > NEW.dueDate THEN
        SET NEW.penaltyPrice = DATEDIFF(NEW.returnDate, NEW.dueDate) * 1.50;
    END IF;
END\\
DELIMITER ;

--                                                      Restricting and Sorting Data 

SELECT * FROM author WHERE authorName LIKE 'S%';

SELECT * FROM author ORDER BY nationality DESC;

-- 														Single Row and Group Functions 

SELECT memberName, UPPER(memberName) AS upper_memberName FROM members;

SELECT authorName, SUBSTRING(authorName, 1, 7) AS author_shortName FROM author;


