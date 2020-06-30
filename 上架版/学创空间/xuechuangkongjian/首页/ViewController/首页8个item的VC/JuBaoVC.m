//
//  JuBaoVC.m
//  mag
//
//  Created by 李晓满 on 2018/8/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "JuBaoVC.h"
#import "IQKeyboardManagerConstants.h"

@interface JuBaoVC ()
@property (nonatomic , strong)IQTextView * contentView;
@end

@implementation JuBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"举报";
    [self initHeaderView];
}
- (void)initHeaderView{
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, ScreenW, 300)];
    self.tableView.tableHeaderView = headerView;
    
    UIView * contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
    contentBgView.backgroundColor = UIColor.whiteColor;
    [headerView addSubview:contentBgView];
    
    self.contentView = [[IQTextView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 200)];
    self.contentView.placeholder = @"请输入举报内容";
    self.contentView.font = [UIFont systemFontOfSize:15];
    [contentBgView addSubview:self.contentView];
    
    
    UIButton * submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 256, ScreenW - 30, 44)];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [headerView addSubview:submitBtn];
}
- (void)submitBtnClick{
    if (self.contentView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入举报内容!"];
        return;
    }
    NSDictionary * dict = @{
                            @"token":SESSION_TOKEN,
                            @"type":@1,
                            @"otherId":self.billId,
                            @"content":self.contentView.text
                            };
    [LxmNetworking networkingPOST:[LxmURLDefine user_report] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"举报成功"];
            [self.navigationController popViewControllerAnimated:YES];
           
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
