//
//  LxmMyPageVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyPageVC.h"
#import "LxmMyPageHeaderView.h"
#import "LxmHomeCell.h"
#import "LxmGoodListCell.h"
#import "LxmModifyUserInfoVC.h"
#import "LxmCodeVC.h"
#import "LxmTaskDetailVC.h"
#import "LxmGoodsDetailVC.h"

@interface LxmMyPageVC ()<LxmMyPageHeaderViewDelegate>
@property (nonatomic , strong) LxmMyPageInfoView * infoView;
@property (nonatomic , assign) NSInteger selectIndex;
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@property (nonatomic , assign) LxmMyPageVC_type type;
@end

@implementation LxmMyPageVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmMyPageVC_type)type{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (UILabel *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
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
    self.tableView.backgroundColor = self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.noneDataView;
    self.infoView = [[LxmMyPageInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
    if (self.type == LxmMyPageVC_type_me) {
        self.infoView.infoModel = self.infoModel;
    }else{
        self.infoView.otherInfoModel = self.otherInfoModel;
    }
    
    self.infoView.backgroundColor = UIColor.whiteColor;
    [self.infoView.modifyBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView.codeBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.infoView;
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadDanList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        if (self.selectIndex == 0) {
             [safe_self loadDanList];
        }else if (self.selectIndex == 1){
             [safe_self loadCanList];
        }else if (self.selectIndex == 2){
            [safe_self loadReceiveEvaluateList];
        }
       
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.selectIndex == 0) {
            [safe_self loadDanList];
        }else if (self.selectIndex == 1){
            [safe_self loadCanList];
        }else if (self.selectIndex == 2){
            [safe_self loadReceiveEvaluateList];
        }
    }];
}

- (void)loadOtherInfo {
    
}


- (void)loadDanList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        
        NSDictionary *dict = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmMyPageVC_type_me) {
            dict = @{
                    @"token":SESSION_TOKEN,
                    @"pageNum":@(self.page),
                    @"time":self.time
                    };
            str = [LxmURLDefine user_findMyHelpList];
        }else{
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"otherUserId":self.otherId.length > 0 ? self.otherId : self.otherInfoModel.otherUserID,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
            str = [LxmURLDefine user_findOthersHelpList];
        }
        
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyPublishRootModel class] success:^(NSURLSessionDataTask *task, LxmMyPublishRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmMyPublishModel * model = responseObject.result;
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

- (void)loadCanList{
    if (ISLOGIN&&SESSION_TOKEN) {
        NSDictionary *dict = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmMyPageVC_type_me) {
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
            str = [LxmURLDefine user_findMyCanList];
        }else{
            dict = @{
                    @"token":SESSION_TOKEN,
                    @"typeId":@0,
                    @"otherUserId":self.otherInfoModel.otherUserID,
                    @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                    @"pageNum":@(self.page),
                    @"time":self.time
                    };
            str = [LxmURLDefine user_findOthersCanList];
        }
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmCanListRootModel class] success:^(NSURLSessionDataTask *task, LxmCanListRootModel * responseObject) {
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

- (void)loadReceiveEvaluateList{
    if (ISLOGIN&&SESSION_TOKEN) {
        NSDictionary * dict  =[NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == LxmMyPageVC_type_me) {
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
            str = [LxmURLDefine user_findMyRecEvaList];
        }else{
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"otherUserId": self.otherId.length > 0 ? self.otherId : self.otherInfoModel.otherUserID,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
            str = [LxmURLDefine user_findOthersRecEva];
        }
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyEvaluateListRootModel class] success:^(NSURLSessionDataTask *task, LxmMyEvaluateListRootModel * responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmMyEvaluateListModel1 * model = responseObject.result;
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

- (void)infoBtnClick:(UIButton *)btn{
    if (btn == self.infoView.modifyBtn) {
        LxmModifyUserInfoVC * vc = [[LxmModifyUserInfoVC alloc] init];
        vc.model = self.infoModel;
        __weak typeof(self)safe_safe = self;
        vc.refreshPreVC = ^{
            safe_safe.infoView.infoModel = [LxmTool ShareTool].userModel;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn == self.infoView.codeBtn){
        if (self.type == LxmMyPageVC_type_me) {
            LxmCodeVC * vc = [[LxmCodeVC alloc] init];
            vc.model = self.infoModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (self.otherInfoModel.otherUserID.intValue == [LxmTool ShareTool].userModel.userId) {
                //我自己 二维码
                LxmUserInfoModel *infoModel = [[LxmUserInfoModel alloc] init];
                infoModel.sex = self.otherInfoModel.otherSex.intValue;
                infoModel.headimg = self.otherInfoModel.otherHead;
                infoModel.schoolName = self.otherInfoModel.schoolName;
                infoModel.userId = self.otherInfoModel.otherUserID.intValue;
                infoModel.nickname = self.otherInfoModel.otherNickname;
                infoModel.institute = self.otherInfoModel.institute;
                LxmCodeVC * vc = [[LxmCodeVC alloc] init];
                vc.model = infoModel;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                if (self.otherInfoModel.isFriend.intValue == 1) {
                    //是好友 显示已添加
                } else {
                    //加好友
                    [self addFriend];
                }
            }
           
        }
    }
}

- (void)addFriend{
    if (ISLOGIN) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"好友请求" preferredStyle:UIAlertControllerStyleAlert];
        //以下方法就可以实现在提示框中输入文本；
        //在AlertView中添加一个输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入申请内容";
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *contextTF = alertController.textFields.firstObject;
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            if (contextTF.text.length!=0) {
                dict[@"content"] = contextTF.text;
            }
            dict[@"token"] = SESSION_TOKEN;
            dict[@"otherUserId"] =  self.otherId.length > 0 ? self.otherId : self.otherInfoModel.otherUserID;
            [LxmNetworking networkingPOST:[LxmURLDefine user_applyFriend] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"key"] intValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"好友请求已发送"];
                }else{
                    [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:@"您还没有登录,请先登录!"];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 0) {
        LxmHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHomeCell"];
        if (!cell)
        {
            cell = [[LxmHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHomeCell" isMine:YES];
            UIView * line = [[UIView alloc] init];
            line.backgroundColor = BGGrayColor;
            [cell addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.leading.trailing.equalTo(cell);
                make.height.equalTo(@10);
            }];
        }
        LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
        if (self.type == LxmMyPageVC_type_me) {
            model.relUserHead = self.infoModel.headimg;
            model.relUserId = @(self.infoModel.userId);
            model.relNickname = self.infoModel.nickname;
            model.relRate = @(self.infoModel.goodRate);
            model.relSex = @(self.infoModel.sex);
        }else{
            model.relUserHead = self.otherInfoModel.otherHead;
            model.relUserId = self.otherInfoModel.otherUserID;
            model.relNickname = self.otherInfoModel.otherNickname;
            model.relRate = self.otherInfoModel.otherGoodRate;
            model.relSex = self.otherInfoModel.otherSex;
        }
        cell.model = model;
        __weak typeof(self)safe_self = self;
        cell.selectImgBlock = ^(NSInteger index) {
            LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
            LxmTaskDetailVC * detailVC = [[LxmTaskDetailVC alloc] init];
            detailVC.billId = model.billId;
            detailVC.hidesBottomBarWhenPushed = YES;
            [safe_self.navigationController pushViewController:detailVC animated:YES];
        };
        return cell;
    }else if (self.selectIndex == 1){
        LxmGoodListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmGoodListCell"];
        if (!cell)
        {
            cell = [[LxmGoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmGoodListCell" type:LxmGoodListCell_style_minePage];
        }
        LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }else if (self.selectIndex == 2){
        LxmMyPageCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyPageCommentCell"];
        if (!cell)
        {
            cell = [[LxmMyPageCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyPageCommentCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LxmMyEvaluateListModel * model = [self.dataArr objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        LxmMyPageHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        if (!headerView) {
            headerView = [[LxmMyPageHeaderView alloc] initWithReuseIdentifier:@"headerView" withTitleArr:@[@"发布的活",@"发布的技能",@"收到的评价"]];
        }
        headerView.delegate = self;
        return headerView;
    }
    return nil;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 0) {
        LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
        return model.height+10;
    }else if (self.selectIndex == 1){
        LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
        return model.height;
    }else if (self.selectIndex == 2){
        LxmMyEvaluateListModel * model = [self.dataArr objectAtIndex:indexPath.row];
        return model.height;
    }else{
        return 0.01;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectIndex == 0) {
        LxmHomeModel * model = [self.dataArr objectAtIndex:indexPath.row];
        LxmTaskDetailVC * detailVC = [[LxmTaskDetailVC alloc] init];
        detailVC.billId = model.billId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (self.selectIndex == 1){
        LxmCanListModel * model = [self.dataArr objectAtIndex:indexPath.row];
        LxmGoodsDetailVC * vc = [[LxmGoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmGoodsDetailVC_type_ableDetail];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//区头代理
-(void)lxmMyPageHeaderView:(LxmMyPageHeaderView *)view btnAtIndex:(NSInteger)index{
    NSInteger currentSelectIndex = self.selectIndex;
    if(currentSelectIndex != index){
        self.selectIndex = index;
        self.time = [NSString getCurrentTimeChuo];
        self.page = 1;
        if (index == 0) {
            [self loadDanList];
        }else if(index == 1){
            [self loadCanList];
        }else{
            [self loadReceiveEvaluateList];
        }
    }
    
}

@end




@interface LxmMyPageInfoView()
/**
 个人信息模块
 */
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;


@property (nonatomic , strong) UIView * starView;
@property (nonatomic , strong) UIImageView * starImgView1;
@property (nonatomic , strong) UIImageView * starImgView2;
@property (nonatomic , strong) UIImageView * starImgView3;
@property (nonatomic , strong) UIImageView * starImgView4;
@property (nonatomic , strong) UIImageView * starImgView5;


@property (nonatomic , strong) UIButton * schoolBtn;
@property (nonatomic , strong) UIButton * renzhengBtn;

@end

@implementation LxmMyPageInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.modifyBtn];
        [self addSubview:self.starView];
        [self addSubview:self.codeBtn];
        [self addSubview:self.schoolBtn];
        [self addSubview:self.renzhengBtn];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 190, ScreenW, 10)];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains{
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom).offset(5);
        make.trailing.equalTo(self.nameLab.mas_leading).offset(-3);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.greaterThanOrEqualTo(self).offset(30);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.sexImgView);
    }];
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.codeBtn.mas_leading);
        make.leading.equalTo(self.nameLab.mas_trailing).offset(3);
        make.centerY.equalTo(self.sexImgView);
    }];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modifyBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom).offset(10);
        make.trailing.equalTo(self);
        make.width.equalTo(@64);
        make.height.equalTo(@24);
    }];
    [self.schoolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(10);
        make.trailing.equalTo(self).offset(-ScreenW*0.5-3);
        make.leading.greaterThanOrEqualTo(self).offset(15);
        make.height.equalTo(@20);
    }];
    [self.renzhengBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(ScreenW*0.5+10);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImgView.layer.cornerRadius = 40;
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
- (UIButton *)modifyBtn{
    if (!_modifyBtn) {
        _modifyBtn = [[UIButton alloc] init];
        [_modifyBtn setImage:[UIImage imageNamed:@"ico_bianji"] forState:UIControlStateNormal];
        _modifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _modifyBtn;
}
- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] init];
        [_codeBtn setImage:[UIImage imageNamed:@"code"] forState:UIControlStateNormal];
        _codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _codeBtn;
}

- (UIButton *)schoolBtn{
    if (!_schoolBtn) {
        _schoolBtn = [[UIButton alloc] init];
        [_schoolBtn setImage:[UIImage imageNamed:@"xueyuan"] forState:UIControlStateNormal];
        [_schoolBtn setTitle:@"河海大学物联网学院" forState:UIControlStateNormal];
        [_schoolBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _schoolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_schoolBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    }
    return _schoolBtn;
}

- (UIButton *)renzhengBtn{
    if (!_renzhengBtn) {
        _renzhengBtn = [[UIButton alloc] init];
        [_renzhengBtn setImage:[UIImage imageNamed:@"renzheng_y"] forState:UIControlStateNormal];
        [_renzhengBtn setTitle:@"已实名认证" forState:UIControlStateNormal];
        [_renzhengBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _renzhengBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_renzhengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    }
    return _renzhengBtn;
}



- (UIView *)starView{
    if (!_starView) {
        _starView = [[UIView alloc] init];
        for (int i=0; i<5; i++)
        {
            UIImageView *starImg=[[UIImageView alloc] init];
            starImg.frame = CGRectMake(17*i, 0, 15, 15);
            //            starImg.image = [UIImage imageNamed:@"star_1"];
            starImg.image = [UIImage imageNamed:@"star_3"];
            [_starView addSubview:starImg];
            if (i == 0) {
                self.starImgView1 = starImg;
            }else if (i == 1){
                self.starImgView2 = starImg;
            }else if (i == 2){
                self.starImgView3 = starImg;
            }else if (i == 3){
                self.starImgView4 = starImg;
            }else if (i == 4){
                self.starImgView5 = starImg;
            }
        }
        _starView.layer.masksToBounds = YES;
    }
    return _starView;
}

- (void)setInfoModel:(LxmUserInfoModel *)infoModel{
    _infoModel = infoModel;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:infoModel.headimg]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:infoModel.sex == 1?@"male":@"female"];
    self.nameLab.text = infoModel.nickname;
    
    switch (infoModel.goodRate) {
        case 1:
        {
            self.starImgView1.image = [UIImage imageNamed:@"star_3"];
            self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 2:
        {
            self.starImgView1.image = self.starImgView2.image = [UIImage imageNamed:@"star_3"];
            self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 3:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = [UIImage imageNamed:@"star_3"];
            self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 4:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = [UIImage imageNamed:@"star_3"];
            self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 5:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_3"];
        }
            break;
            
        default:
            break;
    }
    
    [self.schoolBtn setTitle:[NSString stringWithFormat:@"%@%@",infoModel.schoolName,infoModel.institute] forState:UIControlStateNormal];
    [self.renzhengBtn setTitle:infoModel.type == 4?@"已实名认证":@"未实名认证" forState:UIControlStateNormal];
    
}

- (void)setOtherInfoModel:(LxmOtherInfoModel *)otherInfoModel{
    
    _otherInfoModel = otherInfoModel;
    self.modifyBtn.hidden = YES;
    if (_otherInfoModel.otherUserID.intValue == [LxmTool ShareTool].userModel.userId) {
        [_codeBtn setImage:[UIImage imageNamed:@"code"] forState:UIControlStateNormal];
    } else {
        [_codeBtn setImage:_otherInfoModel.isFriend.intValue == 1 ? [UIImage imageNamed:@"is_friend"] : [UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
    }
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:otherInfoModel.otherHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:otherInfoModel.otherSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = otherInfoModel.otherNickname;
    
    switch (otherInfoModel.otherGoodRate.intValue) {
        case 1:
        {
            self.starImgView1.image = [UIImage imageNamed:@"star_3"];
            self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 2:
        {
            self.starImgView1.image = self.starImgView2.image = [UIImage imageNamed:@"star_3"];
            self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 3:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = [UIImage imageNamed:@"star_3"];
            self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 4:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = [UIImage imageNamed:@"star_3"];
            self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 5:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_3"];
        }
            break;
            
        default:
            break;
    }
    
    [self.schoolBtn setTitle:[NSString stringWithFormat:@"%@%@",otherInfoModel.schoolName,otherInfoModel.institute] forState:UIControlStateNormal];
    [self.renzhengBtn setTitle:otherInfoModel.type.intValue == 4?@"已实名认证":@"未实名认证" forState:UIControlStateNormal];
}




@end


#import "LxmStarImgView.h"
@interface LxmMyPageCommentCell()
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;
@property (nonatomic , strong) UILabel * timeLab;
/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;

@end
@implementation LxmMyPageCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.timeLab];
        
        [self addSubview:self.contentLab];
        
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
    [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.publicInfoView).offset(15);
        make.width.height.equalTo(@30);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
        make.trailing.equalTo(self.timeLab.mas_leading);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView);
        make.bottom.equalTo(self.headerImgView).offset(2);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        
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
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.text = @"巴啦啦小魔仙";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}
- (LxmStarImgView *)startView{
    if (!_startView) {
        _startView = [[LxmStarImgView alloc] init];
    }
    return _startView;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.text = @"2018-05-31";
        _timeLab.textColor = CharacterLightGrayColor;
    }
    return _timeLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"北门圆通,收件人冯全,送至2-231,中午前送达哦";
    }
    return _contentLab;
}
- (void)setModel:(LxmMyEvaluateListModel *)model{
    _model = model;
    self.startView.starNum = model.score.intValue;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.evaUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.evaUserSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.evaUserNickname;
    NSString * str = model.createTime;
    if (model.createTime) {
        if (model.createTime.length>9) {
            str = [str substringToIndex:model.createTime.length-9];
        }
    }
    self.timeLab.text = str;
    self.contentLab.text = model.content;
    CGFloat connectHeight = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW-30-35, 9999) withFontSize:14].height+10;
    model.height = 60+connectHeight;
}

@end
