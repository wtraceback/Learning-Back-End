175. 组合两个表
    select p.FirstName, p.LastName, a.City, a.State
    from Person as p
    left join Address as a
    on p.PersonId=a.PersonId


176. 第二高的薪水
    解法一：select (select distinct Salary from Employee order by Salary desc limit 1, 1) as SecondHighestSalary
    解法二：select IFNULL((select distinct Salary from Employee order by Salary desc limit 1, 1), NULL) as SecondHighestSalary
    解法三：select (select MAX(Salary) FROM Employee where Salary < (select MAX(Salary) from Employee)) as SecondHighestSalary


177. 第N高的薪水
    CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
    BEGIN
        SET N := N-1;
        RETURN (
        select IFNULL((select distinct e.Salary
                        from Employee as e
                        order by e.Salary desc
                        limit 1 offset N
                        ), NULL)
        );
    END

    解法二：
    CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
    BEGIN
      RETURN (
        select IF(s.num < N, NULL, s.min_salary)
        from (select count(*) as num, MIN(e.Salary) as min_salary
                from (select distinct Salary
                        from Employee order by Salary desc limit N) as e) as s
        );
    END


178. 分数排名
    select so.Score, CONVERT(so.r,SIGNED) as 'Rank'
    from (select s.Score,
    @i:=(case when s.Score=@s_score then @i else @i+1 end) as r,
    @s_score:=s.Score
    from (select Score from Scores order by Score desc) as s, (select @i:=0,@s_score:=-1) as m) as so


    解法二：
    SELECT Score, (SELECT count(DISTINCT score) FROM Scores WHERE score >= s.score) AS Rank
    FROM Scores as s
    ORDER BY Score DESC;

    解法三：
    select Score, DENSE_RANK() over (order by Score desc) as 'Rank'
    from Scores

    解法四：
    select Score, @rank := @rank + if(@prev=(@prev:=Score),0,1) as Rank
    from Scores, (select @rank:=0, @prev:=-1) t
    order by Score desc


180. 连续出现的数字
    select distinct a.Num as ConsecutiveNums
    from Logs as a, Logs as b, Logs as c
    where
        a.id=b.id-1
        and b.id=c.id-1
        and a.Num=b.Num
        and a.Num=c.Num;


181. 超过经理收入的员工
    select e.Name as Employee
    from Employee as e, Employee as m
    where e.ManagerId=m.Id and e.Salary>m.Salary;


182. 查找重复的电子邮箱
    select Email from Person
    group by Email
    having count(Id) >= 2;


183. 从不订购的客户
    select Name as Customers
    from Customers
    where Id not in (select distinct CustomerId from Orders);


184. 部门工资最高的员工
    select c.Department, e.Name as Employee, e.Salary
    from Employee as e, (select d.Name as Department, m.DepartmentId, MAX(m.Salary) as max_Salary
                            from Employee as m
                            inner join Department as d on d.Id=m.DepartmentId
                            group by m.DepartmentId) as c
    where e.DepartmentId=c.DepartmentId and e.Salary=c.max_Salary

    解法二：
    SELECT d.name as Department, e.name as Employee, e.Salary
    FROM Employee as e
    JOIN Department as d ON e.DepartmentId = d.Id
    WHERE (e.DepartmentId , e.Salary) IN
        (SELECT DepartmentId, MAX(Salary) FROM Employee GROUP BY DepartmentId);


185. 部门工资前三高的所有员工
    select d.Name as Department, e.Name as Employee, e.Salary
    from Employee as e
    join Department as d on d.Id=e.DepartmentId
    where (select count(distinct m.Salary) from Employee as m where e.DepartmentId =m.DepartmentId  and m.Salary > e.Salary) < 3
    order by Department, e.Salary desc;


196. 删除重复的电子邮箱
    delete p from Person as p, (select MIN(e.Id) as Id, e.Email from Person as e group by e.Email) as m
    where p.Id<>m.Id and p.Email=m.Email;

    解法二：
    DELETE p1 FROM Person p1, Person p2
    WHERE p1.Email = p2.Email AND p1.Id > p2.Id


197. 上升的温度
    select b.Id from Weather as a, Weather as b
    where DATE_ADD(a.RecordDate, interval 1 DAY)=b.RecordDate and a.Temperature<b.Temperature;

    解法二：
    SELECT weather.id AS 'Id'
    FROM weather
    JOIN weather w ON DATEDIFF(weather.date, w.date) = 1 AND weather.Temperature > w.Temperature;


595. 大的国家
    select name, population, area
    from World
    where area>3000000 or population>25000000;


596. 超过5名学生的课
    select class
    from courses
    group by class
    having count(distinct student) >= 5;


620. 有趣的电影
    select *
    from cinema
    where description <> 'boring' and if(id mod 2 = 1, true, false)
    order by rating desc;

    解法二：
    select *
    from cinema
    where description <> 'boring' and MOD(id, 2) = 1
    order by rating desc;


627. 交换工资（交换性别）
    update salary
    set sex = (case sex
            when 'm' then 'f'
            when 'f' then 'm'
            end)

    解法二：
    UPDATE salary
    SET sex = CASE sex
        WHEN 'm' THEN 'f'
        ELSE 'm'
    END;


1179. 重新格式化部门表
    select id,
    MAX(case when month='Jan' then revenue else NULL end) as Jan_Revenue,
    MAX(case when month='Feb' then revenue else NULL end) as Feb_Revenue,
    MAX(case when month='Mar' then revenue else NULL end) as Mar_Revenue,
    MAX(case when month='Apr' then revenue else NULL end) as Apr_Revenue,
    MAX(case when month='May' then revenue else NULL end) as May_Revenue,
    MAX(case when month='Jun' then revenue else NULL end) as Jun_Revenue,
    MAX(case when month='Jul' then revenue else NULL end) as Jul_Revenue,
    MAX(case when month='Aug' then revenue else NULL end) as Aug_Revenue,
    MAX(case when month='Sep' then revenue else NULL end) as Sep_Revenue,
    MAX(case when month='Oct' then revenue else NULL end) as Oct_Revenue,
    MAX(case when month='Nov' then revenue else NULL end) as Nov_Revenue,
    MAX(case when month='Dec' then revenue else NULL end) as Dec_Revenue
    from Department
    group by id
