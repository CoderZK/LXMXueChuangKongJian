//
//  LxmNewFriendVC.m
//  mag
//
//  Created by 宋乃银 on 2018/7/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmNewFriendVC.h"
#import "LxmSearchNewFriendVC.h"

@interface LxmNewFriendVC ()<LxmNewFriendCellDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmNewFriendVC
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新的朋友";
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    [self initTopSearchView];
    
    self.dataArr = [NSMutableArray array];
    [self loadNewFriendList];
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0.5, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0.5, ScreenW, self.view.bounds.size.height);
    }
    
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak.dataArr removeAllObjects];
        [selfWeak loadNewFriendList];
    }];
    
    
}
//初始化头部view
- (void)initTopSearchView {
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    self.tableView.tableHeaderView = headerView;
    
    UIButton * searchBtn = [[UIButton alloc] init];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBtn setImage:[UIImage imageNamed:@"ico_sousuo"] forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.leading.equalTo(headerView).offset(15);
        make.trailing.equalTo(headerView).offset(-15);
        make.height.equalTo(@40);
    }];
}
//搜索朋友
- (void)searchBtnClick {
    LxmSearchNewFriendVC *searchNewFriendVC = [[LxmSearchNewFriendVC alloc] init];
    [self.navigationController pushViewController:searchNewFriendVC animated:NO];
}

- (void)loadNewFriendList{
    
    if (ISLOGIN) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        NSString * str = [LxmURLDefine user_findNewFriendList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmFindNewFriendListRootModel class] success:^(NSURLSessionDataTask *task, LxmFindNewFriendListRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if (responseObject.key.intValue == 1) {
                LxmFindNewFriendListModel1 * model = responseObject.result;
                NSMutableArray * arr = [NSMutableArray arrayWithArray:model.list];
                self.dataArr = arr;
                self.noneDataView.hidden = self.dataArr > 0;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }else{
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmNewFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNewFriendCell"];
    if (!cell) {
        cell = [[LxmNewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNewFriendCell"];
    }
    LxmFindNewFriendListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
//通过加好友验证
- (void)LxmNewFriendCellPassBtnClick:(LxmNewFriendCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmFindNewFriendListModel * model = [self.dataArr objectAtIndex:indexP.row];
    if (model.type.intValue == 1) {
        [self agreeFriendWithApplyID:model.applyId];
    }
}

- (void)agreeFriendWithApplyID:(NSNumber *)applyID{
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"applyId":applyID
                                };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_agreeFriendApply] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已通过"];
                if (self.passFriendBlock) {
                    self.passFriendBlock();
                }
                [self.dataArr removeAllObjects];
                [self loadNewFriendList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录，请先登录"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 + 30;
}

@end


@interface LxmNewFriendCell()
@property (nonatomic , strong) UIView * topView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UIButton * passBtn;
@property (nonatomic , strong) UILabel * contentLab;
@end

@implementation LxmNewFriendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.headerImgView];
        [self.topView addSubview:self.sexImgView];
        [self.topView addSubview:self.nameLab];
        [self.topView addSubview:self.passBtn];
        [self addSubview:self.contentLab];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        [self setConstrains];
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
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
        make.trailing.equalTo(self.passBtn.mas_leading);
    }];
    [self.passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@26);
        make.width.equalTo(@70);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.equalTo(self.sexImgView);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UIView *)topView{
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
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.text = @"巴啦啦小魔仙";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}

- (UIButton *)passBtn{
    if (!_passBtn) {
        _passBtn = [[UIButton alloc] init];
        [_passBtn setBackgroundImage:[UIImage imageNamed:@"bg_10"] forState:UIControlStateNormal];
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        [_passBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _passBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _passBtn.layer.cornerRadius = 13;
        _passBtn.layer.masksToBounds = YES;
        [_passBtn addTarget:self action:@selector(passBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passBtn;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = CharacterDarkColor;
        _contentLab.text = @"我是叶惠美";
    }
    return _contentLab;
}

- (void)setModel:(LxmFindNewFriendListModel *)model{
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.inviteHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.inviteSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.inviteNickname;
    self.contentLab.text = model.content;
    if (model.type.intValue == 1) {
        [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
        _passBtn.userInteractionEnabled = YES;
    }else{
        [_passBtn setTitle:@"已添加" forState:UIControlStateNormal];
        _passBtn.userInteractionEnabled = NO;
    }
}
- (void)passBtnClick{
    if ([self.delegate respondsToSelector:@selector(LxmNewFriendCellPassBtnClick:)]) {
        [self.delegate LxmNewFriendCellPassBtnClick:self];
    }
}

@end
