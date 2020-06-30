//
//  LxmQiangDanAlertView.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmQiangDanAlertViewDelegte;
@interface LxmQiangDanAlertView : UIView
@property (nonatomic , weak)id<LxmQiangDanAlertViewDelegte>delegate;
@property (nonatomic , strong) UITextField * phoneTF;
-(void)showWithContent:(NSString *)content;
- (void)dismiss;
@property (nonatomic , strong)LxmHomeModel * model;
@end
@protocol LxmQiangDanAlertViewDelegte<NSObject>

- (void)LxmQiangDanAlertViewBottomClick:(LxmQiangDanAlertView *)alertView ;

@end
