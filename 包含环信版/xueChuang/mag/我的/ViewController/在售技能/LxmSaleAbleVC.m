//
//  LxmSaleAbleVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSaleAbleVC.h"
#import "LxmSaleJiNengCell.h"
#import "LxmYueDanPeopleVC.h"
#import "LxmGoodsDetailVC.h"

@interface LxmSaleAbleVC ()<LxmSaleJiNengCellDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmSaleAbleVC
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
    [self loadMyCanList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadMyCanList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadMyCanList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}
- (void)loadMyCanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findMyCanList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCanListRootModel class] success:^(NSURLSessionDataTask *task, LxmCanListRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmCanListModel1 * model = responseObject.result;
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
    LxmSaleJiNengCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSaleJiNengCell"];
    if (!cell)
    {
        cell = [[LxmSaleJiNengCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSaleJiNengCell"];
    }
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)LxmSaleJiNengCell:(LxmSaleJiNengCell *)cell btnAtIndex:(NSInteger)index{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexP.row];
    if (index == 18) {
        if (model.state.intValue == 1) {
            //约单人
            if (model.buyUserNum.intValue > 0) {
                LxmYueDanPeopleVC * vc = [[LxmYueDanPeopleVC alloc] init];
                vc.billId = model.billId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            //上架
            [self editMyCanWithType:@1 model:model];
        }
    }else if (index == 19){
        if (model.state.intValue == 1) {
            //下架
            UIAlertController * actionController = [UIAlertController alertControllerWithTitle:@"确定要下架该技能吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               [self editMyCanWithType:@2 model:model];
            }];
            UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [actionController addAction:a1];
            [actionController addAction:a2];
            [self presentViewController:actionController animated:YES completion:nil];
            
        }else{
            //删除
            [self deleteModel:model];
        }
        
    }
}
//删除
- (void)deleteModel:(LxmCanListModel *)model{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":model.billId
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteMyCan] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [LxmEventBus sendEvent:@"deleteAbleDan" data:nil];
                self.page = 1;
                [self loadMyCanList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}

//上下架
- (void)editMyCanWithType:(NSNumber *)type model:(LxmCanListModel *)model{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"billId":model.billId,
                               @"type":type
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_editMyCan] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [LxmEventBus sendEvent:@"upAbleDanSuccess" data:nil];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadMyCanList];
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
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat topH = 0;
    CGFloat titleH = 0;
    CGFloat contentH = 0;
    if (model.img && ![model.img isEqualToString:@""]) {
        topH = 15+80+15;
    } else {
        titleH = [model.title getSizeWithMaxSize:CGSizeMake(ScreenW - 120, 80) withFontSize:18].height;
        contentH = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 80) withFontSize:14].height;
        contentH = (contentH > 30 ? 30 : contentH);
        topH = 15+titleH+10+contentH;
    }
    CGFloat h = 0;
    if (model.buyUserList.count == 0) {
        h = 0;
    }else{
        h = 50;
    }
    return (topH > 110 ? 110:topH) + h + 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    LxmGoodsDetailVC * vc = nil;
    if (model.state.intValue == 1) {
        //在售
        vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_ableDetail];
    }else{
        //下架
        vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_myJineng];
    }
    vc.billId = model.billId;
    vc.model = model;
    vc.isOwn = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerImgClick:(LxmSaleJiNengCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexP.row];
    LxmGoodsDetailVC * vc = nil;
    if (model.state.intValue == 1) {
        //在售
        vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_ableDetail];
    }else{
        //下架
        vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_myJineng];
    }
    vc.billId = model.billId;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
