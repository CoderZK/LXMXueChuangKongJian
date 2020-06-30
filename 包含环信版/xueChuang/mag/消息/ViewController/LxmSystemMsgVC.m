//
//  LxmSystemMsgVC.m
//  mag
//
//  Created by 宋乃银 on 2018/7/21.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSystemMsgVC.h"
#import "LxmMessageReceiveVC.h"

@interface LxmSystemMsgVC ()
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmSystemMsgVC
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
    self.navigationItem.title = @"系统通知";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadSysMsgList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadSysMsgList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadSysMsgList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}
- (void)loadSysMsgList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findSystemMsgList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmFindInterMsgRootModel class] success:^(NSURLSessionDataTask *task, LxmFindInterMsgRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmFindInterMsgModel1 * model = responseObject.result;
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
    LxmSystemMsgCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSystemMsgCell1"];
    if (!cell)
    {
        cell = [[LxmSystemMsgCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSystemMsgCell1"];
    }
    LxmFindInterMsgModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmFindInterMsgModel * model = [self.dataArr objectAtIndex:indexPath.row];
    return model.height == 0?0.01:model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmFindInterMsgModel * model = [self.dataArr objectAtIndex:indexPath.row];
    if ([model.isRead intValue] == 2) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_editMsg] parameters:@{@"token":SESSION_TOKEN,@"messageId":model.messageId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                model.isRead = @1;
                [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

@end

@interface LxmSystemMsgCell1()
@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UIView  * redPoint;
@property (nonatomic, strong) UILabel * timeLab;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * contentLab;
@end

@implementation LxmSystemMsgCell1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.redPoint];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
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
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(15);
        make.height.width.mas_equalTo(60);
    }];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.equalTo(self.iconImgView.mas_right);
        make.height.width.mas_equalTo(15);
    }];
    self.redPoint.layer.cornerRadius = 7.5f;
    self.redPoint.layer.masksToBounds = YES;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_top).offset(8);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self.timeLab.mas_leading);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(150);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(15);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}


- (void)setModel:(LxmFindInterMsgModel *)model{
    _model = model;
    self.iconImgView.image = [UIImage imageNamed:@"ic_notification_push"];
    if (model.isRead.intValue == 2) {
        self.redPoint.hidden = NO;
    }else {
        self.redPoint.hidden = YES;
    }
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.text = model.title;
    self.contentLab.text = model.content;
    self.timeLab.text = [NSString stringWithFormat:@"%@", model.createTime];
    CGFloat h = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW - 100, 9999) withFontSize:15].height;
    model.height = 65+h+20;
}


#pragma mark - lazyInit

- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = CharacterDarkColor;
        _titleLab.font = [UIFont systemFontOfSize:18];
    }
    return _titleLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = CharacterGrayColor;
        _timeLab.font = [UIFont systemFontOfSize:12];
    }
    return _timeLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = CharacterGrayColor;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        _redPoint.backgroundColor = [UIColor redColor];
    }
    return _redPoint;
}


@end
