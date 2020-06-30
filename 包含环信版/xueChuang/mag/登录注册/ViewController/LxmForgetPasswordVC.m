
//
//  LxmForgetPasswordVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/24.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmForgetPasswordVC.h"
#import "LxmFindPasswordView.h"

@interface LxmForgetPasswordVC ()
@property (nonatomic , strong)LxmFindPasswordView * passwordView;
/**
 发送验证码
 */
@property (nonatomic , strong)NSTimer * timer;
@property (nonatomic , assign)int time;
@end

@implementation LxmForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.tableView.backgroundColor = BGGrayColor;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 210)];
    self.tableView.tableHeaderView = headerView;
    
    self.passwordView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LxmFindPasswordView class]) owner:nil options:nil].firstObject;
    self.passwordView.frame = CGRectMake(0, 0, ScreenW, 210);
    self.passwordView.phoneTF.tintColor = self.passwordView.passwordTF.tintColor = self.passwordView.codeTF.tintColor = CharacterDarkColor;
    self.passwordView.saveBtn.layer.cornerRadius = 22;
    self.passwordView.saveBtn.layer.masksToBounds = YES;
    [self.passwordView.saveBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordView.sendCodeBtn addTarget:self action:@selector(sendCodeClick) forControlEvents:UIControlEventTouchUpInside];
    self.passwordView.passwordTF.secureTextEntry = YES;
    [self.passwordView.secretBtn addTarget:self action:@selector(secretBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.passwordView];
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
- (void)secretBtnCLick{
    self.passwordView.secretBtn.selected = !self.passwordView.secretBtn.selected;
    self.passwordView.passwordTF.secureTextEntry = self.passwordView.secretBtn.selected;
    self.passwordView.passwordTF.secureTextEntry = !self.passwordView.secretBtn.selected;
}
- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 发送验证码
 */
- (void)sendCodeClick{
    if (self.passwordView.phoneTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入手机号"];
        return;
    }
    if (self.passwordView.phoneTF.text.length!=11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.passwordView.phoneTF.text forKey:@"phone"];
    [dict setObject:@2 forKey:@"type"];
    if ([LxmTool ShareTool].session_token) {
        [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine app_sendMobile] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] != 1)
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }else{
            [self.timer invalidate];
            self.timer=nil;
            self.time=60;
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)onTimer1
{
    self.passwordView.sendCodeBtn.enabled = NO;
    [self.passwordView.sendCodeBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",_time--] forState:UIControlStateNormal];
    if (self.time<0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.passwordView.sendCodeBtn.enabled=YES;
        [self.passwordView.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)finishBtnClick{
    //完成
    if (self.passwordView.phoneTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }else if (self.passwordView.codeTF.text.length < 1){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }else if (self.passwordView.passwordTF.text.length < 6 || self.passwordView.passwordTF.text.length > 15){
        [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.passwordView.phoneTF.text forKey:@"phone"];
    [dict setObject:[NSString stringToMD5:self.passwordView.passwordTF.text] forKey:@"password"];
    [dict setObject:self.passwordView.codeTF.text forKey:@"verifCode"];
    NSString * str = [LxmURLDefine app_findPassword];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] != 1)
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
             [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
