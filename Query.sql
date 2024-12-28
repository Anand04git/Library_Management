select * from books;
select * from branch;
select * from employees;
select * from members;
select * from issued_status;
select * from return_status;

--TASKS
--Q1:- write a sql query to create a new record --"('987-1-60129-456-2','to kill a mockingbird', 'classic', 6.00,'yes', 'Harper Lee', 'J.B. Lippincot & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
Values('987-1-60129-456-2','to kill a mockingbird', 'classic', 6.00,'yes', 'Harper Lee', 'J.B. Lippincot & Co.');

--Q2:- update a exixting members address
update members
set member_address = '456 Main st'
where member_id = 'C101';

--Q3:- Delete the record with the issued_id ='IS121' from the issued_status table
delete from issued_status
where issued_id ='IS121';

--Q4:- Retrieve all books Issued by a soecific employee --objectibve :- select all the books issued by the employee with emp_id ='E101'
select * from issued_status
where issued_emp_id='E101';

--Q5:- list members who have issued more than one book
select issued_member_id, 
-- count(issued_id) as no_books_issued
from issued_status
group by issued_member_id
having count(issued_member_id)>1;

-----CTAS
--task 6:- Create summary tables: used CTAS generate new tables based on query results - each book and yotal books issued count.
create table book_count 
as 
select 
	b.isbn,
	b.book_title,
	count(ist.issued_id) as no_issued
from books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1, 2;

select * from book_count;

--Task 7 :- Retrieve all books in specific category
select * from books
where category = 'Classic';

--Task 8 :- find total rental income by category

select 
	b.category,
	sum(b.rental_price),
	count(*)
from books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1
order by 2 desc;


insert into members(member_id, member_name, member_address, reg_date) 
values('C122', 'Vivek Singh', '123 Nhs','2024-10-01'),
('C123', 'Ravi Yadav', '659 Vhs','2024-11-01');

--Task 9 :- List the members who have registered in the last 180 days
select * from members
where reg_date >=current_date-interval '180 days';

--Task 10: List employee with their branch manager anme and thier branch details
select  
	e.emp_id,
	e.emp_name,
	e.salary,
	e2.emp_name as manager_name,
	b.manager_id
from employees as e
join
branch as b
on b.branch_id = e.branch_id
join 
employees as e2
on b.manager_id = e2.emp_id;

--Task 11 :- create a table of books with a rental price above a certain threshold 7$.

create table books_price_grater_than_7
As
select * from books
where rental_price > 7;

select * from books_price_grater_than_7;


--task 12:- retrieve the list of books which not returned yet
select 
	distinct ist.issued_book_name
from issued_status as ist
left join
return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_id is null;