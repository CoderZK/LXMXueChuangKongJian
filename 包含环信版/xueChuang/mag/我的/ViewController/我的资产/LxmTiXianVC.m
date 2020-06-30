//
//  LxmTiXianVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTiXianVC.h"
#import "LxmAddressVC.h"
#import "LxmTiXianSuccessAlertView.h"

@interface LxmTiXianVC ()<LxmAddressVCDelegate>
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) UIButton * selectAddressBtn;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UITextField * putinMoneyTF;
@property (nonatomic , strong) UIView * footerView;
@property (nonatomic , strong) UILabel * addresslab1;
@property (nonatomic , strong) LxmMyAssetsInfoModel * infoModel;
@property (nonatomic , strong) LxmMyAddressModel * addressModel;
@end

@implementation LxmTiXianVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style model:(LxmMyAssetsInfoModel *)model{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.infoModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [self initHeaderView];
    [self initBottomView];
}
//当前选定的提现地址
- (void)selectModel:(LxmMyAddressModel *)model{
    if (model) {
        self.addressModel = model;
        self.addresslab1.text = [NSString stringWithFormat:@"%@  %@",(model.type.intValue == 1?@"支付宝":@"银联卡"),model.account];
    }
}
- (void)initHeaderView{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 310)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = headerView;
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [headerView addSubview:view1];
    
    
    UILabel * addresslab = [[UILabel alloc] init];
    addresslab.font = [UIFont systemFontOfSize:15];
    addresslab.textColor = CharacterDarkColor;
    addresslab.text = @"提现地址";
    [view1 addSubview:addresslab];
    
    [addresslab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view1).offset(15);
        make.centerY.equalTo(view1);
    }];
    
    self.selectAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    [self.selectAddressBtn addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.selectAddressBtn];
    
    self.addresslab1 = [[UILabel alloc] init];
    self.addresslab1.font = [UIFont systemFontOfSize:13];
    self.addresslab1.textColor = CharacterGrayColor;
    self.addresslab1.text = @"请选择提现地址";
    [self.selectAddressBtn addSubview:self.addresslab1];
    
    [self.addresslab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectAddressBtn).offset(15);
        make.centerY.equalTo(self.selectAddressBtn).offset(20);
    }];
    
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"jiantou_2"];
    [self.selectAddressBtn addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectAddressBtn).offset(-15);
        make.centerY.equalTo(self.selectAddressBtn).offset(20);
        make.width.height.equalTo(@20);
    }];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenW, 10)];
    line.backgroundColor = LineColor;
    [headerView addSubview:line];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, ScreenW, 50)];
    [headerView addSubview:view2];
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW, 0.5)];
    line2.backgroundColor = BGGrayColor;
    [view2 addSubview:line2];
    
    UILabel * textlab1 = [[UILabel alloc] init];
    textlab1.font = [UIFont systemFontOfSize:15];
    textlab1.textColor = CharacterDarkColor;
    textlab1.text = @"账户余额";
    [view2 addSubview:textlab1];
    [textlab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view2).offset(15);
        make.centerY.equalTo(view2);
    }];
    
    self.moneyLab = [[UILabel alloc] init];
    self.moneyLab.font = [UIFont systemFontOfSize:15];
    self.moneyLab.textColor = [UIColor blackColor];
    self.moneyLab.text = [NSString stringWithFormat:@"%@元",self.infoModel.money];
    [view2 addSubview:self.moneyLab];
    
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(textlab1.mas_trailing).offset(20);
        make.centerY.equalTo(view2);
    }];
    
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 160, ScreenW, 50)];
    [headerView addSubview:view3];
    UILabel * textlab3 = [[UILabel alloc] init];
    textlab3.font = [UIFont systemFontOfSize:15];
    textlab3.textColor = CharacterDarkColor;
    textlab3.text = @"提现金额";
    [view3 addSubview:textlab3];
    [textlab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view3);
        make.leading.equalTo(view3).offset(15);
    }];
    
    UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 210, ScreenW, 50)];
    [headerView addSubview:view4];
    
    UILabel * textlab4 = [[UILabel alloc] init];
    textlab4.font = [UIFont systemFontOfSize:15];
    textlab4.textColor = CharacterDarkColor;
    textlab4.text = @"￥";
    [view4 addSubview:textlab4];
    
    [textlab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view4).offset(15);
        make.centerY.equalTo(view4);
        make.width.height.equalTo(@20);
    }];
    
    self.putinMoneyTF = [[UITextField alloc] init];
    self.putinMoneyTF.font = [UIFont boldSystemFontOfSize:25];
    self.putinMoneyTF.placeholder = @"请输入提现金额";
    
    [self.putinMoneyTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.putinMoneyTF.textColor = [UIColor blackColor];
    self.putinMoneyTF.keyboardType = UIKeyboardTypeNumberPad;
    [view4 addSubview:self.putinMoneyTF];
    
    [self.putinMoneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(textlab4.mas_trailing).offset(5);
        make.centerY.equalTo(view4);
    }];
    
    UIButton * allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, ScreenW, 50)];
    [allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:allBtn];
    
    UILabel * textlab5 = [[UILabel alloc] init];
    textlab5.font = [UIFont systemFontOfSize:15];
    textlab5.textColor = CharacterDarkColor;
    textlab5.text = @"提现,";
    [allBtn addSubview:textlab5];
    
    [textlab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(allBtn).offset(15);
        make.centerY.equalTo(allBtn);
    }];
    UILabel * textlab6 = [[UILabel alloc] init];
    textlab6.font = [UIFont systemFontOfSize:15];
    textlab6.textColor = BlueColor;
    textlab6.text = @"全部提现";
    [allBtn addSubview:textlab6];
    
    [textlab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(textlab5.mas_trailing).offset(15);
        make.centerY.equalTo(allBtn);
    }];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, ScreenW, 50)];
    self.tableView.tableFooterView = self.footerView;
    
    UILabel * textlab7 = [[UILabel alloc] init];
    textlab7.font = [UIFont systemFontOfSize:13];
    textlab7.textColor = CharacterLightGrayColor;
    textlab7.text = @"1-5个工作日到账";
    [self.footerView addSubview:textlab7];
    
    [textlab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.footerView).offset(15);
        make.centerY.equalTo(self.footerView);
    }];
    
}
//选择地址
- (void)selectAddressClick{
    LxmAddressVC * vc = [[LxmAddressVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
//全部提现
- (void)allBtnClick{
    self.putinMoneyTF.text = self.infoModel.money;
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
    if (ISLOGIN) {
        if (!self.addressModel) {
            [SVProgressHUD showErrorWithStatus:@"请选择提现地址!"];
            return;
        }
        if (self.putinMoneyTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入提现金额!"];
            return;
        }
        if ([self.putinMoneyTF.text intValue] < 1) {
            [SVProgressHUD showErrorWithStatus:@"提现金额至少1元"];
            return;
        }
        if ([self.putinMoneyTF.text intValue] > [self.infoModel.money intValue]) {
            [SVProgressHUD showErrorWithStatus:@"提现金额不能超过账户余额"];
            return;
        }
        
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"addrId":self.addressModel.addrId,
                               @"money":self.putinMoneyTF.text
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertCashLog] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                if (self.refreshPreVC) {
                    self.refreshPreVC();
                };
                LxmTiXianSuccessAlertView * alertView = [[LxmTiXianSuccessAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                });
               
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
    
  
}


@end
