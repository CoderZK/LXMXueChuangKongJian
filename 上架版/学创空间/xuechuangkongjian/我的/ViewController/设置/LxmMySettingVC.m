//
//  LxmMySettingVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMySettingVC.h"
#import "LxmMyAccountSettingVC.h"
#import "LxmLoginAndRegisterVC.h"
#import "BaseNavigationController.h"
#import "LxmHeaderImgView.h"
#import "LxmWebViewController.h"
#import "NSFileManager+FileSize.h"
#import <UShareUI/UShareUI.h>

@interface LxmMySettingVC ()<UMSocialShareMenuViewDelegate>
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , assign)CGFloat cacheSize;
@end

@implementation LxmMySettingVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    self.cacheSize = [NSFileManager getFileSizeForDir:path];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initBottomView];
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
    [self.bottomBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}
//退出登录
- (void)bottomBtnClick{
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_logout] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"key"] intValue] == 10003) {
                
                [LxmTool ShareTool].deviceToken = @"";
                [[LxmTool ShareTool] uploadDeviceToken];
                
                [LxmTool ShareTool].userModel = nil;
                [LxmTool ShareTool].isLogin = NO;
                [LxmTool ShareTool].session_token = nil;
                LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
                
            }else if ([[responseObject objectForKey:@"key"] intValue] == 7){
                
                [LxmTool ShareTool].deviceToken = @"";
                [[LxmTool ShareTool] uploadDeviceToken];
                
                [LxmTool ShareTool].userModel = nil;
                [LxmTool ShareTool].isLogin = NO;
                [LxmTool ShareTool].session_token = nil;
                
                LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
            }else{
                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell0"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCel0"];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
            line.backgroundColor = LineColor;
            [cell addSubview:line];
            
            UILabel * dataLab = [[UILabel alloc] init];
            dataLab.textColor = CharacterDarkColor;
            dataLab.font = [UIFont systemFontOfSize:16];
            dataLab.tag = 11;
            [cell addSubview:dataLab];
            [dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell).offset(-15-20);
                make.centerY.equalTo(cell);
            }];
        }
        UILabel * datalab = (UILabel *)[cell viewWithTag:11];
        datalab.text = [NSString stringWithFormat:@"%.2fM",self.cacheSize];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CharacterDarkColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"清除缓存";
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
            line.backgroundColor = LineColor;
            [cell addSubview:line];
            
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CharacterDarkColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"账号设置";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"分享应用";
        }else{
            cell.textLabel.text = @"关于我们";
        }
         return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    footerView.contentView.backgroundColor = BGGrayColor;
    return footerView;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //清除缓存
        if (_cacheSize>0)
        {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                self.cacheSize=0;
                [SVProgressHUD showSuccessWithStatus:@"清理成功" ];
                [self.tableView reloadData];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"暂无缓存可清理!"];
        }
    }else{
        if (indexPath.row == 0) {
            LxmMyAccountSettingVC * vc = [[LxmMyAccountSettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //分享应用
            [self loadShareData];
            
        }else{
            //关于我们
            [LxmNetworking networkingPOST:[LxmURLDefine app_getBaseInfo] parameters:@{@"type":@6} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                    NSString * str = responseObject[@"result"][@"substance"];
                    if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) {
                        str = @"";
                    }else{
                        str = str;
                    }
                    LxmWebViewController * vc = [[LxmWebViewController alloc] init];
                    vc.navigationItem.title = @"关于我们";
                    vc.loadUrl = [NSURL URLWithString:str];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }
}

//获取分享信息
- (void)loadShareData{
    if (ISLOGIN&&SESSION_TOKEN) {
        [LxmNetworking networkingPOST:[LxmURLDefine app_shareInfo] parameters:@{@"type":@6,@"id":@([LxmTool ShareTool].userModel.userId),@"deviceType":@"2"} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                //分享
                LxmShareInfoModel * shareModel = [LxmShareInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                // self继承自UIViewController
                [UMSocialUIManager setShareMenuViewDelegate:self];
                [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_AlipaySession)]];
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    [self shareWithtype:platformType withModel:shareModel];
                }];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)shareWithtype:(UMSocialPlatformType)platformType withModel:(LxmShareInfoModel *)model {
    // 根据获取的platformType确定所选平台进行下一步操作
    if (platformType == UMSocialPlatformType_WechatSession) {
        [self shareWeChatTitle:model.title content:model.content pic:model.pic url:model.url ok:nil error:nil];
    }else if (platformType == UMSocialPlatformType_WechatTimeLine){
        [self shareWXPYQTitle:model.title content:model.content pic:model.pic url:model.url ok:nil error:nil];
    }else if (platformType == UMSocialPlatformType_QQ){
        [self shareQQTitle:model.title content:model.content pic:model.pic url:model.url ok:nil error:nil];
    }else{
        //支付宝
        [self shareZFBTitle:model.title content:model.content pic:model.pic url:model.url  ok:nil error:nil];
    }
}

@end
