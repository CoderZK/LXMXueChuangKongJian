//
//  LxmRenZhengInfoVC.m
//  mag
//
//  Created by 李晓满 on 2018/8/7.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmRenZhengInfoVC.h"
#import "LxmTextTFView.h"
#import <AlipaySDK/AlipaySDK.h>


@interface LxmRenZhengInfoVC ()
@property (nonatomic , strong) LxmTextTFView * cardView;
@property (nonatomic , strong) LxmTextTFView * nameView;
@end

@implementation LxmRenZhengInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
    
    self.tableView.tableHeaderView = headerView;
    
    self.nameView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.nameView.textlab.text = @"真实姓名";
    self.nameView.rightImgView.hidden = YES;
    self.nameView.backgroundColor = UIColor.whiteColor;
    self.nameView.rightTF.placeholder = @"请输入真实姓名";
    [self.nameView.rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.nameView).offset(-15);
    }];
    [headerView addSubview:self.nameView];
    
    self.cardView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 50)];
    self.cardView.textlab.text = @"身份证号";
    self.cardView.rightImgView.hidden = YES;
    self.cardView.backgroundColor = UIColor.whiteColor;
    self.cardView.rightTF.placeholder = @"请输入身份证号";
    [self.cardView.rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.cardView).offset(-15);
    }];
    [headerView addSubview:self.cardView];
    
    UIButton * bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 150, ScreenW - 30, 44)];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    bottomBtn.layer.cornerRadius = 5;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"认证" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bottomBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"NOTIFICATION_MINE_CHANGEUSER" object:nil];
    
}
- (void)btnClick{
    if (ISLOGIN) {
        if (self.nameView.rightTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
            return;
        }
        if (self.cardView.rightTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入身份证号"];
            return;
        }
        
        NSDictionary * dict = @{
                                @"userId":@([LxmTool ShareTool].userModel.userId),
                                @"realname":self.nameView.rightTF.text,
                                @"idNumber":self.cardView.rightTF.text,
                                @"returnUrl":@"magzmrz://"
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine zhima_initialize] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSString * str = responseObject[@"result"][@"url"];
                
                NSLog(@"----支付宝芝麻认证:%@",str);
                
                [self doVerify:str?str:@""];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}

- (void)doVerify:(NSString *)url {
    NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@",[self URLEncodedStringWithUrl:url]];
    if ([self canOpenAlipay]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl]];
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还没有安装支付宝,请先下载安装后认证"];
    }
}

-(NSString *)URLEncodedStringWithUrl:(NSString *)url {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!*'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
}

- (BOOL)canOpenAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
}

- (void)changeUserInfo {
    [SVProgressHUD showWithStatus:@"同步认证信息"];
    [LxmNetworking networkingPOST:[LxmURLDefine user_editMyInfo] parameters:@{@"isAuth":@1,@"token":[LxmTool ShareTool].session_token} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [LxmTool ShareTool].userModel.type = 4;
            [SVProgressHUD showSuccessWithStatus:@"同步完成"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_MINE_USERINFO" object:nil];
            self.backViewController ? [self.navigationController popToViewController:self.backViewController animated:YES] : nil;
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"同步失败"];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICATION_MINE_CHANGEUSER" object:nil];
}

@end
