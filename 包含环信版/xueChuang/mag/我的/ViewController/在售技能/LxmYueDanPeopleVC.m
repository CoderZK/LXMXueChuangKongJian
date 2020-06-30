//
//  LxmYueDanPeopleVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmYueDanPeopleVC.h"
#import "LxmGoodsDetailVC.h"
#import "LxmMyPageVC.h"
#import "LxmLoginAndRegisterVC.h"

@interface LxmYueDanPeopleVC ()
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmYueDanPeopleVC
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
    self.navigationItem.title = @"约单";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self loadBuyMyCanUserList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadBuyMyCanUserList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadBuyMyCanUserList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}

- (void)loadBuyMyCanUserList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"billId":self.billId,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findBuyMyCanUserList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmBuyMyCanUserRootModel class] success:^(NSURLSessionDataTask *task, LxmBuyMyCanUserRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmBuyMyCanUserModel1 * model = responseObject.result;
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
    LxmYueDanPeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYueDanPeopleCell"];
    if (!cell)
    {
        cell = [[LxmYueDanPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYueDanPeopleCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LxmBuyMyCanUserModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmBuyMyCanUserModel * model = [self.dataArr objectAtIndex:indexPath.row];
    return  model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmBuyMyCanUserModel * model = [self.dataArr objectAtIndex:indexPath.row];
    //跳转他人的个人主页
    [self loadOtherInfoDataWithID:model.buyUserId];
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


@end
@interface LxmYueDanPeopleCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UILabel * numLab;
@property (nonatomic , strong) UIImageView * finishImgView;
@property (nonatomic , strong) UILabel * finishLab;
@property (nonatomic , strong) UILabel * timeLab;
@property (nonatomic , strong) UILabel * timeLab1;

@property (nonatomic, strong) UILabel *addressLabel;

@end
@implementation LxmYueDanPeopleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.headerImgView];
        [self.topView addSubview:self.nameLab];
        [self.topView addSubview:self.numLab];
        [self.topView addSubview:self.finishImgView];
        [self.topView addSubview:self.finishLab];
        [self.topView addSubview:self.timeLab];
        [self.topView addSubview:self.timeLab1];
        [self addSubview:self.addressLabel];
        
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.leading.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setConstrains{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.topView).offset(15);
        make.width.height.equalTo(@30);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self.numLab.mas_leading);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.trailing.equalTo(self.topView).offset(-ScreenW*0.5);
    }];
    [self.finishImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.topView).offset(ScreenW*0.5+10);
        make.width.height.equalTo(@20);
    }];
    [self.finishLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.finishImgView.mas_trailing);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView).offset(-15);
        make.trailing.equalTo(self.topView).offset(-15);
        
    }];
    [self.timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView).offset(10);
        make.trailing.equalTo(self.topView).offset(-15);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 15;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
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
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont systemFontOfSize:14];
        _numLab.text = @"x2";
        _numLab.textColor = CharacterDarkColor;
    }
    return _numLab;
}
- (UIImageView *)finishImgView{
    if (!_finishImgView) {
        _finishImgView = [[UIImageView alloc] init];
        _finishImgView.image = [UIImage imageNamed:@"finish"];
        _finishImgView.layer.cornerRadius = 15;
        _finishImgView.layer.masksToBounds = YES;
    }
    return _finishImgView;
}
- (UILabel *)finishLab{
    if (!_finishLab) {
        _finishLab = [[UILabel alloc] init];
        _finishLab.font = [UIFont systemFontOfSize:14];
        _finishLab.text = @"完成";
        _finishLab.textColor = BlueColor;
    }
    return _finishLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = @"2018/10/19";
        _timeLab.textColor = CharacterDarkColor;
    }
    return _timeLab;
}
- (UILabel *)timeLab1{
    if (!_timeLab1) {
        _timeLab1 = [[UILabel alloc] init];
        _timeLab1.font = [UIFont systemFontOfSize:14];
        _timeLab1.text = @"10:34:55";
        _timeLab1.textColor = CharacterDarkColor;
    }
    return _timeLab1;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = CharacterDarkColor;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (void)setModel:(LxmBuyMyCanUserModel *)model{
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.buyUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.nameLab.text = model.buyUserNick;
    self.numLab.text = [NSString stringWithFormat:@"x%d",model.number.intValue];
    if (model.state.intValue == 3) {
       self.finishImgView.hidden = self.finishLab.hidden = NO;
    }else{
        self.finishImgView.hidden = self.finishLab.hidden = YES;
    }
    if (model.matchTime) {
        NSArray * arr = [model.matchTime componentsSeparatedByString:@" "];
        if (arr.count ==2) {
            NSString * str = arr.firstObject;
            str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            self.timeLab.text = str;
            self.timeLab1.text = arr.lastObject;
        }
    }
    if (!_model.sendAddr) {
        self.addressLabel.text= @"";
    } else {
        self.addressLabel.text = [NSString stringWithFormat:@"收货地址: %@", _model.sendAddr];
    }
}


@end
