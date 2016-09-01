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

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加所有子控制器
    [self setUpChildViewController];
}

// 添加所有子控制器
- (void)setUpChildViewController
{
    // 头条
    TopLineViewController *topLine = [[TopLineViewController alloc] init];
    [self addChildViewController:topLine];
    
    // 热点
    HotViewController *hot = [[HotViewController alloc] init];
    [self addChildViewController:hot];
    
    // 视频
    VideoViewController *video = [[VideoViewController alloc] init];
    [self addChildViewController:video];

    
    // 社会
    SocietyViewController *society = [[SocietyViewController alloc] init];
    [self addChildViewController:society];

    
    // 阅读
    ReaderViewController *reader = [[ReaderViewController alloc] init];
    [self addChildViewController:reader];

    
    // 科技
    ScienceViewController *science = [[ScienceViewController alloc] init];
    [self addChildViewController:science];

    
}
@end
