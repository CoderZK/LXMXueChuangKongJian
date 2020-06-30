//
//  LxmSearchNewFriendVCViewController.m
//  mag
//
//  Created by 李晓满 on 2018/10/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "SearchNewFriendVC.h"
#import "NewFriendVC.h"

@interface LxmSearchNewFriendVC ()<UITextFieldDelegate,LxmNewFriendCellDelegate>

@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , strong) NSMutableArray * dataArr;

@end

@implementation LxmSearchNewFriendVC

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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
   
    if (kDevice_Is_iPhoneX) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-34);
        }];
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }
    [self.tableView layoutIfNeeded];
    
    self.dataArr = [NSMutableArray array];
    [self loadNewFriendList];
    
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak.dataArr removeAllObjects];
        [selfWeak loadNewFriendList];
    }];
    
    [self.tf becomeFirstResponder];
}

- (void)initNav {
    UIView * topNav = [[UIView alloc] init];
    topNav.backgroundColor = BGGrayColor;
    [self.view addSubview:topNav];
    [topNav addSubview:self.tf];
    [topNav addSubview:self.cancelBtn];
    
    [topNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.equalTo(@(StateBarH + 44));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(topNav).offset(15);
        make.bottom.equalTo(topNav).offset(-10);
        make.trailing.equalTo(self.cancelBtn.mas_leading).offset(-15);
        make.height.equalTo(@30);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tf);
        make.trailing.equalTo(topNav).offset(-15);
        make.height.equalTo(@44);
    }];
    
}

- (UITextField *)tf {
    if (!_tf) {
        _tf = [[UITextField alloc] init];
        _tf.placeholder = @"搜索";
        _tf.backgroundColor = [UIColor whiteColor];
        UIButton * leftView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [leftView setImage:[UIImage imageNamed:@"ico_sousuo"] forState:UIControlStateNormal];
        _tf.leftView = leftView;
        _tf.returnKeyType = UIReturnKeySearch;
        _tf.leftViewMode = UITextFieldViewModeAlways;
        _tf.font = [UIFont systemFontOfSize:14];
        _tf.layer.cornerRadius = 5;
        _tf.layer.masksToBounds = YES;
        _tf.delegate = self;
       
    }
    return _tf;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BlueColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_cancelBtn addTarget:self action:@selector(dismissControler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)dismissControler {
    [self.navigationController popViewControllerAnimated:NO];
}
//搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    [self.dataArr removeAllObjects];
    [self loadNewFriendList];
    return YES;
}

- (void)loadNewFriendList{
    
    if (ISLOGIN) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        if (self.tf.text.length!=0||![[self.tf.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            dict[@"nickname"] = self.tf.text;
        }
        NSString * str = [LxmURLDefine user_findNewFriendList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmFindNewFriendListRootModel class] success:^(NSURLSessionDataTask *task, LxmFindNewFriendListRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if (responseObject.key.intValue == 1) {
                LxmFindNewFriendListModel1 * model = responseObject.result;
                NSMutableArray * arr = [NSMutableArray arrayWithArray:model.list];
                self.dataArr = arr;
                self.noneDataView.hidden = self.dataArr.count > 0;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
        }];
    }else{
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmNewFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNewFriendCell"];
    if (!cell) {
        cell = [[LxmNewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNewFriendCell"];
    }
    LxmFindNewFriendListModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
//通过加好友验证
- (void)LxmNewFriendCellPassBtnClick:(LxmNewFriendCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmFindNewFriendListModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
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
