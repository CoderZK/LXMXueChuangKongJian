//
//  LxmTaskDetailVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTaskDetailVC.h"
#import "LxmHomeCell.h"
#import "PopListView.h"
#import "LxmTaskDetailHeaderView.h"
#import "LxmTaskDetailCell.h"
#import "LxmTaskBottomView.h"
#import "LxmQiangDanAlertView.h"
#import "MLYPhotoBrowserView.h"
#import "LxmSelectPeopleVC.h"
#import <UShareUI/UShareUI.h>
#import "LxmJuBaoVC.h"
#import "LxmMyDanVC.h"

@interface LxmTaskDetailVC ()<PopListViewDelegate,LxmTaskBottomViewDelegate,MLYPhotoBrowserViewDataSource,LxmTaskDetailHeaderViewDelegate,LxmTaskDetailCellDelegate,LxmQiangDanAlertViewDelegte,UMSocialShareMenuViewDelegate>
@property (nonatomic , strong) PopListView * popListView;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) LxmTaskBottomView * bottomView;
@property (nonatomic , strong) LxmHomeModel *detailModel;
//查看大图的图片数组
@property (nonatomic , strong) NSArray *imgs;
//任务留言数据
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;

/**
 点赞类型 1任务 2评论 3回复
 */
@property (nonatomic , assign) NSInteger type;

@end

@implementation LxmTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"任务详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.popListView = [[PopListView alloc] initWithTitleArr:@[@"分享",@"举报"] currectIndex:_currentIndex isAccShow:NO];
    self.popListView.delegate = self;
    
    
    [self loadDetailData];
    
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
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadLiuYanList];
    }];
}

- (void)baseLeftBtnClick {
    if (self.backViewControlller) {
        [self.navigationController popToViewController:self.backViewControlller animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 获取任务性情数据
 */
-(void)loadDetailData{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":self.billId
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_getHelpInfo] parameters:dic returnClass:[LxmHomeDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmHomeDetailRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.detailModel = responseObject.result;
                self.detailModel.isDetail = YES;
                if (self.detailModel.state.intValue == 1) {
                    if (kDevice_Is_iPhoneX) {
                        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 44 - 34 - StateBarH - 50);
                        self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34) withStyle:LxmTaskBottomView_style_qiangdan];
                    }else{
                        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 44 - StateBarH - 50);
                        self.bottomView = [[LxmTaskBottomView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50) withStyle:LxmTaskBottomView_style_qiangdan];
                    }
                    self.bottomView.delegate = self;
                    [self.view addSubview:self.bottomView];
                }else{
                    if (kDevice_Is_iPhoneX) {
                        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
                    }else{
                        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                    }
                    self.bottomView.hidden = YES;
                }
                self.detailModel.pageType = 2;
                if (self.detailModel.img) {
                    self.imgs = [self.detailModel.img componentsSeparatedByString:@","];
                }
                [self.bottomView.dianzanBtn setImage:[UIImage imageNamed:self.detailModel.likeStatus.intValue == 1 ?@"like":@"dislike"] forState:UIControlStateNormal];
                [self.bottomView.dianzanBtn setTitle:[NSString stringWithFormat:@"%@",self.detailModel.likeNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",self.detailModel.likeNum.intValue]] forState:UIControlStateNormal];
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

//任务留言列表
- (void)loadLiuYanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"billId":self.billId,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findBillCommentList];
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
                self.time = model.time;
                self.page++;
                [self.tableView reloadData];
            } else {
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [LxmTool ShareTool].commentStr = @"";
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.popListView.isShow){
        [self.popListView disMissAnimation:NO];
    }
    if (self.jumpType == 1) {
        //发布成功跳转
        [self.navigationController popToRootViewControllerAnimated:YES];
        [LxmEventBus sendEvent:@"publishAbleSuccess" data:nil];
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
    if (indexPath.row == 0) {
        [self loadShareData];
    }else if (indexPath.row == 1){
        //举报
        LxmJuBaoVC * vc = [[LxmJuBaoVC alloc] init];
        vc.billId = self.billId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//获取分享信息
- (void)loadShareData{
    
    [LxmNetworking networkingPOST:[LxmURLDefine app_shareInfo] parameters:@{@"type":@1,@"id":self.billId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
        if (self.detailModel.relUserId.intValue == [LxmTool ShareTool].userModel.userId) {
            [SVProgressHUD showErrorWithStatus:@"自己不能抢自己发的任务!"];
        }else{
            //抢单报名
            LxmQiangDanAlertView * view = [[LxmQiangDanAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            view.model = self.detailModel;
            view.delegate = self;
            [view showWithContent:self.detailModel.content];
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    LxmCommentListModel * sectionModel = self.dataArr[section-1];
    return sectionModel.replyList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LxmHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeCell"];
        if (!cell)
        {
            cell = [[LxmHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeCell" isMine:NO];
        }
        cell.model = self.detailModel;
        cell.commentBtn.hidden = YES;
        __weak typeof(self) safe_self = self;
        if (self.imgs.count>0) {
            cell.selectImgBlock = ^(NSInteger index) {
                MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
                mlyView.dataSource = safe_self;
                mlyView.currentIndex = index;
                [mlyView showWithItemsSpuerView:nil];
            };
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.detailModel.height ;
    }
    LxmCommentListModel * sectionModel = self.dataArr[indexPath.section-1];
    LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexPath.row];
    return model.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    LxmCommentListModel * sectionModel = self.dataArr[section-1];
    return sectionModel.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section!=0) {
        LxmCommentListModel * sectionModel = self.dataArr[indexPath.section-1];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UITableViewHeaderFooterView * headerView0  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView0"];
        if (!headerView0) {
            headerView0 = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView0"];
        }
        return headerView0;
    }else{
        LxmTaskDetailHeaderView * headerView = [[LxmTaskDetailHeaderView alloc] initWithReuseIdentifier:@"LxmTaskDetailHeaderView" withIndex:section-1];
        LxmCommentListModel * sectionModel = self.dataArr[section-1];
        headerView.model = sectionModel;
        headerView.backgroundColor = UIColor.whiteColor;
        headerView.delegate = self;
        headerView.contentView.backgroundColor = UIColor.whiteColor;
        return headerView;
    }
}

//图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.imgs.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.imageUrl = [NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:self.imgs[index]]];
    return photo;
}

//留言

- (void)liuYanWith:(NSString *)content{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":self.billId,
                               @"content":content,
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertBillComment] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
- (void)replyMineComment:(LxmCommentListModel *)model withContent:(NSString *)content{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":self.billId,
                               @"commentId":model.commentId,
                               @"content":content,
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertBillReply] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
                               @"billId":self.billId,
                               @"commentId":mineModel.commentId,
                               @"content":content,
                               @"replyId":model.ID,
                               @"toUserId":model.userId,
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertBillReply] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
//删除子评论
- (void)deleteReply:(LxmCommentReplyListModel *)model mainModel:(LxmCommentListModel *)mainModel{
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"replyId":model.ID
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteBillReply] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)deleteMain:(LxmCommentListModel *)model{
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"commentId":model.commentId
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteBillComment] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
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
//任务点赞
- (void)LxmHomeCellZanClick:(LxmHomeCell *)cell{
    [self dianzanwithType:@1 withMain:nil withReplyModel:nil];
}
//主评论点赞
- (void)LxmTaskDetailHeaderView:(LxmTaskDetailHeaderView *)headerView zanIndex:(NSInteger)index{
    LxmCommentListModel * model = [self.dataArr objectAtIndex:index];
    [self dianzanwithType:@2 withMain:model withReplyModel:nil];
    NSLog(@"%ld",index);
}
//回复点赞
- (void)LxmTaskDetailCellZanClick:(LxmTaskDetailCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmCommentListModel * sectionModel = self.dataArr[indexP.section-1];
    LxmCommentReplyListModel * model  = [sectionModel.replyList objectAtIndex:indexP.row];
    [self dianzanwithType:@3 withMain:sectionModel withReplyModel:model];
}

- (void)dianzanwithType:(NSNumber *)type withMain:(LxmCommentListModel *)model withReplyModel:(LxmCommentReplyListModel *)replyModel{
    if (ISLOGIN) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (type.intValue == 1) {
            dic[@"otherId"] = self.billId;
        }else if (type.intValue == 2){
            dic[@"otherId"] = model.commentId;
        }else if (type.intValue == 3){
            dic[@"otherId"] = replyModel.ID;
        }
        dic[@"token"] = SESSION_TOKEN;
        dic[@"type"] = type;
        [LxmNetworking networkingPOST:[LxmURLDefine user_likeBill] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 30003) {
                [SVProgressHUD showSuccessWithStatus:@"点赞成功!"];
                if (type.intValue == 1) {
                    NSNumber * num = @(self.detailModel.likeNum.intValue+1);
                    self.detailModel.likeNum = num;
                    self.detailModel.likeStatus = @1;
                    [self.bottomView.dianzanBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                    [self.bottomView.dianzanBtn setTitle:[NSString stringWithFormat:@"%@",self.detailModel.likeNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",self.detailModel.likeNum.intValue] ] forState:UIControlStateNormal];
                }else if (type.intValue == 2){
                    NSNumber * num = @(model.likeNum.intValue+1);
                    model.likeNum = num;
                    model.likeStatus = @1;
                }else if (type.intValue == 3){
                    NSNumber * num = @(replyModel.likeNum.intValue+1);
                    replyModel.likeNum = num;
                    replyModel.likeStatus = @1;
                }
                [self.tableView reloadData];
               
            }else if ([responseObject[@"key"] intValue] == 30004) {
                [SVProgressHUD showSuccessWithStatus:@"已取消点赞!"];
                if (type.intValue == 1) {
                    NSNumber * num = @(self.detailModel.likeNum.intValue-1);
                    self.detailModel.likeNum = num;
                    self.detailModel.likeStatus = @2;
                    [self.bottomView.dianzanBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                    [self.bottomView.dianzanBtn setTitle:[NSString stringWithFormat:@"%d",self.detailModel.likeNum.intValue] forState:UIControlStateNormal];
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

- (void)LxmQiangDanAlertViewBottomClick:(LxmQiangDanAlertView *)alertView {
    [alertView dismiss];
    if (ISLOGIN) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"token"] = SESSION_TOKEN;
        dic[@"billId"] = self.billId;
        dic[@"orderId"] = self.detailModel.orderId;
        if (alertView.phoneTF.text) {
            dic[@"phone"] = alertView.phoneTF.text;
        }
        [LxmNetworking networkingPOST:[LxmURLDefine user_enrollHelp] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"抢单成功!"];
                [self loadDetailData];
                
                LxmMyDanVC *danVc = [LxmMyDanVC new];
                danVc.isQiangDanVC = YES;
                [self.navigationController pushViewController:danVc animated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}
//
- (void)peopleListClick{
    //
    if (self.detailModel.relUserId.intValue == [LxmTool ShareTool].userModel.userId) {
        if (self.detailModel.state.intValue == 1) {
            //自己为发单人且单子状态为可抢 跳转选择抢单人
            LxmSelectPeopleVC * peopleVC = [[LxmSelectPeopleVC alloc] init];
            [self.navigationController pushViewController:peopleVC animated:YES];
        }else{
            //自己为发单人且单子状态为已选定接单人或已完成 跳转承接人列表
        }
        
    }else{
        if (self.detailModel.state.intValue == 1) {
            //别人为发单人且单子状态为可抢 不跳转
            
        }else{
            //别人为发单人且单子状态为已选定接单人或已完成 跳转承接人列表
        }
    }
    
}


@end
