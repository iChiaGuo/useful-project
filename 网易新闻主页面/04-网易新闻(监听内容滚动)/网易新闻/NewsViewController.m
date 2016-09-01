//
//  NewsViewController.m
//  网易新闻
//
//  Created by xiaomage on 15/10/23.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "NewsViewController.h"

#import "TopLineViewController.h"
#import "HotViewController.h"
#import "SocietyViewController.h"
#import "VideoViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

static CGFloat const labelW = 100;

#define XMGScreenW [UIScreen mainScreen].bounds.size.width

#define XMGScreenH [UIScreen mainScreen].bounds.size.height

@interface NewsViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *selLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation NewsViewController

/*
    网易新闻实现步骤:
    1.搭建结构(导航控制器)
        * 自定义导航控制器根控制器NewsViewController
        * 搭建NewsViewController界面(上下滚动条)
        * 确定NewsViewController有多少个子控制器,添加子控制器
    2.设置上面滚动条标题
        * 遍历所有子控制器
    3.监听滚动条标题点击
        * 3.1 让标题选中,文字变为红色
        * 3.2 滚动到对应的位置
        * 3.3 在对应的位置添加子控制器view
    4.监听滚动完成时候
        * 4.1 在对应的位置添加子控制器view
        * 4.2 选中子控制器对应的标题
 */

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.添加所有子控制器
    [self setUpChildViewController];
    
    // 2.添加所有子控制器对应标题
    [self setUpTitleLabel];
    
    // iOS7会给导航控制器下所有的UIScrollView顶部添加额外滚动区域
    // 不想要添加
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 3.初始化UIScrollView
    [self setUpScrollView];
}

#warning 3.初始化UIScrollView
// 初始化UIScrollView
- (void)setUpScrollView
{
    NSUInteger count = self.childViewControllers.count;
    // 设置标题滚动条
    self.titleScrollView.contentSize = CGSizeMake(count * labelW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容滚动条
    self.contentScrollView.contentSize = CGSizeMake(count * XMGScreenW, 0);
    // 开启分页
    self.contentScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    self.contentScrollView.bounces = NO;
    // 隐藏水平滚动条
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    self.contentScrollView.delegate = self;
}

#warning 2.添加所有子控制器对应标题
// 添加所有子控制器对应标题
- (void)setUpTitleLabel
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = 44;
   
    for (int i = 0; i < count; i++) {
        // 获取对应子控制器
        UIViewController *vc = self.childViewControllers[i];
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        
        labelX = i * labelW;
        
        // 设置尺寸
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 设置label文字
        label.text = vc.title;
        
        // 设置高亮文字颜色
        label.highlightedTextColor = [UIColor redColor];
        
        // 设置label的tag
        label.tag = i;
        
        // 设置用户的交互
        label.userInteractionEnabled = YES;
        
       
        // 添加到titleLabels数组
        [self.titleLabels addObject:label];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
         // 默认选中第0个label
        if (i == 0) {
            [self titleClick:tap];
        }
        
        // 添加label到标题滚动条上
        [self.titleScrollView addSubview:label];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 1.添加子控制器view
    [self showVc:index];
   
    // 2.把对应的标题选中
    UILabel *selLabel = self.titleLabels[index];
    
    [self selectLabel:selLabel];

    
}

// 显示控制器的view
- (void)showVc:(NSInteger)index
{
    CGFloat offsetX = index * XMGScreenW;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    vc.view.frame = CGRectMake(offsetX, 0, XMGScreenW, XMGScreenH);
    
    [self.contentScrollView addSubview:vc.view];
    
}

// 点击标题的时候就会调用
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    
    // 0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色
    [self selectLabel:selLabel];
   
    // 2.滚动到对应的位置
    NSInteger index = selLabel.tag;
    // 2.1 计算滚动的位置
    CGFloat offsetX = index * XMGScreenW;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 3.给对应位置添加对应子控制器
    [self showVc:index];

}

// 选中label
- (void)selectLabel:(UILabel *)label
{
    _selLabel.highlighted = NO;
    
    label.highlighted = YES;
    
    _selLabel = label;

}

#warning 1.添加所有子控制器对应标题
// 添加所有子控制器
- (void)setUpChildViewController
{
    // 头条
    TopLineViewController *topLine = [[TopLineViewController alloc] init];
    topLine.title = @"头条";
    [self addChildViewController:topLine];
    
    // 热点
    HotViewController *hot = [[HotViewController alloc] init];
    hot.title = @"热点";
    [self addChildViewController:hot];
    
    // 视频
    VideoViewController *video = [[VideoViewController alloc] init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    // 社会
    SocietyViewController *society = [[SocietyViewController alloc] init];
    society.title = @"社会";
    [self addChildViewController:society];
    
    // 阅读
    ReaderViewController *reader = [[ReaderViewController alloc] init];
    reader.title = @"阅读";
    [self addChildViewController:reader];

    // 科技
    ScienceViewController *science = [[ScienceViewController alloc] init];
    science.title = @"科技";
    [self addChildViewController:science];

    
}
@end
