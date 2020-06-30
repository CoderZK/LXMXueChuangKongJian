//
//  LxmModel.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmModel : NSObject

@end
@interface LxmHomeDynamicModel:NSObject

@property (nonatomic,strong) NSString * dsc;
@property (nonatomic,strong) NSString * img;

@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSNumber * commentNum;
@property (nonatomic,strong) NSString * commentContent;
@property (nonatomic,strong) NSNumber * likeNum;
@property (nonatomic,assign) CGFloat height;
@end
