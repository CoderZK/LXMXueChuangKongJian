//
//  LxmAlipayAuthInfoModel.h
//  mag
//
//  Created by 李晓满 on 2018/7/25.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmAlipayAuthInfoModel : NSObject

//签约平台内的appid
@property (nonatomic, copy) NSString *appID;

//商户签约id
@property (nonatomic, copy) NSString *pid;

- (NSString *)getInfoStr;

@end
