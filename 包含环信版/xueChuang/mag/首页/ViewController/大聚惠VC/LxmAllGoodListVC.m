//
//  LxmAllGoodListVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/13.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmAllGoodListVC.h"
#import "LxmGoodListTopView.h"
#import "LxmGoodListCell.h"
#import "LxmGoodsDetailVC.h"

@interface LxmAllGoodListVC ()
@property (nonatomic , strong)LxmGoodListTopView * topView;

@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@property (nonatomic , strong) NSNumber * cunrrentID;
@end

@implementation LxmAllGoodListVC
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"麦奇二手精品";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    self.dataArr = [NSMutableArray array];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadGoodsList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadGoodsList];
    }];
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    
}

- (void)setCurrentModel:(LxmGoodListModel *)currentModel{
    if (currentModel) {
        self.time = [NSString getCurrentTimeChuo];
        self.page = 1;
        self.cunrrentID = currentModel.ID;
//        [self.tableView.mj_header beginRefreshing];
        [self loadGoodsList];
    }
}

- (void)loadGoodsList{
    if (ISLOGIN&&SESSION_TOKEN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"typeId":self.cunrrentID,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findECList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmGoodsListRootModel class] success:^(NSURLSessionDataTask *task, LxmGoodsListRootModel * responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmGoodsListModel1 * model = responseObject.result;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmGoodListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodListCell"];
    if (!cell)
    {
        cell = [[LxmGoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodListCell" type:LxmGoodListCell_style_allgoodlist];
    }
    LxmCanListModel * model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmCanListModel * model = self.dataArr[indexPath.row];
    return model.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmCanListModel * model = self.dataArr[indexPath.row];
    LxmGoodsDetailVC * vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_goodsDetail];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
