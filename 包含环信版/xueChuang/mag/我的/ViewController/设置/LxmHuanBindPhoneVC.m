//
//  LxmHuanBindPhoneVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHuanBindPhoneVC.h"
#import "LxmMyAccountSettingVC.h"

@interface LxmHuanBindPhoneVC ()
@property (nonatomic , strong)LxmHuanBindPhoneView * oldPhoneView;
@property (nonatomic , strong)LxmHuanBindPhoneView * codeView;
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , assign)LxmHuanBindPhoneVC_type type;
/**
 发送验证码
 */
@property (nonatomic , strong)NSTimer * timer;
@property (nonatomic , assign)int time;

@end

@implementation LxmHuanBindPhoneVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmHuanBindPhoneVC_type)type{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == LxmHuanBindPhoneVC_type_first) {
        self.navigationItem.title = @"换绑手机";
    }else{
        self.navigationItem.title = @"换绑手机";
    }
    
    [self initHeaderView];
}
- (void)initHeaderView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 180)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = headerView;
    
    self.oldPhoneView = [[LxmHuanBindPhoneView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.oldPhoneView.rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.oldPhoneView.rightBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    self.oldPhoneView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.oldPhoneView.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.oldPhoneView.rightBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.oldPhoneView.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
    }];
    [headerView addSubview:self.oldPhoneView];
    
    self.codeView = [[LxmHuanBindPhoneView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 50)];
    self.codeView.leftlab.text = @"验证码";
    self.codeView.leftTF.placeholder = @"请输入验证码";
    [self.codeView.leftTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.codeView);
    }];
    [self.codeView layoutIfNeeded];
    [headerView addSubview:self.codeView];
    
    self.bottomBtn = [[UIButton alloc] init];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    if (self.type == LxmHuanBindPhoneVC_type_first) {
        [self.bottomBtn setTitle:@"验证后绑定新手机" forState:UIControlStateNormal];
    }else{
        [self.bottomBtn setTitle:@"绑定新手机号" forState:UIControlStateNormal];
    }
    
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.bottomBtn.layer.cornerRadius = 25;
    self.bottomBtn.layer.masksToBounds = YES;
    [self.bottomBtn addTarget:self action:@selector(bindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.bottomBtn];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView);
        make.leading.equalTo(headerView).offset(15);
        make.trailing.equalTo(headerView).offset(-15);
        make.height.equalTo(@50);
    }];
    if (self.type == LxmHuanBindPhoneVC_type_first) {
        self.oldPhoneView.leftlab.text = @"旧手机";
        self.oldPhoneView.leftTF.text = self.phone;
        self.oldPhoneView.leftTF.userInteractionEnabled = NO;
    }else{
        self.oldPhoneView.leftlab.text = @"新手机";
        self.oldPhoneView.leftTF.placeholder = @"请输入手机号";
        self.oldPhoneView.leftTF.userInteractionEnabled = YES;
    }
}

- (void)bindBtnClick{
    if (ISLOGIN) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString * str = @"";
        [dict setObject:SESSION_TOKEN forKey:@"token"];
        if (self.type == LxmHuanBindPhoneVC_type_first) {
            str = [LxmURLDefine user_validateOldPhone];
            if (self.codeView.leftTF.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            [dict setObject:self.oldPhoneView.leftTF.text forKey:@"oldPhone"];
        }else{
            str = [LxmURLDefine user_bindingNewPhone];
            if (self.oldPhoneView.leftTF.text.length==0) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
                return;
            }
            if ([self.oldPhoneView.leftTF.text isEqualToString:self.phone]) {
                [SVProgressHUD showErrorWithStatus:@"请输入新绑定的手机号"];
                return;
            }
            if (self.codeView.leftTF.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            [dict setObject:self.oldPhoneView.leftTF.text forKey:@"phone"];
        }
         [dict setObject:self.codeView.leftTF.text forKey:@"verifCode"];
       
        [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject objectForKey:@"key"] intValue] == 1){
                if (self.type == LxmHuanBindPhoneVC_type_first) {
                    LxmHuanBindPhoneVC * vc = [[LxmHuanBindPhoneVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmHuanBindPhoneVC_type_second];
                    vc.phone = self.phone;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"换绑成功"];
                   
                    NSArray * vcs = self.navigationController.viewControllers;
                    for (BaseTableViewController * vc in vcs) {
                        if ([vc isKindOfClass:[LxmMyAccountSettingVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bandSuccess" object:nil];
                }
                
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } else {
        [SVProgressHUD showSuccessWithStatus:@"您还没有登录,请先登录!"];
    }
}



- (void)getCode{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.type == LxmHuanBindPhoneVC_type_first) {
        [dict setObject:self.oldPhoneView.leftTF.text forKey:@"phone"];
        [dict setObject:@4 forKey:@"type"];
    }else{
        if (self.oldPhoneView.leftTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请先输入手机号"];
            return;
        }
        if ([self.oldPhoneView.leftTF.text isEqualToString:self.phone]) {
            [SVProgressHUD showErrorWithStatus:@"请输入新绑定的手机号"];
            return;
        }
        if (self.oldPhoneView.leftTF.text.length!=11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        [dict setObject:self.oldPhoneView.leftTF.text forKey:@"phone"];
        [dict setObject:@5 forKey:@"type"];
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
-(void)onTimer1 {
    self.oldPhoneView.rightBtn.enabled = NO;
    [self.oldPhoneView.rightBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",_time--] forState:UIControlStateDisabled];
    if (self.time<0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.oldPhoneView.rightBtn.enabled=YES;
        [self.oldPhoneView.rightBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    }
}

@end

@implementation LxmHuanBindPhoneView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftlab = [[UILabel alloc] init];
        self.leftlab.textColor = CharacterLightGrayColor;
        self.leftlab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.leftlab];
        [self.leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.width.lessThanOrEqualTo(@50);
            make.height.equalTo(@50);
        }];
        
        self.leftTF = [[UITextField alloc] init];
        self.leftTF.textColor = CharacterDarkColor;
        self.leftTF.font = [UIFont systemFontOfSize:15];
        self.leftTF.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftTF];
        
        self.rightBtn = [[UIButton alloc] init];
        [self addSubview:self.rightBtn];
        
        [self.leftTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self.leftlab.mas_trailing).offset(10);
            make.trailing.equalTo(self.rightBtn.mas_leading);
            make.height.equalTo(@50);
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.width.equalTo(@80);
            make.height.equalTo(@50);
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
