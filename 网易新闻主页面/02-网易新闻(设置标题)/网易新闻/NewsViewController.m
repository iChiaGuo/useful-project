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

@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加所有子控制器
    [self setUpChildViewController];
    
    // 添加所有子控制器对应标题
    [self setUpTitleLabel];
    
    // iOS7会给导航控制器下所有的UIScrollView顶部添加额外滚动区域
    // 不想要添加
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化UIScrollView
    [self setUpScrollView];
}
// 初始化UIScrollView
- (void)setUpScrollView
{
    NSUInteger count = self.childViewControllers.count;
    self.titleScrollView.contentSize = CGSizeMake(count * labelW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

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
        
        // 设置用户的交互
        label.userInteractionEnabled = YES;
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        // 添加label到标题滚动条上
        [self.titleScrollView addSubview:label];
    }
    
}

// 点击标题的时候就会调用
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"%s",__func__);
}

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
