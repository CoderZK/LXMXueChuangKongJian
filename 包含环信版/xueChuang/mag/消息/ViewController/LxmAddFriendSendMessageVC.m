//
//  LxmAddFriendSendMessageVC.m
//  mag
//
//  Created by 宋乃银 on 2018/7/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmAddFriendSendMessageVC.h"

@interface LxmAddFriendSendMessageVC ()
@property (nonatomic , strong)UITextField * contentTF;
@end

@implementation LxmAddFriendSendMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setTitle:@"发送" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    [self initTableHeaderView];
}

- (void)sendBtnClick{
    if (ISLOGIN) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        if (self.contentTF.text.length > 15) {
            [SVProgressHUD showErrorWithStatus:@"招呼内容限制15字"];
            return;
        }
        
        if (self.contentTF.text.length!=0) {
            dict[@"content"] = self.contentTF.text;
        }
        dict[@"token"] = SESSION_TOKEN;
        dict[@"otherUserId"] = self.friendID;
        [LxmNetworking networkingPOST:[LxmURLDefine user_applyFriend] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"好友请求已发送"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}

- (void)initTableHeaderView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableHeaderView = headerView;
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenW-30, 20)];
    lab.text = @"打个招呼吧~";
    lab.textColor = CharacterGrayColor;
    lab.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:lab];
    
    UIView * tfView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 50)];
    tfView.backgroundColor = UIColor.whiteColor;
    [headerView addSubview:tfView];
    
    self.contentTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 50)];
    self.contentTF.placeholder = @"请输入申请内容";
    self.contentTF.textColor = CharacterDarkColor;
    self.contentTF.font = [UIFont systemFontOfSize:16];
    [tfView addSubview:self.contentTF];
}


@end
