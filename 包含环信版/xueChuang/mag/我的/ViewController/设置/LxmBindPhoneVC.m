//
//  LxmBindPhoneVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmBindPhoneVC.h"

@interface LxmBindPhoneVC ()
@property (nonatomic , strong) LxmBindPutinView * phoneView;
@property (nonatomic , strong) LxmBindPutinView * codeView;
@property (nonatomic , strong) LxmBindPutinView * passwordView;
/**
 发送验证码
 */
@property (nonatomic , strong)NSTimer * timer;
@property (nonatomic , assign)int time;

@end

@implementation LxmBindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [rightbtn setTitle:@"完成" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    [self initHeaderView];
}
- (void)finishBtnClick{
    if (self.phoneView.leftTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (self.codeView.leftTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.passwordView.leftTF.text.length<6||self.passwordView.leftTF.text.length>15) {
        [SVProgressHUD showErrorWithStatus:@"密码长度必须在6~15之间"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phoneView.leftTF.text forKey:@"phone"];
    [dict setObject:[NSString stringToMD5:self.codeView.leftTF.text] forKey:@"password"];
    [dict setObject:self.passwordView.leftTF.text forKey:@"verificationCode"];
    NSString * str = [LxmURLDefine user_bindingPhone];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            if (self.refreshPreVC) {
                self.refreshPreVC();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}
- (void)initHeaderView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = headerView;
    
    self.phoneView = [[LxmBindPutinView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.phoneView.leftTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneView.leftTF.placeholder = @"请输入手机号";
    [self.phoneView.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [headerView addSubview:self.phoneView];
    
    self.codeView = [[LxmBindPutinView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 50)];
    self.codeView.leftTF.placeholder = @"请输入验证码";
    self.codeView.leftTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeView.rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeView.rightBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    self.codeView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.codeView.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.codeView.rightBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.codeView.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
    }];
    [headerView addSubview:self.codeView];
    
    self.passwordView = [[LxmBindPutinView alloc] initWithFrame:CGRectMake(0, 100, ScreenW, 50)];
    self.passwordView.leftTF.placeholder = @"请输入新密码";
    [self.passwordView.rightBtn setImage:[UIImage imageNamed:@"mimanosee"] forState:UIControlStateNormal];
    [self.passwordView.rightBtn setImage:[UIImage imageNamed:@"mimasee"] forState:UIControlStateSelected];
    [self.passwordView.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
    }];
    [headerView addSubview:self.passwordView];
    
}
- (void)getCode{
    if (self.phoneView.leftTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入手机号"];
        return;
    }
    if (self.phoneView.leftTF.text.length!=11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phoneView.leftTF.text forKey:@"phone"];
    [dict setObject:@3 forKey:@"type"];
    if ([LxmTool ShareTool].session_token) {
        [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine app_sendMobile] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1){
            [self.timer invalidate];
            self.timer=nil;
            self.time=60;
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)onTimer1
{
    self.codeView.rightBtn.enabled = NO;
    [self.codeView.rightBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",_time--] forState:UIControlStateDisabled];
    if (self.time<0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.codeView.rightBtn.enabled=YES;
        [self.codeView.rightBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    }
}


@end

@implementation LxmBindPutinView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftTF = [[UITextField alloc] init];
        self.leftTF.textColor = CharacterDarkColor;
        self.leftTF.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.leftTF];
        
        self.rightBtn = [[UIButton alloc] init];
        [self addSubview:self.rightBtn];
        
        [self.leftTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self.rightBtn.mas_leading);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@0.1);
        }];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
@end

