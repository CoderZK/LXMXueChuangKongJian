//
//  LxmLvAndPaiMaiDetailVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmLvAndPaiMaiDetailVC.h"
#import "SNY_AdScrollView.h"
#import "LxmLvAndPaiMaiItemView.h"
#import <WebKit/WebKit.h>
#import "LxmLiuYanView.h"
#import "PopListView.h"
#import "LxmTaskBottomView.h"
#import "LxmTaskDetailCell.h"
#import "LxmTaskDetailHeaderView.h"
#import "LxmPaiMaiAndZiXunBottomView.h"
#import "LxmBaoMingVC.h"
#import <UShareUI/UShareUI.h>

@interface LxmLvAndPaiMaiDetailVC ()<UIScrollViewDelegate,PopListViewDelegate,LxmTaskBottomViewDelegate,LxmPaiMaiAndZiXunBottomViewDelegate,LxmTaskDetailCellDelegate,LxmTaskDetailHeaderViewDelegate,LxmLvAndPaiMaiItemViewDelegate,UMSocialShareMenuViewDelegate>
@property (nonatomic , strong) PopListView * popListView;
@property (nonatomic , strong) LxmTaskBottomView * bottomView;
@property (nonatomic , strong) LxmPaiMaiAndZiXunBottomView * bottomView1;

@property (nonatomic , strong) LxmArticleModel * typeModel;
@property (nonatomic , strong) NSNumber * typeID;
@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) SNY_AdScrollView * bannerView;
@property (nonatomic , strong) LxmLvAndPaiMaiItemView * itemView;
@property (nonatomic , strong) WKWebView * webView;
@property (nonatomic , strong) LxmLiuYanView * liuYanView;

//任务留言数据
@property (nonatomic , strong) LxmArticleDetailModel * detailModel;

@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;

@end

@implementation LxmLvAndPaiMaiDetailVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style typeModel:(LxmArticleModel *)model type:(NSNumber *)typeID{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.typeID = typeID;
        self.typeModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"内容详情";
    [self initTableHeader];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.popListView = [[PopListView alloc] initWithTitleArr:@[@"分享"] currectIndex:0 isAccShow:NO];
    self.popListView.delegate = self;
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 50-34);
        if (self.typeID.intValue == 6) {
            self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34) withStyle:LxmTaskBottomView_style_baoming];


            self.bottomView.delegate = self;
            [self.view addSubview:self.bottomView];
        }else{
            //拍卖和咨询的
            self.bottomView1 = [[LxmPaiMaiAndZiXunBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
            self.bottomView1.delegate = self;
            [self.view addSubview:self.bottomView1];
        }

    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 50);
        if (self.typeID.intValue == 6) {
            self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50) withStyle:LxmTaskBottomView_style_baoming];
            self.bottomView.delegate = self;
            [self.view addSubview:self.bottomView];
        }else{
            //拍卖和咨询的
            self.bottomView1 = [[LxmPaiMaiAndZiXunBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
            self.bottomView1.delegate = self;
            [self.view addSubview:self.bottomView1];
        }
    }
    
    
    //任务留言
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadLiuYanList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadLiuYanList];
        [self loadArticleInfo];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadLiuYanList];
    }];
    
    //获取文章详情
    [self loadArticleInfo];
    
}
//获取文章详情
- (void)loadArticleInfo{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"articleId": self.textId.length > 0 ? self.textId : self.typeModel.articleId
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_getArticleInfo] parameters:dic returnClass:[LxmArticleDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmArticleDetailRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.detailModel = responseObject.result;
                self.itemView.detailModel = self.detailModel;
                 self.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言(%d)",self.detailModel.commentNum.intValue];
                NSString * ss = @"<div style=\"font-size: 40px;overflow: hidden;width: 100%\"><style>img{max-width:100%;display:block;margin:0 auto;width: 100%}</style>";

                NSString * conent = [NSString stringWithFormat:@"%@%@</div>",ss,self.detailModel.content];
                [self.webView loadHTMLString:conent?conent:@"" baseURL:nil];
                
                if (self.typeID.intValue == 6) {
                    self.bottomView.model = self.detailModel;
                }else{
                    self.bottomView1.model = self.detailModel;
                }
                CGFloat bannerH = 0;
                if (self.detailModel.pic&&![self.detailModel.pic isEqualToString:@""]) {
                    NSArray * arr = [self.detailModel.pic componentsSeparatedByString:@","];
                    NSMutableArray * bannerArr  = [NSMutableArray array];
                    for (int i = 0; i<arr.count; i++) {
                        LxmHomeBannerModel * model = [[LxmHomeBannerModel alloc] init];
                        model.pic = arr[i];
                        [bannerArr addObject:model];
                    }
                    self.bannerView.dataArr = bannerArr;
                    bannerH = 150;
                }
                self.bannerView.frame = CGRectMake(0, 0, ScreenW, bannerH);
                self.itemView.frame = CGRectMake(0, bannerH, ScreenW, 100);
                self.webView.frame =  CGRectMake(0, bannerH+100, ScreenW, self.webView.height);
                [self.webView sizeToFit];
                self.liuYanView.frame = CGRectMake(0, bannerH+100+self.webView.height, ScreenW, 50);
                self.headerView.frame = CGRectMake(0, 0, ScreenW, bannerH+100+self.webView.height+50);
                [self.headerView layoutIfNeeded];
                
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


//任务留言列表
- (void)loadLiuYanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"articleId":self.textId.length > 0 ? self.textId : self.typeModel.articleId,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findArticleCommentList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCommentRootModel class] success:^(NSURLSessionDataTask *task, LxmCommentRootModel * responseObject) {
            [SVProgressHUD dismiss];
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
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}


- (void)rightBtnClick{
    
    CGPoint point = [self.view convertPoint:CGPointMake(ScreenW - 110, StateBarH+44) fromView:self.navigationController.navigationBar];
    if (self.popListView.isShow){
        [self.popListView disMissAnimation:NO];
    }else{
        [self.popListView showAtPoint:point animation:YES isShow:YES];
    }
}
-(void)PopListView:(PopListView *)view  didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadShareData];
}
//获取分享信息
- (void)loadShareData{
    
    [LxmNetworking networkingPOST:[LxmURLDefine app_shareInfo] parameters:@{@"type":@3,@"id":self.typeModel.articleId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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


//旅游的bottom
- (void)lxmTaskBottomView:(LxmTaskBottomView *)bottomView btnAtIndex:(NSInteger)index{
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
    }else{
        //抢单报名
        LxmBaoMingVC * vc = [[LxmBaoMingVC alloc] init];
        vc.model = self.detailModel;
        vc.articleID = self.typeModel.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//留言

- (void)liuYanWith:(NSString *)content{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"articleId":self.textId.length > 0 ? self.textId : self.typeModel.articleId,
                               @"content":content,
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertArticleComment] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
                self.itemView.detailModel = self.detailModel;
                self.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言(%d)",self.detailModel.commentNum.intValue];

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



//拍卖和咨询的bottom
- (void)lxmPaiMaiAndZiXunBottomView:(LxmPaiMaiAndZiXunBottomView *)bottomView btnAtIndex:(NSInteger)index{
    if (index == 0) {
        //超赞
        [self dianzanwithType:@1 withMain:nil withReplyModel:nil];
    }else{
        //留言
        __weak typeof(self) safe_self = self;
        [LxmCommentView showWithOkBlock:^(NSString *str) {
            NSLog(@"%@",str);
            [safe_self liuYanWith:str];
        }];
    }
}


- (void)initTableHeader{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250+5+50)];
    self.headerView.backgroundColor = UIColor.whiteColor;
    
    self.bannerView = [[SNY_AdScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    [self.headerView addSubview:self.bannerView];
    
    self.itemView = [[LxmLvAndPaiMaiItemView alloc] initWithFrame:CGRectMake(0, 150, ScreenW, 100)];
    self.itemView.delegate = self;
    [self.headerView addSubview:self.itemView];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 250, ScreenW, 5)];
    [self.webView sizeToFit];
    [self.headerView addSubview:self.webView];
    
    self.liuYanView  = [[LxmLiuYanView alloc] initWithFrame:CGRectMake(0, 250+self.webView.scrollView.contentSize.height, ScreenW, 50)];
    self.liuYanView.backgroundColor = UIColor.whiteColor;
    [self.headerView addSubview:self.liuYanView];
    self.tableView.tableHeaderView = self.headerView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.webView.scrollView.delegate = self;
    [LxmTool ShareTool].commentStr = @"";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    if (self.popListView.isShow){
        [self.popListView disMissAnimation:NO];
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentSize"]&&object == self.webView.scrollView)
    {
        self.webView.height = self.webView.scrollView.contentSize.height;
        CGFloat bannerH = 0;
        if (self.detailModel.pic&&![self.detailModel.pic isEqualToString:@""]) {
            NSArray * arr = [self.detailModel.pic componentsSeparatedByString:@","];
            NSMutableArray * bannerArr  = [NSMutableArray array];
            for (int i = 0; i<arr.count; i++) {
                LxmHomeBannerModel * model = [[LxmHomeBannerModel alloc] init];
                model.pic = arr[i];
                [bannerArr addObject:model];
            }
            self.bannerView.dataArr = bannerArr;
            bannerH = 150;
        }
        self.bannerView.frame = CGRectMake(0, 0, ScreenW, bannerH);
        self.itemView.frame = CGRectMake(0, bannerH, ScreenW, 100);
        self.webView.frame =  CGRectMake(0, bannerH+100, ScreenW, self.webView.height);
        [self.webView sizeToFit];
        self.liuYanView.frame = CGRectMake(0, bannerH+100+self.webView.height, ScreenW, 50);
        self.headerView.frame = CGRectMake(0, 0, ScreenW, bannerH+100+self.webView.height+50);
        [self.headerView layoutIfNeeded];
        [self.tableView reloadData];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LxmCommentListModel * sectionModel = self.dataArr[section];
    return sectionModel.replyList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmCommentListModel * sectionModel = self.dataArr[indexPath.section];
    return sectionModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LxmTaskDetailHeaderView * headerView = [[LxmTaskDetailHeaderView alloc] initWithReuseIdentifier:@"LxmTaskDetailHeaderView" withIndex:section];
    LxmCommentListModel * sectionModel = self.dataArr[section];
    headerView.model = sectionModel;
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.delegate = self;
    headerView.contentView.backgroundColor = UIColor.whiteColor;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    LxmCommentListModel * sectionModel = self.dataArr[section];
    return sectionModel.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section!=0) {
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
}

//收藏、取消收藏文章
- (void)LxmLvAndPaiMaiItemViewCollectionClick{
    if (ISLOGIN) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"articleId"] = self.textId.length > 0 ? self.textId : self.typeModel.articleId;
        dic[@"token"] = SESSION_TOKEN;
        dic[@"typeId"] = self.typeID;
        [LxmNetworking networkingPOST:[LxmURLDefine user_collectArticle] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 30001) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                if (self.refreshMineCollection) {
                    self.refreshMineCollection();
                }
                self.detailModel.collectStatus = @1;
                self.itemView.detailModel = self.detailModel;
            }else if ([responseObject[@"key"] intValue] == 30002) {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
                self.detailModel.collectStatus = @2;
                self.itemView.detailModel = self.detailModel;
                if (self.refreshMineCollection) {
                    self.refreshMineCollection();
                }
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
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
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteArticleReply] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"articleId":self.textId.length > 0 ? self.textId : self.typeModel.articleId,
                               @"commentId":mineModel.commentId,
                               @"content":content,
                               @"replyId":model.ID,
                               @"toUserId":model.userId,
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertArticleReply] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    if (ISLOGIN) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (type.intValue == 1) {
            dic[@"otherId"] = self.textId.length > 0 ? self.textId : self.typeModel.articleId;
        }else if (type.intValue == 2){
            dic[@"otherId"] = model.commentId;
        }else if (type.intValue == 3){
            dic[@"otherId"] = replyModel.ID;
        }
        dic[@"token"] = SESSION_TOKEN;
        dic[@"type"] = type;
        [LxmNetworking networkingPOST:[LxmURLDefine user_likeArticle] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 30003) {
                [SVProgressHUD showSuccessWithStatus:@"点赞成功!"];
                if (type.intValue == 1) {
                    NSNumber * num = @(self.detailModel.likeNum.intValue+1);
                    self.detailModel.likeNum = num;
                    self.detailModel.likeStatus = @1;
                    self.itemView.detailModel = self.detailModel;
                    
                    if (self.typeID.intValue == 6) {
                        self.bottomView.model = self.detailModel;
                    }else{
                        self.bottomView1.model = self.detailModel;
                    }
                    
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
                    self.itemView.detailModel = self.detailModel;
                    if (self.typeID.intValue == 6) {
                        self.bottomView.model = self.detailModel;
                    }else{
                        self.bottomView1.model = self.detailModel;
                    }
                    
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

/**
 section的headerView的代理事件 回复/删除主评论
 */

- (void)LxmTaskDetailHeaderView:(LxmTaskDetailHeaderView *)headerView btnAnIndex:(NSInteger)index{
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
- (void)deleteMain:(LxmCommentListModel *)model{
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"commentId":model.commentId
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteArticleComment] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                
                NSNumber * num = self.detailModel.commentNum;
                num = @(num.intValue-1);
                self.detailModel.commentNum = num;
                self.itemView.detailModel = self.detailModel;
                self.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言(%d)",self.detailModel.commentNum.intValue];
                
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
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"articleId":self.textId.length > 0 ? self.textId : self.typeModel.articleId,
                               @"commentId":model.commentId,
                               @"content":content,
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertArticleReply] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
                self.itemView.detailModel = self.detailModel;
                self.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"留言(%d)",self.detailModel.commentNum.intValue];
                
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
