//
//  LxmMyCommentVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyCommentVC.h"
#import "PingJiaVC.h"
#import "LXMStarView.h"
#import "IQKeyboardManagerConstants.h"

@interface LxmMyCommentVC ()<LXMStarViewDelegate>
@property (nonatomic , strong)LXMStarView * starView;
@property (nonatomic , strong)IQTextView * contentView;

@property (nonatomic , assign)NSInteger  starNum;
@end

@implementation LxmMyCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self initTableHeaderView];
}
- (void)rightBtnClick{
    if (ISLOGIN) {
        if (self.starNum == 0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有选择评价星级!"];
            return;
        }
        if (self.contentView.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有输入评价内容!"];
            return;
        }
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":self.danModel.billId,
                               @"allotId":self.model.allotId,
                               @"otherUserId":self.model.robUserId,
                               @"score":@(self.starNum),
                               @"content":self.contentView.text
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_evaHelpUser] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已评价!"];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.refreshPreBlock) {
                    self.refreshPreBlock();
                };
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
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = headerView;
    
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = LineColor;
    [headerView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(headerView);
        make.height.equalTo(@0.5);
    }];
    
    self.starView = [[LXMStarView alloc] initWithFrame:CGRectMake((ScreenW-200)*0.5, 35, 200, 30) withSpace:10];
    self.starView.delegate = self;
    [headerView addSubview:self.starView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 98, ScreenW - 30, 1)];
    line.backgroundColor = LineColor;
    [headerView addSubview:line];
    
    self.contentView = [[IQTextView alloc] initWithFrame:CGRectMake(15, 100, ScreenW - 30, 200)];
    self.contentView.placeholder = @"写点什么吧......";
    self.contentView.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:self.contentView];
    
}
//星星数量
- (void)didClickStar:(NSInteger )star{
    self.starNum = star;
}


@end
