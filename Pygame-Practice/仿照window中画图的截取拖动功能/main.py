import sys
import pygame


class Configuration():
    """配置相关的类"""

    def __init__(self):
        self.size = (600, 700)
        self.caption = 'Strip background image'
        self.bg_color = (230, 230, 230)


class Rectangle():
    """矩形相关的类"""

    def __init__(self, screen):
        self.screen = screen

        self.start = (0, 0)
        self.end = (0, 0)
        self.rect_size = (0, 0)

        self.drawing = False
        self.rect_color = (255, 0, 0)
        self.border_width = 1

    def draw_rect(self):
        pygame.draw.rect(self.screen, self.rect_color, (self.start, self.rect_size), self.border_width)


def event_loop(flex_rect, can_draw):
    for event in pygame.event.get():
        # 关闭游戏窗口
        if event.type == pygame.QUIT:
            sys.exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if can_draw:
                # 确定矩形的起点
                flex_rect.start = event.pos
                flex_rect.rect_size = 0, 0
                flex_rect.drawing = True
        elif event.type == pygame.MOUSEBUTTONUP:
            if can_draw:
                # 确定矩形的尺寸大小
                flex_rect.end = event.pos
                flex_rect.rect_size = flex_rect.end[0] - flex_rect.start[0], flex_rect.end[1] - flex_rect.start[1]
                flex_rect.drawing = False
        elif event.type == pygame.MOUSEMOTION:
            if can_draw and flex_rect.drawing:
                # 不断变化中的矩形形状
                flex_rect.end = event.pos
                flex_rect.rect_size = flex_rect.end[0] - flex_rect.start[0], flex_rect.end[1] - flex_rect.start[1]


def main():
    # 游戏配置项
    configs = Configuration()

    # 游戏的初始化、游戏窗口的设置、游戏窗口标题的设置
    pygame.init()
    screen = pygame.display.set_mode(configs.size)
    pygame.display.set_caption(configs.caption)

    # 画矩形的类
    flex_rect = Rectangle(screen)

    # 要截取的图片
    img = pygame.image.load('images/piqiu.bmp')
    rect = img.get_rect()

    can_draw = True

    while True:
        event_loop(flex_rect, can_draw)

        screen.fill(configs.bg_color)
        screen.blit(img, rect)

        # 画矩形框
        flex_rect.draw_rect()

        pygame.display.update()


if __name__ == '__main__':
    main()