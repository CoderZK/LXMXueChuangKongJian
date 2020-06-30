//
//  NSString+Size.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
/**
 获得字符串的大小
 */

-(CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize;
+ (NSString *)stringToMD5:(NSString *)str;

+ (NSDate *)dataWithStr:(NSString *)str;
/****
 ios比较日期大小默认会比较到秒
 ****/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


+(NSString *)convertToJsonData:(id)dict;
+ (CGFloat)getHeightWith:(NSString *)str;
/**
 转化时间倒计时
 */
+(double)chaWithCreateTime:(NSString *)creatTime;

/**
 转化时间
 */
+(NSString *)stringWithTime:(NSString *)str;
+ (NSString *)getCurrentTime;

//获取当前时间戳有两种方法(以秒为单位)
+(NSString *)getCurrentTimeChuo;


/**
 根据类型获取类型名称
 */
+(NSString *)returnTypeNameWithType:(NSInteger)type;


@end
