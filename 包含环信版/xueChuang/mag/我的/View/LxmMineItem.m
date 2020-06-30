//
//  LxmMineItem.m
//  mag
//
//  Created by 宋乃银 on 2018/7/7.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMineItem.h"

@implementation LxmMineItem

+ (instancetype)itemWithType:(LxmMineItemType)type {
    LxmMineItem *item = [LxmMineItem new];
    item.type = type;
    switch (type) {
        case LxmMineItemType_huo:
            item.logoImg = @"grzx_1";
            item.title = @"我发布的活|我抢的活";
            break;
            
        case LxmMineItemType_jineng:
            item.logoImg = @"grzx_5";
            item.title = @"发布的技能|购买的技能";
            break;
            
        case LxmMineItemType_goods:
            item.logoImg = @"grzx_3";
            item.title = @"我购买的商品";
            break;
            
        case LxmMineItemType_wodebaoming:
            item.logoImg = @"grzx_4";
            item.title = @"我的报名";
            break;
            
        case LxmMineItemType_wodepingjia:
            item.logoImg = @"grzx_2";
            item.title = @"我的评价";
            break;
            
        case LxmMineItemType_wodeshoucang:
            item.logoImg = @"grzx_6";
            item.title = @"我的收藏";
            break;
            
        case LxmMineItemType_wodezichan:
            item.logoImg = @"grzx_7";
            item.title = @"我的资产";
            break;
            
        case LxmMineItemType_shimingrenzheng:
            item.logoImg = @"grzx_8";
            item.title = @"实名认证";
            break;
            
        default:
            break;
    }
    return item;
}

@end
