路线图
    基础：
        第 1 章：
            将学习第一种实用的算法 --> 二分查找
            还将学习使用 大O表示法 分析算法的速度
        第 2 章：
            学习两种基本的数据结构 --> 数组和链表
                它们贯穿全文并还将被用来创建更高级的数据结构 --> 散列表（第 5 章）
        第 3 章：
            学习递归，一种被众多算法（如第 4 章的快速排序）采用的实用技巧

    介绍应用广泛的算法（余下章节）
        问题解决技巧：
            遇到问题，如果不确定该如何高效地解决，可以尝试 --> 分而治之（第 4 章）或 动态规划（第 9 章）
            如果认识到根本就没有高效的解决方案，可转而使用贪婪算法（第 8 章）来得到近似答案

        散列表（第 5 章）：
            散列表是一种很有用的数据结构，由键值对组成，如 人名和电子邮箱地址 或 用户名和密码
                散列表的用途非常的大，每当我需要解决问题时，首先想到的两种方法是：
                    可以使用散列表吗？
                    可以使用图来建立模型吗？

        图算法（第 6、7 章）：
            图是一种模拟网络的方法，这种网络包括人际关系网、公路网、神经元网络或者任何一组连接。
            广度优先搜索（第 6 章）和狄克斯特拉算法（第 7 章）计算网络中两点之间的最短距离，可用来计算两人之间的分隔度或前往目的地的最短路径

        K最近邻算法（KNN）（第 10 章）：
            这是一种简单的机器学习算法，可用于创建推荐系统、OCR引擎、预测股价或其他值（如“我们认为Adit会给这部电影打4星”）的系统，以及对物件进行分类（如“这个字母是 Q”）

        适合你进一步学习的 10 种算法（第 11 章）：


第 1 章（算法简介）：
    1、算法 是一组完成任务的指令。任何代码片段都可视为算法。
        性能：
            明白使用的算法的优缺点

    2、对数：
        log 不写底数时默认的底数可能是 2、e 或 10。具体情况要以文章明确给出的记号表或案例说明为准。
        通常情况下，数学计算中都是 10，计算机学科是 2，编程语言里面是 e。

    3、简单查找：
        运行时间：
            O(n)
        代码示例：
            def simple_search(list, item):
                for index in range(len(list)):
                    if list[index] == item:
                        return index
                else:
                    return None

    4、二分查找：
        条件：一个有序的元素列表
            每次排除一半的单词，直至最后只剩下一个单词或者返回 None
        运行时间：
            O(log n)
        代码示例：
            def binary_search(list, item):
                low = 0
                high = len(list) - 1

                while low <= high:
                    mid = (low + high) // 2
                    guess = list[mid]

                    if guess == item:
                        return mid
                    if guess > item:
                        high = mid - 1
                    else:
                        low = mid + 1

                return None

    5、运行时间
        每次介绍算法，都要讨论其运行时间。一般而言，应该选择效率最高的算法，以最大限度地减少运行时间或占用空间。
            线性时间
                最多需要猜测的次数与列表长度相同 --> O(n)
            对数时间
                二分查找的运行时间为对数时间（或 log时间） --> O(log n)

    6、大 O 表示法
        大 O 表示法是一种特殊的表示法，指出了算法的速度有多快。
        1、算法的运行时间以不同的速度增加
            仅知道算法需要多长时间才能运行完毕还不够，还需要知道运行时间如何随列表增长而增加。这正是 大O表示法 的用武之地。
            大 O 表示法指的并非以秒为单位的速度。大 O 表示法让你能够比较操作数，它指出了算法运行时间的增速。
        2、大 O 表示法指出了最糟糕情况下的运行时间

        常见的 大 O 运行时间
            O( 1 )              常量时间
            O(log n)            对数时间：包括：二分查找
            O(n)                线性时间：包括：简单查找
            O(n * log n)        包括：快速排序
            O(n ^ 2)            包括：选择排序
            O(n!)

    7、小结：
        二分查找的速度比简单查找快得多
        O(log n) 比 O(n) 快，当需要搜索的元素越多时，前者比后者快得越多
        算法的运行时间并不以秒为单位，算法运行时间是从其增速的角度度量的
        算法的运行时间用 大 O 表示法 表示
        算法的速度指的并非时间，而是操作数的增速
        讨论算法的速度是，我们说的是随着输入的增加，其运行时间将以什么样的速度增加


第 2 章（选择排序）：
    1、内存的工作原理：
        需要将数据存储到内存时，你请求计算机提供存储空间，计算机给你一个存储地址（内存地址）。
        存储多项数据的两种基本方式（两种最基本的数据结构）
            数组
                优点：读取元素时，可以随机直接读取某一个元素（跳跃读取）
                缺点：没有足够的连续的空闲存储空间时，则不能存储；如果预留位置，那么可能会浪费内存 或 超出时又要移动
                支持随机访问和顺序访问
            链表
                优势：随机插入元素（存入内存，将其内存地址存储到前一个元素中）
                缺点：读取元素时，需要先读取前面的元素再一个个递进到需要的元素
                只支持顺序访问

    2、学习一种排序算法：
        很多算法仅在数据经过排序之后才管用，如：
            二分查找

        选择排序：
            从小到大的顺序排列：
                遍历整个列表，将最大值添加到一个新的列表中
                再次按照这种方法，找出第二大的数值
                依次这样查找，直到列表的所有值都添加到了新的列表中
            运行时间：
                O( n * n ) = O( n^2 )
            代码示例：
                def findSmallest(arr):
                    smallest = arr[0]
                    smallest_index = 0

                    for i in range(1, len(arr)):
                        if arr[i] < smallest:
                            smallest = arr[i]
                            smallest_index = i

                    return smallest_index

                def selectionSort(arr):
                    newArr = []
                    for i in range(len(arr)):
                        smallest = findSmallest(arr)
                        newArr.append(arr.pop(smallest))

                    return newArr

    3、小结：
        计算机内存犹如一大堆抽屉
        需要存储多个元素时，可使用数组或链表
        数组的元素都在一起
        链表的元素时分开的，其中每个元素都存储了下一个元素的地址
        数组的读取速度很快
        链表的插入和删除速度很快
        在同一个数组中，所有元素的类型都必须相同（都为 int、double 等），这样才能比较大小
