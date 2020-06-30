//
//  LxmRenZhengVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmRenZhengVC.h"
#import "LxmRenZhengInfoVC.h"

@interface LxmRenZhengVC ()
@property (nonatomic , strong) UIImageView * iconImgView;
@property (nonatomic , strong) UILabel * textLab;
@property (nonatomic , strong) UIButton * renzhengBtn;
@end

@implementation LxmRenZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, (ScreenH-StateBarH - 44-50)*0.5)];
    self.tableView.tableHeaderView = headerView;
    
    self.iconImgView = [[UIImageView alloc] init];
    self.iconImgView.image = [UIImage imageNamed:@"renzheng_n1"];
    [headerView addSubview:self.iconImgView];
    
    self.textLab = [[UILabel alloc] init];
    self.textLab.font = [UIFont systemFontOfSize:16];
    self.textLab.textColor = CharacterDarkColor;
    self.textLab.text = @"还未完成实名认证";
    [headerView addSubview:self.textLab];
    
    self.renzhengBtn = [[UIButton alloc] init];
    [self.renzhengBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.renzhengBtn setTitle:@"去认证" forState:UIControlStateNormal];
    [self.renzhengBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.renzhengBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.renzhengBtn.layer.cornerRadius = 25;
    self.renzhengBtn.layer.masksToBounds = YES;
    [headerView addSubview:self.renzhengBtn];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.bottom.equalTo(self.textLab.mas_top).offset(-10);
        make.width.height.equalTo(@50);
    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.bottom.equalTo(self.renzhengBtn.mas_top).offset(-20);
    }];
    
    [self.renzhengBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(headerView);
        make.width.equalTo(@(ScreenW*0.5));
        make.height.equalTo(@50);
    }];
}
- (void)btnClick{
    LxmRenZhengInfoVC * vc = [[LxmRenZhengInfoVC alloc] init];
    vc.backViewController = self.backViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
