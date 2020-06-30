//
//  UIColor+Typecolor.h
//  mag
//
//  Created by 李晓满 on 2018/7/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Typecolor)
+(UIColor *)colorWithType:(NSInteger)type;
+(UIColor *)colorWithTypeName:(NSString *)typeName;
@end
