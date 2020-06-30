//
//  LxmPublishVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPublishVC.h"
#import "LxmPublishItemView.h"
#import "LxmPublishDanVC.h"
#import "LxmPublishAbleDanVC.h"
#import "TabBarController.h"

@interface LxmPublishVC ()<UIAlertViewDelegate>
@property (nonatomic , strong)UIView * headerView;
@property (nonatomic , strong)LxmPublishItemView * itemView1;
@property (nonatomic , strong)UILabel * titleLab;
@property (nonatomic , strong)LxmPublishItemView * itemView2;
@property (nonatomic , strong)NSMutableArray * arr1;
@property (nonatomic , strong)NSMutableArray * arr2;
@end

@implementation LxmPublishVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [LxmEventBus registerEvent:@"publishAbleSuccess" block:^(id data) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [LxmEventBus registerEvent:@"publishAbleDanSuccess" block:^(id data) {
        UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([vc isKindOfClass:[TabBarController class]]) {
           TabBarController *tabbar = (TabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            tabbar.selectedIndex = 1;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"发活";
    UIButton * leftbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 2*(ceil(4/3.0)*(80+(ScreenW-80*3-60)/2)+15+15-((ScreenW-80*3-60)/2))+50+30)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    
    self.itemView1 = [[LxmPublishItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 15+ceil(4/3.0)*(80+(ScreenW-80*3-60)/2)+15-((ScreenW-80*3-60)/2))];
    __weak typeof(self)safe_self = self;
    self.itemView1.clickBlock = ^(NSInteger item) {
        [safe_self publishWithItem:item];
    };
    self.itemView1.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.itemView1];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ceil(4/3.0)*(80+(ScreenW-80*3-60)/2)+15+15-((ScreenW-80*3-60)/2), ScreenW, 50)];
    self.titleLab.text = @"校园商家发活";
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.titleLab];
    
    self.itemView2 = [[LxmPublishItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), ScreenW, 15+ceil(4/3.0)*(80+(ScreenW-80*3-60)/2)+15-((ScreenW-80*3-60)/2))];
    self.itemView2.clickBlock = ^(NSInteger item) {
        [safe_self ablePublishWithItem:item];
    };
    self.itemView2.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.itemView2];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@0.5);
    }];
    
    self.arr1 = [NSMutableArray array];
    self.arr2 = [NSMutableArray array];
    
    [self getReleadeTypeList];
    [self loadMyInfoDataWithShowSVProgressHUD:NO];
    
}

- (void)getReleadeTypeList{
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine user_findReleaseTypeList] parameters:@{@"token":SESSION_TOKEN} returnClass:[LxmHomeBannerRootModel class] success:^(NSURLSessionDataTask *task, LxmHomeBannerRootModel* responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1) {
            NSArray<LxmHomeBannerModel * > * arr = responseObject.result;
            
            for (LxmHomeBannerModel * model in arr) {
                if (model.type.intValue == 2) {
                    [self.arr1 addObject:model];
                }else if (model.type.intValue == 4){
                     [self.arr2 addObject:model];
                }
            }
            self.itemView1.dataArr = self.arr1;
            self.itemView2.dataArr = self.arr2;
            
            self.headerView.frame = CGRectMake(0, 0, ScreenW, (ceil(self.arr1.count/3.0)*(80+(ScreenW-80*3-60)/2)+(ceil(self.arr1.count/3.0)*(80+(ScreenW-80*3-60)/2)+15+15-((ScreenW-80*3-60)/2))+50+30));
            self.itemView1.frame = CGRectMake(0, 0, ScreenW, 15+ceil(self.arr1.count/3.0)*(80+(ScreenW-80*3-60)/2)+15-((ScreenW-80*3-60)/2));
            self.titleLab.frame = CGRectMake(0, ceil(self.arr1.count/3.0)*(80+(ScreenW-80*3-60)/2)+15+15-((ScreenW-80*3-60)/2), ScreenW, 50);
            self.itemView2.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), ScreenW, 15+ceil(self.arr2.count/3.0)*(80+(ScreenW-80*3-60)/2)+15-((ScreenW-80*3-60)/2));
        }else{
            [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadMyInfoDataWithShowSVProgressHUD:(BOOL)show{
    if (show == YES) {[SVProgressHUD show];}
    [LxmNetworking networkingPOST:[LxmURLDefine user_getMyInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
                [LxmTool ShareTool].userModel = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            if (show == YES) {[SVProgressHUD showSuccessWithStatus:@"获取认证信息成功"];}
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (show == YES) {[SVProgressHUD showErrorWithStatus:@"获取认证信息失败"];}
    }];
}

- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publishWithItem:(NSInteger)item{
    if ([LxmTool ShareTool].userModel.type == 4) {
        LxmHomeBannerModel * model = [self.arr1 objectAtIndex:item];
        LxmPublishDanVC * vc = [[LxmPublishDanVC alloc] initWithTableViewStyle:UITableViewStyleGrouped LxmHomeBannerModel:model];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([LxmTool ShareTool].userModel.type == 3) {
        [SVProgressHUD showErrorWithStatus:@"还未实名认证"];
    }else {
        [self showAlaterView];
    }
}

- (void)ablePublishWithItem:(NSInteger)item{
    
    if ([LxmTool ShareTool].userModel.type == 4) {
        LxmHomeBannerModel * model = [self.arr2 objectAtIndex:item];
        LxmPublishAbleDanVC * vc = vc = [[LxmPublishAbleDanVC alloc] initWithTableViewStyle:UITableViewStyleGrouped LxmHomeBannerModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([LxmTool ShareTool].userModel.type == 3) {
        [SVProgressHUD showErrorWithStatus:@"还未实名认证"];
    }else {
        [self showAlaterView];
    }
}

- (void)showAlaterView {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"还未获取认证信息,是否获取" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadMyInfoDataWithShowSVProgressHUD:YES];
    }]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
