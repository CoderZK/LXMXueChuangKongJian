//
//  LxmSureSelectPeopleAlertView.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmSureSelectPeopleAlertViewDelegate;
@interface LxmSureSelectPeopleAlertView : UIView
@property (nonatomic , weak)id<LxmSureSelectPeopleAlertViewDelegate>delegate;
-(void)showWithContent:(NSString *)content;
- (void)dismiss;

@end

@protocol LxmSureSelectPeopleAlertViewDelegate<NSObject>
- (void)LxmSureSelectPeopleAlertViewNext:(LxmSureSelectPeopleAlertView *)view;
@end
