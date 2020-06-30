//
//  LxmMyQiangDanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyQiangDanVC.h"
#import "LxmMyQiangDanCell.h"
#import "LxmCommentContentView.h"
#import "LxmTaskDetailVC.h"
@interface LxmMyQiangDanVC ()<LxmMyQiangDanCellDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmMyQiangDanVC
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
    [self loadQiangDanList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadQiangDanList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadQiangDanList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}

- (void)loadQiangDanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findMyRobHelpList];
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
    LxmMyQiangDanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyQiangDanCell"];
    if (!cell)
    {
        cell = [[LxmMyQiangDanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyQiangDanCell"];
    }
    LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    __weak typeof(self)safe_self = self;
    cell.selectImgBlock = ^(NSInteger index) {
        LxmHomeModel * model = [safe_self.dataArr objectAtIndex:indexPath.row];
        LxmTaskDetailVC * detailVC = [[LxmTaskDetailVC alloc] init];
        detailVC.billId = model.billId;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
}

- (void)lxmMyQiangDanCell:(LxmMyQiangDanCell *)cell btnAtIndex:(NSInteger)index{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr objectAtIndex:indexP.row];
    if (index == 22) {
        //左边按钮
        
    }else if (index == 23){
        //右边按钮
        if (model.state.intValue == 1) {
            //取消申请
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消申请吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self cancelQiangDan:model];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }else if(model.state.intValue == 2){
            //确认完成
            [self finishWithModel:model];
        }else if (model.state.intValue == 3){
            //已完成 只是状态显示 没有事件
        }else if (model.state.intValue == 4){
            [self seeComment:model];
        }else if (model.state.intValue == 5){
            //删除订单
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除订单吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self deleteQiangDan:model];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
       
    }
}
- (void)imgCollectionClick:(LxmMyQiangDanCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr objectAtIndex:indexP.row];
    LxmTaskDetailVC * detailVC = [[LxmTaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)peopleFinishDanClick:(LxmMyQiangDanCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmHomeModel * model = [self.dataArr objectAtIndex:indexP.row];
    LxmTaskDetailVC * detailVC = [[LxmTaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//查看我抢的活订单评价
- (void)seeComment:(LxmHomeModel *)model{
    if (ISLOGIN) {
        NSDictionary * dic  = @{
                                @"token":SESSION_TOKEN,
                                @"billId":model.billId
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine user_getMyRobHelpEva] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                //查看评价
                LxmCommentContentView * alertView = [[LxmCommentContentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertView.star = responseObject[@"result"][@"score"];
                alertView.textView.text = responseObject[@"result"][@"content"];
                [alertView show];
              
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

//取消我抢的活订单
- (void)cancelQiangDan:(LxmHomeModel *)model{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dic  = @{
                                @"token":SESSION_TOKEN,
                                @"allotId":model.allotId
                                };
        [LxmNetworking networkingPOST:[LxmURLDefine user_cannelMyRobHelp] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已取消"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadQiangDanList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

- (void)finishWithModel:(LxmHomeModel *)model{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"allotId":model.allotId
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_finishMyRobHelp] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已完成"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadQiangDanList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
    
}

- (void)deleteQiangDan:(LxmHomeModel *)model{
    
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"allotId":model.allotId
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteMyRobHelp] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已删除"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadQiangDanList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
    LxmTaskDetailVC * detailVC = [[LxmTaskDetailVC alloc] init];
    detailVC.billId = model.billId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
