//
//  XckjLvYouAndPaiMaiVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "XckjLvYouAndPaiMaiVC.h"
#import "LxmWenZhangCell.h"
#import "XckjLvAndPaiMaiDetailVC.h"

@interface XckjLvYouAndPaiMaiVC ()
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@property (nonatomic , strong) LxmHomeBannerModel * typeModel;


@end

@implementation XckjLvYouAndPaiMaiVC

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
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style  currentModel:(LxmHomeBannerModel *)model{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.typeModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.typeModel.content;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    }

    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadArticleList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadArticleList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [safe_self loadArticleList];
    }];
   
}


- (void)loadArticleList{
    
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.typeModel.isMyCollection) {
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"typeId":self.typeModel.ID,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
            str = [LxmURLDefine user_findMyCollectList];
        }else{
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                     @"typeId":self.typeModel.ID,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
            str = [LxmURLDefine user_findArticleListFromType];
        }

        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmArticleRootModel class] success:^(NSURLSessionDataTask *task, LxmArticleRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmArticleModel1 * model = responseObject.result;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmWenZhangCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmWenZhangCell"];
    if (!cell)
    {
        cell = [[LxmWenZhangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmWenZhangCell"];
    }
    LxmArticleModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmArticleModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    return model.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmArticleModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    XckjLvAndPaiMaiDetailVC *  vc = [[XckjLvAndPaiMaiDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped typeModel:model type:self.typeModel.ID];
    __weak typeof(self)safe_self = self;
    vc.refreshMineCollection = ^{
        safe_self.time = [NSString getCurrentTimeChuo];
        safe_self.page = 1;
        [safe_self loadArticleList];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
