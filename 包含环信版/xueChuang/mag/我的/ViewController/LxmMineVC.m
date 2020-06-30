//
//  LxmMineVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMineVC.h"
#import "LxmMineItem.h"
#import "LxmMineNormalCell.h"
#import "LxmMineUserInfoCell.h"
#import "LxmMyPageVC.h"
#import "LxmMyDanVC.h"
#import "LxmZaiShouVC.h"
#import "LxmPayMoneyAbleVC.h"
#import "LxmMyBaoMingVC.h"
#import "LxmMyPingJiaVC.h"
#import "LxmMyCollectionVC.h"
#import "LxmMyZiChanVC.h"
#import "LxmRenZhengVC.h"
#import "LxmMySettingVC.h"
#import "LxmLoginAndRegisterVC.h"
#import "LxmPayMoneyAbleVC.h"

@interface LxmMineVC ()
@property (nonatomic, strong) NSArray<NSArray<LxmMineItem *> *> *itemArr;
@end

@implementation LxmMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.itemArr = @[@[[LxmMineItem itemWithType:LxmMineItemType_info]],
                     @[[LxmMineItem itemWithType:LxmMineItemType_huo],
                       [LxmMineItem itemWithType:LxmMineItemType_jineng],
                       [LxmMineItem itemWithType:LxmMineItemType_goods]],
                     @[[LxmMineItem itemWithType:LxmMineItemType_wodebaoming],
                       [LxmMineItem itemWithType:LxmMineItemType_wodepingjia],
                       [LxmMineItem itemWithType:LxmMineItemType_wodeshoucang]],
                     @[[LxmMineItem itemWithType:LxmMineItemType_wodezichan],
                       [LxmMineItem itemWithType:LxmMineItemType_shimingrenzheng]]];
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"ico_shezhi"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    [self loadMyInfoData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpData) name:@"NOTIFICATION_MINE_USERINFO" object:nil];
    
}

- (void)loadMyInfoData{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getMyInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [LxmTool ShareTool].userModel = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)userInfoUpData {
    [self loadMyInfoData];
}

- (void)settingBtnClick{
    if (ISLOGIN) {
        //设置
        LxmMySettingVC * vc = [[LxmMySettingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.itemArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.itemArr[indexPath.section];
    LxmMineItem *item = arr[indexPath.row];
    if (item.type == LxmMineItemType_info) {
        LxmMineUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMineUserInfoCell"];
        if (!cell) {
            cell = [[LxmMineUserInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LxmMineUserInfoCell"];
        }
        cell.model = [LxmTool ShareTool].userModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        LxmMineNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMineNormalCell"];
        if (!cell) {
            cell = [[LxmMineNormalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LxmMineNormalCell"];
        }
        cell.imageView.image = [UIImage imageNamed:item.logoImg];
        cell.textLabel.text = item.title;
        if (item.type == LxmMineItemType_shimingrenzheng) {
            [LxmTool ShareTool].userModel.type = 3;
            cell.detailTextLabel.text = [LxmTool ShareTool].userModel.type == 4 ? @"已认证" : @"未认证";
        } else {
            cell.detailTextLabel.text = @"";
        }
        cell.showTopLine = indexPath.row != 0;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.itemArr[indexPath.section];
    LxmMineItem *item = arr[indexPath.row];
    
    BaseViewController * vc  = nil;
    if (item.type == LxmMineItemType_info) {
        if (ISLOGIN) {
            LxmMyPageVC * vc1 = [[LxmMyPageVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmMyPageVC_type_me];
            vc1.infoModel = [LxmTool ShareTool].userModel;
            vc1.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc1 animated:YES];
            
        }else{
            LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
       
    }else if(item.type == LxmMineItemType_huo){
        vc = [[LxmMyDanVC alloc] init];
    }else if(item.type == LxmMineItemType_jineng){
        vc = [[LxmZaiShouVC alloc] init];
    }else if (item.type == LxmMineItemType_goods){
        vc = [[LxmPayMoneyAbleVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmPayMoneyAbleVC_type_wgmdsp];
    }else if (item.type == LxmMineItemType_wodebaoming){
        vc = [[LxmMyBaoMingVC alloc] init];
    }else if (item.type == LxmMineItemType_wodepingjia){
        vc = [[LxmMyPingJiaVC alloc] init];
    }else if (item.type == LxmMineItemType_wodeshoucang){
        vc = [[LxmMyCollectionVC alloc] init];
    }else if (item.type == LxmMineItemType_wodezichan){
        vc = [[LxmMyZiChanVC alloc] init];
    }else if (item.type == LxmMineItemType_shimingrenzheng){
        if ([LxmTool ShareTool].userModel.type == 3) {
            LxmRenZhengVC * vc = [[LxmRenZhengVC alloc] init];
            vc.backViewController = self;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICATION_MINE_USERINFO" object:nil];
}

@end
