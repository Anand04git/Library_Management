# Library_Management

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_database`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.


## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.


## ERD of project:-
![image](https://github.com/user-attachments/assets/7f4454da-f061-40b0-9525-25941467b5d9)

- **Database Creation**: Created a database named `library_database`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
--Library Management System

--creating the branch table

create table branch (
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address varchar(10),
	contact_no varchar(15)
);
alter table branch
alter column branch_address type varchar(50);

create table employees (
	emp_id varchar(10) primary key,
	emp_name varchar(25),
	position varchar(20),
	salary int,
	branch_id varchar(10)
);
alter table employees
alter column salary type float;

drop table if exists books;
create table books(
	isbn varchar(25) primary key,
	book_title varchar(75),
	category varchar(20),
	rental_price float,
	status varchar(20),
	author varchar(35), 
	publisher varchar(55)
);

create table members (
	member_id varchar(10) primary key,
	member_name varchar(25),
	member_address varchar(75),
	reg_date date
);

create table issued_status (
	issued_id varchar(10) primary key,
	issued_member_id varchar(10),
	issued_book_name varchar(75),
	issued_date date,
	issued_book_isbn varchar(25),
	issued_emp_id varchar(10)
);

create table return_status (
	return_id varchar(10) primary key,
	issued_id varchar(10),
	return_book_name varchar(75),
	return_book_date date,
	return_book_isbn varchar(20)
);
```
### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.


## 3. Advance Queries to fetch the data from the inherited tables

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.



