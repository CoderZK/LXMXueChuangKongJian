//
//  XckjQiangDanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/6.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "XckjQiangDanVC.h"
#import "LxmHomeCell.h"
#import "PopListView.h"
#import "TaskDetailVC.h"
#import "LxmMyPageVC.h"
#import "LxmLoginAndRegisterVC.h"

@interface XckjQiangDanVC ()<PopListViewDelegate,LxmHomeCellDelegate>
@property (nonatomic , strong) LxmHomeBannerModel * itemModel;
@property (nonatomic , strong) PopListView * popListView;
@property (nonatomic , assign) NSInteger currentIndex;

@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;

@end

@implementation XckjQiangDanVC
- (UILabel *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _noneDataView.text = @"没有数据!";
        _noneDataView.font = [UIFont systemFontOfSize:16];
        _noneDataView.textAlignment = NSTextAlignmentCenter;
        _noneDataView.textColor = [UIColor blackColor];
        _noneDataView.hidden = YES;
    }
    return _noneDataView;
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style currentModel:(LxmHomeBannerModel *)model{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.itemModel = model;
        _currentIndex = 0;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = self.itemModel.content;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.popListView = [[PopListView alloc] initWithTitleArr:@[@"最新发布",@"好评率",@"热度",@"价格由高到低",@"价格由低到高"] currectIndex:_currentIndex isAccShow:YES];
    self.popListView.delegate = self;
    
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadDanList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
   
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadDanList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [safe_self loadDanList];
    }];
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    
    [LxmEventBus registerEvent:@"yilahei" block:^(id data) {
       self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadDanList];
    }];
    
}
- (void)loadDanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                                @"typeId":self.itemModel.ID,
                                @"sort":@(self.currentIndex+1),
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findHelpListFromType];
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
                if (self.dataArr.count == 0) {
                    self.noneDataView.hidden = NO;
                }else{
                    self.noneDataView.hidden = YES;
                }
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.popListView.isShow){
        [self.popListView disMissAnimation:NO];
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
-(void)PopListView:(PopListView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    view.currentIndex = indexPath.row;
    self.currentIndex = indexPath.row;
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadDanList];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeCell"];
    if (!cell)
    {
        cell = [[LxmHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeCell" isMine:NO];
    }
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    __weak typeof(self)safe_self = self;
    cell.selectImgBlock = ^(NSInteger index) {
        LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
        TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
        detailVC.billId = model.billId;
        [safe_self.navigationController pushViewController:detailVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)headerImgViewClick:(LxmHomeCell *)cell{
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



- (void)LxmHomeCellZanClick:(LxmHomeCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)imgCollectionClick:(LxmHomeCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
