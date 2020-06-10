1、SELECT 语句中使用时必须遵循的顺序

    子句          说明                      是否必须使用
    -----------------------------------------------------
    SELECT      要返回的列或表达式           是
    FROM        从中检索数据的表             仅在从表选择数据时使用
    WHERE       行级过滤                    否
    GROUP BY    分组说明                    仅在按组计算聚集时使用
    HAVING      组级过滤                    否
    ORDER BY    输出排序顺序                否


2、通配符的使用
    MySQL 中实现模糊查询有两种方式
    a、LIKE / NOT LIKE
    b、REGEXP / NOT REGEXP

    a、第一种是标准的 SQL 模式匹配，有两种通配符 "_" 和 "%"，如：
        select * from students where name like '李_';
        select * from students where name like '李%';

    b、第二种是使用扩展正则表达式的模式匹配，如：
        select * from students where name REGEXP '[a-e]';  -- 只要搜索的列中包含 a、b、c、d、e 中的任意字母都算匹配


3、测试计算
    SELECT 语句为测试、检验函数和计算提供了很好的方法。虽然 SELECT 通常用于从表中检索数据，但是省略了 FROM 子句后就是
    简单的访问和处理表达式。
    select 3 * 2;
    select Trim(' abc ');
    select Now();


4、时间相关的函数(https://www.w3school.com.cn/sql/sql_dates.asp)
    YEAR()          将时间参数传递进去，可以获得当前的年份 如：select YEAR( now() );  可以获取出当前的年份
    MONTH()         将时间参数传递进去，可以获得当前的月份
    WEEK()          该函数返回日期的星期数
    DAY()           将时间参数传递进去，可以获得当前的天数
    NOW()           可以获取当前的 年月日 时分秒
    EXTRACT()       用于返回日期/时间的单独部分，比如年、月、日、小时、分钟等等
        EXTRACT(unit FROM date)
    DATE_ADD()      增加日期，增加天数或月份
        DATE_ADD(NOW(), interval 1 MONTH)
        DATE_ADD(NOW(), interval 1 DAY)
    DATEDIFF()      返回两个日期之间的天数
        语法 DATEDIFF(date1, date2)
            SELECT DATEDIFF('2019-12-30','2019-12-29')      返回 1
            SELECT DATEDIFF('2019-12-29','2019-12-30')      返回 -1
    DATE_FORMAT()   获取指定格式的日期，能够把一个日期/时间转换成各种各样的字符串格式
        DATE_FORMAT(date, format)
        select date_format(now(), '%Y%m%d%H%i%s');                      -- 20200526203638
        select date_format('2020-05-26 20:36:38', '%Y%m%d%H%i%s');      -- 20200526203638


5、case when then else end
    case 具有两种格式:
    1、简单 case 函数
        case sex
            when '1' then '男'
            when '2' then '女'
            else '其他'
        end

    2、case 搜索函数
        case
            when sex = '1' then '男'
            when sex = '2' then '女'
            else '其他'
        end


6、字符串拼接
    CONCAT(string1, string2)
    group_concat


7、SQL 查询结果自己添加一列自增字段
    select 表名.*, @rank:=@rank+1 as r
    from 表名, (select @rank:=0) as 别名;


8、IFNULL 函数
    IFNULL() 函数用于判断第一个表达式是否为 NULL，如果为 NULL 则返回第二个参数的值，如果不为 NULL 则返回第一个参数的值。
    IFNULL(expression, alt_value)


9、取余
    select MOD(5, 2);        -- 1
    select 5 mod 2;          -- 1
    select 5 % 2;            -- 1


10、IF 函数
    IF(expr1, expr2, expr3)，如果 expr1 的值为 true，则返回 expr2 的值，如果 expr1 的值为 false，则返回expr3的值。


11、多个字段的 in 或者是 not in
    前面的字段彼此相关联，同时存在才算是真的在
    (a, b) in (select a, b from table)
    (a, b, c) in (select a, b, c from table)


12、delete 的新解法
    DELETE
        p1
    FROM
        Person p1, Person p2
    WHERE
        p1.Email = p2.Email AND p1.Id > p2.Id


13、mysql 中 limit 后面不能带运算符，只能是常量
    limit 里面不可以进行 加减乘除 运算


14、 mysql 中定义变量的两种方式：
    使用 set ，变量名以 @ 开头
        set @var=1;
    使用 declare
        declare var1 int default 0;
        set var1 = 10;


15、 日期类型可以使用 大于、小于 运算符直接进行比较运算
    select * from students where birth > '1990-01-01'


16、现在 MySQL 有函数支持排名
    dense_rank()：连续排序           -- 1 2 2 3
        DENSE_RANK() OVER (
            PARTITION BY <expression>[{,<expression>...}]
            ORDER BY <expression> [ASC|DESC], [{,<expression>...}]
        )

        首先，PARTITION BY子句将FROM子句生成的结果集划分为分区。DENSE_RANK()函数应用于每个分区。
        其次，ORDER BY  子句指定DENSE_RANK()函数操作的每个分区中的行顺序。

    rank()：跳跃排序                 -- 1 2 2 4
        RANK() OVER (
            PARTITION BY <expression>[{,<expression>...}]
            ORDER BY <expression> [ASC|DESC], [{,<expression>...}]
        )

        首先，PARTITION BY子句将结果集划分为分区。RANK()功能在分区内执行，并在跨越分区边界时重新初始化。
        其次，ORDER BY子句按一个或多个列或表达式对分区内的行进行排序。


17、:=和=的区别
    =
        只有在set和update时才是和:=一样，赋值的作用，其它都是等于的作用。
    :=
        不只在set和update时时赋值的作用，在select也是赋值的作用。

    为了避免多添加一个输出列，而用 @i=(@i:=2)。先获取 @i 的值替换 @i，然后再将 2 赋值给 @i，因此可以直接比较
        select if(@i=(@i:=2), 0, 1) from (select @i:=1) as a;


18、字符串转成数字
    使用函数
        CAST(value as type);
        CONVERT(value, type);
        type 类型： 浮点数 : DECIMAL  整数 : SIGNED  无符号整数 : UNSIGNED  日期 : DATE  时间: TIME  日期时间型 : DATETIME 等等。

            select * from scores order by CAST(course_id as SIGNED)  desc
            select * from scores order by CONVERT(course_id, SIGNED)  desc


19、SQL 日期类型可以使用大于、小于号直接进行比较运算
    select * from students where birth > '1990-01-01'
    select * from students where birth > CONVERT('1990-1-1', DATETIME);
    select * from students where birth > CAST('1990-1-1' as DATETIME);

20、MySQL 的 delete not in 操作
    正确：delete from tableA where id not in  (1, 2, 3);
    正确：delete from tableA where id not in (select id from tableB)

    错误：      delete from tableA where id not in (select MIN(id) from tableA group by email)
    解决办法：  delete from tableA where id not in (select * from (select MIN(id) from tableA group by email) as t)


21、使用 SQL 保留字做输出列名
    使用 SQL 的保留字作为输出列名，则会报错，但是你依旧想要使用该字符作为输出列名，则将其加上两个单引号括起来即可


22、group by 使用过程中的问题
    使用 GROUP BY 可以为每个元素创建一组结果行，仅允许针对多个值（例如SUM，AVG，MIN，MAX，COUNT）进行聚合操作。
    单独地使用 group by (不加聚合函数)，每次只能显示出每组记录的第一条记录。
    如果想要对其中该元素都某一属性进行筛选，则需要添加聚合函数（MAX 或 SUM）---单个元素属性的聚合函数 （单个元素属性的聚合函数 == 属性本身）
    因此但凡使用 group by，需要挑选值时，前面一定要有聚合函数（MAX /MIN / SUM /AVG / COUNT）
