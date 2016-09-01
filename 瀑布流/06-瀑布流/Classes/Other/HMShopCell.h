//
//  HMShopCell.h
//  06-瀑布流
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMWaterflowViewCell.h"
@class HMWaterflowView, HMShop;

@interface HMShopCell : HMWaterflowViewCell
+ (instancetype)cellWithWaterflowView:(HMWaterflowView *)waterflowView;

@property (nonatomic, strong) HMShop *shop;
@end
