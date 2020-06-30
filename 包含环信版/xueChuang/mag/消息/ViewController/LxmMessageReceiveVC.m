//
//  LxmMessageReceiveVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMessageReceiveVC.h"
#import "LxmInteractionMsgVC.h"
#import "LxmSystemMsgVC.h"
#import <Hyphenate/Hyphenate.h>
#import "EaseMessageViewController.h"
#import "LxmMyPageVC.h"

@interface LxmMessageReceiveVC ()
@property (nonatomic , strong) LxmMessageInfoModel * messageModel;
@property (nonatomic, strong) NSArray<EMConversation *> *conversations;
@end

@implementation LxmMessageReceiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
    __weak typeof(self) safe_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [safe_self loadMessageList];
        [self loadHuanxinSession];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.messageModel = nil;
    [self loadMessageList];
    [self loadHuanxinSession];
}

- (void)loadHuanxinSession {
    NSArray<EMConversation *> *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    self.conversations = conversations;
    [self.tableView reloadData];
}

- (void)updata {
    self.messageModel = nil;
    [self loadMessageList];
    [self loadHuanxinSession];
}

- (void)loadMessageList{
    
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                };
        NSString * str = [LxmURLDefine user_findMsgList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            if ([responseObject[@"key"] intValue] == 1) {
                self.messageModel = [LxmMessageInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ?2:self.conversations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LxmHuDongmessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmHuDongmessageCell"];
        if (!cell)
        {
            cell = [[LxmHuDongmessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmHuDongmessageCell"];
        }
        if (indexPath.row == 0) {
            cell.iconImgView.image = [UIImage imageNamed:@"ic_notification_sys"];
            cell.redlab.hidden = self.messageModel.isNewInter.intValue == 1 ? NO : YES;
            cell.redlab.text = self.messageModel.isNewInter.intValue == 1 ? [NSString stringWithFormat:@" %d ",self.messageModel.interMsgNum.intValue]:@"";
            cell.titleLab.text = @"互动消息";
            cell.contentLab.text = self.messageModel.lastInterContent;
            cell.timeLab.text = self.messageModel.isNewInter.intValue == 1?[NSString stringWithTime:self.messageModel.lastInterTime]:@"";
        }else{
            cell.iconImgView.image = [UIImage imageNamed:@"ic_notification_push"];
            cell.redlab.hidden = self.messageModel.isNewSys.intValue == 1?NO:YES;
            cell.redlab.text = self.messageModel.isNewSys.intValue == 1?[NSString stringWithFormat:@" %d ",self.messageModel.sysMsgNum.intValue]:@"";
            cell.titleLab.text = @"通知";
            cell.contentLab.text = self.messageModel.lastMsgContent;
            cell.contentLab.numberOfLines = 2;
            cell.timeLab.text = self.messageModel.isNewSys.intValue == 1?[NSString stringWithTime:self.messageModel.lastMsgTime]:@"";
        }
        return cell;
    } else {
        LxmDanmessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmDanmessageCell"];
        if (!cell)
        {
            cell = [[LxmDanmessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmDanmessageCell"];
        }
        cell.dataModel = [self.conversations objectAtIndex:indexPath.row];
        
        [cell setUserImageViewDidSelected:^{
            
            NSString *otherId = [[self.conversations objectAtIndex:indexPath.row] valueForKeyPath:@"conversationId"];
            [LxmNetworking networkingPOST:[LxmURLDefine user_getOthersInfo] parameters:@{@"token":SESSION_TOKEN,@"otherUserId":otherId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"key"] intValue] == 1) {
                    LxmOtherInfoModel * otherModel = [LxmOtherInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                    otherModel.otherUserID = [NSNumber numberWithInt:otherId.intValue];
                    LxmMyPageVC * vc1 = [[LxmMyPageVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmMyPageVC_type_other];
                    vc1.otherInfoModel = otherModel;
                    vc1.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc1 animated:YES];
                }else{
                    [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  section == 0 ?10:0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LxmInteractionMsgVC * vc = [LxmInteractionMsgVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            LxmSystemMsgVC * vc = [LxmSystemMsgVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        EMConversation *model = [self.conversations objectAtIndex:indexPath.row];
        NSString *user = model.conversationId;
        [self getUserInfoFromHXWithUserID:user];
    }
}

- (void)getUserInfoFromHXWithUserID:(NSString *)userID{
    if (ISLOGIN) {
        NSString * myID = @([LxmTool ShareTool].userModel.userId).stringValue;
        NSMutableArray * idArr = [NSMutableArray arrayWithArray:@[userID,myID]];
        NSString * ids = [idArr componentsJoinedByString:@","];
        [LxmNetworking networkingPOST:[LxmURLDefine user_getUserInfoFromHX] parameters:@{@"token":SESSION_TOKEN,@"userIds":ids} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSArray * arr = responseObject[@"result"][@"list"];
                LxmHuanXinModel * huanxinModel = nil;
                 LxmHuanXinModel * huanxinModel1 = nil;
                if (arr.count==2) {
                   huanxinModel = [LxmHuanXinModel mj_objectWithKeyValues:arr.firstObject];
                    huanxinModel1 = [LxmHuanXinModel mj_objectWithKeyValues:arr.lastObject];
                }
                EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:userID conversationType:EMConversationTypeChat];
                chatController.userModel = huanxinModel;
                chatController.myUserModel = huanxinModel1;
                chatController.navigationItem.title = huanxinModel.nickname;
                chatController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatController animated:YES];
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
@implementation LxmHuDongmessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.redlab];
        [self addSubview:self.titleLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.contentLab];
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
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@60);
    }];
    [self.redlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(-10);
        make.height.equalTo(@15);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView).offset(-15);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self.timeLab.mas_leading);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView).offset(15);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
- (UILabel *)redlab{
    if (!_redlab) {
        _redlab = [[UILabel alloc] init];
        _redlab.backgroundColor = [UIColor colorWithRed:239/255.0 green:72/255.0 blue:72/255.0 alpha:1];
        _redlab.textColor = UIColor.whiteColor;
        _redlab.font = [UIFont systemFontOfSize:13];
        _redlab.layer.cornerRadius = 7.5;
        _redlab.layer.masksToBounds = YES;
    }
    return _redlab;
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
    }
    return _contentLab;
}
@end

#import "EaseConvertToCommonEmoticonsHelper.h"
@interface LxmDanmessageCell()
@property (nonatomic , strong) UIImageView *headerImgView;
@property (nonatomic , strong) UIImageView *sexImgView;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *redPoint;
@end

@implementation LxmDanmessageCell

- (UILabel *)redPoint{
    if (!_redPoint) {
        _redPoint = [[UILabel alloc] init];
        _redPoint.backgroundColor = [UIColor colorWithRed:239/255.0 green:72/255.0 blue:72/255.0 alpha:1];
        _redPoint.textColor = UIColor.whiteColor;
        _redPoint.font = [UIFont systemFontOfSize:13];
        _redPoint.layer.cornerRadius = 7.5;
        _redPoint.layer.masksToBounds = YES;
        _redPoint.textAlignment = NSTextAlignmentCenter;
    }
    return _redPoint;
}

- (void)setDataModel:(EMConversation *)dataModel {
    if (dataModel.type == EMConversationTypeChat) {
        if (dataModel.conversationId) {
            [self getUserInfoFromHXWithUserID:dataModel.conversationId withModel:dataModel];
        }
        NSTimeInterval time = dataModel.latestMessage.timestamp / 1000.0;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *oneDayStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        self.timeLab.text = [NSString stringWithTime:oneDayStr];
        self.contentLab.text = [self subTitleMessageByConversation:dataModel];
        if (dataModel.unreadMessagesCount > 99) {
            self.redPoint.text = @"99";
        }else if(dataModel.unreadMessagesCount == 0) {
            self.redPoint.hidden = YES;
        }else {
            self.redPoint.text = [NSString stringWithFormat:@"%d",dataModel.unreadMessagesCount];
        }
    }
}

//得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation {
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    EMMessageBody * messageBody = lastMessage.body;
    if (lastMessage) {
        EMMessageBodyType  messageBodytype = lastMessage.body.type;
        switch (messageBodytype) {
                //图像类型
            case EMMessageBodyTypeImage:
            {
                ret = NSLocalizedString(@"图片消息", @"[image]");
            } break;
                //文本类型
            case EMMessageBodyTypeText:
            {
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];  //表情映射
                ret = didReceiveText;
            } break;
                //语音类型
            case EMMessageBodyTypeVoice:
            {
                ret = NSLocalizedString(@"语音消息", @"[voice]");
            } break;
                //位置类型
            case EMMessageBodyTypeLocation:
            {
                ret = NSLocalizedString(@"地理位置信息", @"[location]");
            } break;
                //视频类型
            case EMMessageBodyTypeVideo:
            {
                ret = NSLocalizedString(@"视频消息", @"[video]");
            } break;
                
            default:
                break;
        }
    }
    return ret;
}



- (void)getUserInfoFromHXWithUserID:(NSString *)userID withModel:(EMConversation *)dataModel{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getUserInfoFromHX] parameters:@{@"token":SESSION_TOKEN,@"userIds":userID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                NSArray * arr = responseObject[@"result"][@"list"];
                LxmHuanXinModel * huanxinModel = nil;
                if (arr.count==1) {
                    huanxinModel = [LxmHuanXinModel mj_objectWithKeyValues:arr.firstObject];
                    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:huanxinModel.headimg]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
                    self.sexImgView.image = [UIImage imageNamed:huanxinModel.sex.intValue == 1?@"male":@"female"];
                    self.nameLab.text = huanxinModel.nickname;
                }
              
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.redPoint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelected)];
        [self.headerImgView addGestureRecognizer:tap];
        self.headerImgView.userInteractionEnabled = YES;
        
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

- (void)didSelected {
    _userImageViewDidSelected ? _userImageViewDidSelected() : nil;
}

- (void)setConstrains{
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@40);
    }];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(-10);
        make.height.equalTo(@15);
        make.width.mas_equalTo(15);
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
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView);
        make.bottom.equalTo(self.headerImgView);
        make.trailing.equalTo(self).offset(-15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom).offset(15);
        make.leading.equalTo(self.sexImgView);
        make.trailing.equalTo(self).offset(-15);
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
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.text = @"05-31";
        _timeLab.textColor = CharacterGrayColor;
    }
    return _timeLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = CharacterDarkColor;
        _contentLab.text = @"我已经完成了单子,查收一下";
    }
    return _contentLab;
}

@end

