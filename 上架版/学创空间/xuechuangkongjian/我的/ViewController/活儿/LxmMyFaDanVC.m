//
//  LxmMyFaDanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyFaDanVC.h"
#import "LxmMyFaDanCell.h"
#import "LxmSelectPeopleVC.h"
#import "TaskDetailVC.h"
#import "LxmPeopleListVC.h"

@interface LxmMyFaDanVC ()<LxmMyFaDanCellDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmMyFaDanVC
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
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
        [safe_self loadDanList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    
}
- (void)loadDanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findMyHelpList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyPublishRootModel class] success:^(NSURLSessionDataTask *task, LxmMyPublishRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmMyPublishModel * model = responseObject.result;
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmMyFaDanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyFaDanCell"];
    if (!cell)
    {
        cell = [[LxmMyFaDanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyFaDanCell"];
    }
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    __weak typeof(self)safe_self = self;
    cell.selectImgBlock = ^(NSInteger index) {
        LxmHomeModel * model = [safe_self.dataArr lxm_object1AtIndex:indexPath.row];
        TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
        detailVC.billId = model.billId;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
}
//
- (void)peopleFinishDanClick:(LxmMyFaDanCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    if (model.state.intValue == 1) {
        //可抢 跳转选择抢单人
        if (model.robList.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"还没有人抢单!"];
            return;
        }else{
            LxmSelectPeopleVC * vc = [[LxmSelectPeopleVC alloc] init];
            vc.billId = model.billId;
            vc.refreshPreBlock = ^{
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadDanList];
            };
            [self.preVC.navigationController pushViewController:vc animated:YES];
        }
    }else{
        //已选定抢单人 和 已完成
        LxmPeopleListVC * vc = [[LxmPeopleListVC alloc] init];
        vc.model = model;
        [self.preVC.navigationController pushViewController:vc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    return model.height;
}
- (void)lxmMyFaDanCell:(LxmMyFaDanCell *)cell btnAtIndex:(NSInteger)index{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    if (index == 15) {
        //进行中 完成中 已完成
        
    }else if(index == 16){
        //取消订单
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消订单吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
             [self cancelDan:model];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
       
    }else if (index == 17){
        if (model.state.intValue == 1) {
            //可抢
            //选择抢单人
            if (model.robList.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"还没有人抢单!"];
                return;
            }else{
                LxmSelectPeopleVC * vc = [[LxmSelectPeopleVC alloc] init];
                vc.billId = model.billId;
                vc.refreshPreBlock = ^{
                    self.time = [NSString getCurrentTimeChuo];
                    self.page = 1;
                    [self loadDanList];
                };
                [self.preVC.navigationController pushViewController:vc animated:YES];
            }
        }else if (model.state.intValue == 2){
            //完成中
            [self finishWithModel:model];
            
        }else{
            //已完成
            LxmPeopleListVC * vc = [[LxmPeopleListVC alloc] init];
            vc.model = model;
            [self.preVC.navigationController pushViewController:vc animated:YES];
        }
    }
}
//取消我发布的活订单
- (void)cancelDan:(LxmHomeModel *)model{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dic  = @{
                                @"token":SESSION_TOKEN,
                                @"billId":model.billId
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine user_cannelMyRelHelp] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已取消"];
                [LxmEventBus sendEvent:@"cancelPublishAbleSuccess" data:nil];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadDanList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
   
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)imgCollectionClick:(LxmMyFaDanCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    TaskDetailVC * detailVC = [[TaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)finishWithModel:(LxmHomeModel *)model{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":model.billId
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_finishMyRelHelp] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已完成"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadDanList];
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
