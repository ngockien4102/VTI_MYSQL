# cau 1
create view sale_department_info as (
	SELECT 
     a.*
FROM
    account a
        JOIN
    department d ON a.department_id = d.department_id
WHERE
    d.department_name = 'sale'
);

select * from sale_department_info;

# cau 2
create view account_join_group as (
		SELECT 
    a.user_name, COUNT(ga.group_id)
FROM
    group_account ga
        JOIN
    account a ON ga.account_id = a.account_id
GROUP BY a.account_id
HAVING COUNT(ga.group_id) = (SELECT 
        MAX(gi)
    FROM
        (SELECT 
            COUNT(ga.group_id) gi
        FROM
            group_account ga
        JOIN account a ON ga.account_id = a.account_id
        GROUP BY a.account_id) t)
);

select * from account_join_group;

# cau 3
create view content_length as (
	select * from question where char_length(content) > 300
);

select * from content_length;
drop view content_length;

#cau 4

CREATE VIEW department_many_people AS
    (SELECT 
        d.*
    FROM
        department d
            JOIN
        account a ON d.department_id = a.department_id
    GROUP BY d.department_id
    HAVING COUNT(a.account_id) = (SELECT 
            MAX(num)
        FROM
            (SELECT 
                COUNT(*) num
            FROM
                department d
            JOIN account a ON d.department_id = a.department_id
            GROUP BY d.department_id) t));

select * from department_many_people;

# cau 5
create view c5 as (
	select * from question q join account a on q.creator_id = a.account_id where a.full_name like 'nguyen%'
);
select * from c5;
