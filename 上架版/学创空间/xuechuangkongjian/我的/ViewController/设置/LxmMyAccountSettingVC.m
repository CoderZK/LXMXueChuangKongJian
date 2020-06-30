//
//  LxmMySettingVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyAccountSettingVC.h"
#import "LxmBindPhoneVC.h"
#import "LxmHuanBindPhoneVC.h"
#import "LxmForgetPasswordVC.h"
#import "BaseNavigationController.h"
#import "LxmAlipayAuthInfoModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UMShare/UMShare.h>

@interface LxmMyAccountSettingVC ()
@property (nonatomic , strong)  LxmAccountInfoModel * accountModel;
@property (nonatomic , strong)  NSString * zhifubaoCode;
@end

@implementation LxmMyAccountSettingVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFuBaoNoti:) name:@"ZhiFuBaoRenZheng" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bandsuccess) name:@"bandSuccess" object:nil];
}

- (void)bandsuccess {
    self.accountModel = nil;
    [self loadAccountInfo];
}

- (void)zhiFuBaoNoti:(NSNotification *)noti {
    NSDictionary *resultDic = noti.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        [SVProgressHUD showErrorWithStatus:@"用户取消了授权"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        [SVProgressHUD showSuccessWithStatus:@"授权成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *parmasArr = [resultDic[@"result"] componentsSeparatedByString:@"&"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *parma in parmasArr) {
                NSArray *tempArr = [parma componentsSeparatedByString:@"="];
                if (tempArr.count == 2) {
                    [dict setObject:tempArr.lastObject forKey:tempArr.firstObject];
                }
            }
            if ([dict[@"result_code"] isEqualToString:@"200"]) {
                //auth_code表示授权成功的授码。
                NSString * str = dict[@"auth_code"];
                self.zhifubaoCode = str;
                [self getThirdInfoDataWithAuthCode:str];
                
            }else if ([dict[@"result_code"] isEqualToString:@"1005"]){
                [SVProgressHUD showErrorWithStatus:@"账户已冻结"];
            }else if ([dict[@"result_code"] isEqualToString:@"202"]){
                [SVProgressHUD showErrorWithStatus:@"系统异常，请稍后再试"];
            }
        });
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
        [SVProgressHUD showErrorWithStatus:@"系统异常"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"授权失败"];
    }
}

- (void)getThirdInfoDataWithAuthCode:(NSString *)code {
    [self bindThirdWithType:@"1" withModel:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号设置";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadAccountInfo];
}
- (void)loadAccountInfo {
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getAccountInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                self.accountModel = [LxmAccountInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?(LxmTool.ShareTool.isShenHe ? 1 : 4):1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        line.backgroundColor = LineColor;
        [cell addSubview:line];
      
    }
    cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = cell.detailTextLabel.textColor = CharacterDarkColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = [self.accountModel.phone isEqualToString:@""]?@"未绑定":self.accountModel.phone;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"支付宝";
            cell.detailTextLabel.text = [self.accountModel.alipay isEqualToString:@""]?@"未绑定":self.accountModel.alipay;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"微信";
            cell.detailTextLabel.text = [self.accountModel.weChat isEqualToString:@""]?@"未绑定":self.accountModel.weChat;
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"QQ";
            cell.detailTextLabel.text = [self.accountModel.QQ isEqualToString:@""]?@"未绑定":self.accountModel.QQ;
        }
    }else{
        cell.textLabel.text = @"修改密码";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([self.accountModel.phone isEqualToString:@""]) {
                //手机号
                LxmBindPhoneVC * vc = [[LxmBindPhoneVC alloc] init];
                vc.refreshPreVC = ^{
                    self.accountModel = nil;
                    [self loadAccountInfo];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //换绑手机
                LxmHuanBindPhoneVC * vc = [[LxmHuanBindPhoneVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmHuanBindPhoneVC_type_first];
                vc.phone = self.accountModel.phone;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (indexPath.row == 1){
            if ([self.accountModel.alipay isEqualToString:@""]) {
                [self renzhewngWithType:@"1"];
            }
        }else if (indexPath.row == 2){
            if ([self.accountModel.weChat isEqualToString:@""]) {
                [self renzhewngWithType:@"2"];
            }
        }else if (indexPath.row == 3){
            if ([self.accountModel.QQ isEqualToString:@""]) {
                [self renzhewngWithType:@"3"];
            }
        }
    }else{
        if ([self.accountModel.phone isEqualToString:@""]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"未设置密码,请先绑定手机" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            LxmForgetPasswordVC * vc = [[LxmForgetPasswordVC alloc] init];
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
- (void)renzhewngWithType:(NSString *)type{
    if (ISLOGIN) {
        if (type.intValue == 1) {
            LxmAlipayAuthInfoModel *model = [LxmAlipayAuthInfoModel new];
            model.appID = @"2019121769968589";
            model.pid =   @"2088731024827837";
            NSString *info = [model getInfoStr];
            [[AlipaySDK defaultService] auth_V2WithInfo:info fromScheme:@"com.biuwork.xckj.alipayrenzheng" callback:^(NSDictionary *resultDic) {
                NSLog(@"%@",resultDic);
            }];
        }else if (type.intValue == 2){
            [self getAuthWithUserInfoFromWechat];
        }else if(type.intValue == 3){
            [self getAuthWithUserInfoFromQQ];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
    
}

//QQ登录
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            LxmThirdInfoModel * info = [[LxmThirdInfoModel alloc] init];
            info.threeId = resp.uid;
            info.threeName = resp.name;
            info.headimg = resp.iconurl;
            info.type = 3;
            [self loadWithThirdInfo:info];
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}


// 微信登录
#import <UMShare/UMShare.h>

- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            LxmThirdInfoModel * info = [[LxmThirdInfoModel alloc] init];
            info.threeId = resp.uid;
            info.threeName = resp.name;
            info.headimg = resp.iconurl;
            info.type = 2;
            [self loadWithThirdInfo:info];
        }
    }];
}

- (void)loadWithThirdInfo:(LxmThirdInfoModel *)info{
     [self bindThirdWithType:@(info.type).stringValue withModel:info];
}

- (void)bindThirdWithType:(NSString *)type withModel:(LxmThirdInfoModel *)infoModel{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    if (type.intValue == 1) {
        dict[@"code"] = self.zhifubaoCode;
    }else{
        dict[@"threeId"] = infoModel.threeId;
        dict[@"threeName"] = infoModel.threeName;
    }
    dict[@"type"] = type;
    [LxmNetworking networkingPOST:[LxmURLDefine user_bindingThree] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功!"];
            [self loadAccountInfo];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}



@end
