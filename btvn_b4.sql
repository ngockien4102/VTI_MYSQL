-- 1. Join.
--        Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT 
    a.*, d.department_name
FROM
    account a
        INNER JOIN
    department d ON a.department_id = d.department_id;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT 
    *
FROM
    account
WHERE
    create_date > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT 
    *
FROM
    account a
        INNER JOIN
    position p ON a.position_id = p.position_id
WHERE
    p.position_name = 'dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
# cach 1
SELECT 
    d.department_name
FROM
    department d
        INNER JOIN
    account a ON d.department_id = a.department_id
GROUP BY d.department_name
HAVING COUNT(a.account_id) > 3;

# cach 2
SELECT 
    *
FROM
    department d
WHERE
    (SELECT 
            COUNT(*)
        FROM
            account a
        WHERE
            a.department_id = d.department_id) > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT 
    e.question_id, q.content
FROM
    exam_question e
        JOIN
    question q ON e.question_id = q.question_id
GROUP BY e.question_id
HAVING COUNT(e.exam_id) = (SELECT 
        MAX(ce)
    FROM
        (SELECT 
            COUNT(exam_id) ce
        FROM
            exam_question
        GROUP BY question_id) eq);

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT 
    c.category_name, COUNT(question_id)
FROM
    category_question c
        JOIN
    question q ON c.category_id = q.category_id
GROUP BY c.category_id;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT 
    content, COUNT(exam_id)
FROM
    question q
        JOIN
    exam_question e ON q.question_id = e.question_id
GROUP BY e.question_id;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT 
    q.content, COUNT(answer_id)
FROM
    question q
        JOIN
    answer a ON q.question_id = a.question_id
GROUP BY a.question_id;

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT 
    group_name, COUNT(account_id)
FROM
    `group` g
        inner JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY ga.group_id;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT 
    position_name
FROM
    position pn
        JOIN
    account ac ON pn.position_id = ac.position_id
GROUP BY pn.position_id
HAVING COUNT(account_id) = (SELECT 
        MIN(ca)
    FROM
        (SELECT 
            position_name, COUNT(a.account_id) ca
        FROM
            account a
        JOIN position p ON a.position_id = p.position_id
        GROUP BY p.position_id) t);

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT 
    d.department_name, p.position_name, COUNT(a.account_id)
FROM
    department d
        INNER JOIN
    account a ON d.department_id = a.department_id
        INNER JOIN
    position p ON p.position_id = a.position_id
GROUP BY a.department_id , a.position_id;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT 
    q.question_id,
    e.exam_id,
    q.content,
    tq.type_name,
    cq.category_name,
    a.full_name created_by,
    e.code,
    e.duration,
    e.title,
    asw.content answer_content,
    asw.is_correct
FROM
    question q
        JOIN
    type_question tq ON q.type_id = tq.type_id
        JOIN
    category_question cq ON q.category_id = cq.category_id
        JOIN
    account a ON a.account_id = q.question_id
        JOIN
    answer asw ON q.question_id = asw.question_id
        JOIN
    exam_question eq ON eq.question_id = q.question_id
        JOIN
    exam e ON e.exam_id = eq.exam_id
GROUP BY q.question_id , e.exam_id , asw.answer_id;

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 
    type_name, COUNT(q.question_id)
FROM
    type_question tq
        JOIN
    question q ON tq.type_id = q.type_id
GROUP BY tq.type_id;

-- Question 14:Lấy ra group không có account nào
# cach 1
SELECT 
    g.group_name, COUNT(ga.account_id)
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) > 0;

# cach 2
SELECT 
    *
FROM
    `group` g
WHERE
    g.group_id NOT IN (SELECT DISTINCT
            group_id
        FROM
            group_account);  

-- Question 15: Lấy ra group không có account nào
# trùng câu 14

-- Question 16: Lấy ra question không có answer nào.
SELECT 
    q.*
FROM
    question q
        LEFT JOIN
    answer a ON q.question_id = a.question_id
WHERE
    a.answer_id IS NULL;
    
    
-- 2. Union.
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT 
    a.*
FROM
    account a
        JOIN
    group_account ga ON a.account_id = ga.account_id
WHERE
    ga.group_id = 1 
UNION SELECT 
    a.*
FROM
    account a
        JOIN
    group_account ga ON a.account_id = ga.account_id
WHERE
    ga.group_id = 2;

-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
-- b) Lấy các group có nhỏ hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b).

SELECT 
    g.group_name, COUNT(ga.account_id)
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) >= 1 
UNION SELECT 
    g.group_name, COUNT(ga.account_id)
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) < 7;
