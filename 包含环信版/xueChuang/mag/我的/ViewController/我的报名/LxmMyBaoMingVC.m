//
//  LxmMyBaoMIngVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyBaoMingVC.h"
#import "LxmBaomingDetailVC.h"

@interface LxmMyBaoMingVC ()
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmMyBaoMingVC
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
    self.navigationItem.title = @"我的报名";
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
    [self loadMyBaoMingList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadMyBaoMingList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadMyBaoMingList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}
- (void)loadMyBaoMingList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findMyTourList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyTourListRootModel class] success:^(NSURLSessionDataTask *task, LxmMyTourListRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmMyTourListModel1 * model = responseObject.result;
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
    LxmMyBaoMingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyBaoMingCell"];
    if (!cell)
    {
        cell = [[LxmMyBaoMingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyBaoMingCell"];
    }
    LxmMyTourListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmMyTourListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    LxmBaomingDetailVC * vc = [[LxmBaomingDetailVC alloc] init];
    vc.applyId = model.applyId;
    vc.refreshPreVC = ^{
        self.time = [NSString getCurrentTimeChuo];
        self.page = 1;
        [self loadMyBaoMingList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end


@interface LxmMyBaoMingCell()
@property (nonatomic , strong) UIImageView * picView;
@property (nonatomic , strong) UILabel * titlelab;
@property (nonatomic , strong) UILabel  * moneylab;
@property (nonatomic , strong) UILabel * timeLab;
@property (nonatomic , strong) UILabel * stateLab;

@end
@implementation LxmMyBaoMingCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.picView];
        [self addSubview:self.titlelab];
        [self addSubview:self.moneylab];
        [self addSubview:self.timeLab];
        [self addSubview:self.stateLab];
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
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@100);
    }];
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView);
        make.leading.equalTo(self.picView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-95);
    }];
    [self.moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView);
        make.trailing.equalTo(self).offset(-15);
        make.width.lessThanOrEqualTo(@80);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.picView);
        make.leading.equalTo(self.titlelab);
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.picView);
        make.trailing.equalTo(self).offset(-15);
    }];
    
}

- (UIImageView *)picView{
    if (!_picView) {
        _picView = [[UIImageView alloc] init];
        _picView.image = [UIImage imageNamed:@"whequemoren"];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.layer.masksToBounds = YES;
    }
    return _picView;
}
- (UILabel *)titlelab{
    if (!_titlelab) {
        _titlelab = [[UILabel alloc] init];
        _titlelab.textColor = CharacterDarkColor;
        _titlelab.font = [UIFont systemFontOfSize:18];
        _titlelab.text = @"国庆德国+法国+瑞士+意大利12日游";
        _titlelab.numberOfLines = 2;
    }
    return _titlelab;
}
- (UILabel *)moneylab{
    if (!_moneylab) {
        _moneylab = [[UILabel alloc] init];
        _moneylab.textColor = YellowColor;
        _moneylab.font = [UIFont boldSystemFontOfSize:18];
        _moneylab.text = @"￥50";
        _moneylab.textAlignment = NSTextAlignmentRight;
    }
    return _moneylab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = CharacterLightGrayColor;
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.text = @"2017.08.28";
    }
    return _timeLab;
}

- (UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.textColor = CharacterDarkColor;
        _stateLab.font = [UIFont systemFontOfSize:15];
        _stateLab.text = @"待付款";
    }
    return _stateLab;
}

- (void)setModel:(LxmMyTourListModel *)model{
    _model = model;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.pic]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
    self.titlelab.text = model.title;
    self.moneylab.text = [NSString stringWithFormat:@"￥%@",model.money];
    NSString * str  = model.createTime;
    if (model.createTime.length>9) {
        str = [model.createTime substringToIndex:model.createTime.length - 9];
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    self.timeLab.text = str;
    if (model.status.intValue == 1) {
        self.stateLab.text = @"待付款";
    }else if (model.status.intValue == 2){
        self.stateLab.text = @"已支付";
    }else if (model.status.intValue == 4){
        self.stateLab.text = @"已关闭";
    }
}

@end
