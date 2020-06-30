//
//  LxmRegistView.h
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmRegistView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *secretBTn;


@end
