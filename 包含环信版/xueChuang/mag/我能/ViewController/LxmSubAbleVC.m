//
//  LxmSubAbleVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSubAbleVC.h"
#import "LxmGoodListCell.h"
#import "LxmGoodsDetailVC.h"
#import "LxmMyPageVC.h"
#import "LxmLoginAndRegisterVC.h"

@interface LxmSubAbleVC ()<LxmGoodListCellDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@property (nonatomic , strong) NSNumber * cunrrentID;
@end

@implementation LxmSubAbleVC
- (UILabel *)noneDataView {
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
    
    self.dataArr = [NSMutableArray array];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadCanList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadCanList];
    }];
    
}
- (void)setCurrentModel:(LxmGoodListModel *)currentModel {
    if (currentModel) {
        self.time = [NSString getCurrentTimeChuo];
        self.page = 1;
        self.cunrrentID = currentModel.ID;
        [self loadCanList];
    }
}
- (void)loadCanList{
    if (self.isyouke) {
        NSDictionary * dict = @{
                                @"typeId":self.cunrrentID,
                                @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findSkillList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCanListRootModel class] success:^(NSURLSessionDataTask *task, LxmCanListRootModel * responseObject) {
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    } else {
        if (ISLOGIN&&SESSION_TOKEN) {
            NSDictionary * dict = @{
                                    @"token":SESSION_TOKEN,
                                    @"typeId":self.cunrrentID,
                                    @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                                    @"pageNum":@(self.page),
                                    @"time":self.time
                                    };
            NSString * str = [LxmURLDefine user_findCanList];
            [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCanListRootModel class] success:^(NSURLSessionDataTask *task, LxmCanListRootModel * responseObject) {
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
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
        }
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmGoodListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodListCell"];
    if (!cell)
    {
        cell = [[LxmGoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodListCell" type:LxmGoodListCell_style_dianshang];
    }
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (void)LxmGoodListCellHeaderImgViewClick:(LxmGoodListCell *)cell{
    if (self.isyouke) {
        
    } else {
        NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
        LxmCanListModel * model = [self.dataArr objectAtIndex:indexP.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    return model.height==0?0.01:model.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    LxmGoodsDetailVC * vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_ableDetail];
    vc.model = model;
    if (self.isyouke) {
        vc.isyouke = YES;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
