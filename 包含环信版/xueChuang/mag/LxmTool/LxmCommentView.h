//
//  LxmCommentView.h
//  OneYuanTuan
//
//  Created by 李晓满 on 15/12/9.
//  Copyright © 2015年 heJevon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmCommentView : UIView

+(void)showWithOkBlock:(void(^)(NSString *str))okBlock;

@end
