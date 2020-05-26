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


4、时间相关的函数
    YEAR()          将时间参数传递进去，可以获得当前的年份 如：select YEAR( now() );  可以获取出当前的年份
    MONTH()         将时间参数传递进去，可以获得当前的月份
    DAY()           将时间参数传递进去，可以获得当前的天数
    NOW()           可以获取当前的 年月日 时分秒

    date_format(date, format)            能够把一个日期/时间转换成各种各样的字符串格式
        select date_format(now(), '%Y%m%d%H%i%s');                      -- 20200526203638
        select date_format('2020-05-26 20:36:38', '%Y%m%d%H%i%s');      -- 20200526203638

    str_to_date(str, format)       能够把一个字符串转换成日期格式，也可以转换为时间
         select str_to_date('2020/05/26 20:43:30', '%Y/%m/%d %H:%i:%s');     -- 2020-05-26 02:43:30
