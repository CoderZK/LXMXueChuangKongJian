//
//  LxmAddAdressVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmAddAdressVC.h"
#import "LxmTextTFView.h"
#import "MKTextTableViewCell.h"

@interface LxmAddAdressVC ()<UITextFieldDelegate>
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) LxmTextTFView * nameView;
@property (nonatomic , strong) LxmTextTFView * accountView;
@property (nonatomic , strong) LxmTextTFView * bankView;
@property (nonatomic , strong) NSArray *nameArray;

@property (nonatomic , assign) NSInteger selectIndex;


@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *account;

@property (strong, nonatomic) NSString *bankAccount;

@property (nonatomic , strong) LxmMyAddressModel * addressModel;

@property (nonatomic , assign) BOOL isRequest;

@end

@implementation LxmAddAdressVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style withModel:(LxmMyAddressModel *)model{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.addressModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现地址";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    
    [self initBottomView];
    
    //初始化选择支付方式
    self.selectIndex = 0;
    
    if (self.addressModel) {
        if (self.addressModel.type.intValue == 1) {
            self.nameArray = @[@"姓名",@"账号"];
            self.selectIndex = 0;
            self.name = self.addressModel.name;
            self.account = self.addressModel.account;
        }else {
            self.nameArray = @[@"姓名",@"银行名称",@"账号"];
            self.selectIndex = 1;
            self.name = self.addressModel.name;
            self.account = self.addressModel.account;
            self.bankAccount = self.addressModel.bankName;
        }
    }else {
        self.nameArray = @[@"姓名",@"账号"];
    }
}

- (void)initBottomView{
    UIView * bottomView = nil;
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}

- (void)bottomBtnClick{
    if (self.addressModel) {
        if (self.name.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
            return;
        }
        if (self.account.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入账号"];
            return;
        }
        
        if (self.selectIndex == 1 && self.bankAccount.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入银行名称"];
            return;
        }
        
//        if (self.selectIndex == 1000) {
//            [SVProgressHUD showErrorWithStatus:@"请选择提现方式"];
//            return;
//        }
        
        NSDictionary * dic = @{
                                       @"token":SESSION_TOKEN,
                                       @"type":@(self.selectIndex+1),
                                       @"name":self.name,
                                       @"account":self.account,
                                       @"bankName":self.bankAccount.length > 0 ? self.bankAccount : @"",
                                       @"addrId":self.addressModel.addrId,
                                       };
                if (self.isRequest == NO) {
                    self.isRequest = YES;
                    [LxmNetworking networkingPOST:[LxmURLDefine user_updateCashAddress] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        if ([responseObject[@"key"] intValue] == 1) {
                            if (self.refreshBlock) {
                                self.refreshBlock();
                            }
                            [SVProgressHUD showSuccessWithStatus:@"地址修改成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }else{
                            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                            self.isRequest = NO;
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        self.isRequest = NO;
                    }];
                }
    }else{
        if (ISLOGIN) {
            if (self.name.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
                return;
            }
            if (self.account.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入账号"];
                return;
            }
            
            if (self.selectIndex == 1 && self.bankAccount.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入银行名称"];
                return;
            }
            
//            if (self.selectIndex == 1000) {
//                [SVProgressHUD showErrorWithStatus:@"请选择提现方式"];
//                return;
//            }
            
            NSDictionary * dic = @{
                                   @"token":SESSION_TOKEN,
                                   @"type":@(self.selectIndex+1),
                                   @"name":self.name,
                                   @"account":self.account,
                                   @"bankName":self.bankAccount.length > 0 ? self.bankAccount : @"",
                                   };
            if (self.isRequest == NO) {
                self.isRequest = YES;
                [LxmNetworking networkingPOST:[LxmURLDefine user_insertCashAddress] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"key"] intValue] == 1) {
                        if (self.refreshBlock) {
                            self.refreshBlock();
                        }
                        [SVProgressHUD showSuccessWithStatus:@"地址添加成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                        self.isRequest = NO;
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    self.isRequest = NO;
                }];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return self.nameArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LxmAddAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAddAdressCell"];
        if (!cell)
        {
            cell = [[LxmAddAdressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAddAdressCell"];
        }
        
        cell.accImgView.image = [UIImage imageNamed:indexPath.item == self.selectIndex?@"xuanze_1":@"xuanze"];
        cell.titleLab.text = indexPath.row == 0 ?@"支付宝":@"银行卡";
        cell.iconImgView.image = [UIImage imageNamed:indexPath.row == 0 ?@"zhifubao1":@"bg_yinhangka"];
        return cell;
    } else if (indexPath.section == 1) {
        if (self.selectIndex == 0) {
            NSString *cellIdentifier = NSStringFromClass([MKTextTableViewCell class]);
            UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            MKTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.nameLabel.text = self.nameArray[indexPath.row];
            cell.nameTextfiled.delegate = self;
            cell.nameTextfiled.tag = indexPath.row;
            if (indexPath.row == 0) {
                cell.nameTextfiled.placeholder = @"请输入姓名";
                cell.nameTextfiled.text = self.name;
            }
            if (indexPath.row == 1) {
                cell.nameTextfiled.placeholder = @"请输入账号";
                cell.nameTextfiled.text = self.account;
            }
            return cell;
        } else if (self.selectIndex == 1) {
            NSString *cellIdentifier = NSStringFromClass([MKTextTableViewCell class]);
            UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            MKTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.nameLabel.text = self.nameArray[indexPath.row];
            cell.nameTextfiled.delegate = self;
            cell.nameTextfiled.tag = indexPath.row;
            if (indexPath.row == 0){
                cell.nameTextfiled.placeholder = @"请输入姓名";
                cell.nameTextfiled.text = self.name;
            }
            if (indexPath.row == 1) {
                cell.nameTextfiled.placeholder = @"请输入银行名称";
                cell.nameTextfiled.text = self.bankAccount;
            }
            if (indexPath.row == 2) {
                cell.nameTextfiled.placeholder = @"请输入账号";
                cell.nameTextfiled.text = self.account;
            }
            return cell;
        } else {
            return [UITableViewCell new];
        }
    } else {
        return [UITableViewCell new];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.selectIndex == 0) {
        if (textField.tag == 0) {
            self.name = textField.text;
        }
        if (textField.tag == 1) {
            self.account = textField.text;
        }
    }else if (self.selectIndex == 1) {
        if (textField.tag == 0) {
            self.name = textField.text;
        }
        if (textField.tag == 1) {
            self.bankAccount = textField.text;
        }
        if (textField.tag == 2) {
            self.account = textField.text;
        }
    }else {
        if (textField.tag == 0) {
            self.name = textField.text;
        }
        if (textField.tag == 1) {
            self.account = textField.text;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.textColor = CharacterDarkColor;
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.tag = 21;
        [headerView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.leading.equalTo(headerView).offset(15);
        }];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(headerView);
            make.height.equalTo(@0.5);
        }];
    }
    UILabel * titleLab = (UILabel *)[headerView viewWithTag:21];
    titleLab.text = section == 0 ? @"选择提现方式":@"详细信息";
    headerView.contentView.backgroundColor = UIColor.whiteColor;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0?10:0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        self.selectIndex = indexPath.row;
        
        if (self.selectIndex == 0) {
            self.nameArray = @[@"姓名",@"账号"];
        }else if (self.selectIndex == 1) {
            self.nameArray = @[@"姓名",@"银行名称",@"账号"];
        }
        [self.tableView reloadData];
    }
}

@end
@interface LxmAddAdressCell()

@end
@implementation LxmAddAdressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.accImgView];
        
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setConstrains{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@25);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.width.height.equalTo(@20);
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
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.text = @"支付宝";
        _titleLab.textColor = CharacterDarkColor;
    }
    return _titleLab;
}

- (UIImageView *)accImgView{
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"xuanze"];
    }
    return _accImgView;
}

@end
