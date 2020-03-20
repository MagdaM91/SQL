--1.Get everything from "Phone", which is after '-' sign (Employee table)

select substr(Phone, INSTR(Phone, '-')+1, LENGTH(Phone)) "EndOfString"
from Employee;


--2.Get everything from "email", till @ from Employee table
select substr(Email, 1, INSTR(Email, '@')-1) "BeforeAt"
from Employee;


--3.Get everything from "email", after @ from Employee table
select substr(Email, INSTR(Email, '@')+1, LENGTH(Email)) "AfterAt"
from Employee;


--4.get "Fax" and replace '-' with '/' note use replace() function
select replace(Fax, '-','/') "ReplacedFax"
from customer;


--5.get everything from "Phone" column between first '(' and second ')'

with subtable as (select substr(Phone, INSTR(Phone, '('), LENGTH(Phone)) as SubPhone
from customer)
select substr(SubPhone, 1, INSTR(SubPhone, ')')) "BetweenBrackets"
from subtable;

--6.select data from column "Country" and show it as upper case 

select UPPER(country) "Country"
from Customer;


-- 7. select Customer "FirstName", "LastName", Company which is assigned to Employee who has Id =3

select Customer.FirstName, Customer.LastName, Customer.Company
from Customer 
left join Employee on Customer.SupportRepId = Employee.EmployeeId 
where Employee.EmployeeId = 3;


--8. select Customer "FirstName", "LastName", Company which is assigned to Employee who has Id =3 where Country is different than USA

select Customer.FirstName, Customer.LastName, Customer.Company 
from Customer 
left join Employee on Customer.SupportRepId = Employee.EmployeeId 
where Employee.EmployeeId = 3 and Customer.Country !='USA';


--9. select Customer "FirstName", "LastName", Company which is assigned to Employee who has Id =3 and Customer has FAX number

select Customer.FirstName, Customer.LastName, Customer.Company
from Customer 
left join Employee on Customer.SupportRepId = Employee.EmployeeId 
where Employee.EmployeeId = 3 and Customer.Fax is not null;

--10. Change task nr.7 and rename table in select statemnt as following: Customer -> Cust, Employee -> Emp

select Cust.FirstName, Cust.LastName, Cust.Company
from Customer Cust
left join Employee Emp on Cust.SupportRepId = Emp.EmployeeId 
where Emp.EmployeeId = 3;


--11. Select top 3 Customers how has the highest sum of Invoices. I want to see FirstName, LastName, Country for these customers.

select Customer.FirstName, Customer.LastName, Customer.Country, SUM(Invoice.Total)
from Customer
left join Invoice on Customer.CustomerId = Invoice.CustomerId 
group by Customer.CustomerId 
order by SUM(Invoice.Total) DESC 
limit 3;


-- 12. Select top 5 employees how support the biggest Customers in company

with subtable as (select customer.CustomerId, invoice.Total, Customer.SupportRepId, SUM(total)
from Customer
inner join Invoice on Customer.CustomerId = Invoice.CustomerId 
group by customer.CustomerId
order by sum(total) desc
limit 5)
select employee.FirstName, employee.LastName
from employee
join subtable on subtable.supportrepid = employee.EmployeeId;


--13. Select Artist Name who create the biggest amount of Albums

select Artist.Name, count(Album.ArtistId)
from Artist
left join Album on Artist.ArtistId = Album.ArtistId
group by Artist.ArtistId
order by count(Album.ArtistId) desc
limit 1;


--14. Select Artist Name who create the biggest amount of Albums if there are some artists how has no album select 'no albums'

with subtable as (select Artist.Name, count(Album.ArtistId) as 'Amount'
from Artist
left join Album on Artist.ArtistId = Album.ArtistId
group by Artist.ArtistId
order by Amount desc)
select case when subtable.Amount = 0 then 'no albums' else Amount end Albums, Subtable.Name
from subtable;


--15. Select Phone number from Employye and name it as "EmployeePhone" and select phone number from Customers and name it as "CustomerPhone"
-- to do this task check UNION ALL statement

select NULL as 'EmployeePhone', employee.Phone as 'CustomerPhone' 
from Employee
union all
select Customer.Phone as 'CustomerPhone', NULL as 'EmployeePhone'
from Customer;


--16. select title from Album if title starts from S letter then print 'Słabe' if title starts from W print 'Warte'

select case when instr(Title, 'S') = 1 then 'Slabe' when instr(Title, 'W')= 1 then 'Warte' else Title end Title
from album;


--17. select CustomerId, InvoiceDate from Invoice where invoices was from period 2007-01, 2007-06

select CustomerId, InvoiceDate
from Invoice
where InvoiceDate BETWEEN '2007-01-01' and '2007-06-01';


--18. Select FirstName, LastName from Customer wher e invoices was from period 2007-01, 2007-06

select Customer.FirstName, Customer.LastName
from Customer
left join Invoice on Customer.CustomerId = Invoice.CustomerId 
where Invoice.InvoiceDate BETWEEN '2007-01-01' and '2007-06-01';


--19. select * from invocies where BillingPostal code end on 0

select *
from Invoice 
where BillingPostalCode like '%0';

select *
from Invoice 
where SUBSTR(BillingPostalCode, LENGTH(BillingPostalCode),1) = '0';


--20. select top 5 invoices wihich has the highest total number

select InvoiceId, total
from Invoice
order by total desc
limit 5;


--21. Show City and amount of Customers from each city

select BillingCity, count(CustomerId) as Amount
from Invoice
group by BillingCity
order by count(CustomerId) desc;


--22. Show Country and amount of Customers from each Country

select BillingCountry, count(CustomerId)
from Invoice 
group by BillingCountry 
order by count(CustomerId) desc;


--23. Insert '291-9943' into column "Fax" in Customer table where responisble LastName = 'Johnson'

Update Customer set fax = '291-9943'
where SupportRepId = 
(select Employee.EmployeeId 
from Employee 
where LastName = 'Johnson');


--24. Update state column in customer table and set 'FK' where empty

Update Customer set State = 'FK'
where State is null;


--26. Get last letter from BillingCity table invocies, to be sure select in one column "BillingCity" and in second column last letters

SELECT BillingCity, substr(BillingCity, LENGTH(BillingCity)) as "LastLetter"
from Invoice;
                                               
--30. Print how many Track has each Album

select AlbumId, count(AlbumId) as 'Amount of Track'
from Track
group by albumid
order by count(AlbumId) desc;


--31. Check how many second last each Album

select AlbumId, sum(Milliseconds)
from Track
group by AlbumId
order by sum(Milliseconds) desc;


--32. How many gender are assigned to Album

select GenreId, count(AlbumId) 
from Track
group by GenreId
order by GenreId;


--33. How many albums was created by more than one Composer

select count(Composer)
from Track
where instr(Composer, ',')> 0 or instr(Composer, '/')> 0 or instr(Composer, '&')> 0 or instr(Composer, '&')> 0;

--34. How many albums was created by Queen band

SELECT count(Composer)
from track
where Composer = 'Queen';


--35. How many second last Queens songs and how many GB it consuming

select sum(Milliseconds), sum(Bytes)
from Track
where Composer = 'Queen';

                                               
--36. Create view which will show report: Amount of invoices per each month for specyfic cilent
create  view ExampleView as 
select substr(InvoiceDate, 1, 7) as MonthlyDate, count(CustomerId) as AmountOfInvoices, CustomerId
from Invoice
group by MonthlyDate, CustomerId
order by InvoiceId; 

--37. Creat monthly sales report view
-- Details: Amount of invoices per each month for chosen Customer,
-- Income per each month for chosen customer, FirstName, LastName (incom is a sum of total)
create view MonthlyReport as 

with Subquery as (select substr(InvoiceDate, 1, 7) as MonthlyDate, 
Customer.CustomerId, count(Invoice.CustomerId) as AmountofInvoices, Customer.FirstName, Customer.LastName, 
sum(Invoice.total) as SumOfInvoice
from Invoice
join Customer on Invoice.CustomerId = Customer.CustomerId
group by MonthlyDate, Customer.CustomerId
order by Invoice.InvoiceId)
select * from Subquery order by Subquery.MonthlyDate, Subquery.SumOfInvoice desc;

select * from MonthlyReport ;


--38.Create table Library and students. Library should have column BookId(primarykey, not null), Title, Author, release date, 
--BookedBy (foreingkey to students table)
-- Table students should have StudentID(primary key, not null), FirstName, LastName, ShoolName
-- Table BookingDetails where will be column as following: StudentId, BookId, Title, Author, BookedFrom(date),
--BookedTo (date).


--Figure out Name of students and add them his own id's and insert to table Students(at least 3 students)
--Insert at least 5 books and give him ID, insert into column (BookedBy id of students how want to borrow book)
--Insert data to table BookingDetails and insert which student borrowe which book and set BookedFrom date
--(it should be date when he or she borrowed book)
--If students won't return book yest left BookedTo column as null

Create table Library 
(BookId integer primary key not null,
Title text not null,
Author TEXT not null,
ReleaseDate datetime not null,
BookedBy integer,
foreign Key(BookedBy)references "Students" (Studentid));

Insert into Library (Bookid, Title, Author, ReleaseDate, BookedBy)
Values (1, 'Harry', 'Rowling', '1992-01-01', 2),
(2, 'Male kobietki', 'Gerwig', '2003-02-03', 6),
(3, 'Ptaki ciernistych krzewow', 'Collen', '1809-04-05', 3),
(4, 'Moje marzenia', 'Kowalewski', '1990-04-09', 4),
(5, 'Urwisko', 'Piekarska', '2003-07-09', 4),
(6, 'Pieklo', 'Piatek', '1999-11-12', 2);

select *
from Library;



Create table Students
(StudentId integer not null,
FirstName TEXT not null,
LastName Text not null,
SchoolName TEXT not null);

Insert into Students (StudentId, FirstName, LastName, SchoolName)
Values (1, 'Tomek', 'Nowak', 'UMCS'),
(2, 'Jan', 'Kowalski', 'KUL'),
(3, 'Weronika', 'Maj', 'UM'),
(4, 'Albert', 'Nosaczowski', 'KUL'),
(5, 'Dawid', 'Kozak', 'UMCS'),
(6, 'Maria', 'Marecka', 'UMCS');

select *
from students;

Create table BookingDetails
(StudentId integer not null,
BookId integer not null,
Title text not null,
Author  text not null,
BookedFrom datetime not null,
BookedTo datetime);

Insert into BookingDetails (StudentId, BookId, Title, Author, BookedFrom, BookedTo)
values (2, 1, 'Harry', 'Rowling', '2020-01-03', '2020-03-01'),
(6, 2, 'Male kobietki', 'Gerwig', '2020-02-12', null),
(3, 3, 'Ptaki ciernistych krzewow', 'Collen', '2020-01-23', null),
(4, 4, 'Moje marzenia', 'Kowalewski', '2020-02-02', '2020-03-03'),
(4, 5, 'Urwisko', 'Piekarska', '2020-02-06', null),
(2, 6, 'Pieklo', 'Piatek', '2020-01-08', null);

select *
from BookingDetails;


select * from BookingDetails
delete from BookingDetails
where 1=1

--39. Select Firstname, Lastname of students, who didn't get back books.

select Students.FirstName, Students.LastName
from Students
join BookingDetails on Students.StudentId = BookingDetails.StudentId
where BookingDetails.BookedTo is null;

--40.Choose students from UMCS, who didn't get back books.

select students.FirstName, Students.LastName
from Students
join BookingDetails on Students.StudentId = BookingDetails.StudentId
where BookingDetails.BookedTo is null and Students.SchoolName = 'UMCS';
                                            
--41. Sum of total, which is highest than avarage of all invoices.

Select sum(total)
from Invoice 
where total > (select avg(total) from invoice);

--42.Avarage amount of albums of artist who publiced more than 2 albums.

Select avg(how_many)
from (select count(*) as how_many
		from Album 
		group by ArtistId 
		HAVING how_many >2);
	
--43. Rows which contains customerid, total above avarage of invoices. This difference should be > 0
select i1.customerid, 
(i1.total - ( Select avg(i2.total)
			from invoice as i2 
			where i1.customerid = i2.customerid)) as above_avarage
from invoice as i1
where above_avarage > 0;

