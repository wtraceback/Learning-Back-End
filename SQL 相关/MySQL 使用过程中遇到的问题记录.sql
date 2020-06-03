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
