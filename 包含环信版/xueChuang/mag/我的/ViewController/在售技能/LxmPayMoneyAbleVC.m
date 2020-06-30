//
//  LxmPayMoneyAbleVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPayMoneyAbleVC.h"
#import "LxmGoodsDetailVC.h"
#import "LxmPayVC.h"

@interface LxmPayMoneyAbleVC ()<LxmPayMoneyAbleCellDelegate>
@property (nonatomic , assign)LxmPayMoneyAbleVC_type type;
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmPayMoneyAbleVC
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
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmPayMoneyAbleVC_type)type{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == LxmPayMoneyAbleVC_type_wgmdsp) {
        self.navigationItem.title = @"订单";
    }
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
    [self loadMyBuyCanList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadMyBuyCanList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadMyBuyCanList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}
- (void)loadMyBuyCanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = @"";
        
        if (self.type == LxmPayMoneyAbleVC_type_fbjn) {
            str = [LxmURLDefine user_findMyBuyCanList];
        }else{
            str = [LxmURLDefine user_findMyECList];
        }
        
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
    LxmPayMoneyAbleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPayMoneyAbleCell"];
    if (!cell)
    {
        cell = [[LxmPayMoneyAbleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPayMoneyAbleCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    if (self.type == LxmPayMoneyAbleVC_type_fbjn) {
        model.isfbjn = YES;
    }
//    model.content = @"GV小矮个大SAV到工程本地不潇洒和时间长了好想带上很好吃的神经病出具的非和抵抗力萨比臭豆腐差不多是快来吧臭豆腐成都市将咖啡成都商报纪念卡遍历出VCD发你社保卡浪费VCD商家爱看出风口你得及时才能登发数据库女教师的禅道上那接口吃饭你家";
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    if (model.isfbjn) {
        return 60+110+60;
    } else {
        CGFloat contentH = 0;
        if (model.content&&![model.content isEqualToString:@""]) {
            contentH = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:14].height + 15;
        }
        contentH =  (contentH > 30?30:contentH);
        return 60+15+20+10+contentH+60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LxmCanListModel * model = self.dataArr[indexPath.row];
    LxmGoodsDetailVC * vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_goodsDetail];
    vc.model = model;
    vc.billId = model.ecId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)LxmPayMoneyAbleCell:(LxmPayMoneyAbleCell *)cell btnAtIndex:(NSInteger)index{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmCanListModel * model = [self.dataArr objectAtIndex:indexP.row];
    if (index == 20) {//左
        if (self.type == LxmPayMoneyAbleVC_type_fbjn) {
            if (model.state.intValue == 3) {
                //删除
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条记录吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteWith:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                
            }
        }else{
            if (model.status.intValue == 5) {
                //删除
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条记录吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteWith:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                
            }
        }
       
    }else{//右
        if (self.type == LxmPayMoneyAbleVC_type_fbjn) {
            if (model.state.intValue == 1) {
                //支付
               if (model.billState.intValue == 1) {
                    [self payWithOrderID:[NSString stringWithFormat:@"%@",model.orderId] money:model.allMoney withtype:3];
               } else {
                    [SVProgressHUD showErrorWithStatus:@"技能商品已下架"];
               }
                
            }else if (model.state.intValue == 2){
                //确认收货
                
                UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self sureShouHuo:model];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
            
        }else{
            if (model.status.intValue == 1||model.status.intValue == 3) {
                //待付款或支付失败
                if (ISLOGIN) {
                    [self payWithOrderID:[NSString stringWithFormat:@"%@",model.orderId] money:model.allMoney withtype:4];
//                    if (model.billState.intValue == 1) {
//                        [self payWithOrderID:[NSString stringWithFormat:@"%@",model.orderId] money:model.allMoney withtype:4];
//                    }else {
//                        [SVProgressHUD showErrorWithStatus:@"技能商品已下架"];
//                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
                }
            }else if (model.status.intValue == 2){
                //支付成功或 已发货
                [self sureShouHuo:model];
            }else{
                //已收货
            }
        }
       
    }
}

- (void)deleteWith:(LxmCanListModel *)model{
    if (ISLOGIN) {
        NSDictionary *dict = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmPayMoneyAbleVC_type_fbjn) {
            str = [LxmURLDefine user_deleteMyBuyCan];
            dict  = @{
                      @"token":SESSION_TOKEN,
                      @"allotId":model.allotId
                      };
        }else{
            str = [LxmURLDefine user_deleteMyEC];
            dict  = @{
                      @"token":SESSION_TOKEN,
                      @"orderId":model.orderId
                      };
        }
        [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showErrorWithStatus:@"已删除"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadMyBuyCanList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}


- (void)payWithOrderID:(NSString *)orderID money:(NSNumber *)money withtype:(NSInteger)type{
    LxmPayVC * vc = nil;
    if (type == 3) {
        vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStylePlain type:3];
    }else{
        vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStylePlain type:4];
    }
    __weak typeof(self) safe_self = self;
    vc.refreshPreVC = ^{
        safe_self.time = [NSString getCurrentTimeChuo];
        safe_self.page = 1;
        [safe_self loadMyBuyCanList];
        
    };
    vc.orderMoney = money;
    vc.orderID = orderID;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sureShouHuo:(LxmCanListModel *)model{
    if (ISLOGIN) {
        NSDictionary * dict  = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmPayMoneyAbleVC_type_fbjn) {
            str =  [LxmURLDefine user_confirmMyCan];
            dict  = @{
                      @"token":SESSION_TOKEN,
                      @"allotId":model.allotId
                      };
        }else{
            str =  [LxmURLDefine user_confirmMyEC];
            dict  = @{
                      @"token":SESSION_TOKEN,
                      @"orderId":model.orderId
                      };
        }
        
        [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadMyBuyCanList];
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

#import "LxmStarImgView.h"

@interface LxmPayMoneyAbleCell()
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UILabel * orderInfolab;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;

@property (nonatomic , strong) UIImageView * dianImgView;
@property (nonatomic , strong) UILabel * typeLab;

/**
 商品信息模块
 */
@property (nonatomic , strong) UIView * goodInfoView;
@property (nonatomic , strong) UIImageView * picImgView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UILabel * contentLab;

/**
 订单状态模块
 */
@property (nonatomic , strong) UIView * stateView;

@property (nonatomic , strong) UILabel * stateLab;
@property (nonatomic , strong) UILabel * totalMoneyLab;
@property (nonatomic , strong) UILabel * numLab;

@property (nonatomic , strong) UIButton * peopleBtn;
@property (nonatomic , strong) UIButton * stateBtn;

@end
@implementation LxmPayMoneyAbleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        [self.publicInfoView addSubview:self.orderInfolab];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self addSubview:self.goodInfoView];
        [self.goodInfoView addSubview:self.picImgView];
        [self.goodInfoView addSubview:self.titleLab];
        [self.goodInfoView addSubview:self.moneyLab];
        [self.goodInfoView addSubview:self.contentLab];
        
        [self addSubview:self.stateView];
        [self.stateView addSubview:self.stateLab];
//        [self.stateView addSubview:self.totalMoneyLab];
//        [self.stateView addSubview:self.numLab];
        [self.stateView addSubview:self.peopleBtn];
        [self.stateView addSubview:self.stateBtn];
        
        [self setConstrains];
        
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self.stateView addSubview:line];
        __weak typeof(self)safe_self = self;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safe_self.stateView);
            make.leading.equalTo(safe_self.stateView).offset(15);
            make.trailing.equalTo(safe_self.stateView).offset(-15);
            make.height.equalTo(@0.5);
        }];
        
        UIView * line1 = [[UIView alloc] init];
        line1.backgroundColor = BGGrayColor;
        [self.stateView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(safe_self.stateView);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}
- (void)setConstrains{
    [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.publicInfoView).offset(10);
        make.width.height.equalTo(@40);
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
    [self.dianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.width.height.equalTo(@6);
        make.trailing.equalTo(self.typeLab.mas_leading).offset(-3);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
    }];
    
    [self.orderInfolab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startView.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    [self.goodInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom);
        make.leading.trailing.equalTo(self.publicInfoView);
        make.height.equalTo(@110);
    }];
    [self.picImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.goodInfoView).offset(15);
        make.width.height.equalTo(@80);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.picImgView.mas_trailing).offset(15);
        make.top.equalTo(self.picImgView);
        make.trailing.lessThanOrEqualTo(self.moneyLab.mas_leading);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.trailing.equalTo(self.goodInfoView).offset(-15);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLab);
        make.trailing.equalTo(self.goodInfoView).offset(-15);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodInfoView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@60);
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(self.stateView);
    }];
//    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.stateLab.mas_trailing);
//        make.centerY.equalTo(self.stateView);
//    }];
//    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.totalMoneyLab.mas_trailing);
//        make.centerY.equalTo(self.stateView);
//    }];

    [self.peopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.trailing.equalTo(self.stateBtn.mas_leading).offset(-15);
        make.leading.greaterThanOrEqualTo(self.stateLab.mas_leading);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.trailing.equalTo(self.stateView);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
}

- (UIView *)publicInfoView{
    if (!_publicInfoView) {
        _publicInfoView = [[UIView alloc] init];
    }
    return _publicInfoView;
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 20;
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
- (LxmStarImgView *)startView{
    if (!_startView) {
        _startView = [[LxmStarImgView alloc] init];
        _startView.layer.masksToBounds = YES;
    }
    return _startView;
}
- (UIImageView *)dianImgView{
    if (!_dianImgView) {
        _dianImgView = [[UIImageView alloc] init];
        _dianImgView.backgroundColor = [UIColor colorWithRed:81/255.0 green:224/255.0 blue:245/255.0 alpha:1];
        _dianImgView.layer.cornerRadius = 3;
        _dianImgView.layer.masksToBounds = YES;
    }
    return _dianImgView;
}
- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:14];
        _typeLab.text = @"跑腿";
        _typeLab.textColor = CharacterLightGrayColor;
    }
    return _typeLab;
}
- (UILabel *)orderInfolab{
    if (!_orderInfolab) {
        _orderInfolab = [[UILabel alloc] init];
        _orderInfolab.font = [UIFont systemFontOfSize:14];
        _orderInfolab.text = @"订单编号:43070215545";
        _orderInfolab.textColor = CharacterLightGrayColor;
    }
    return _orderInfolab;
}

- (UIView *)goodInfoView{
    if (!_goodInfoView) {
        _goodInfoView = [[UIView alloc] init];
    }
    return _goodInfoView;
}
- (UIImageView *)picImgView{
    if (!_picImgView) {
        _picImgView = [[UIImageView alloc] init];
        _picImgView.image = [UIImage imageNamed:@"whequemoren"];
    }
    return _picImgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = CharacterDarkColor;
        _titleLab.text = @"手工润唇膏";
    }
    return _titleLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont boldSystemFontOfSize:18];
        _moneyLab.textColor = CharacterDarkColor;
        _moneyLab.text = @"20元/支";
    }
    return _moneyLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.numberOfLines = 2;
        _contentLab.text = @"北门圆通,收件人冯全,送至2-231,中午前送达哦";
    }
    return _contentLab;
}
- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
       
    }
    return _stateView;
}

- (UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.textColor = CharacterDarkColor;
        _stateLab.font = [UIFont systemFontOfSize:14];
    }
    return _stateLab;
}
//- (UILabel *)totalMoneyLab{
//    if (!_totalMoneyLab) {
//        _totalMoneyLab = [[UILabel alloc] init];
//        _totalMoneyLab.textColor = YellowColor;
//        _totalMoneyLab.font = [UIFont boldSystemFontOfSize:18];
//        _totalMoneyLab.text = @"￥160";
//    }
//    return _totalMoneyLab;
//}
//- (UILabel *)numLab{
//    if (!_numLab) {
//        _numLab = [[UILabel alloc] init];
//        _numLab.textColor = CharacterDarkColor;
//        _numLab.font = [UIFont systemFontOfSize:14];
//        _numLab.text = @"(20x8)";
//    }
//    return _numLab;
//}

- (UIButton *)peopleBtn{
    if (!_peopleBtn) {
        _peopleBtn = [[UIButton alloc] init];
        [_peopleBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
        [_peopleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_peopleBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _peopleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _peopleBtn.tag = 20;
        _peopleBtn.layer.cornerRadius = 8;
        _peopleBtn.layer.masksToBounds = YES;
        [_peopleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _peopleBtn;
}
- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [[UIButton alloc] init];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_stateBtn setTitle:@"已收货" forState:UIControlStateNormal];
        [_stateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _stateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _stateBtn.tag = 21;
        _stateBtn.layer.cornerRadius = 8;
        _stateBtn.layer.masksToBounds = YES;
        [_stateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateBtn;
}

- (void)setModel:(LxmCanListModel *)model{
    _model = model;
    self.startView.starNum = model.relRate.intValue;
    //60
    if (model.img) {
        NSArray * arr = [model.img componentsSeparatedByString:@","];
        if (arr.count>=1) {
            [self.picImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:arr.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
        }
    }
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.relUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.relSex.intValue == 1?@"male":@"female"];
    self.typeLab.text = [NSString returnTypeNameWithType:model.sendType.intValue];
    self.titleLab.text = model.title;
    self.moneyLab.text = [NSString stringWithFormat:@"%@元/%@",model.money,model.unit];
    self.nameLab.text = model.relNickname;
    self.dianImgView.backgroundColor = [UIColor colorWithType:model.sendType.intValue];
    self.contentLab.text = model.content;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"费用合计:"];
    NSAttributedString *stt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",model.allMoney] ? [NSString stringWithFormat:@"￥%@",model.allMoney] : @"￥0" attributes:@{NSForegroundColorAttributeName:YellowColor}];
    NSAttributedString *stt1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"(%@x%d)",model.money,model.number.intValue] ? [NSString stringWithFormat: @"(%@x%d)",model.money,model.number.intValue] : @"(0x1)" attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    [att appendAttributedString:stt];
    [att appendAttributedString:stt1];
    self.orderInfolab.text = [NSString stringWithFormat:@"订单编号: %@",model.orderNo];
    self.stateLab.attributedText = att;
//    self.totalMoneyLab.text = [NSString stringWithFormat:@"￥%@",model.allMoney];
//    self.numLab.text = [NSString stringWithFormat: @"(%@x%d)",model.money,model.number.intValue];
    
    if (model.isfbjn) {
        if (model.state.intValue == 1) {
            //待付款
            self.peopleBtn.hidden = YES;
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"待支付" forState:UIControlStateNormal];
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenW - 115));
            }];
            
        }else if (model.state.intValue == 2){
            //支付成功 或 已发货
            self.peopleBtn.hidden = YES;
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenW - 115));
            }];
        }else{
            //已收货
            self.peopleBtn.hidden = NO;
            [self.peopleBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.peopleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"已收货" forState:UIControlStateNormal];
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenW - 215));
            }];
        }
        
        
        
        [self.goodInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@110);
        }];
        [self.picImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self.goodInfoView).offset(15);
            make.width.height.equalTo(@80);
        }];
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.picImgView.mas_trailing).offset(15);
        }];
        
    }else{
        if (model.status.intValue == 1||model.status.intValue == 3) {
            //待付款 或支付失败
            self.peopleBtn.hidden = YES;
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"待支付" forState:UIControlStateNormal];
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenW - 115));
            }];
            
        }else if (model.status.intValue == 2||model.status.intValue == 4){
            //支付成功 或 已发货
            self.peopleBtn.hidden = YES;
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenW - 115));
            }];
        }else{
            //已收货
            self.peopleBtn.hidden = NO;
            [self.peopleBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.peopleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"已收货" forState:UIControlStateNormal];
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenW - 215));
            }];
        }
        
        CGFloat contentH = 0;
        if (model.content&&![model.content isEqualToString:@""]) {
            contentH = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:14].height + 15;
        }
       contentH =  (contentH > 30?30:contentH);

        [self.goodInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(15+20+10+contentH));
        }];
        [self.picImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@0);
        }];
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.picImgView.mas_trailing);
        }];
     
    }
    [self layoutIfNeeded];
}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(LxmPayMoneyAbleCell:btnAtIndex:)]) {
        [self.delegate LxmPayMoneyAbleCell:self btnAtIndex:btn.tag];
    }
}

@end
