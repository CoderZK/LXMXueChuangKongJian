//
//  LxmAddressVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmAddressVC.h"
#import "LxmAddAdressVC.h"

@interface LxmAddressVC ()<LxmAddressCellDelegate>
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , strong) NSMutableArray * dataArr;
@end

@implementation LxmAddressVC
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
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    self.navigationItem.title = @"提现地址";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initBottomView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];

    self.dataArr = [NSMutableArray array];
    [self loadMyAddressList];
    __weak typeof(self) safe_self = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        [safe_self loadMyAddressList];
    }];

}
- (void)loadMyAddressList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                };
        NSString * str = [LxmURLDefine user_findCashAddressList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyAddressRootModel class] success:^(NSURLSessionDataTask *task, LxmMyAddressRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if (responseObject.key.intValue == 1) {
                LxmMyAddressModel1 * model = responseObject.result;
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
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}



- (void)initBottomView{
    UIView * bottomView = nil;
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"新增提现地址" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}

- (void)bottomBtnClick{
    LxmAddAdressVC * vc = [[LxmAddAdressVC alloc] initWithTableViewStyle:UITableViewStylePlain withModel:nil];
    __weak typeof(self)safe_self = self;
    vc.refreshBlock = ^{
        [safe_self.dataArr removeAllObjects];
        [safe_self loadMyAddressList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAddressCell"];
    if (!cell)
    {
        cell = [[LxmAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAddressCell"];
    }
    LxmMyAddressModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmMyAddressModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectModel:)]) {
        [self.delegate selectModel:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120+50;
}
- (void)lxmAddressCell:(LxmAddressCell *)cell btnAtIndex:(NSInteger)index{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmMyAddressModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    if (index == 33) {
        //修改
        LxmAddAdressVC * vc = [[LxmAddAdressVC alloc] initWithTableViewStyle:UITableViewStylePlain withModel:model];
        __weak typeof(self)safe_self = self;
        vc.refreshBlock = ^{
            [safe_self.dataArr removeAllObjects];
            [safe_self loadMyAddressList];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //删除
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条提现地址吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteWithID:model.addrId];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)deleteWithID:(NSNumber *)addressID{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"addrId":addressID
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteCashAddress] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已删除"];
                [self.dataArr removeAllObjects];
                [self loadMyAddressList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
   
}



@end

@interface LxmAddressCell()
@property (nonatomic , strong) UIImageView * iconImgView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UILabel * codeLab;

@property (nonatomic , strong) UIView * bottomView;
@property (nonatomic , strong) UIButton * editBtn;
@property (nonatomic , strong) UIButton * deleteBtn;
@end
@implementation LxmAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.nameLab];
        [self addSubview:self.codeLab];
        
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.editBtn];
        [self.bottomView addSubview:self.deleteBtn];
        
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        UIView * line1 = [[UIView alloc] init];
        line1.backgroundColor = BGGrayColor;
        [self.bottomView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self.bottomView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setConstrains{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(13);
        make.width.height.equalTo(@25);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(5);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.leading.equalTo(self.titleLab);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
    [self.codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLab);
        make.bottom.equalTo(self).offset(-65);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bottomView).offset(-15);
        make.centerY.equalTo(self.bottomView);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.deleteBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.bottomView);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"bg_yinhangka"];
    }
    return _iconImgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.text = @"支付宝";
        _titleLab.textColor = CharacterDarkColor;
    }
    return _titleLab;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.text = @"李佳丽";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}
- (UILabel *)codeLab{
    if (!_codeLab) {
        _codeLab = [[UILabel alloc] init];
        _codeLab.font = [UIFont systemFontOfSize:16];
        _codeLab.text = @"123456789156313";
        _codeLab.textColor = CharacterDarkColor;
    }
    return _codeLab;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        
    }
    return _bottomView;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitle:@"  编辑" forState:UIControlStateNormal];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"addressedit"] forState:UIControlStateNormal];
        [_editBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _editBtn.tag = 33;
        [_editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setTitle:@"  删除" forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"addressdelete"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _deleteBtn.tag = 34;
        [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(lxmAddressCell:btnAtIndex:)]) {
        [self.delegate lxmAddressCell:self btnAtIndex:btn.tag];
    }
}


- (void)setModel:(LxmMyAddressModel *)model{
    _model = model;
    self.iconImgView.image = [UIImage imageNamed:model.type.intValue == 1?@"zhifubao1":@"bg_yinhangka"];
    model.type.intValue == 1 ? (self.titleLab.text = @"支付宝") : (self.titleLab.text = model.bankName);
    self.nameLab.text = model.name;
    self.codeLab.text = model.account;
}

@end
