
//
//  LxmMyCostRecordVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyCostRecordVC.h"


@interface LxmMyCostRecordVC ()
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@end

@implementation LxmMyCostRecordVC
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
    self.navigationItem.title = @"消费记录";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self loadMyExpendList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        * safe_page = 1;
        [safe_self loadMyExpendList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadMyExpendList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}

- (void)loadMyExpendList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                };
        NSString * str = [LxmURLDefine user_findMyConsumeList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyConsumeRootModel class] success:^(NSURLSessionDataTask *task, LxmMyConsumeRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmMyConsumeModel1 * model = responseObject.result;
                NSArray * dataArr =  [NSMutableArray arrayWithArray:model.list];
                [self.dataArr addObjectsFromArray:dataArr];
                if (self.dataArr.count == 0) {
                    self.noneDataView.hidden = NO;
                }else{
                    self.noneDataView.hidden = YES;
                }
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
    LxmMyCostRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyCostRecordCell"];
    if (!cell)
    {
        cell = [[LxmMyCostRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyCostRecordCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LxmMyConsumeModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end

@interface LxmMyCostRecordCell()
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * timeLab;
@property (nonatomic , strong) UILabel * moneyLab;
@end

@implementation LxmMyCostRecordCell 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.moneyLab];
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)setConstrains{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-15);
        make.leading.equalTo(self).offset(15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(15);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.text = @"支付-跑步";
        _titleLab.textColor = CharacterDarkColor;
    }
    return _titleLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = @"2017-05-20 14:00";
        _timeLab.textColor = CharacterLightGrayColor;
    }
    return _timeLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont boldSystemFontOfSize:18];
        _moneyLab.text = @"-￥50";
        _moneyLab.textColor = BlueColor;
    }
    return _moneyLab;
}
- (void)setModel:(LxmMyConsumeModel *)model{
    _model = model;
    NSString * str  = model.createTime;
    if (model.createTime.length > 3) {
        str = [str substringToIndex:model.createTime.length-3];
    }
    self.timeLab.text = str;
    if (model.type.intValue == 1) {
        self.titleLab.text = model.typeName;
        _moneyLab.text = [NSString stringWithFormat:@"+￥%0.2f",model.money.floatValue];
        _moneyLab.textColor = YellowColor;
    }else if (model.type.intValue == 2){
        self.titleLab.text = model.typeName;
        _moneyLab.text = [NSString stringWithFormat:@"-￥%0.2f",model.money.floatValue];
        _moneyLab.textColor = BlueColor;
    }else if (model.type.intValue == 3){
        _moneyLab.text = @"申请中";
        self.titleLab.text = @"提现";
        _moneyLab.textColor = CharacterDarkColor;
    }else if (model.type.intValue == 4){
        _moneyLab.text = @"提现成功";
        self.titleLab.text = @"提现";
        _moneyLab.textColor = CharacterDarkColor;
    }else if (model.type.intValue == 5){
        _moneyLab.text = @"提现失败";
        self.titleLab.text = @"提现";
        _moneyLab.textColor = CharacterDarkColor;
    }
}


@end
