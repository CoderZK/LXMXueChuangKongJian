//
//  LxmMyZiChanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyZiChanVC.h"
#import "LxmMyCostRecordVC.h"
#import "LxmTiXianVC.h"

@interface LxmMyZiChanVC ()
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * iconImgView;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UIView * footerView;
@property (nonatomic , strong) LxmMyAssetsInfoModel * infoModel;
@end

@implementation LxmMyZiChanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"金额";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initHeaderView];
    [self initBottomView];
    [self getMyAssetsInfo];
}

- (void)getMyAssetsInfo{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getMyAssetsInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:[LxmMyAssetsInfoRootModel class] success:^(NSURLSessionDataTask *task, LxmMyAssetsInfoRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.infoModel = responseObject.result;
                self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",self.infoModel.money.floatValue];
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW, 0.5)];
        line.backgroundColor = LineColor;
        [cell addSubview:line];
    }
    cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = cell.detailTextLabel.textColor = CharacterDarkColor;
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"ico_shouru"];
            cell.textLabel.text = @"收入";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",self.infoModel.income.floatValue];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"ico_huafei"];
            cell.textLabel.text = @"花费";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",self.infoModel.expend.floatValue];
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"ico_xiaofeijilu"];
        cell.textLabel.text = @"账单记录";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)initHeaderView{
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    self.headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.headerView;
    
    self.headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, ScreenW - 20, 110)];
    self.headerImgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:255/255.0 alpha:1];
    self.headerImgView.layer.cornerRadius = 10;
    self.headerImgView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.headerImgView];
    
    self.iconImgView = [[UIImageView alloc] init];
    self.iconImgView.image = [UIImage imageNamed:@"bg_9"];
    [self.headerImgView addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView).offset(20);
        make.width.height.equalTo(@70);
    }];
    
    UILabel * textlab = [[UILabel alloc] init];
    textlab.font = [UIFont systemFontOfSize:15];
    textlab.textColor = UIColor.whiteColor;
    textlab.text = @"账户余额";
    [self.headerImgView addSubview:textlab];
    
    self.moneyLab = [[UILabel alloc] init];
    self.moneyLab.font = [UIFont systemFontOfSize:18];
    self.moneyLab.textColor = UIColor.whiteColor;
    self.moneyLab.text = @"￥799.00";
    [self.headerImgView addSubview:self.moneyLab ];
    
    [textlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView).offset(-15);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView).offset(10);
        make.leading.equalTo(textlab);
    }];
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 139.5, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.headerView addSubview:line];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.tableView.tableFooterView = self.footerView;
    
    UILabel * textlab1 = [[UILabel alloc] init];
    textlab1.font = [UIFont systemFontOfSize:13];
    textlab1.textColor = CharacterLightGrayColor;
    textlab1.text = @"满1元可提现";
    [self.footerView addSubview:textlab1];
    
    [textlab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.footerView).offset(15);
        make.centerY.equalTo(self.footerView);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{
           
        }
    }else{
        //账单记录
        LxmMyCostRecordVC * vc = [[LxmMyCostRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)initBottomView{
    UIView * bottomView = nil;
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"提现" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}

//提现
- (void)bottomBtnClick{
    LxmTiXianVC * vc = [[LxmTiXianVC alloc] initWithTableViewStyle:UITableViewStylePlain model:self.infoModel];
    vc.refreshPreVC = ^{
        [self getMyAssetsInfo];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
