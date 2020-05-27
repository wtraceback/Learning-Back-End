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

    增加日期
        DATE_ADD(date, INTERVAL expr type)
            DATE_ADD(NOW(), interval 1 MONTH)
            DATE_ADD(NOW(), interval 1 DAY)
    提取日期
        EXTRACT(unit FROM date);
    获取指定格式的日期
        date_format(date, format)            能够把一个日期/时间转换成各种各样的字符串格式
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
