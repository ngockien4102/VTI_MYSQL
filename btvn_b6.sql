-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó.
delimiter //
create procedure get_info_dept_name(
	in dept_name nvarchar(30)
)
begin
	SELECT 
    a.*
FROM
    account a
        INNER JOIN
    group_account ga ON a.account_id = ga.account_id
        INNER JOIN
    `group` g ON g.group_id = ga.group_id
WHERE
    g.group_name = dept_name; 
end  //
call get_info_dept_name('group_all');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group.
delimiter //
create procedure get_num_dept_by_acc()
begin
SELECT DISTINCT
    a.user_name, COUNT(ga.group_id)
FROM
    account a
        LEFT JOIN
    group_account ga ON a.account_id = ga.account_id
GROUP BY a.account_id;

end  //
call get_num_dept_by_acc();

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại.
delimiter //
create procedure get_num_type_question()
begin
SELECT 
    tq.type_name, COUNT(q.question_id)
FROM
    question q
        LEFT JOIN
    type_question tq ON q.type_id = tq.type_id
GROUP BY q.type_id;
end  //
call get_num_type_question();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất.
delimiter //
create procedure get_max_type_question()
begin
SELECT 
    q.type_id
FROM
    question q
        LEFT JOIN
    type_question tq ON q.type_id = tq.type_id
GROUP BY q.type_id
HAVING COUNT(q.question_id) = (SELECT 
        MAX(cq)
    FROM
        (SELECT 
            tq.type_name, COUNT(q.question_id) cq
        FROM
            question q
        LEFT JOIN type_question tq ON q.type_id = tq.type_id
        GROUP BY q.type_id) t);
end  //
call get_max_type_question();

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question.
delimiter //
create procedure get_name_max_type_question()
begin
SELECT 
    tq.type_name
FROM
    question q
        LEFT JOIN
    type_question tq ON q.type_id = tq.type_id
GROUP BY q.type_id
HAVING COUNT(q.question_id) = (SELECT 
        MAX(cq)
    FROM
        (SELECT 
            tq.type_name, COUNT(q.question_id) cq
        FROM
            question q
        LEFT JOIN type_question tq ON q.type_id = tq.type_id
        GROUP BY q.type_id) t);
end  //
call get_name_max_type_question();

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào.
delimiter //
create procedure get_group_name( in search nvarchar(20))
begin
select * from `group` where group_name like concat('%', search ,'%');
end  //
call get_group_name('a');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
-- delimiter //
-- create procedure get_group_name( in full_name nvarchar(50),in email varchar(50))
-- begin
-- insert into account(email, user_name, full_name, department_id, position_id, create_date)
-- values(email, );
-- end  //
-- call get_group_name('a');


-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
delimiter //
create procedure get_by_length( in type_name varchar(15))
begin
SELECT 
    MAX(char_num)
FROM
    (SELECT 
        q.question_id, COUNT(LENGTH(q.content)) char_num
    FROM
        question q
    LEFT JOIN type_question tq ON q.type_id = tq.type_id
    GROUP BY q.question_id) t
HAVING tq.type_name = type_name; 
end  //
call get_by_length('Multiple-Choice');


-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
delimiter //
create procedure delete_exam( in id int)
begin
delete from exam where exam_id = id;
end  //
call delete_exam(1);

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
-- dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi
-- removing
delimiter //
create procedure delete_exam_last_3year()
begin
declare ids varchar()
select 
delete from exam where exam_id = id;
end  //
call delete_exam_last_3year();

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được
-- chuyển về phòng ban default là phòng ban chờ việc
-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
with t as (select 1 as month_num from dual
		union
        select 2 from dual
		union
        select 3 from dual
		union
        select 4 from dual
		union
        select 5 from dual
		union
        select 6 from dual
		union
        select 7 from dual
		union
        select 8 from dual
		union
        select 9 from dual
		union
        select 10 from dual
		union
        select 11 from dual
		union
        select 12 from dual
)
select t.month_num, count(q.question_id) from t left join question q on t.month_num = month(q.create_date) group by t.month_num;

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")

