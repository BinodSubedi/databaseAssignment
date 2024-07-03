-- Book-table:

create table book (book_id serial primary key,title varchar(18) unique not null, author varchar(20) not null, genre varchar(18) not null, publisher_id int,
 publication_year date default current_date, foreign key (publisher_id) references publisher(publisher_id));

-- Author-table:

create table author (author_id serial primary key, author_name varchar(20),
 birth_date date not null default current_date, nationality varchar(18) default 'unknown');


-- Publisher-table:

create table publisher (publisher_id serial primary key,
 publisher_name varchar(20) unique not null, country varchar(20) default 'unknown');


-- Customer-table:

create table customer (customer_id serial primary key, customer_name varchar(20),
 email varchar(30) default 'unknown', address varchar(25) default 'unknown');


-- Order-table:

create table "order"(order_id serial primary key, order_date date default current_date,
 customer_id int, total_amount int not null, foreign key (customer_id) references customer(customer_id));



--  Book_Author join table:

create table book_author (book_id int, author_id int,
 foreign key (book_id) references book(book_id), foreign key (author_id) references author(author_id));


-- Book_Order join table:

create table book_order (book_id int, order_id int,
 foreign key (book_id) references book(book_id), foreign key (order_id) references "order"(order_id));


-- Questions::

-- 1.)

select * from students where student_id in (select student_id from enrollments where
 course_id=(select course_id from courses where course_name='Math'));


--  2.)

select * from courses where course_id in (select course_id from enrollments where student_id=
(select student_id from students where student_name='Bob'));


-- 3.)

select * from students where student_id in (select student_id from (select student_id, count(course_id)
 from enrollments group by student_id) e where e.count > 1);


-- 4.)

select * from students where student_grade_id= (select grade_id from grades where grade_name='A');


-- 5.)

select s.course_id, s.student_number, c.course_name from (select * from (select count(student_id) as student_number, course_id from enrollments group by course_id)) s 
inner join courses c on s.course_id = c.course_id order by s.student_number asc;

-- Sub-query only:

select course_id, student_number, (select course_name from courses where courses.course_id = enrollments.course_id) as course_name from (select course_id, count(student_id) as 
student_number from enrollments group by course_id) as enrollments order by student_number asc;


-- 6.)


select e.enrolled_count, e.course_id, c.course_name from (select count(course_id) enrolled_count, course_id from enrollments group by course_id) e 
inner join courses c on e.course_id = c.course_id order by e.enrolled_count desc limit 1;

-- Sub-query only:

select course_id, enrolled_count, (select course_name from courses where courses.course_id = enrollments.course_id) as course_name from (select count(course_id) as enrolled_count, course_id from enrollments 
group by course_id) as enrollments order by enrolled_count desc limit 1;


-- 7.)

select * from students where student_id in (select  student_id from enrollments group by student_id having 
count(course_id) = (select count(course_id) from courses));


-- 8.)

select * from students where not student_id in (select  student_id from enrollments group by student_id having count(course_id) 
between 1 and (select count(course_id) from courses));


-- 9.)

select avg(student_age) from students where student_id in (select student_id from enrollments where 
course_id= (select course_id from courses where course_name='Science' ) );


-- 10.)

select * from (select * from students s inner join grades g on s.student_grade_id= g.grade_id) where student_id in (select student_id from 
enrollments where course_id = (select course_id from cour
ses where course_name='History'));


-- Sub-query only:

select * from students where student_id in ( select student_id from enrollments where course_id = (select course_id from courses 
where course_name = 'History')) and student_grade_id in (select grade_id from grades);











