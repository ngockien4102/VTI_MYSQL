drop database testing_system;
create database if not exists testing_system;
use testing_system;
create table if not exists department
(
	department_id int auto_increment primary key,
    department_name varchar(30)
);

create table if not exists `position`
(
	position_id int auto_increment primary key,
    position_name enum('Dev','Test', 'Scrum Master','PM')
);

create table if not exists account
(
	account_id int auto_increment primary key,
    email varchar(50),
    user_name varchar(50),
    full_name varchar(50),
    department_id int,
    position_id int,
	create_date datetime,
    foreign key (position_id) references `position`(position_id),
    foreign key (department_id) references department(department_id)
);
create table if not exists `group` (
	group_id int auto_increment primary key,
    group_name varchar(30),
    creator_id int,
    create_date datetime,
    foreign key (creator_id) references account (account_id)
);

create table if not exists group_account (
	group_id int,
    account_id int,
    join_date datetime,
    foreign key (group_id) references `group` (group_id),
    foreign key (account_id) references account(account_id)
);

create table if not exists type_question(
	type_id int auto_increment primary key,
    type_name enum('Essay', 'Multiple-Choice')
);

create table if not exists category_question(
	category_id int auto_increment primary key,
    category_name varchar(20)
);

create table if not exists question(
	question_id int auto_increment primary key,
    content text,
    category_id int,
    type_id int,
    creator_id int,
    create_date datetime,
    foreign key (category_id) references category_question(category_id),
    foreign key (type_id) references type_question(type_id),
    foreign key (creator_id) references account(account_id)
);

create table if not exists exam (
	exam_id int auto_increment primary key,
    code varchar(20),
    title varchar(100),
    category_id int,
    duration int,
    creator_id int ,
    create_date datetime,
    foreign key (category_id) references category_question(category_id),
    foreign key (creator_id) references account(account_id)
);

create table if not exists exam_question(
	exam_id int,
    question_id int,
    foreign key (question_id) references question(question_id),
    foreign key (exam_id) references exam(exam_id)
);

 create table if not exists answer(
	answer_id int auto_increment primary key,
    content text,
    question_id int,
    is_correct boolean,
    foreign key (question_id) references question(question_id)
 );
 
 insert into position (position_id, position_name)
 values (1, 'Dev'),(2, 'Test'),(3, 'Scrum Master'),(4, 'PM');

insert into department (department_id, department_name)
values (1,'phan mem 1'),(2,'phan mem 2'),(3,'phan mem 3'),(4,'phan mem 4'),(5,'phan mem 5');

insert into account (account_id, email, user_name, full_name, department_id, position_id, create_date)
values (1, 'mail1@gmail.com', 'acc1', 'nguyen van a', 1, 1, '2025-11-27 08:14:50'),
 (2, 'mail2@gmail.com', 'acc2', 'nguyen van b', 2, 2, '2023-01-27 10:14:50'),
 (3, 'mail3@gmail.com', 'acc3', 'nguyen van c', 3, 3, '2022-03-10 15:19:00'),
 (4, 'mail4@gmail.com', 'acc4', 'nguyen van d', 4, 4, '2021-09-11 13:14:15'),
 (5, 'mail5@gmail.com', 'acc5', 'nguyen van e', 2, 4, '2022-10-04 09:14:40');
 
 insert into `group` (group_id, group_name, creator_id, create_date)
 values (1, 'group_dev', 1, '2025-11-27 08:14:50'),
		(2, 'group_test', 2, '2023-01-27 10:14:50'),
        (3, 'group_scrum_master', 3, '2022-03-10 15:19:00'),
        (4, 'group_pm', 4, '2021-09-11 13:14:15'),
        (5, 'group_all', 4, '2022-10-04 09:14:40');
        
insert into group_account (group_id, account_id, join_date)
values (5, 1, '2025-11-27 08:14:50'),
	   (5, 2, '2025-11-27 08:14:50'),
       (5, 3, '2025-11-27 08:14:50'),
       (5, 4, '2025-11-27 08:14:50'),
       (5, 5, '2025-11-27 08:14:50');
       
insert into type_question (type_id,type_name)
values (1, 'Essay'),
	   (2, 'Multiple-Choice');
       
insert into category_question(category_id, category_name)
values (1, 'easy'),
(2, 'medium 1'),
(3, 'medium 2'),
(4, 'hard'),
(5, 'very hard');

insert into exam(exam_id, `code`, title, category_id, duration, creator_id, create_date)
values (1, 'D01', 'test dev', 1, 60, 5, '2025-11-27 08:14:50'),
(2, 'D02', 'test dev', 2, 30, 5, '2025-11-27 08:14:50'),
(3, 'D03', 'test dev', 3, 15, 4, '2025-11-27 08:14:50'),
(4, 'D04', 'test Scrum Master', 4, 10, 5, '2025-11-27 08:14:50'),
(5, 'D05', 'test Scrum Master', 5, 20, 4, '2025-11-27 08:14:50');

insert into question (question_id, content, category_id, type_id, creator_id, create_date)
values (1, 'what', 1, 1, 4, '2020-11-27 08:14:50'),
(2, 'why', 2, 2, 5, '2020-11-27 08:14:50'),
(3, 'how', 3, 1, 4, '2020-11-27 08:14:50'),
(4, 'who', 4, 2, 5, '2020-11-27 08:14:50'),
(5, 'when', 5, 1, 4, '2020-11-27 08:14:50');

insert into exam_question(exam_id, question_id)
values (1,2),(2,3),(3,4),(4,5),(5,1);

insert into answer(answer_id, content, question_id, is_correct)
values (1, 'aaa', 1, false),
(2, 'aaaa', 1, true),
(3, 'bbb', 2, true),
(4, 'bbbb', 2, false),
(5, 'ccc', 3, false),
(6, 'cccc', 3, true),
(7, 'ddd', 4, true),
(8, 'dddd', 4, false),
(9, 'eee', 5, false),
(10, 'eeee', 5, true);




       

        

 



