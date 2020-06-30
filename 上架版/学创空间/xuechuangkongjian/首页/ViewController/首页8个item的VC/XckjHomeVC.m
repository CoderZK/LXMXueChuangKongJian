//
//  XckjHomeVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "XckjHomeVC.h"
#import "SNY_AdScrollView.h"
#import "LxmHomeItemView.h"
#import "LxmHomeCell.h"
#import "XckjQiangDanVC.h"
#import "XckjLvYouAndPaiMaiVC.h"
#import "AroundVC.h"
#import "GoodListVC.h"
#import "LxmWebViewController.h"
#import "TaskDetailVC.h"
#import "LxmLoginAndRegisterVC.h"
#import "SNYQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
//#import "ZBarSDK.h"
#import "LxmMyPageVC.h"
#import "LxmFullInfoVC.h"
#import "BaseNavigationController.h"
#import "XckjLvAndPaiMaiDetailVC.h"
#import "AroundDetailVC.h"
#import "SNY_AdScrollView.h" //顺序图
#import "GoodsDetailVC.h"
#import "LxmZaiShouVC.h"
#import "LxmPayMoneyAbleVC.h"
#import "TabBarController.h"
#import "LxmHomeNewItemView.h"
#import "LxmHomeNewCell.h"

@interface XckjHomeVC ()<SNY_AdScrollViewDelegate,LxmHomeNewCellDelegate,SNYQRCodeVCDelegate,SNY_AdScrollViewDelegate>
@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) SNY_AdScrollView * bannerView;

@property (strong, nonatomic) SNY_AdScrollView *cycleScrollView; //轮播的控件
@property (strong, nonatomic) NSMutableArray <LxmHomeBannerModel *> *cycleScrollViewModelArray;//轮播的内容

//@property (nonatomic , strong) LxmHomeItemView * itemView;

@property (nonatomic , strong) LxmHomeNewItemView * itemNewView;//新版itemView

@property (nonatomic , strong) UIImageView * gudingImgView;

/**
 baner数据
 */
@property (nonatomic , strong) NSArray * bannerArr;

/**
 8大模块数据
 */
@property (nonatomic , strong) NSArray * itemArr;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;

@end

@implementation XckjHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    WeakObj(self);
    [LxmEventBus registerEvent:@"publishAbleSuccess" block:^(id data) {//校园商家发布成功
           selfWeak.page = 1;
           [selfWeak loadHomeList];
    }];
    [LxmEventBus registerEvent:@"cancelPublishAbleSuccess" block:^(id data) {//取消校园商家发布的订单
        selfWeak.page = 1;
        [selfWeak loadHomeList];
    }];
   
    
    
    //初始化数据
    self.cycleScrollViewModelArray = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initHeaderView];
    
    UIButton * leftbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"ico_saomiao"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    
    if (ISLOGIN == NO) {
        //如果没有登录请立即登
        LxmLoginAndRegisterVC * logInAndRegisterViewController = [[LxmLoginAndRegisterVC alloc] init];
        logInAndRegisterViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *uiNavC = [[UINavigationController alloc] initWithRootViewController:logInAndRegisterViewController];
        [self presentViewController:uiNavC animated:YES completion:nil];
    } else {
       [self loadHasPerfect]; //请求个人信息是否完善
        [LxmEventBus registerEvent:@"yilahei" block:^(id data) {
            [self loadHasPerfect]; //请求个人信息是否完善
        }];
    }
}

 //请求个人信息是否完善的网络请求
- (void)loadHasPerfect {
    [LxmNetworking networkingPOST:[LxmURLDefine user_hasPerfect] parameters:@{@"token":[LxmTool ShareTool].session_token} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1)
        {
            NSNumber * num = responseObject[@"result"][@"hasPerfect"];
            if (num.intValue == 1) {
                //如果已经完善了那么就直接更新UI界面
                [self upDataConfigUI];
            } else {//信息不完善
                LxmFullInfoVC * vc  = [[LxmFullInfoVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 更新UI界面
 */
- (void)upDataConfigUI {
    
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        safe_self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        self.bannerArr = nil;
        self.itemArr = nil;
        [safe_self loadHomeList];
        [safe_self loadBannerData];
        [safe_self loadHomeItem];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [safe_self loadHomeList];
    }];
    
    [self loadHomeList];
    [self loadBannerData];
    [self loadHomeItem];
}


- (void)scanBtnClick{
    //扫一扫 加好友
    SNYQRCodeVC * vc = [[SNYQRCodeVC alloc] init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SNYQRCodeVCDelegate

- (void)SNYQRCodeVC:(SNYQRCodeVC *)vc scanResult:(NSString *)str {
    
    [vc.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //加好友
        [self loadOtherInfoDataWithID:@(str.integerValue)];
    });
    
}

- (void)loadHomeList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{@"token":SESSION_TOKEN,
                                @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findIndexHelpList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmHomeRootModel class] success:^(NSURLSessionDataTask *task, LxmHomeRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmHomeModel1 * model = responseObject.result;
                NSArray * dataArr =  [NSMutableArray arrayWithArray:model.list];
                [self.dataArr addObjectsFromArray:dataArr];
                self.time = model.time;
                
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
     
    }
}

//获取banner列表
- (void)loadBannerData{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_findBannerList] parameters:@{@"token":[LxmTool ShareTool].session_token} returnClass:[LxmHomeBannerRootModel class] success:^(NSURLSessionDataTask *task, LxmHomeBannerRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                [self.cycleScrollViewModelArray removeAllObjects];
                [self.cycleScrollViewModelArray addObjectsFromArray:responseObject.result];
                self.cycleScrollView.dataArr = self.cycleScrollViewModelArray;
                
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
    
}

//获取首页8大模块
- (void)loadHomeItem{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_findMuduleList] parameters:@{@"token":SESSION_TOKEN} returnClass:[LxmHomeBannerRootModel class] success:^(NSURLSessionDataTask *task, LxmHomeBannerRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.itemArr = responseObject.result;
                
                self.itemNewView.itemArr = self.itemArr;
                
                self.itemNewView.frame =  CGRectMake(0, 0, ScreenW, ceil(self.itemArr.count/2.0)*55 + 15);
                
                self.gudingImgView.frame = CGRectMake(15, CGRectGetMaxY(self.itemNewView.frame), ScreenW - 30, (ScreenW*180/750));
                
                self.cycleScrollView.frame = CGRectMake(15, CGRectGetMaxY(self.gudingImgView.frame) + 10, ScreenW - 30, (ScreenW - 30) * 260/750.0);
                
                self.headerView.frame = CGRectMake(0, 0, ScreenW, CGRectGetMaxY(self.cycleScrollView.frame) + 15) ;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
   
}

- (void)initHeaderView{
    
    WeakObj(self);
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100 + (ScreenW - 30) * 260/750.0 + (ScreenW*180/750) + 15)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    
    self.itemNewView = [[LxmHomeNewItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.itemNewView.clickBlock = ^(LxmHomeBannerModel *model) {
        [selfWeak toPageWith:model];
    };
    [self.headerView addSubview:self.itemNewView];
    
    self.gudingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.itemNewView.frame), ScreenW - 30, (ScreenW*180/750))];
    self.gudingImgView.image = [UIImage imageNamed:@"homeBannerView"];
    self.gudingImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diansahngClick)];
    [self.gudingImgView addGestureRecognizer:tap];
    self.gudingImgView.layer.cornerRadius = 10;
    self.gudingImgView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.gudingImgView];
    
    //轮播图
    self.cycleScrollView = [[SNY_AdScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.gudingImgView.frame) + 10, ScreenW - 30, (ScreenW - 30) * 260/750.0)];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.layer.cornerRadius = 10;
    self.cycleScrollView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.cycleScrollView];
    
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@0.5);
    }];
}
- (void)diansahngClick{
    GoodListVC * vc = [[GoodListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sny_adScrollView:(SNY_AdScrollView *)scrollView selectedIndex:(NSInteger)index {
    NSLog(@"did select at index: %ld", (long)index);
    LxmHomeBannerModel * model = [self.cycleScrollViewModelArray lxm_object1AtIndex:index];
    if (model.type.intValue == 1) {
        [self loadBannerDetailWith:model.bannerId];
    }else if (model.type.intValue == 2){
        //文章
        if ([model.typeId intValue] == 9) {
            AroundDetailVC *aroundDetailViewController = [[AroundDetailVC alloc] init];
            aroundDetailViewController.nearId = model.otherId;
            aroundDetailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aroundDetailViewController animated:YES];
        }else {
            XckjLvAndPaiMaiDetailVC *  vc = [[XckjLvAndPaiMaiDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped typeModel:nil type:model.typeId];
            vc.textId = model.otherId.stringValue;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (model.type.intValue == 3){
        //电商
        GoodsDetailVC *goodDetailViewController = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_goodsDetail];
        LxmCanListModel * mmm = [[LxmCanListModel alloc] init];
        mmm.ecId = model.otherId;
        goodDetailViewController.model = mmm;
        
//        goodDetailViewController.billId = model.otherId;
        goodDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodDetailViewController animated:YES];
    }
}

- (void)loadBannerDetailWith:(NSNumber *)bannerID{
    [LxmNetworking networkingPOST:[LxmURLDefine user_findBannerInfo] parameters:@{@"token":SESSION_TOKEN,@"bannerId":bannerID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            //富文本
            NSString * contentStr = responseObject[@"result"][@"content"];
            NSString * ss = @"<div style=\"font-size: 40px;overflow: hidden;width: 100%\"><style>img{max-width:100%;display:block;margin:0 auto;width: 100%}</style>";
            
            NSString * content = [NSString stringWithFormat:@"%@%@</div>", ss, contentStr];
            LxmWebViewController * webVC = [[LxmWebViewController alloc] init];
            webVC.navigationItem.title = @"图文详情";
            [webVC loadHtmlStr:content withBaseUrl:Base_URL];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeNewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeNewCell"];
    if (!cell)
    {
        cell = [[LxmHomeNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeNewCell" isMine:NO];
    }
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    model.pageType = 1;
    model.isDetail = NO;
    cell.model = model;
    cell.delegate = self;
    __weak typeof(self)safe_self = self;
    cell.selectImgBlock = ^(NSInteger index) {
        LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
        TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
        detailVC.billId = model.billId;
        detailVC.hidesBottomBarWhenPushed = YES;
        [safe_self.navigationController pushViewController:detailVC animated:YES];
    };
    cell.pageToDetail = ^{
        LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
        TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
        detailVC.billId = model.billId;
        detailVC.hidesBottomBarWhenPushed = YES;
        [safe_self.navigationController pushViewController:detailVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
//    LxmHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeCell"];
//    if (!cell)
//    {
//        cell = [[LxmHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeCell" isMine:NO];
//    }
//    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
//    model.pageType = 1;
//    model.isDetail = NO;
//    cell.model = model;
//    cell.delegate = self;
//    __weak typeof(self)safe_self = self;
//    cell.selectImgBlock = ^(NSInteger index) {
//        LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
//        TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
//        detailVC.billId = model.billId;
//        detailVC.hidesBottomBarWhenPushed = YES;
//        [safe_self.navigationController pushViewController:detailVC animated:YES];
//    };
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeModel * model = [_dataArr lxm_object1AtIndex:indexPath.row];
    model.height = 10 + 15 + 130 + 15 + 60;
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmHomeModel * model = [_dataArr lxm_object1AtIndex:indexPath.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)toPageWith:(LxmHomeBannerModel *)model{
    
    if (ISLOGIN) {
        if (model.type.intValue == 2) {
            XckjQiangDanVC * vc  = vc = [[XckjQiangDanVC alloc] initWithTableViewStyle:UITableViewStylePlain currentModel:model];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (model.type.intValue == 3){
            if (model.ID.intValue == 9) {
                AroundVC * vc = [[AroundVC alloc] initWithTableViewStyle:UITableViewStylePlain type:AroundVC_type_home];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                XckjLvYouAndPaiMaiVC * vc = [[XckjLvYouAndPaiMaiVC alloc] initWithTableViewStyle:UITableViewStylePlain currentModel:model];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

//列表页点赞
- (void)LxmHomeNewCellZanClick:(LxmHomeCell *)cell{
    
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [_dataArr lxm_object1AtIndex:indexP.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)dianzanWithModel:(LxmHomeModel *)model{
    
}

- (void)imgCollectionClick:(LxmHomeCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [_dataArr lxm_object1AtIndex:indexP.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)headerImgViewClick:(LxmHomeNewCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [_dataArr lxm_object1AtIndex:indexP.row];
    if (model.isAnonymity.intValue != 1) {
        //跳转他人的个人主页
        [self loadOtherInfoDataWithID:model.relUserId];
    }
}

- (void)loadOtherInfoDataWithID:(NSNumber *)otherID{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getOthersInfo] parameters:@{@"token":SESSION_TOKEN,@"otherUserId":otherID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                LxmOtherInfoModel * otherModel = [LxmOtherInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                otherModel.otherUserID = otherID;
                LxmMyPageVC * vc1 = [[LxmMyPageVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmMyPageVC_type_other];
                vc1.otherInfoModel = otherModel;
                vc1.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc1 animated:YES];
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

@end
