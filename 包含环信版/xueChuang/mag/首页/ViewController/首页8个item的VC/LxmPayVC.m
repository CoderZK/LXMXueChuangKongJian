//
//  LxmPayVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPayVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LxmLvYouAndPaiMaiVC.h"
#import "LxmBaomingDetailVC.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "LxmTaskDetailVC.h"

@interface LxmPayVC ()<WXApiManagerDelegate>
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , assign) NSInteger  selectRow;
@property (nonatomic , strong) NSString * money;
//1 报名订单  2 旅游报名 3 我购买的技能 4 支付电商 
@property (nonatomic , assign) NSInteger type;

@end

@implementation LxmPayVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(NSInteger)type{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFuBaoNoti:) name:@"ZhiFuBaoPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayNoti:) name:@"WXPAY" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择支付方式";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initBottomView];
    [self getMyAssetsInfo];
    [WXApiManager sharedManager].delegate = self;
}
- (void)getMyAssetsInfo{
    
    [LxmNetworking networkingPOST:[LxmURLDefine user_getMyAssetsInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            self.money = responseObject[@"result"][@"money"];
            
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)zhiFuBaoNoti:(NSNotification *)noti{
    NSDictionary *resultDic = noti.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        //用户取消支付
        [SVProgressHUD showErrorWithStatus:@"取消支付"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.type == 1) {
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                LxmTaskDetailVC *taskDetailViewController = [[LxmTaskDetailVC alloc] init];
                taskDetailViewController.billId = [NSNumber numberWithInt:self.billId.intValue];
                taskDetailViewController.backViewControlller = self.backViewController;
                taskDetailViewController.jumpType = 1;
                [self.navigationController pushViewController:taskDetailViewController animated:YES];
            }else if (self.type == 2){
                [SVProgressHUD showSuccessWithStatus:@"报名成功"];
                NSArray * arr = self.navigationController.viewControllers;
                for (BaseViewController * vc in arr) {
                    if ([vc isKindOfClass:[LxmLvYouAndPaiMaiVC class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    if ([vc isKindOfClass:[LxmBaomingDetailVC class]]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        if (self.refreshPreVC) {
                            self.refreshPreVC();
                        }
                    }
                }
            }else{
                 [SVProgressHUD showSuccessWithStatus:@"购买成功"]; [self.navigationController popViewControllerAnimated:YES];
                if (self.refreshPreVC) {
                    self.refreshPreVC();
                }
            }
        });
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }

}

- (void)wechatPayNoti:(NSNotification *)noti{
    BaseResp * resp = noti.object;
    if (resp.errCode==WXSuccess)
    {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.type == 1) {
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                LxmTaskDetailVC *taskDetailViewController = [[LxmTaskDetailVC alloc] init];
                taskDetailViewController.billId = [NSNumber numberWithInt:self.billId.intValue];
                taskDetailViewController.jumpType = 1;
                taskDetailViewController.backViewControlller = self.backViewController;
                [self.navigationController pushViewController:taskDetailViewController animated:YES];
            }else if (self.type == 2){
                [SVProgressHUD showSuccessWithStatus:@"报名成功"];
                NSArray * arr = self.navigationController.viewControllers;
                for (BaseViewController * vc in arr) {
                    if ([vc isKindOfClass:[LxmLvYouAndPaiMaiVC class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    if ([vc isKindOfClass:[LxmBaomingDetailVC class]]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        if (self.refreshPreVC) {
                            self.refreshPreVC();
                        }
                    }
                }
            }else{
                [SVProgressHUD showSuccessWithStatus:@"购买成功"]; [self.navigationController popViewControllerAnimated:YES];
                if (self.refreshPreVC) {
                    self.refreshPreVC();
                }
            }
        });
    }
    else if (resp.errCode==WXErrCodeUserCancel)
    {
        [SVProgressHUD showErrorWithStatus:@"用户取消了支付"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
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
    [self.bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}

//去支付
- (void)bottomBtnClick{
    
    if (self.orderMoney.floatValue > self.money.floatValue&&self.selectRow == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式!"];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary * dict = @{@"token":SESSION_TOKEN,
                            @"orderId":self.orderID,
                            @"payType":@(self.selectRow+1)
                            };
    NSString * str = @"";
    if (self.type == 1) {
        str = [LxmURLDefine user_payHelpOrder];
    }else if (self.type == 2){
        str = [LxmURLDefine user_payTourOrder];
    }else if (self.type == 3){
        str = [LxmURLDefine user_payCanOrder];
    }else if (self.type == 4){
        str = [LxmURLDefine user_payECOrder];
    }
    
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            if (self.selectRow + 1 == 1) {
                if (self.type == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    LxmTaskDetailVC *taskDetailViewController = [[LxmTaskDetailVC alloc] init];
                    taskDetailViewController.billId = [NSNumber numberWithInt:self.billId.intValue];
                    taskDetailViewController.jumpType = 1;
                    taskDetailViewController.backViewControlller = self.backViewController;
                    [self.navigationController pushViewController:taskDetailViewController animated:YES];
                }else if (self.type == 2){
                    [SVProgressHUD showSuccessWithStatus:@"报名成功"];
                    NSArray * arr = self.navigationController.viewControllers;
                    for (BaseViewController * vc in arr) {
                        if ([vc isKindOfClass:[LxmLvYouAndPaiMaiVC class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                        if ([vc isKindOfClass:[LxmBaomingDetailVC class]]) {
                            [self.navigationController popViewControllerAnimated:YES];
                            if (self.refreshPreVC) {
                                self.refreshPreVC();
                            }
                        }
                    }
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.refreshPreVC) {
                        self.refreshPreVC();
                    }
                }
                
            }else if(self.selectRow + 1 == 2){
                //发起支付
                NSString *orderString = responseObject[@"result"][@"orderString"];
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"com.biuwork.xckj.safepay" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }else{
                //微信支付
                NSDictionary * dict = responseObject[@"result"];
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"paySign"];
                [WXApi sendReq:req];
            }
        } else {
             UIAlertController * alertController = [UIAlertController alertControllerWithTitle:responseObject[@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPayCell"];
    if (!cell)
    {
        cell = [[LxmPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPayCell"];
    }
    if (indexPath.row == 0) {
        cell.iconImgView.image = [UIImage imageNamed:@"zhanghu"];
        if (self.orderMoney.floatValue>self.money.floatValue) {
            cell.userInteractionEnabled = NO;
            cell.titleLab.text = @"账户余额不足";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BGGrayColor;
            cell.accImgView.image = [UIImage imageNamed:@"xuanze"];
        }else{
            cell.userInteractionEnabled = YES;
            cell.backgroundColor = UIColor.whiteColor;
            cell.titleLab.text = [NSString stringWithFormat:@"账户余额 ￥%@",self.money];
            cell.accImgView.image = [UIImage imageNamed:indexPath.row == self.selectRow?@"tijiao":@"xuanze"];
        }
    }else if (indexPath.row == 1){
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = UIColor.whiteColor;
        cell.iconImgView.image = [UIImage imageNamed:@"zhifubao2"];
        cell.titleLab.text = @"支付宝支付";
        cell.accImgView.image = [UIImage imageNamed:indexPath.row == self.selectRow?@"tijiao":@"xuanze"];
    }else{
        cell.userInteractionEnabled = YES;
        cell.iconImgView.image = [UIImage imageNamed:@"wechat2"];
        cell.titleLab.text = @"微信支付";
        cell.accImgView.image = [UIImage imageNamed:indexPath.row == self.selectRow?@"tijiao":@"xuanze"];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectRow = indexPath.row;
    [self.tableView reloadData];
}

@end

@implementation LxmPayCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.accImgView];
        [self setConstrains];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}
- (void)setConstrains{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@30);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.width.height.equalTo(@20);
    }];
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = CharacterDarkColor;
    }
    return _titleLab;
}
- (UIImageView *)accImgView{
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"xuanze_2"];
    }
    return _accImgView;
}

@end
