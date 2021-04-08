import requests
from pyquery import PyQuery as pq
import os


class Model(object):
    """
    基类，用于显示实例的信息
    """
    def __repr__(self):
        name = self.__class__.__name__
        # 使用生成器，在使用的时候才将值计算出来，避免使用列表占用大的空间
        properties = ('{}=({})'.format(k, v) for k, v in self.__dict__.items())
        s = '\n<{} \n  {}>'.format(name, '\n  '.join(properties))
        return s


class Movie(Model):
    """
    存储电影信息的类
    """
    def __init__(self):
        self.name = ''
        self.ranking = 0
        self.score = 0
        self.quote = ''
        self.posters_url = ''


def movie_from_element(element):
    """
    从 class="item" 元素中获取一个电影的所有信息
    第 8 页的 寄生虫，没有引用语，选择器查找不到会返回 ""
    """
    d = pq(element)

    m = Movie()
    m.name = d('.title').text()
    m.ranking = d('.pic').find('em').text()
    m.score = d('.rating_num').text()
    m.quote = d('.inq').text()
    m.posters_url = d('.pic').find('img').attr('src')

    return m


def cached_url(url):
    """
    缓存，避免重复下载同一个网页浪费时间
    """
    folder = 'cached'
    filename = url.split('=', 1)[-1] + '.html'
    path = os.path.join(folder, filename)

    if os.path.exists(path):
        # 如果是之前下载过的网页，则直接从缓存中读取
        with open(path, 'rb') as f:
            s = f.read()
            return s
    else:
        # 如果是之前从未下载过的网页，直接下载并缓存
        # 如果 cached 文件夹不存在，则重新建立
        if not os.path.exists(folder):
            os.makedirs(folder)

        # 需要为 requests.get() 方法添加 headers，不然访问豆瓣电影top250会返回 418 响应
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
        }

        # 发送请求，并将抓取的结果写入文件
        r = requests.get(url, headers=headers)
        with open(path, 'wb') as f:
            f.write(r.content)

        return r.content


def movies_from_url(url):
    """
    从 url 中下载网页并解析出所有需要的信息
    """
    page = cached_url(url)
    d = pq(page)
    # 返回包含所有 class="item" 标签的列表
    items = d('.item')

    # 从每一个 item 中获取对应电影的所有信息
    movies = [movie_from_element(i) for i in items]
    return movies


def main():
    for i in range(0, 250, 25):
        url = 'https://movie.douban.com/top250?start={}'.format(i)
        movies = movies_from_url(url)
        print('douban top250 movies', movies)


if __name__ == '__main__':
    main()
