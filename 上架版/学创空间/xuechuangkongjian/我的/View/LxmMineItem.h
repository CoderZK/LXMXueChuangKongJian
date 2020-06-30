//
//  LxmMineItem.h
//  mag
//
//  Created by 宋乃银 on 2018/7/7.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LxmMineItemType) {
    LxmMineItemType_info,
    LxmMineItemType_huo,
    LxmMineItemType_jineng,
    LxmMineItemType_goods,
    LxmMineItemType_wodebaoming,
    LxmMineItemType_wodepingjia,
    LxmMineItemType_wodeshoucang,
    LxmMineItemType_wodezichan,
    LxmMineItemType_shimingrenzheng
};

@interface LxmMineItem : NSObject

@property (nonatomic, strong) NSString *logoImg;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) LxmMineItemType type;

+ (instancetype)itemWithType:(LxmMineItemType)type;

@end
