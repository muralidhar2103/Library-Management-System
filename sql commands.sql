CREATE DATABASE library
    DEFAULT CHARACTER SET = 'utf8mb4';

use library;

create table Employee (
    empid varchar(20) primary key,
    name varchar(30),
    password varchar(30),
    dept varchar(30),
    doj varchar(30),
    sal varchar(30)
);

create table Student (
    rollno varchar(20) primary key,
    name varchar(30),
    password varchar(30),
    dept varchar(30),
    sem varchar(30),
    batch varchar(30)
); 

create table Book (
    bid varchar(20) primary key,
    title varchar(30),
    subject varchar(30),
    author varchar(30),
    status varchar(30)
); 

create table Issue (
    bid varchar(20),
    issueto varchar(30),
    issueby varchar(30),
    primary key(bid,issueto,issueby),
    foreign key(bid) references Book(bid),
    foreign key(issueto) references Student(rollno),
    foreign key(issueby) references Employee(empid)
);

--Trigger: Student can only borrow maximum of 3 books
DELIMITER $$;
CREATE TRIGGER issue_before_insert
    BEFORE INSERT ON Issue
    FOR EACH ROW
BEGIN
    DECLARE c INT;
    DECLARE msg VARCHAR(30);
    SELECT count(*) INTO c 
    FROM Issue
    WHERE Issueto=NEW.Issueto
    GROUP BY Issueto;
    IF c=3 THEN
        SET msg = concat('Limit reached');
        signal sqlstate '45000' set message_text =msg;
    END IF
END $$
DELIMITER ;



INSERT INTO Employee VALUES('1','Suresh','qwerty','cse','16/01/2022','42000');
INSERT INTO Employee VALUES('2','Mahesh','qwerty','ece','12/01/2021','53000');
INSERT INTO Employee VALUES('3','Ramesh','qwerty','eee','23/10/2019','64000');
INSERT INTO Employee VALUES('4','Ram','qwerty','mech','17/08/2012','28000');
INSERT INTO Employee VALUES('5','Veer','qwerty','ise','21/10/2010','25000');


INSERT INTO Student VALUES('1','Diya','qwerty','cse','5','a1');
INSERT INTO Student VALUES('2','Vikram','qwerty','ece','8','b2');
INSERT INTO Student VALUES('3','Charan','qwerty','eie','2','d1');
INSERT INTO Student VALUES('4','Nani','qwerty','ise','6','a2');
INSERT INTO Student VALUES('5','Vikrant','qwerty','chem','4','c1');


INSERT INTO Book VALUES('12432','Mechanical Engineering','Mechanical','Gwen Stacy','avail');
INSERT INTO Book VALUES('13142','Python Zero to Hero','python','Mary Jane','avail');
INSERT INTO Book VALUES('43543','Introduction to Programming','compuer science','Harry Osborn','avail');
INSERT INTO Book VALUES('65356','Chemical Bonds','Chemistry','Ben Parker','avail');
INSERT INTO Book VALUES('34632','Data Structures and algorithms','Java','Haward Starck','avail');
INSERT INTO Book VALUES('34331','Computer Organisation','CSE','Albert','avail');
INSERT INTO Book VALUES('34135','DBMS','CSE','Lucy Mayor','avail');
INSERT INTO Book VALUES('41234','Software Engineering','CSE','Hetmayer','avail');
INSERT INTO Book VALUES('41224','Data Communications','CSE','Vinay Reddy','avail');


INSERT INTO Issue VALUES('12432','3','1');
INSERT INTO Issue VALUES('43543','2','5');
INSERT INTO Issue VALUES('13142','1','4');
INSERT INTO Issue VALUES('65356','1','2');
INSERT INTO Issue VALUES('34632','4','3');
INSERT INTO Issue VALUES('34331','1','3');
INSERT INTO Issue VALUES('12432','1','3');


--Procedure: To find number of books when id is given
DELIMITER $$
CREATE PROCEDURE get_all_borrowed_books(IN id INT)
BEGIN 
    SELECT *
    FROM Book b
    JOIN Issue i
    ON b.bid=i.bid
    WHERE i.issueto=id;
END $$
DELIMITER ;

CALL get_all_borrowed_books(1);

--Procedure : to return the book on basis on roll_no and bid

DELIMITER $$
CREATE PROCEDURE return_book(IN roll_no INT, IN bid INT)
BEGIN
    DELETE FROM Issue i
    WHERE i.issueto=roll_no AND i.bid=bid;

    UPDATE Book b 
    SET b.status="avail"
    WHERE b.bid=bid;

END
DELIMITER ;

CALL return_book(3,12432);

select DISTINCT(s.name) 
from student s, employee e, issue i
where e.empid=1 and s.rollno = i.issueto;

select * 
from student s 
where s.rollno
not in(select issueto from issue);

select title,count(*) as No_of_Books 
from Book 
group by title;