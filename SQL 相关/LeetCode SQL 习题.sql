175. 组合两个表
    select
        p.FirstName, p.LastName, a.City, a.State
    from
        Person as p
    left join Address as a
    on p.PersonId=a.PersonId


176. 第二高的薪水
    解法一：select (select distinct Salary from Employee order by Salary desc limit 1, 1) as SecondHighestSalary
    解法二：select IFNULL((select distinct Salary from Employee order by Salary desc limit 1, 1), NULL) as SecondHighestSalary
    解法三：select (select MAX(Salary) FROM Employee where Salary < (select MAX(Salary) from Employee)) as SecondHighestSalary


181. 超过经理收入的员工
    select
        e.Name as Employee
    from
        Employee as e, Employee as m
    where
        e.ManagerId=m.Id and e.Salary>m.Salary;


182. 查找重复的电子邮箱
    select
        Email
    from
        Person
    group by
        Email
    having
        count(Id) >= 2;


595. 大的国家
    select
        name, population, area
    from
        World
    where
        area>3000000 or population>25000000;


596. 超过5名学生的课
    select
        class
    from
        courses
    group by
        class
    having
        count(distinct student) >= 5;


197. 上升的温度
    select
        b.Id
    from
        Weather as a, Weather as b
    where
        DATE_ADD(a.RecordDate, interval 1 DAY)=b.RecordDate and a.Temperature<b.Temperature;
