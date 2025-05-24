--Task 14: Update Book Status on Return
--Write a query to update the status of books in the books table to "Yes"
--when they are returned (based on entries in the return_status table).

select * from books;
select * from return_status;
select * from issued_status;

create or replace procedure add_return_records
	(
	p_return_id varchar(10) ,
	p_issued_id varchar(30),
	p_book_quality varchar(10)
	)
language plpgsql
as $$

declare
v_isbn varchar(50);
v_book_name varchar(80);

begin
	insert into return_status(return_id, issued_id, return_date, book_quality )
	values (p_return_id, p_issued_id, current_Date, p_book_quality);

	select issued_book_isbn,
	issued_book_name
	into v_isbn, v_book_name
	from issued_status
	where issued_id = p_issued_id;

	update boooks
	set status = 'yes'
	where isbn = v_isbn;

	raise notice ' thank you for returning the book: %', v_book_name;
	end;
	$$

end

select * from books;
select * from return_status;
select * from issued_status;
	
	issued_id = 'IS136'
	issued_book_isbn = '978-0-7432-7357-1'


select * from issued_status
where 	issued_book_isbn = '978-0-7432-7357-1';

select * from return_status;
where 	issued_id = 'IS136';

select * from books
where isbn = '978-0-7432-7357-1';

call add_return_records('R')

/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch,
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

create table branch_report
as
select br.branch_id, br.manager_id, count(isd.issued_id) as no_of_books_issued, 
count(rs.return_id) as no_of_books_returned, sum(b.rental_price) as total_revenue from branch br
join employees e
on br.branch_id = e.branch_id
join issued_status isd
on isd.issued_emp_id = e.emp_id
left join return_status rs
on rs.issued_id = isd.issued_id
join books b
on b.isbn = isd.issued_book_isbn
group by 1,2 
order by total_revenue desc;

select * from branch_report;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;
select * from members;
select * from books;
select * from books;

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have issued at least one book in the last 2 years. */

create table Active_members 
as
select * from members where member_id in ( 
select distinct issued_member_id from issued_status
where issued_date >= current_date - interval'2 year');

select * from active_members;

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues.
Display the employee name, number of books processed, and their branch. */

select * from employees;
select * from issued_status;
select * from branch;
select e.emp_name, count(ist.issued_id) as num_of_books_processed, b.*
from issued_status ist
join employees e
on e.emp_id = ist.issued_emp_id
join branch b
on b.branch_id = e.branch_id
group by e.emp_name, b.branch_id
order by num_of_books_processed desc limit 3
;

/*Task 19: Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
The procedure should function as follows: The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes'). If the book is available, 
it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message 
indicating that the book is currently not available. */

select * from books;
select * from issued_status;


CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variabable
    v_status VARCHAR(10);

BEGIN
-- all the code
    -- checking if book is available 'yes'
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;


    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$


-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

```


