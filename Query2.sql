--SQL LIBRARY MANAGEMENT SYSYTEM QUERY:- 2

select * from books
where isbn ='978-0-307-58837-1'
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
-- select * from return_status
-- where issued_id ='IS135';

-- ADVANCE TASK

--Task 13 :- Identify the members with overdue books
--write a query to identify members who have overdue books(assume a 30 day period). display the member_id, member_name, book title issue date, and any overdues

Select 
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	-- rs.return_book_date,
	Current_date - ist.issued_date as overdue_days
from issued_status as ist
join
members as m
on m.member_id = ist.issued_member_id
join
books as bk
on bk.isbn = ist.issued_book_isbn
left join
return_status as rs
on rs.issued_id = ist.issued_id
where rs.return_book_date is null
and (Current_date - ist.issued_date)>30
order by 1;

--- TASK 14:- write a query to update the status of books in the books table to "yes" when they are returned (bases on the entries in the return statuds
--
--STORE PROCEDURES CONCEPTS

create or replace procedure add_return_records(p_return_id varchar(10),p_issued_id varchar(10),p_book_quality varchar(15))
language plpgsql
as $$

declare
	v_isbn varchar(25);
	v_book_name varchar(75);
begin
	--all logic and code
	--1. inserting the record in return table based on user input
	insert into return_status(return_id, issued_id, return_book_date, book_quality)
	values
	(p_return_id, p_issued_id, current_date, p_book_quality);

	select 
		issued_book_isbn,
		issued_book_name
	into 
		v_isbn,
		v_book_name
	from issued_status
	where issued_id = p_issued_id;
	
	update books
	set status = 'yes'
	where isbn = v_isbn;

	raise notice 'Thank you for returning the book: %', v_book_name;
	
end;
$$



--Now testing the function for the issued_id ='IS135' and its isbn is "978-0-307-58837-1"

call add_return_records('RS119','IS135','Good');


delete from return_status
where return_id ='RS119';

-- TASK 15:- Branch performance report
-- Create a query that generates the performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals
create table branch_report
as 
select 
	b.branch_id, 
	b.manager_id, 
	count(ist.issued_id) as no_books_issued,
	count(rs.issued_id) as no_books_returned,
	sum(bk.rental_price)as total_revenue
from 
	issued_status as ist
join 
	employees as e
on e.emp_id = ist.issued_emp_id
join
	branch as b
on e.branch_id = b.branch_id
left join 
	return_status as rs
on rs.issued_id = ist.issued_id
join 
	books as bk
on ist.issued_book_isbn = bk.isbn
group by 1,2;

select * from branch_report;

-- TASK 16 :- Create a  table of active members
-- use the create table as (ctas) statements to create a new table active_members containing members who have issued at
--least one book in the last 6 months
create table active_members
as
select 
	distinct m.member_id,
	m.member_name,
	m.member_address,
	m.reg_date
from 
	issued_status as ist
join 
	members as m
on m.member_id = ist.issued_member_id
where ist.issued_date >= current_date-interval '6 month';

select * from active_members;

--TASK 17 :-
-- Find Employees with the most book issues processed
-- write a query to find the top 3 employees who have processed the most book issues.
-- Display the employee_name, number of book processed, and thier branch

select 
	e.emp_name,
	count(ist.issued_id) as no_book_issued,
	e.branch_id
from employees as e
join issued_status as ist
on ist.issued_emp_id = e.emp_id
group by 1, 3
order by 2 desc
limit 3;

-- TASK 18 :- identified member issuing high risk books
-- Write a query to identify members who have issued books more than twice with the status "Damaged" in the books table. display the member name, book title, and the number off times they have issued damaged books

select 
	member_id, 
	member_name,
	count(ist.issued_id) > 2 as no_nook_issued
from issued_status as ist
left join  return_status as rs
on rs.issued_id = ist.issued_id
join
members as m
on m.member_id = ist.issued_member_id
where rs.book_quality = 'Damaged'
group by 1;


-- TASK 19 :- Stored prod=cedure objective:-
/* create  astored procedure to maanage the status of books in a library system
Desc :- write a stored procedure that udates the status of book in the library based on its issuance
the procedure should function as follows : the stored proc should take the book_id as an input parameter
the procedure should first check if the book is available( status = 'yes'). if the book is available, it should be issued, and the status of book in the books table should be updated as 'no'. if the book is not available , the procedure should return a error msg indicating the book is currently unavailable
*/

create or replace procedure issue_book(p_issued_id varchar(10), p_issued_member_id varchar(10), p_issued_book_isbn varchar(30), p_issued_emp_id varchar(10))
language plpgsql
as $$

declare
	v_status varchar(10);
begin
-- all logic and code
	select status
	into
	v_status
	from books
	where isbn = p_issued_book_isbn;
	
	if 
		v_status ='yes'
		then
		insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		values
		(p_issued_id, p_issued_member_id, current_date, p_issued_book_isbn, p_issued_emp_id);

		update books
		set status = 'no'
		where isbn = p_issued_book_isbn;

		raise notice 'Book record added successfully for book isbn : %',p_issued_book_isbn ;
		
	else
		raise notice 'Book you have requested is not available, book isbn : %', p_issued_book_isbn ;

	end if;
	
end;
$$


select * from books;
--"978-0-553-29698-2" -- yes
--"978-0-375-41398-8"-- no

select * from issued_status;
-- TESTING THE STORE PROCEDURE
call issue_book('IS155','C108', '978-0-553-29698-2', 'E104');
call issue_book('IS156','C108', '978-0-375-41398-8', 'E104');

select * from books
where isbn = '978-0-553-29698-2'