//
//  AddFriendVC.m
//  mag
//
//  Created by 宋乃银 on 2018/7/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "AddFriendVC.h"
#import "AddFriendSendMessageVC.h"
#import "SNYQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ZBarSDK.h"
#import "LxmMyPageVC.h"

@interface AddFriendVC ()<UISearchResultsUpdating, UISearchControllerDelegate,LxmAddFriendCellDelegate,SNYQRCodeVCDelegate>
@property(nonatomic , strong)UISearchController *searchController;
@property (nonatomic , strong)UIImageView * noneDataImgView;
@property (nonatomic , strong)UILabel * noneDataLab;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSearchBar];

    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"ico_saomiao"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    self.noneDataImgView = [[UIImageView alloc] init];
    self.noneDataImgView.image = [UIImage imageNamed:@"bg_4"];
    [self.tableView addSubview:self.noneDataImgView];
    
    [self.noneDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tableView);
        make.width.height.equalTo(@150);
    }];
    
    self.noneDataLab = [[UILabel alloc] init];
    self.noneDataLab.text = @"还没有数据加载噢~";
    self.noneDataLab.font = [UIFont systemFontOfSize:18];
    self.noneDataLab.textColor = CharacterLightGrayColor;
    [self.tableView addSubview:self.noneDataLab];
    
    [self.noneDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noneDataImgView.mas_bottom);
        make.centerX.equalTo(self.tableView);
    }];
    
    self.dataArr = [NSMutableArray array];
  
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    
}
- (void)searchPeople{
    
    if (ISLOGIN) {
        if (self.searchController.searchBar.text.length==0||[[self.searchController.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
//            [SVProgressHUD showErrorWithStatus:@"搜索用户昵称"];
            return;
        }
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"nickname"] = self.searchController.searchBar.text;
        [SVProgressHUD show];
        NSString * str = [LxmURLDefine user_findUserList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmFindNewFriendListRootModel class] success:^(NSURLSessionDataTask *task, LxmFindNewFriendListRootModel * responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmFindNewFriendListModel1 * model = responseObject.result;
                NSMutableArray * arr = [NSMutableArray arrayWithArray:model.list];
                self.dataArr = arr;
                if (self.dataArr.count == 0) {
                    self.noneDataLab.hidden = self.noneDataImgView.hidden = NO;
                }else{
                    self.noneDataLab.hidden = self.noneDataImgView.hidden = YES;
                }
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}


- (void)scanBtnClick{
    //扫一扫 加好友
    SNYQRCodeVC * vc = [[SNYQRCodeVC alloc] init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SNYQRCodeVCDelegate

- (void)SNYQRCodeVC:(SNYQRCodeVC *)vc scanResult:(NSString *)str
{
    [vc.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //加好友
        [self loadOtherInfoDataWithID:@(str.integerValue)];
    });
    
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
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmAddFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAddFriendCell"];
    if (!cell)
    {
        cell = [[LxmAddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAddFriendCell"];
    }
    LxmFindNewFriendListModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
//添加好友界面
- (void)LxmAddFriendCellBtnClick:(LxmAddFriendCell *)cell{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmFindNewFriendListModel * model = [self.dataArr lxm_object1AtIndex:indexP.row];
    AddFriendSendMessageVC * vc = [[AddFriendSendMessageVC alloc] init];
    vc.friendID = model.serUserId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)initSearchBar{
    self.definesPresentationContext =YES;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    _searchController.searchBar.placeholder = @"搜索用户昵称";
    _searchController.searchBar.backgroundImage = [UIImage imageNamed:@"bgBackGroundColor"];
    _searchController.searchBar.showsCancelButton = NO;
    for (id cencelButton in [ _searchController.searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    self.tableView.tableHeaderView = _searchController.searchBar;
    [self updatePosition];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
     [_searchController.searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
    self.page = 1;
    [self searchPeople];
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    [_searchController.searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self updatePosition];
}

- (void)updatePosition {
    NSString *placeholder = _searchController.searchBar.placeholder;
    CGFloat placeholderWidth = [placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size.width;
    [_searchController.searchBar setPositionAdjustment:UIOffsetMake((_searchController.searchBar.frame.size.width - placeholderWidth - 40) * 0.5, 0) forSearchBarIcon:UISearchBarIconSearch];
}

@end

@interface LxmAddFriendCell()
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UIButton * addBtn;
@end

@implementation LxmAddFriendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.addBtn];
        
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
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
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
        make.trailing.equalTo(self.addBtn.mas_leading);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@26);
        make.width.equalTo(@70);
    }];
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

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"bg_10"] forState:UIControlStateNormal];
        [_addBtn setTitle:@"+ 添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _addBtn.layer.cornerRadius = 13;
        _addBtn.layer.masksToBounds = YES;
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (void)addClick{
    if ([self.delegate respondsToSelector:@selector(LxmAddFriendCellBtnClick:)]) {
        [self.delegate LxmAddFriendCellBtnClick:self];
    }
}
- (void)setModel:(LxmFindNewFriendListModel *)model{
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.headimg]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.sex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.nickname;
    if (model.isFriend.intValue == 1) {
        [_addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        _addBtn.userInteractionEnabled = NO;
    }else{
        [_addBtn setTitle:@"+ 添加" forState:UIControlStateNormal];
        _addBtn.userInteractionEnabled = YES;
    }
}

@end
