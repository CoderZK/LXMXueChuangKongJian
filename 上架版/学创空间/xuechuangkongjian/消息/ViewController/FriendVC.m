//
//  FriendVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "FriendVC.h"
#import "AddFriendVC.h"
#import "NewFriendVC.h"

@interface FriendVC ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray*> *friends;
@property (nonatomic , strong)LxmFriendHeaderView * friendsView;
@property (nonatomic , strong)LxmFriendHeaderView * addFriendsView;

@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , strong) NSMutableArray * dataArr;


@property (nonatomic , strong)NSMutableDictionary * dataDict;
@property (nonatomic , strong)NSArray * keyArr;

@end

@implementation FriendVC
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
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    self.dataArr = [NSMutableArray array];
    self.dataDict = [NSMutableDictionary dictionary];
    [self loadFriendList];
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    [self initTableHeaderView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        [self.dataDict removeAllObjects];
        [self loadFriendList];
    }];
    
}

- (void)loadFriendList{
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                };
        NSString * str = [LxmURLDefine user_findFriendList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmNewFriendListRootModel class] success:^(NSURLSessionDataTask *task, LxmNewFriendListRootModel * responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                
                LxmNewFriendListModel1 * model = responseObject.result;
                
                if (model.friendNum.intValue == 0) {
                    self.friendsView.numLab.hidden = YES;
                }else{
                    self.friendsView.numLab.hidden = NO;
                }
                self.friendsView.numLab.text = model.friendNum.stringValue;
                for (LxmNewFriendListModel * friendmodel in model.list) {
                    if (friendmodel.friendNickname)
                    {
                        //将取出的名字转换成字母
                        NSMutableString *pinyin = [friendmodel.friendNickname mutableCopy];
                        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
                        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
                        //将拼音转换成大写拼音
                        NSString * upPinyin = [pinyin uppercaseString];
                        //取出第一个首字母当做字典的key
                        NSString * firstStr = [upPinyin substringToIndex:1];
                        NSMutableArray * arr = [self.dataDict objectForKey:firstStr];
                        if (!arr)
                        {
                            arr = [NSMutableArray array];
                            [self.dataDict setObject:arr forKey:firstStr];
                        }
                        [arr lxm_add1Object:friendmodel];
                    }
                    NSLog(@"%@",self.dataDict);
                    
                    self.keyArr = [self.dataDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2];
                    }];
                    [SVProgressHUD dismiss];
                    NSLog(@"self.keyArr=%@",self.keyArr);
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

- (void)initTableHeaderView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView  = headerView;
    
    self.friendsView = [[LxmFriendHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    self.friendsView.iconImgView.image = [UIImage imageNamed:@"pic_xinde"];
    self.friendsView.textLab.text = @"新的朋友";
    self.friendsView.numLab.text = @"5";
    [self.friendsView addTarget:self action:@selector(newFriendClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.friendsView];
    
    self.addFriendsView = [[LxmFriendHeaderView alloc] initWithFrame:CGRectMake(0, 60, ScreenW, 60)];
    self.addFriendsView.iconImgView.image = [UIImage imageNamed:@"pic_haoyou"];
    self.addFriendsView.textLab.text = @"添加好友";
    self.addFriendsView.numLab.hidden = YES;
    [self.addFriendsView addTarget:self action:@selector(addFriendClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.addFriendsView];
}

- (void)newFriendClick{
    
    NewFriendVC *vc = [[NewFriendVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    WeakObj(self);
    vc.passFriendBlock = ^{
        [selfWeak loadFriendList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addFriendClick {
    AddFriendVC *vc = [[AddFriendVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmFriendCell"];
    if (!cell) {
        cell = [[LxmFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmFriendCell"];
    }
    NSString *key = self.keyArr[indexPath.section];
    LxmNewFriendListModel *model = self.dataDict[key][indexPath.row];
    cell.model = model;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString * key = [self.keyArr lxm_object1AtIndex:section];
    return [[self.dataDict objectForKey:key] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.keyArr[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.keyArr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
@implementation LxmFriendHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLab];
        [self addSubview:self.numLab];
        [self setConstrains];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)setConstrains{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@30);
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.numLab);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
}

- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:18];
        _textLab.textColor = CharacterDarkColor;
    }
    return _textLab;
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont systemFontOfSize:15];
        _numLab.textColor = UIColor.whiteColor;
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.backgroundColor = [UIColor redColor];
        _numLab.layer.cornerRadius = 10;
        _numLab.layer.masksToBounds = YES;
    }
    return _numLab;
}

@end


@implementation LxmFriendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.starView];
        [self setConstrains];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setModel:(LxmNewFriendListModel *)model {
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:_model.friendHead]] placeholderImage:[UIImage imageNamed:@"moren"]];
    self.nameLab.text = _model.friendNickname;
    self.sexImgView.highlighted = _model.friendSex;
    self.starView.starNum = _model.friendGoodRate.intValue;
}

- (void)setConstrains{
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@44);
    }];
    
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self).offset(-10);
        make.width.height.equalTo(@15);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(2);
        make.centerY.equalTo(self.sexImgView);
        make.trailing.lessThanOrEqualTo(self);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 22;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UIImageView *)sexImgView {
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
        _nameLab.textColor = CharacterDarkColor;
        _nameLab.text = @"别来无恙";
    }
    return _nameLab;
}

- (LXMStarView *)starView {
    if (!_starView) {
        _starView = [[LXMStarView alloc] initWithFrame:CGRectMake(0, 0, 100, 20) withSpace:2];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

@end


