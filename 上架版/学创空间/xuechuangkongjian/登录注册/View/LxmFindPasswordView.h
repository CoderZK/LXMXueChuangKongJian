//
//  LxmFindPasswordView.h
//  mag
//
//  Created by 李晓满 on 2018/7/23.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmFindPasswordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end
