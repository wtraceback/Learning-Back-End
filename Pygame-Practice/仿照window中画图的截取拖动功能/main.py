import sys
import pygame

class SubImage():
    """子截图相关的类"""

    def __init__(self, screen):
        self.screen = screen
        self.img = ''
        self.rect = (0, 0, 0, 0)

    def blit_img(self):
        self.screen.blit(self.img, self.rect)


class Rectangle():
    """矩形相关的类"""

    def __init__(self, screen):
        self.screen = screen

        self.start = (0, 0)
        self.end = (0, 0)
        self.size = (0, 0)

        self.drawing = False
        self.rect_color = (255, 0, 0)
        self.border_width = 1

    def draw_rect(self):
        pygame.draw.rect(self.screen, self.rect_color, (self.start, self.size), self.border_width)


class Configuration():
    """配置相关的类"""

    def __init__(self):
        self.size = (600, 700)
        self.caption = 'Strip background image'
        self.bg_color = (230, 230, 230)
        self.click_time = 0
        self.can_drag = False

        self.rects = []
        self.sub_images = []


def event_loop(screen, configs):
    for event in pygame.event.get():
        # 关闭游戏窗口
        if event.type == pygame.QUIT:
            sys.exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            print('down click_time = {}'.format(configs.click_time))
            if configs.click_time == 0:
                # 确定矩形的起点
                flex_rect = Rectangle(screen)
                flex_rect.start = event.pos
                flex_rect.size = 0, 0
                flex_rect.drawing = True
                configs.rects.append(flex_rect)

            elif configs.click_time == 1:
                print('1 click_time = {}'.format(configs.click_time))
                # 是否点击在矩形框范围内
                if (configs.sub_images[-1].rect.x < event.pos[0] and event.pos[0] < configs.sub_images[-1].rect.x + configs.sub_images[-1].rect.width) and (
                        configs.sub_images[-1].rect.y < event.pos[1] and event.pos[1] < configs.sub_images[-1].rect.height):
                    # 点在焦点范围内，可以拖动
                    configs.can_drag = True
                else:
                    # 不是点击在矩形框范围内，将所有配置项初始化
                    configs.click_time = 2
                    # 将原来的矩形框剔除
                    configs.rects.pop()

            # elif configs.click_time == 2:
            #     print('2 click_time = {}'.format(configs.click_time))
            #     configs.click_time = 0
            #     pass

        elif event.type == pygame.MOUSEBUTTONUP:
            print('up click_time = {}'.format(configs.click_time))

            if configs.click_time == 0:
                # 确定矩形的尺寸大小
                configs.rects[0].end = event.pos
                configs.rects[0].size = configs.rects[0].end[0] - configs.rects[0].start[0], configs.rects[0].end[1] - configs.rects[0].start[1]
                configs.rects[0].drawing = False

                # 现在屏蔽画矩形框，改为拖拽判断
                configs.click_time = 1

                # 获取裁剪的图片
                sub_img = SubImage(screen)
                sub_img.img = screen.subsurface(pygame.Rect(configs.rects[0].start, configs.rects[0].size)).copy()
                sub_img.rect = sub_img.img.get_rect()
                sub_img.rect.x = configs.rects[0].start[0]
                sub_img.rect.y = configs.rects[0].start[1]
                configs.sub_images.append(sub_img)

            elif configs.click_time == 1 and configs.can_drag:
                # 移动后，在其他位置松开左键,依然还可以再次拖动
                configs.can_drag = False

            # # elif configs.can_drag:
            # #     configs.can_drag = False
        elif event.type == pygame.MOUSEMOTION:
            # print('rects = {}'.format(configs.rects))
            # print('sub_imgs = {}'.format(configs.sub_images))
            if configs.click_time == 0 and configs.rects:
                if configs.rects[0].drawing:
                    # 不断变化中的矩形形状
                    configs.rects[0].end = event.pos
                    configs.rects[0].size = configs.rects[0].end[0] - configs.rects[0].start[0], configs.rects[0].end[1] - configs.rects[0].start[1]
            elif configs.can_drag:
                # 获取拖动中的子截图的坐标
                configs.sub_images[0].rect.center = event.pos


def main():
    # 游戏配置项
    configs = Configuration()

    # 游戏的初始化、游戏窗口的设置、游戏窗口标题的设置
    pygame.init()
    screen = pygame.display.set_mode(configs.size)
    pygame.display.set_caption(configs.caption)

    # 要截取的图片
    img = pygame.image.load('images/piqiu.bmp')
    rect = img.get_rect()

    while True:
        event_loop(screen, configs)

        screen.fill(configs.bg_color)
        screen.blit(img, rect)

        # 画矩形框
        # 在允许绘画矩形以及拖拉子截图时，绘制矩形，如果在点击的第三下，则不做任何改动
        if configs.rects and configs.click_time != 2:
            configs.rects[0].draw_rect()

        # 只要存在子截图，就将其绘画出来
        if configs.sub_images:
            for temp_img in configs.sub_images:
                screen.blit(temp_img.img, temp_img.rect)

        pygame.display.update()


if __name__ == '__main__':
    main()