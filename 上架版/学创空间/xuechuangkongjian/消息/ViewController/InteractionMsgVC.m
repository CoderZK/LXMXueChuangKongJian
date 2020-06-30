//
//  InteractionMsgVC.m
//  mag
//
//  Created by 宋乃银 on 2018/7/21.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "InteractionMsgVC.h"
#import "TaskDetailVC.h"
#import "XckjLvAndPaiMaiDetailVC.h"
#import "GoodsDetailVC.h"
#import "LxmMyPageVC.h"

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeTaskSay = 3,//发活留言
    MessageTypeTaskConfirm = 4,//发活回复
    MessageTypeTaskGood = 5,//发活点赞
    MessageTypeTaskGoodSay = 6,//发活点赞评论
    MessageTypeTaskGoodConfirm = 7,//发活点赞回复
    MessageTypeTextConfirm = 8,//文章回复
    MessageTypeTextGoodSay = 9,//点赞文章评论
    MessageTypeTextGoodConfirm = 10,//点赞文章回复
    MessageTypeGoodsConfirm = 11,//商品回复
    MessageTypeGoodSay = 12,//点赞商品评论
    MessageTypeGoodConfirm = 13,//点赞商品回复
    MessageTypeJiNengSay = 14,//技能留言
    MessageTypeJiNengConfirm = 15,//技能回复
    MessageTypeJiNengGood = 16,//技能点赞
    MessageTypeJiNengGoodSay = 17,//技能点赞评论
    MessageTypeJiNengGoodConfirm = 18,//技能点赞回复
};

@interface InteractionMsgVC ()
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation InteractionMsgVC
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
    self.navigationItem.title = @"互动消息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadInterMsgList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadInterMsgList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadInterMsgList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}

- (void)loadInterMsgList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findInteractMsgList];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmInteractionMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmInteractionMsgCell"];
    if (!cell) {
        cell = [[LxmInteractionMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmInteractionMsgCell"];
    }
    LxmFindInterMsgModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.dataModel = model;
    [cell setHeadImageViewHandle:^{
        [self loadOtherInfoDataWithID:model.otherUserId];
    }];
    return cell;
}

- (void)loadOtherInfoDataWithID:(NSNumber *)otherID{
   
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmFindInterMsgModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    [self readMsgWithID:model.messageId model:model];
    
    switch ([model.type intValue]) {
        case MessageTypeTaskSay:
        {
            TaskDetailVC *taskDetailViewController = [TaskDetailVC new];
            taskDetailViewController.billId = model.otherId;
            [self.navigationController pushViewController:taskDetailViewController animated:YES];
        }
            break;
        case MessageTypeTaskConfirm:
        {
            TaskDetailVC *taskDetailViewController = [TaskDetailVC new];
            taskDetailViewController.billId = model.otherId;
            [self.navigationController pushViewController:taskDetailViewController animated:YES];
        }
            break;
        case MessageTypeTaskGood:
        {
            TaskDetailVC *taskDetailViewController = [TaskDetailVC new];
            taskDetailViewController.billId = model.otherId;
            [self.navigationController pushViewController:taskDetailViewController animated:YES];
        }
            break;
        case MessageTypeTaskGoodSay:
        {
            
            TaskDetailVC *taskDetailViewController = [TaskDetailVC new];
            taskDetailViewController.billId = model.otherId;
            [self.navigationController pushViewController:taskDetailViewController animated:YES];
        }
            break;
        case MessageTypeTaskGoodConfirm:
        {
            TaskDetailVC *taskDetailViewController = [TaskDetailVC new];
            taskDetailViewController.billId = model.otherId;
            [self.navigationController pushViewController:taskDetailViewController animated:YES];
        }
            break;
        case MessageTypeTextConfirm:
        {
            XckjLvAndPaiMaiDetailVC *  vc = [[XckjLvAndPaiMaiDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped typeModel:nil type:nil];
            vc.textId = model.otherId.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeTextGoodSay:
        {
            XckjLvAndPaiMaiDetailVC *  vc = [[XckjLvAndPaiMaiDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped typeModel:nil type:nil];
            vc.textId = model.otherId.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeTextGoodConfirm:
        {
            XckjLvAndPaiMaiDetailVC *  vc = [[XckjLvAndPaiMaiDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped typeModel:nil type:nil];
            vc.textId = model.otherId.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeGoodsConfirm:
        {
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_goodsDetail];
            vc.billId = model.otherId;
            vc.isOwn = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeGoodSay:
        {
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_goodsDetail];
            vc.billId = model.otherId;
            vc.isOwn = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeGoodConfirm:
        {
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_goodsDetail];
            vc.billId = model.otherId;
            vc.isOwn = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeJiNengSay:
        {
            LxmCanListModel * model0 = [[LxmCanListModel alloc] init];
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_ableDetail];
            model0.billId = model.otherId;
            vc.model = model0;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeJiNengConfirm:
        {
            LxmCanListModel * model0 = [[LxmCanListModel alloc] init];
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_ableDetail];
            model0.billId = model.otherId;
            vc.model = model0;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeJiNengGood:
        {
            LxmCanListModel * model0 = [[LxmCanListModel alloc] init];
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_ableDetail];
            model0.billId = model.otherId;
            vc.model = model0;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeJiNengGoodSay:
        {
            LxmCanListModel * model0 = [[LxmCanListModel alloc] init];
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_ableDetail];
            model0.billId = model.otherId;
            vc.model = model0;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MessageTypeJiNengGoodConfirm:
        {
            LxmCanListModel * model0 = [[LxmCanListModel alloc] init];
            GoodsDetailVC * vc = [[GoodsDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:GoodsDetailVC_type_ableDetail];
            model0.billId = model.otherId;
            vc.model = model0;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)readMsgWithID:(NSNumber *)msgID model:(LxmFindInterMsgModel *)model{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_editMsg] parameters:@{@"token":SESSION_TOKEN,@"messageId":msgID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                model.isRead = @1;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}

@end

@interface LxmInteractionMsgCell()
@property (nonatomic , strong)UIView * topView;
@property (nonatomic , strong)UIImageView * headerImgView;
@property (nonatomic , strong)UILabel * nameLab;
@property (nonatomic , strong)UILabel * titleLab;
@property (nonatomic , strong)UILabel * timeLab;
@property (nonatomic , strong)UILabel * contentLab;
@property (nonatomic , strong)UILabel * redLab;
@end

@implementation LxmInteractionMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.headerImgView];
        [self.topView addSubview:self.nameLab];
        [self.topView addSubview:self.titleLab];
        [self.topView addSubview:self.timeLab];
        [self.topView addSubview:self.redLab];
        [self addSubview:self.contentLab];
        [self setConstrains];
        
        UIView * line = [UIView new];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        self.headerImgView.userInteractionEnabled = YES;
        
        //添加点击手势
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
        
        [self.headerImgView addGestureRecognizer:click];
        
    }
    return self;
}

- (void)clickAction {
    _headImageViewHandle ? _headImageViewHandle() : nil;
}

- (void)setConstrains{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.top.equalTo(@15);
        make.width.height.equalTo(@30);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView).offset(-10);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self.titleLab.mas_leading);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView).offset(10);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self.titleLab.mas_leading);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.trailing.equalTo(self.topView).offset(-25);
        make.width.equalTo(@80);
    }];
    [self.redLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.trailing.equalTo(self.topView).offset(-15);
        make.width.height.equalTo(@6);
    }];
   
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60);
        make.leading.equalTo(self).offset(55);
        make.trailing.equalTo(self.topView).offset(-25-80);
        make.height.mas_equalTo(30);
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

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"欧拉拉呼呼赞了你";
        _nameLab.textColor = CharacterDarkColor;
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"05-31";
        _timeLab.textColor = CharacterLightGrayColor;
        _timeLab.font = [UIFont systemFontOfSize:13];
    }
    return _timeLab;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"北门圆通，收件人冯全北门圆通，收件人冯全";
        _titleLab.textColor = CharacterLightGrayColor;
        _titleLab.numberOfLines = 2;
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}

- (UILabel *)redLab{
    if (!_redLab) {
        _redLab = [[UILabel alloc] init];
        _redLab.backgroundColor = [UIColor colorWithRed:239/255.0 green:72/255.0 blue:72/255.0 alpha:1];
        _redLab.textColor = UIColor.whiteColor;
        _redLab.font = [UIFont systemFontOfSize:13];
        _redLab.layer.cornerRadius = 3;
        _redLab.layer.masksToBounds = YES;
    }
    return _redLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = CharacterDarkColor;
        _contentLab.text = @"北门圆通，收件人冯全北门圆通，收件人冯全";
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (void)setDataModel:(LxmFindInterMsgModel *)dataModel{
    _dataModel = dataModel;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:dataModel.otherUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.nameLab.text = [NSString stringWithFormat:@"%@",dataModel.title];
    self.titleLab.text = dataModel.otherContent;
    self.timeLab.text = [NSString stringWithTime:dataModel.createTime];
    self.contentLab.text = dataModel.content;
    self.redLab.hidden = dataModel.isRead.intValue == 1?YES:NO;
}


@end
