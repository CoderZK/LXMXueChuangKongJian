//
//  LxmPeopleListVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPeopleListVC.h"
#import "LxmMyCommentVC.h"
#import "LxmStarImgView.h"



@interface LxmPeopleListVC ()<LxmPeopleListCellDelegate>

@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , strong) NSMutableArray * dataArr;

@end

@implementation LxmPeopleListVC
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
    self.navigationItem.title = @"承接人";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    self.dataArr = [NSMutableArray array];
    [self loadPeopleList];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}

- (void)loadPeopleList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"billId":self.model.billId
                                };
        NSString * str = [LxmURLDefine user_findHelpUserList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyQingDanPeopleRootModel class] success:^(NSURLSessionDataTask *task, LxmMyQingDanPeopleRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
               
                LxmMyQingDanPeopleModel1 * model = responseObject.result;
                NSArray * dataArr =  [NSMutableArray arrayWithArray:model.list];
                [self.dataArr addObjectsFromArray:dataArr];
                if (self.dataArr.count == 0) {
                    self.noneDataView.hidden = NO;
                }else{
                    self.noneDataView.hidden = YES;
                }
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

- (void)setModel:(LxmHomeModel *)model{
    _model = model;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmPeopleListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPeopleListCell"];
    if (!cell)
    {
        cell = [[LxmPeopleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPeopleListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LxmMyQingDanPeopleModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (void)LxmPeopleListCellCommnetBtnClick:(LxmPeopleListCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmMyQingDanPeopleModel * model = [self.dataArr objectAtIndex:indexP.row];
    LxmMyCommentVC * vc = [[LxmMyCommentVC alloc] init];
    vc.model = model;
    vc.danModel = self.model;
    vc.refreshPreBlock = ^{
        self.dataArr = nil;
        [self loadPeopleList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end


@interface LxmPeopleListCell()
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;

@property (nonatomic , strong) UIButton * commnetBtn;
@end
@implementation LxmPeopleListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.startView];
        [self addSubview:self.commnetBtn];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains{
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@40);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
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
    [self.commnetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
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
- (UIButton *)commnetBtn{
    if (!_commnetBtn) {
        _commnetBtn = [[UIButton alloc] init];
        [_commnetBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_commnetBtn setBackgroundImage:[UIImage imageNamed:@"bg_10"] forState:UIControlStateNormal];
        [_commnetBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _commnetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _commnetBtn.layer.cornerRadius = 12.5;
        _commnetBtn.layer.masksToBounds = YES;
        [_commnetBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commnetBtn;
}
- (void)commentClick{
    if ([self.delegate respondsToSelector:@selector(LxmPeopleListCellCommnetBtnClick:)]) {
        [self.delegate LxmPeopleListCellCommnetBtnClick:self];
    }
}
- (void)setModel:(LxmMyQingDanPeopleModel *)model{
    _model = model;
    self.startView.starNum = model.robUserRate.intValue;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.robUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.robUserSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.robUserNick;
    if (model.state.intValue == 2) {
        self.commnetBtn.hidden = YES;
    }else if(model.state.intValue == 3){
        //已完成的单子可以进行评价
        self.commnetBtn.hidden = NO;
        self.commnetBtn.userInteractionEnabled = YES;
    }else{
        //已评价
        self.commnetBtn.userInteractionEnabled = NO;
        [self.commnetBtn setTitle:@"已评价" forState:UIControlStateNormal];
        [self.commnetBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    }
}

@end
