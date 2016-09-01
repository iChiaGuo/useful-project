//
//  HMShopsViewController.m
//  06-瀑布流
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMShopsViewController.h"
#import "HMShopCell.h"
#import "HMWaterflowView.h"
#import "HMShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface HMShopsViewController ()<HMWaterflowViewDataSource, HMWaterflowViewDelegate>
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) HMWaterflowView *waterflowView;
@end

@implementation HMShopsViewController

- (NSMutableArray *)shops
{
    if (_shops == nil) {
        self.shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 0.初始化数据
    NSArray *newShops = [HMShop objectArrayWithFilename:@"2.plist"];
    [self.shops addObjectsFromArray:newShops];
    
    // 1.瀑布流控件
    HMWaterflowView *waterflowView = [[HMWaterflowView alloc] init];
    waterflowView.backgroundColor = [UIColor redColor];
    // 跟随着父控件的尺寸而自动伸缩
    waterflowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    waterflowView.frame = self.view.bounds;
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    [self.view addSubview:waterflowView];
    self.waterflowView = waterflowView;
    
    // 2.继承刷新控件
//    [waterflowView addFooterWithCallback:^{
//        NSLog(@"进入上拉加载状态");
//    }];
    
//    [waterflowView addHeaderWithCallback:^{
//        NSLog(@"进入下拉加载状态");
    //    }];
    
    [waterflowView addHeaderWithTarget:self action:@selector(loadNewShops)];
    [waterflowView addFooterWithTarget:self action:@selector(loadMoreShops)];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    NSLog(@"屏幕旋转完毕");
    [self.waterflowView reloadData];
}

- (void)loadNewShops
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载1.plist
        NSArray *newShops = [HMShop objectArrayWithFilename:@"1.plist"];
        [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新瀑布流控件
        [self.waterflowView reloadData];
        
        // 停止刷新
        [self.waterflowView headerEndRefreshing];
    });
}

- (void)loadMoreShops
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载3.plist
        NSArray *newShops = [HMShop objectArrayWithFilename:@"3.plist"];
        [self.shops addObjectsFromArray:newShops];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新瀑布流控件
        [self.waterflowView reloadData];
        
        // 停止刷新
        [self.waterflowView footerEndRefreshing];
    });
}

#pragma mark - 数据源方法
- (NSUInteger)numberOfCellsInWaterflowView:(HMWaterflowView *)waterflowView
{
    return self.shops.count;
}

- (HMWaterflowViewCell *)waterflowView:(HMWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    HMShopCell *cell = [HMShopCell cellWithWaterflowView:waterflowView];
    
    cell.shop = self.shops[index];
    
    return cell;
}

- (NSUInteger)numberOfColumnsInWaterflowView:(HMWaterflowView *)waterflowView
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        // 竖屏
        return 3;
    } else {
        return 5;
    }
}

#pragma mark - 代理方法
- (CGFloat)waterflowView:(HMWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    HMShop *shop = self.shops[index];
    // 根据cell的宽度 和 图片的宽高比 算出 cell的高度
    return waterflowView.cellWidth * shop.h / shop.w;
}
@end