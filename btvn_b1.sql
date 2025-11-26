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
    full_ame varchar(50),
    department_id int,
    position_id int,
    foreign key (position_id) references `position`(position_id),
    foreign key (department_id) references department(department_id),
	create_date datetime
);
create table if not exists `group` (
	group_id int auto_increment primary key,
    group_name varchar(30),
    creator_id int,
    foreign key (creator_id) references account (account_id),
    create_date datetime
);

create table if not exists group_account (
	group_id int,
    foreign key (group_id) references `group` (group_id),
    account_id int,
    foreign key (account_id) references account(account_id),
    join_date datetime
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
    foreign key (category_id) references category_question(category_id),
    type_id int,
    foreign key (type_id) references type_question(type_id),
    creator_id int,
    foreign key (creator_id) references account(account_id),
    create_date datetime
);

create table if not exists exam (
	exam_id int auto_increment primary key,
    code varchar(20),
    title varchar(100),
    category_id int,
    foreign key (category_id) references category_question(category_id),
    duration timestamp,
    creator_id int ,
    foreign key (creator_id) references account(account_id),
    create_date datetime
);

create table if not exists exam_question(
	exam_id int,
    foreign key (exam_id) references exam(exam_id),
    question_id int,
    foreign key (question_id) references question(question_id)
)




