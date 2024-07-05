CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_major VARCHAR(100)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_description VARCHAR(255)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Students (student_id, student_name, student_major) VALUES
(1, 'Alice', 'Computer Science'),
(2, 'Bob', 'Biology'),
(3, 'Charlie', 'History'),
(4, 'Diana', 'Mathematics');

INSERT INTO Courses (course_id, course_name, course_description) VALUES
(101, 'Introduction to CS', 'Basics of Computer Science'),
(102, 'Biology Basics', 'Fundamentals of Biology'),
(103, 'World History', 'Historical events and cultures'),
(104, 'Calculus I', 'Introduction to Calculus'),
(105, 'Data Structures', 'Advanced topics in CS');


INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1, 1, 101, '2023-01-15'),
(2, 2, 102, '2023-01-20'),
(3, 3, 103, '2023-02-01'),
(4, 1, 105, '2023-02-05'),
(5, 4, 104, '2023-02-10'),
(6, 2, 101, '2023-02-12'),
(7, 3, 105, '2023-02-15'),
(8, 4, 101, '2023-02-20'),
(9, 1, 104, '2023-03-01'),
(10, 2, 104, '2023-03-05');

-- Inner Join

select j.student_name,j.student_major,c.course_name, c.course_description 
from (select s.student_name, s.student_major, e.course_id from
students s inner join enrollments e on s.student_id = e.student_id) j inner join courses c 
on j.course_id = c.course_id order by j.student_name asc;

-- Left Join

INSERT INTO Students (student_id, student_name, student_major) VALUES
(5, 'Ryan', 'Mathematics');

select j.student_name,j.student_major,c.course_name, c.course_description 
from (select s.student_name, s.student_major, e.course_id from
students s left join enrollments e on s.student_id = e.student_id) j left join courses c 
on j.course_id = c.course_id order by j.student_name asc;


-- Right Join

INSERT INTO Courses (course_id, course_name, course_description) VALUES
(106, 'Neuro Informatics', 'Advanced neuron data analysis');

select j.student_name,j.student_major,c.course_name, c.course_description 
from (select s.student_name, s.student_major, e.course_id from
students s left join enrollments e on s.student_id = e.student_id) j right join courses c 
on j.course_id = c.course_id order by j.student_name asc;


-- Self join

select jf.student_name, js.student_name, js.course_name, js.course_description from (
select j.student_name,j.student_major,c.course_name, c.course_description 
from (select s.student_name, s.student_major, e.course_id from
students s inner join enrollments e on s.student_id = e.student_id) j inner join courses c 
on j.course_id = c.course_id order by j.student_name asc
) jf join
(
select j.student_name,j.student_major,c.course_name, c.course_description 
from (select s.student_name, s.student_major, e.course_id from
students s inner join enrollments e on s.student_id = e.student_id) j inner join courses c 
on j.course_id = c.course_id order by j.student_name asc
) js on jf.course_name = js.course_name and jf.student_name != js.student_name;



-- Complex join


select * from students where not student_name in (
select j1.student_name from
(select s.student_name, c.course_name, e.enrollment_date
from enrollments e
join courses c on e.course_id = c.course_id
join students s on s.student_id = e.student_id) j1
join
(
select s.student_name, c.course_name, e.enrollment_date
from enrollments e
join courses c on e.course_id = c.course_id
join students s on s.student_id = e.student_id
)j2
on j1.student_name = j2.student_name
where (j1.course_name != j2.course_name and
((j1.course_name = 'Introduction to CS' and j2.course_name = 'Data Structures')
or
(j2.course_name = 'Introduction to CS' and j1.course_name = 'Data Structures'))));

-- Row number

select distinct s.student_id, s.student_name, e.enrollment_date, row_number() 
over(partition by s.student_name order by e.enrollment_date) 
from students s inner join
enrollments e on s.student_id = e.student_id order by s.student_name asc;

-- Rank

select s.student_name, s.student_id, e.enrollment_number,Rank() over(order by e.enrollment_number desc)
from students s
inner join (select student_id, count(student_id) as enrollment_number from enrollments 
group by student_id) e
on s.student_id = e.student_id order by enrollment_number desc;

-- Dense Rank

select c.course_id, c.course_name,e.enrollment_count, Dense_rank() over
(order by e.enrollment_count desc) from courses c inner join
(select count(course_id) as enrollment_count,
course_id from enrollments group by course_id) e
on c.course_id = e.course_id;

