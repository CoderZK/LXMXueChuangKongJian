//
//  UIColor+Typecolor.m
//  mag
//
//  Created by 李晓满 on 2018/7/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "UIColor+Typecolor.h"

@implementation UIColor (Typecolor)
+(UIColor *)colorWithType:(NSInteger)type{
    UIColor * typeColor = nil;
    switch (type) {
        case 1:
            typeColor = [UIColor colorWithRed:122/255.0 green:206/255.0 blue:95/255.0 alpha:1];
            break;
        case 2:
            typeColor = [UIColor colorWithRed:244/255.0 green:164/255.0 blue:60/255.0 alpha:1];
            break;
        case 3:
            typeColor = [UIColor colorWithRed:249/255.0 green:113/255.0 blue:72/255.0 alpha:1];
            break;
        case 4:
            typeColor = [UIColor colorWithRed:79/255.0 green:204/255.0 blue:246/255.0 alpha:1];
            break;
        default:
            break;
    }
    return typeColor;
}
+(UIColor *)colorWithTypeName:(NSString *)typeName{
    UIColor * typeColor = nil;
    if ([typeName isEqualToString:@"邮寄"]) {
        typeColor = [UIColor colorWithRed:122/255.0 green:206/255.0 blue:95/255.0 alpha:1];
    }else if ([typeName isEqualToString:@"线上"]){
        typeColor = [UIColor colorWithRed:244/255.0 green:164/255.0 blue:60/255.0 alpha:1];
    }else if ([typeName isEqualToString:@"当面"]){
        typeColor = [UIColor colorWithRed:249/255.0 green:113/255.0 blue:72/255.0 alpha:1];
    }else{
        typeColor = [UIColor colorWithRed:79/255.0 green:204/255.0 blue:246/255.0 alpha:1];
    }
    return typeColor;
}
@end
