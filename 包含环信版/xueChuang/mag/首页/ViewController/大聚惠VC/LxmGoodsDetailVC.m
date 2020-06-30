//
//  LxmGoodsDetailVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmGoodsDetailVC.h"
#import <WebKit/WebKit.h>

#import "LxmTaskBottomView.h"
#import "LxmTaskDetailHeaderView.h"
#import "LxmTaskDetailCell.h"
#import "LxmYueDanPayVC.h"
#import <UShareUI/UShareUI.h>
#import <Hyphenate/Hyphenate.h>
#import "EaseMessageViewController.h"
#import "LxmImgCollectionView.h"
#import "LxmCanListTextCell.h"
#import "LxmCanListImgCell.h"
#import "LxmZaiShouVC.h"
#import "LxmPayMoneyAbleVC.h"
#import "LxmLoginAndRegisterVC.h"
#import "BaseNavigationController.h"

@interface LxmGoodsDetailVC ()<LxmTaskBottomViewDelegate,LxmTaskDetailHeaderViewDelegate,LxmTaskDetailCellDelegate,UMSocialShareMenuViewDelegate>
@property (nonatomic , assign) LxmGoodsDetailVC_type type;

@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) LxmGoodsDetailNavItemView * navItemView;
@property (nonatomic , strong) LxmGoodsDetailTableTopView * tableTopView;

@property (nonatomic , strong) WKWebView * webView;
@property (nonatomic , strong) LxmGoodsDetailTableBottomView * tableBottomView;

@property (nonatomic , strong) LxmTaskBottomView * bottomView;
@property (nonatomic , strong) LxmGoodsDetailModel * detailModel;


@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@property (nonatomic , strong) NSArray * imgs;
@end

@implementation LxmGoodsDetailVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmGoodsDetailVC_type)type{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navItemView = [[LxmGoodsDetailNavItemView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [headerView1 addSubview:self.navItemView];
    
    self.navigationItem.titleView = headerView1;
    
    [self.navItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView1);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
    }];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100+5+100)];
    self.headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableTopView = [[LxmGoodsDetailTableTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    __weak typeof(self)safe_self = self;
    self.tableTopView.zanBlock = ^{
        [safe_self dianzanwithType:@1 withMain:nil withReplyModel:nil];
    };
    [self.headerView addSubview:self.tableTopView];
    
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        //电商
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 100+5+100);
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, 100, ScreenW - 30, 5)];
        [self.webView sizeToFit];
        [self.headerView addSubview:self.webView];
        self.tableBottomView  = [[LxmGoodsDetailTableBottomView alloc] initWithFrame:CGRectMake(0, 105, ScreenW, 100)];
        if (self.type == LxmGoodsDetailVC_type_myJineng) {
            self.tableBottomView.liuYanView.liuYanLab.text = @"留言区(3)";
        }
         [self.headerView addSubview:self.tableBottomView];
    }else{
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 100);
    }
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        [rightBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    }
    
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
   
    
    if (self.type != LxmGoodsDetailVC_type_myJineng) {
        if (kDevice_Is_iPhoneX) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
            if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44 - StateBarH - 50-34 , ScreenW, 50+34) withStyle:LxmTaskBottomView_style_GoodsDetail];
            }else{
                self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44 - StateBarH - 50-34 , ScreenW, 50+34) withStyle:LxmTaskBottomView_style_yudan];
            }
        }else{
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 50);
            if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                   self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44 - StateBarH - 50 , ScreenW, 50) withStyle:LxmTaskBottomView_style_GoodsDetail];
            }else{
                   self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44 - StateBarH - 50 , ScreenW, 50) withStyle:LxmTaskBottomView_style_yudan];
            }
         
        }
        self.bottomView.delegate = self;
        [self.view addSubview:self.bottomView];
    }else{
        if (kDevice_Is_iPhoneX) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
        }else{
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        }
    }
    
    [self loadDetailData];
    
    //任务留言
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadLiuYanList];
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadLiuYanList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadLiuYanList];
    }];
}

//任务留言列表
- (void)loadLiuYanList{
    if (self.isyouke) {
        NSDictionary * dict = [NSDictionary dictionary];
        NSString * str = @"";
        dict = @{
                 @"billId":self.model.billId.stringValue.length > 0 ? self.model.billId : self.billId,
                 @"pageNum":@(self.page),
                 @"time":self.time
                 };
        str = [LxmURLDefine user_findSkillCommentList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCommentRootModel class] success:^(NSURLSessionDataTask *task, LxmCommentRootModel * responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmCommentList1Model * model = responseObject.result;
                NSArray * dataArr =  [NSMutableArray arrayWithArray:model.list];
                [self.dataArr addObjectsFromArray:dataArr];
                if (self.dataArr.count == 0) {
                    self.noneDataView.hidden = NO;
                }else{
                    self.noneDataView.hidden = YES;
                }
                self.time = model.time;
                self.page++;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    } else {
        if (ISLOGIN) {
            NSDictionary * dict = [NSDictionary dictionary];
            NSString * str = @"";
            if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                dict = @{
                         @"token":SESSION_TOKEN,
                         @"ecId":self.model.ecId.stringValue.length > 0 ? self.model.ecId : self.billId,
                         @"pageNum":@(self.page),
                         @"time":self.time
                         };
                str = [LxmURLDefine user_findECCommentList];
            }else{
                dict = @{
                         @"token":SESSION_TOKEN,
                         @"billId":self.model.billId.stringValue.length > 0 ? self.model.billId : self.billId,
                         @"pageNum":@(self.page),
                         @"time":self.time
                         };
                str = [LxmURLDefine user_findBillCommentList];
            }
            
            [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCommentRootModel class] success:^(NSURLSessionDataTask *task, LxmCommentRootModel * responseObject) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                if (responseObject.key.intValue == 1) {
                    if (self.page == 1) {
                        [self.dataArr removeAllObjects];
                    }
                    LxmCommentList1Model * model = responseObject.result;
                    NSArray * dataArr =  [NSMutableArray arrayWithArray:model.list];
                    [self.dataArr addObjectsFromArray:dataArr];
                    if (self.dataArr.count == 0) {
                        self.noneDataView.hidden = NO;
                    }else{
                        self.noneDataView.hidden = YES;
                    }
                    self.time = model.time;
                    self.page++;
                    [self.tableView reloadData];
                }else{
                    [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
        }
    }
}

- (void)loadDetailData{
    if (self.isyouke) {
        NSString * str = @"";
        NSMutableDictionary * dic  = [NSMutableDictionary dictionary];
        str = [LxmURLDefine user_getSkillInfo];
        dic[@"billId"] = self.model.billId.stringValue.length > 0 ? self.model.billId : self.billId;
        
        [LxmNetworking networkingPOST:str parameters:dic returnClass:[LxmGoodsDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmGoodsDetailRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.detailModel = responseObject.result;
                self.navItemView.infoModel = self.detailModel;
                self.tableTopView.infoModel = self.detailModel;
                self.bottomView.detailModel = self.detailModel;
                if (self.detailModel.img&&![self.detailModel.img_kg isEqualToString:@""]) {
                    self.imgs = [self.detailModel.img_kg componentsSeparatedByString:@","];
                }else{
                    self.imgs = [NSArray array];
                }
                [self.tableView reloadData];
            }else{
                if ([responseObject.key intValue] == 40002) {
                    [SVProgressHUD showErrorWithStatus:@"商品已经下架"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        if (ISLOGIN&&SESSION_TOKEN) {
            
            NSString * str = @"";
            NSMutableDictionary * dic  = [NSMutableDictionary dictionary];
            dic[@"token"] = SESSION_TOKEN;
            if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                str = [LxmURLDefine user_getECInfo];
                dic[@"ecId"] = self.model.ecId.stringValue.length > 0 ? self.model.ecId : self.billId;
            }else{
                str = [LxmURLDefine user_getCanInfo];
                dic[@"billId"] = self.model.billId.stringValue.length > 0 ? self.model.billId : self.billId;
            }
            
            [LxmNetworking networkingPOST:str parameters:dic returnClass:[LxmGoodsDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmGoodsDetailRootModel * responseObject) {
                if (responseObject.key.intValue == 1) {
                    self.detailModel = responseObject.result;
                    self.navItemView.infoModel = self.detailModel;
                    self.tableTopView.infoModel = self.detailModel;
                    self.bottomView.detailModel = self.detailModel;
                    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                        
                        NSLog(@"connet : %@",self.detailModel.content);
                        
                         NSString * ss = @"<div style=\"font-size: 40px;overflow: hidden;width: 100%\"><style>img{max-width:100%;display:block;margin:0 auto;width: 100%}</style>";
                        
                        NSString * conent = [NSString stringWithFormat:@"%@%@</div>",ss,self.detailModel.content];
                        [self.webView loadHTMLString:conent?conent:@"" baseURL:nil];
                        self.tableBottomView.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言区(%d)",self.detailModel.commentNum.intValue];
                        self.tableBottomView.infoModel = self.detailModel;
                    }else{
                        if (self.detailModel.img&&![self.detailModel.img_kg isEqualToString:@""]) {
                            self.imgs = [self.detailModel.img_kg componentsSeparatedByString:@","];
                        }else{
                            self.imgs = [NSArray array];
                        }
                    }
                    [self.tableView reloadData];
                }else{
                    if ([responseObject.key intValue] == 40002) {
                        [SVProgressHUD showErrorWithStatus:@"商品已经下架"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
                    }
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
        }
    }
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.webView.scrollView.delegate = self;
    }
    [LxmTool ShareTool].commentStr = @"";
    
    [LxmEventBus registerEvent:@"LxmPayMoneyAbleVC" block:^(id data) {
        LxmPayMoneyAbleVC * vc = [[LxmPayMoneyAbleVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmPayMoneyAbleVC_type_wgmdsp];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [LxmEventBus registerEvent:@"LxmZaiShouVC" block:^(id data) {
        LxmZaiShouVC *vc = [[LxmZaiShouVC alloc] init];
        vc.isPerchusVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
}

- (void)rightBtnClick{
    //分享
    [self loadShareData];
}

//获取分享信息
- (void)loadShareData{
    NSDictionary * dit = [NSDictionary dictionary];
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        dit = @{
                @"type":@5,
                @"id":self.model.ecId.stringValue.length > 0 ? self.model.ecId : self.billId
                };
    }else if (self.type == LxmGoodsDetailVC_type_ableDetail){
        dit = @{
                @"type":@2,
                @"id":self.model.billId.stringValue.length > 0 ? self.model.billId : self.billId
                };
    };
    [LxmNetworking networkingPOST:[LxmURLDefine app_shareInfo] parameters:dit returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)shareWithtype:(UMSocialPlatformType)platformType withModel:(LxmShareInfoModel *)model {
    // 根据获取的platformType确定所选平台进行下一步操作
    if (platformType == UMSocialPlatformType_WechatSession) {
        [self shareWeChatTitle:model.title content:model.content pic:model.pic url:model.url ok:^{
            
        } error:^{
            
        }];
    }else if (platformType == UMSocialPlatformType_WechatTimeLine){
        [self shareWXPYQTitle:model.title content:model.content pic:model.pic url:model.url ok:^{
            
        } error:^{
            
        }];
    }else if (platformType == UMSocialPlatformType_QQ){
        [self shareQQTitle:model.title content:model.content pic:model.pic url:model.url ok:^{
            
        } error:^{
            
        }];
    }else{
        //支付宝
        [self shareZFBTitle:model.title content:model.content pic:model.pic url:model.url  ok:^{
            
        } error:^{
            
        }];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentSize"] && object == self.webView.scrollView)
    {
        if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
            self.webView.height = self.webView.scrollView.contentSize.height;
            self.webView.frame =  CGRectMake(15, 100, ScreenW - 30, self.webView.height);
            if (self.detailModel.buyUserNum.intValue == 0) {
                self.tableBottomView.frame = CGRectMake(0, 100+self.webView.height, ScreenW, 50);
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 100+self.webView.height+50);
            }else{
                self.tableBottomView.frame = CGRectMake(0, 100+self.webView.height, ScreenW, 100);
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 100+self.webView.height+100);
            }
        }else{
            self.tableBottomView.frame = CGRectMake(0, 100+self.webView.height, ScreenW, 0);
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 100+self.webView.height+0);
        }
        [self.headerView layoutIfNeeded];
        [self.tableView reloadData];
    }
}



- (void)lxmTaskBottomView:(LxmTaskBottomView *)bottomView btnAtIndex:(NSInteger)index{
    if (self.isyouke) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您现在是游客身份,确定要登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        if (index == 0) {
            //超赞
            [self dianzanwithType:@1 withMain:nil withReplyModel:nil];
        }else if (index == 1){
            //留言
            __weak typeof(self) safe_self = self;
            [LxmCommentView showWithOkBlock:^(NSString *str) {
                NSLog(@"%@",str);
                [safe_self liuYanWith:str];
            }];
        }else if (index == 2){
            //立即约单
            if (ISLOGIN) {
                
                if (self.isOwn == NO && self.model.relUserId.intValue != [LxmTool ShareTool].userModel.userId) {
                    LxmYueDanPayVC * vc  = [[LxmYueDanPayVC alloc] initWithTableViewStyle:UITableViewStyleGrouped detailModel:self.detailModel];
                    vc.refreshPreVC = ^{
                        [self loadDetailData];
                    };
                    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                        vc.ecId = self.model.ecId;
                    }else{
                        vc.billId = self.model.billId;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"你不可以约单自己的技能商品"];
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
            }
            
        }else if (index == 3){
            //聊一聊
            if (!self.model.relUserId) {
                self.model.relUserId = self.detailModel.relUserId;
            }
            if (self.isOwn == NO && self.model.relUserId.intValue != [LxmTool ShareTool].userModel.userId) {
                NSString *user = self.model.relUserId.stringValue;
                [self getUserInfoFromHXWithUserID:user];
            }else {
                [SVProgressHUD showErrorWithStatus:@"你不可以和自己聊天"];
            }
        }
    }
    
}

- (void)getUserInfoFromHXWithUserID:(NSString *)userID{
    if (ISLOGIN) {
        NSString * myID = @([LxmTool ShareTool].userModel.userId).stringValue;
        NSMutableArray * idArr = [NSMutableArray arrayWithArray:@[userID,myID]];
        NSString * ids = [idArr componentsJoinedByString:@","];
        [LxmNetworking networkingPOST:[LxmURLDefine user_getUserInfoFromHX] parameters:@{@"token":SESSION_TOKEN,@"userIds":ids} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSArray * arr = responseObject[@"result"][@"list"];
                LxmHuanXinModel * huanxinModel = nil;
                LxmHuanXinModel * huanxinModel1 = nil;
                if (arr.count == 2) {
                    huanxinModel = [LxmHuanXinModel mj_objectWithKeyValues:arr.firstObject];
                    huanxinModel1 = [LxmHuanXinModel mj_objectWithKeyValues:arr.lastObject];
                }
                EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:userID conversationType:EMConversationTypeChat];
                chatController.detailModel = self.model;
                chatController.isDetail = YES;
                chatController.userModel = huanxinModel;
                chatController.myUserModel = huanxinModel1;
                chatController.navigationItem.title = huanxinModel.nickname;
                chatController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatController animated:YES];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        return self.dataArr.count;
    }
    return self.dataArr.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        LxmCommentListModel * sectionModel = self.dataArr[section];
        return sectionModel.replyList.count;
    }else{
        if (section == 0) {
            return self.imgs.count+1;
        }else{
            LxmCommentListModel * sectionModel = self.dataArr[section-1];
            return sectionModel.replyList.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        LxmTaskDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTaskDetailCell"];
        if (!cell)
        {
            cell = [[LxmTaskDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTaskDetailCell"];
        }
        LxmCommentListModel * sectionModel = self.dataArr[indexPath.section];
        LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                LxmCanListTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmCanListTextCell"];
                if (!cell) {
                    cell = [[LxmCanListTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmCanListTextCell"];
                }
                cell.conetntLab.text = self.detailModel.content;
                return cell;
            }else{
                LxmCanListImgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmCanListImgCell"];
                if (!cell) {
                    cell = [[LxmCanListImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmCanListImgCell"];
                }
                cell.imgStr = [self.imgs objectAtIndex:indexPath.row - 1];
                return cell;
            }
            
        }else{
            LxmTaskDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmTaskDetailCell"];
            if (!cell)
            {
                cell = [[LxmTaskDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmTaskDetailCell"];
            }
            LxmCommentListModel * sectionModel = self.dataArr[indexPath.section-1];
            LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexPath.row];
            cell.delegate = self;
            cell.model = model;
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        if (self.isyouke) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您现在是游客身份,确定要登录吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        } else {
            LxmCommentListModel * sectionModel = self.dataArr[indexPath.section];
            LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexPath.row];
            if (model.userId.intValue == [LxmTool ShareTool].userModel.userId) {
                //自己的子评论
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertView addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条回复吗?" preferredStyle:UIAlertControllerStyleAlert];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [self deleteReply:model mainModel:sectionModel];
                    }]];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    __weak typeof(self) safe_self = self;
                    [LxmCommentView showWithOkBlock:^(NSString *str) {
                        [safe_self replysubWithModel:model mineModel:sectionModel withcontent:str];
                    }];
                    
                }]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:alertView animated:YES completion:nil];
            }else{
                //别人的子评论
                __weak typeof(self) safe_self = self;
                [LxmCommentView showWithOkBlock:^(NSString *str) {
                    [safe_self replysubWithModel:model mineModel:sectionModel withcontent:str];
                }];
            }
        }
        
    }else{
        if (indexPath.section == 0) {
            
        }else{
            if (self.isyouke) {
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您现在是游客身份,确定要登录吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            } else {
                LxmCommentListModel * sectionModel = self.dataArr[indexPath.section - 1];
                LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexPath.row];
                if (model.userId.intValue == [LxmTool ShareTool].userModel.userId) {
                    //自己的子评论
                    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条回复吗?" preferredStyle:UIAlertControllerStyleAlert];
                        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [self deleteReply:model mainModel:sectionModel];
                        }]];
                        [self presentViewController:alertView animated:YES completion:nil];
                        
                    }]];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        __weak typeof(self) safe_self = self;
                        [LxmCommentView showWithOkBlock:^(NSString *str) {
                            [safe_self replysubWithModel:model mineModel:sectionModel withcontent:str];
                        }];
                        
                    }]];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }else{
                    //别人的子评论
                    __weak typeof(self) safe_self = self;
                    [LxmCommentView showWithOkBlock:^(NSString *str) {
                        [safe_self replysubWithModel:model mineModel:sectionModel withcontent:str];
                    }];
                }
            }
        }
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        LxmCommentListModel * sectionModel = self.dataArr[indexPath.section];
        return sectionModel.height;
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                CGFloat contentHeight = [self.detailModel.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:15].height;
                return contentHeight==0?30.01:(contentHeight+30);
            }else{
                NSString *imgStr = [self.imgs objectAtIndex:indexPath.row - 1];
                if ([imgStr containsString:@"|"]) {
                    NSArray * arr = [imgStr componentsSeparatedByString:@"|"];
                    if (arr.count == 3) {
                        NSString * w = arr[1];
                        NSString * h = arr[2];
                        CGFloat height  = ((ScreenW - 30)*h.intValue)/(w.intValue);
                        return height+5;
                    }
                    return 200+5;
                }else{
                    return 200+5;
                }
            }
        }else{
            LxmCommentListModel * sectionModel = self.dataArr[indexPath.section-1];
            return sectionModel.height;
        }
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        return 0.01;
    }else{
        if (section == 0) {
            if (self.detailModel.buyUserNum.intValue == 0) {
                return 50;
            }else{
                return 100;
            }
        }else{
            return 0.01;
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        LxmTaskDetailHeaderView * headerView = [[LxmTaskDetailHeaderView alloc] initWithReuseIdentifier:@"LxmTaskDetailHeaderView" withIndex:section];
        LxmCommentListModel * sectionModel = self.dataArr[section];
        headerView.model = sectionModel;
        headerView.delegate = self;
        headerView.contentView.backgroundColor = UIColor.whiteColor;
        return headerView;
    }else{
        if (section == 0) {
            UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
            if (!headerView) {
                headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
            }
            headerView.contentView.backgroundColor = UIColor.whiteColor;
            return headerView;
        }else{
            LxmTaskDetailHeaderView * headerView = [[LxmTaskDetailHeaderView alloc] initWithReuseIdentifier:@"LxmTaskDetailHeaderView" withIndex:section-1];
            LxmCommentListModel * sectionModel = self.dataArr[section-1];
            headerView.model = sectionModel;
            headerView.delegate = self;
            headerView.contentView.backgroundColor = UIColor.whiteColor;
            return headerView;
        }
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        UITableViewHeaderFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView0"];
        if (!footerView) {
            footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView0"];
        }

        footerView.contentView.backgroundColor = UIColor.whiteColor;
        return footerView;
    }else{
        if (section == 0) {
           // LxmAbleTableFooterView
            LxmAbleTableFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
            if (!footerView) {
                footerView = [[LxmAbleTableFooterView alloc] initWithReuseIdentifier:@"footerView"];
            }
            footerView.backgroundColor = UIColor.whiteColor;
            footerView.contentView.backgroundColor = UIColor.whiteColor;
            footerView.infoModel = self.detailModel;
            return footerView;
        }else{
            UITableViewHeaderFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView1"];
            if (!footerView) {
                footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView1"];
            }
            footerView.backgroundColor = UIColor.whiteColor;
            footerView.contentView.backgroundColor = UIColor.whiteColor;
            return footerView;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
        LxmCommentListModel * sectionModel = self.dataArr[section];
        return sectionModel.height;
    }else{
        if (section == 0) {
            return 0.01;
        }else{
            LxmCommentListModel * sectionModel = self.dataArr[section-1];
            return sectionModel.height;
        }
    }
  
}

//留言

- (void)liuYanWith:(NSString *)content{
    if (ISLOGIN) {
        NSDictionary * dic = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
            dic = @{
                    @"token":SESSION_TOKEN,
                    @"ecId":self.billId.stringValue.length > 0 ? self.billId : self.model.ecId,
                    @"content":content,
                    };
            str = [LxmURLDefine user_insertECComment];
        }else{
            dic = @{
                    @"token":SESSION_TOKEN,
                    @"billId":self.billId.stringValue.length > 0 ? self.billId : self.model.billId,
                    @"content":content,
                    };
            str = [LxmURLDefine user_insertBillComment];
        }
        
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:str parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"留言成功"];
                //构造数据 插入留言列表
                LxmCommentListModel * model = [[LxmCommentListModel alloc] init];
                model.commentId = responseObject[@"result"][@"commentId"];
                model.userId = @([LxmTool ShareTool].userModel.userId);
                model.userPic = [LxmTool ShareTool].userModel.headimg;
                model.sex = @([LxmTool ShareTool].userModel.sex);
                model.userName = [LxmTool ShareTool].userModel.nickname;
                model.content = content;
                model.createTime = [NSString getCurrentTime];
                model.likeNum = @0;
                model.likeStatus = @2;
                model.isDelete = @2;
                [self.dataArr insertObject:model atIndex:0];
                [self.tableView reloadData];
                
                NSNumber * num = self.detailModel.commentNum;
                num = @(num.intValue +1);
                self.detailModel.commentNum = num;
                self.tableBottomView.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言区(%d)",self.detailModel.commentNum.intValue];
                
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
    
}

//删除子评论
- (void)deleteReply:(LxmCommentReplyListModel *)model mainModel:(LxmCommentListModel *)mainModel{
    if (ISLOGIN) {
        
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"replyId":model.ID
                                };
        NSString * str = @"";
        if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
            str = [LxmURLDefine user_deleteECReply];
        }else{
            str = [LxmURLDefine user_deleteBillReply];
        }
        [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSMutableArray * arr  = [NSMutableArray arrayWithArray:mainModel.replyList];
                [arr removeObject:model];
                mainModel.replyList = arr;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}
//回复子评论

- (void)replysubWithModel:(LxmCommentReplyListModel *)model mineModel:(LxmCommentListModel *)mineModel withcontent:(NSString *)content{
    if (ISLOGIN) {
        NSDictionary * dic = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
            dic = @{
                    @"token":SESSION_TOKEN,
                    @"ecId": self.billId.stringValue.length > 0 ? self.billId : self.model.ecId,
                    @"commentId":mineModel.commentId,
                    @"content":content,
                    @"replyId":model.ID,
                    @"toUserId":model.userId,
                    };
            str = [LxmURLDefine user_insertECReply];
        }else{
            dic = @{
                      @"token":SESSION_TOKEN,
                      @"billId":self.billId.stringValue.length > 0 ? self.billId : self.model.billId,
                      @"commentId":mineModel.commentId,
                      @"content":content,
                      @"replyId":model.ID,
                      @"toUserId":model.userId,
                      };
            str = [LxmURLDefine user_insertBillReply];
        }
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:str parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"回复留言成功"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadLiuYanList];
                //构造数据 插入留言回复列表
                NSMutableArray * arr = [NSMutableArray arrayWithArray:mineModel.replyList];
                LxmCommentReplyListModel * replyModel = [[LxmCommentReplyListModel alloc] init];
                replyModel.userId = @([LxmTool ShareTool].userModel.userId);
                replyModel.userPic = [LxmTool ShareTool].userModel.headimg;
                replyModel.sex = @([LxmTool ShareTool].userModel.sex);
                replyModel.userName = [LxmTool ShareTool].userModel.nickname;
                replyModel.toName  = model.userName;
                replyModel.content  = content;
                if (model.userId.intValue!=[LxmTool ShareTool].userModel.userId) {
                    replyModel.toUserId = model.userId;
                }
                replyModel.ID = responseObject[@"result"][@"replyId"];
                replyModel.createTime = [NSString getCurrentTime];
                replyModel.likeNum = @0;
                replyModel.likeStatus = @2;
                [arr addObject:replyModel];
                mineModel.replyList = arr;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}



//主评论点赞
- (void)LxmTaskDetailHeaderView:(LxmTaskDetailHeaderView *)headerView zanIndex:(NSInteger)index{
    LxmCommentListModel * model = [self.dataArr objectAtIndex:index];
    [self dianzanwithType:@2 withMain:model withReplyModel:nil];
    NSLog(@"%ld",index);
}
- (void)LxmTaskDetailCellZanClick:(LxmTaskDetailCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmCommentListModel * sectionModel = self.dataArr[indexP.section];
    LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexP.row];
    [self dianzanwithType:@3 withMain:sectionModel withReplyModel:model];
}
- (void)dianzanwithType:(NSNumber *)type withMain:(LxmCommentListModel *)model withReplyModel:(LxmCommentReplyListModel *)replyModel{
    if (self.isyouke) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您现在是游客身份,确定要登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        if (ISLOGIN) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            NSString * str = @"";
            if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
                if (type.intValue == 1) {
                    dic[@"otherId"] = self.billId.stringValue.length > 0 ? self.billId : self.model.ecId;
                }else if (type.intValue == 2){
                    dic[@"otherId"] = model.commentId;
                }else if (type.intValue == 3){
                    dic[@"otherId"] = replyModel.ID;
                }
                str = [LxmURLDefine user_likeEC];
            }else{
                if (type.intValue == 1) {
                    dic[@"otherId"] = self.billId.stringValue.length > 0 ? self.billId : self.model.billId;
                }else if (type.intValue == 2){
                    dic[@"otherId"] = model.commentId;
                }else if (type.intValue == 3){
                    dic[@"otherId"] = replyModel.ID;
                }
                str = [LxmURLDefine user_likeBill];
            }
            
            dic[@"token"] = SESSION_TOKEN;
            dic[@"type"] = type;
            [LxmNetworking networkingPOST:str parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"key"] intValue] == 30003) {
                    [SVProgressHUD showSuccessWithStatus:@"点赞成功!"];
                    if (type.intValue == 1) {
                        NSNumber * num = @(self.detailModel.likeNum.intValue+1);
                        self.detailModel.likeNum = num;
                        self.detailModel.likeStatus = @1;
                        self.tableTopView.infoModel = self.detailModel;
                        self.bottomView.detailModel = self.detailModel;
                    }else if (type.intValue == 2){
                        NSNumber * num = @(model.likeNum.intValue+1);
                        model.likeNum = num;
                        model.likeStatus = @1;
                        [self.tableView reloadData];
                    }else if (type.intValue == 3){
                        NSNumber * num = @(replyModel.likeNum.intValue+1);
                        replyModel.likeNum = num;
                        replyModel.likeStatus = @1;
                        [self.tableView reloadData];
                    }
                }else if ([responseObject[@"key"] intValue] == 30004) {
                    [SVProgressHUD showSuccessWithStatus:@"已取消点赞!"];
                    if (type.intValue == 1) {
                        NSNumber * num = @(self.detailModel.likeNum.intValue-1);
                        self.detailModel.likeNum = num;
                        self.detailModel.likeStatus = @2;
                        self.tableTopView.infoModel = self.detailModel;
                        self.bottomView.detailModel = self.detailModel;
                        
                    }else if (type.intValue == 2){
                        NSNumber * num = @(model.likeNum.intValue-1);
                        model.likeNum = num;
                        model.likeStatus = @2;
                    }else if (type.intValue == 3){
                        NSNumber * num = @(replyModel.likeNum.intValue-1);
                        replyModel.likeNum = num;
                        replyModel.likeStatus = @2;
                    }
                    [self.tableView reloadData];
                }else{
                    [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
        }
    }
   
}

/**
 section的headerView的代理事件 回复/删除主评论
 */

- (void)LxmTaskDetailHeaderView:(LxmTaskDetailHeaderView *)headerView btnAnIndex:(NSInteger)index{
    if (self.isyouke) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您现在是游客身份,确定要登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        LxmCommentListModel * model = [self.dataArr objectAtIndex:index];
        if (model.userId.intValue == [LxmTool ShareTool].userModel.userId) {
            //自己的
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertView addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条留言吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteMain:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"%ld",index);
                
                __weak typeof(self) safe_self = self;
                [LxmCommentView showWithOkBlock:^(NSString *str) {
                    [safe_self replyMineComment:model withContent:str];
                }];
                
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:alertView animated:YES completion:nil];
        }else{
            //别人的
            __weak typeof(self) safe_self = self;
            [LxmCommentView showWithOkBlock:^(NSString *str) {
                [safe_self replyMineComment:model withContent:str];
            }];
        }
    }
}
- (void)deleteMain:(LxmCommentListModel *)model{
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"commentId":model.commentId
                                };
        NSString * str = @"";
        if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
            str = [LxmURLDefine user_deleteECComment];
        }else{
            str = [LxmURLDefine user_deleteBillComment];
        }
        [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                
                NSNumber * num = self.detailModel.commentNum;
                num = @(num.intValue-1);
                self.detailModel.commentNum = num;
                self.tableBottomView.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言区(%d)",self.detailModel.commentNum.intValue];
                
                NSMutableArray * arr = self.dataArr;
                [arr removeObject:model];
                self.dataArr = arr;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}
- (void)replyMineComment:(LxmCommentListModel *)model withContent:(NSString *)content{
    if (ISLOGIN) {
        NSDictionary * dic = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmGoodsDetailVC_type_goodsDetail) {
            dic = @{
                    @"token":SESSION_TOKEN,
                    @"ecId":self.billId.stringValue.length > 0 ? self.billId : self.model.ecId,
                    @"commentId":model.commentId,
                    @"content":content,
                    };
            str = [LxmURLDefine user_insertECReply];
        }else{
            dic = @{
                    @"token":SESSION_TOKEN,
                    @"billId":self.billId.stringValue.length > 0 ? self.billId :self.model.billId,
                    @"commentId":model.commentId,
                    @"content":content,
                    };
             str = [LxmURLDefine user_insertBillReply];
        }
        
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:str parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"留言成功"];
                //构造数据 插入留言回复列表
                NSMutableArray * arr = [NSMutableArray arrayWithArray:model.replyList];
                LxmCommentReplyListModel * replyModel = [[LxmCommentReplyListModel alloc] init];
                replyModel.userId = @([LxmTool ShareTool].userModel.userId);
                replyModel.userPic = [LxmTool ShareTool].userModel.headimg;
                replyModel.sex = @([LxmTool ShareTool].userModel.sex);
                replyModel.userName = [LxmTool ShareTool].userModel.nickname;
                replyModel.toName  = model.userName;
                if (model.userId.intValue!=[LxmTool ShareTool].userModel.userId) {
                    replyModel.toUserId = model.userId;
                }
                replyModel.content = content;
                replyModel.ID = responseObject[@"result"][@"replyId"];
                replyModel.createTime = [NSString getCurrentTime];
                replyModel.likeNum = @0;
                replyModel.likeStatus = @2;
                [arr addObject:replyModel];
                model.replyList = arr;
                [self.tableView reloadData];
                
                NSNumber * num = self.detailModel.commentNum;
                num = @(num.intValue+1);
                self.detailModel.commentNum = num;
                self.tableBottomView.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言区(%d)",self.detailModel.commentNum.intValue];
                
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

@interface LxmGoodsDetailNavItemView ()
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UIView * startView;
@property (nonatomic , strong) UIImageView * starImgView1;
@property (nonatomic , strong) UIImageView * starImgView2;
@property (nonatomic , strong) UIImageView * starImgView3;
@property (nonatomic , strong) UIImageView * starImgView4;
@property (nonatomic , strong) UIImageView * starImgView5;

@end
@implementation LxmGoodsDetailNavItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.startView];
        
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(self);
        make.width.height.equalTo(@30);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView);
        make.bottom.equalTo(self.headerImgView).offset(2);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 15;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}
- (UIImageView *)sexImgView{
    if (!_sexImgView) {
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.image = [UIImage imageNamed:@"female"];
    }
    return _sexImgView;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.text = @"巴啦啦小魔仙";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}
- (UIView *)startView{
    if (!_startView) {
        _startView = [[UIView alloc] init];
        for (int i=0; i<5; i++)
        {
            UIImageView *starImg=[[UIImageView alloc] init];
            starImg.frame = CGRectMake(17*i, 0, 15, 15);
            //            starImg.image = [UIImage imageNamed:@"star_1"];
            starImg.image = [UIImage imageNamed:@"star_3"];
            [_startView addSubview:starImg];
            if (i == 0) {
                self.starImgView1 = starImg;
            }else if (i == 1){
                self.starImgView2 = starImg;
            }else if (i == 2){
                self.starImgView3 = starImg;
            }else if (i == 3){
                self.starImgView4 = starImg;
            }else if (i == 4){
                self.starImgView5 = starImg;
            }
        }
        _startView.layer.masksToBounds = YES;
    }
    return _startView;
}
- (void)setInfoModel:(LxmGoodsDetailModel *)infoModel{
    _infoModel = infoModel;
    switch (infoModel.goodRate.intValue) {
        case 1:
        {
            self.starImgView1.image = [UIImage imageNamed:@"star_3"];
            self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 2:
        {
            self.starImgView1.image = self.starImgView2.image = [UIImage imageNamed:@"star_3"];
            self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 3:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = [UIImage imageNamed:@"star_3"];
            self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 4:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = [UIImage imageNamed:@"star_3"];
            self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 5:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_3"];
        }
            break;
            
        default:
            break;
    }
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:infoModel.userHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:infoModel.sex.intValue == 1?@"male":@"female"];
    self.nameLab.text = infoModel.nickname;
    
}



@end

@interface LxmGoodsDetailTableTopView()
@property (nonatomic , strong) UIView * topView;
@property (nonatomic , strong) UIImageView * leftLineImgView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UIImageView * rightLineImgView;
@property (nonatomic , strong) UIView * bottomView;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UIButton * dianzanBtn;
@end
@implementation LxmGoodsDetailTableTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.topView];
        [self.topView addSubview:self.leftLineImgView];
        [self.topView addSubview:self.titleLab];
        [self.topView addSubview:self.rightLineImgView];
        
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.moneyLab];
        [self.bottomView addSubview:self.dianzanBtn];
        
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.leftLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.width.equalTo(@120);
        make.trailing.equalTo(self.titleLab.mas_leading).offset(-5);
        make.height.equalTo(@1);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.topView);
    }];
    [self.rightLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.width.equalTo(@120);
        make.leading.equalTo(self.titleLab.mas_trailing).offset(5);
        make.height.equalTo(@1);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.bottomView);
        
    }];
    [self.dianzanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.trailing.equalTo(self.bottomView).offset(-15);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
  
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (UIImageView *)leftLineImgView{
    if (!_leftLineImgView) {
        _leftLineImgView = [[UIImageView alloc] init];
        _leftLineImgView.image = [UIImage imageNamed:@"blue"];
    }
    return _leftLineImgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textColor = BlueColor;
        _titleLab.text = @"手工润唇膏";
    }
    return _titleLab;
}

- (UIImageView *)rightLineImgView{
    if (!_rightLineImgView) {
        _rightLineImgView = [[UIImageView alloc] init];
        _rightLineImgView.image = [UIImage imageNamed:@"blue"];
    }
    return _rightLineImgView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont systemFontOfSize:13];
        _moneyLab.textColor = CharacterDarkColor;
        _moneyLab.text = @"20元/支   邮寄";
    }
    return _moneyLab;
}

- (UIButton *)dianzanBtn{
    if (!_dianzanBtn) {
        _dianzanBtn = [[UIButton alloc] init];
        [_dianzanBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_dianzanBtn setTitle:@"11" forState:UIControlStateNormal];
        [_dianzanBtn setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        _dianzanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _dianzanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _dianzanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_dianzanBtn addTarget:self action:@selector(zanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzanBtn;
}

- (void)zanClick{
    if (self.zanBlock) {
        self.zanBlock();
    }
}


- (void)setInfoModel:(LxmGoodsDetailModel *)infoModel{
    _infoModel = infoModel;
    self.titleLab.text = infoModel.title;
    self.moneyLab.text = [NSString stringWithFormat:@"%@元/%@   %@",infoModel.money,infoModel.unit,[NSString returnTypeNameWithType:infoModel.sendType.intValue]];
    [self.dianzanBtn setTitle:[NSString stringWithFormat:@"%@",infoModel.likeNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",infoModel.likeNum.intValue]] forState:UIControlStateNormal];
    [self.dianzanBtn setImage:[UIImage imageNamed:infoModel.likeStatus.intValue == 1?@"like":@"dislike"] forState:UIControlStateNormal];
}



@end


#import "LxmHeaderImgView.h"
@interface LxmGoodsDetailTableBottomView()
/**
 抢单人信息模块
 */
@property (nonatomic , strong) LxmHeaderImgView * peopleView;
@property (nonatomic , strong) UILabel * totalLab;

@end

@implementation LxmGoodsDetailTableBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.peopleView];
        [self.peopleView addSubview:self.totalLab];
        
        self.liuYanView  = [[LxmLiuYanView alloc] init];
        self.liuYanView.liuYanLab.text = @"留言(5)";
        self.liuYanView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.liuYanView];

        
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(self.peopleView);
    }];
    [self.liuYanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peopleView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
}
- (LxmHeaderImgView *)peopleView{
    if (!_peopleView) {
        _peopleView = [[LxmHeaderImgView alloc] init];
        _peopleView.isGoodList = YES;
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW - 30, 0.5)];
        line.backgroundColor = LineColor;
        [_peopleView addSubview:line];
        _peopleView.layer.masksToBounds = YES;
    }
    return _peopleView;
}
- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        _totalLab.font = [UIFont systemFontOfSize:13];
        _totalLab.textColor = CharacterLightGrayColor;
        _totalLab.text = @"5人已抢单";
    }
    return _totalLab;
}

- (void)setInfoModel:(LxmGoodsDetailModel *)infoModel{
    _infoModel = infoModel;
    if (infoModel.buyUserList.count == 0) {
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        self.peopleView.items = infoModel.buyUserList;
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        self.totalLab.text = [NSString stringWithFormat:@"%d人已抢单",infoModel.buyUserNum.intValue];
    }
}

@end


@interface LxmAbleTableFooterView()
/**
 抢单人信息模块
 */
@property (nonatomic , strong) LxmHeaderImgView * peopleView;
@property (nonatomic , strong) UILabel * totalLab;
@end

@implementation LxmAbleTableFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.peopleView];
        [self.peopleView addSubview:self.totalLab];
        
        self.liuYanView  = [[LxmLiuYanView alloc] init];
        self.liuYanView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.liuYanView];
        
        
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains{
    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(self.peopleView);
    }];
    [self.liuYanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peopleView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
}
- (LxmHeaderImgView *)peopleView{
    if (!_peopleView) {
        _peopleView = [[LxmHeaderImgView alloc] init];
        _peopleView.isGoodList = YES;
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW - 30, 0.5)];
        line.backgroundColor = LineColor;
        [_peopleView addSubview:line];
        _peopleView.layer.masksToBounds = YES;
    }
    return _peopleView;
}
- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        _totalLab.font = [UIFont systemFontOfSize:13];
        _totalLab.textColor = CharacterLightGrayColor;
        _totalLab.text = @"5人已抢单";
    }
    return _totalLab;
}

- (void)setInfoModel:(LxmGoodsDetailModel *)infoModel{
    _infoModel = infoModel;
    if (infoModel.buyUserList.count == 0) {
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        self.peopleView.items = infoModel.buyUserList;
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        self.totalLab.text = [NSString stringWithFormat:@"%d人已抢单",infoModel.buyUserNum.intValue];
    }
    self.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言(%d)",infoModel.commentNum.intValue];
}

@end


