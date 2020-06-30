//
//  LxmMessageReceiveVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import <Hyphenate/Hyphenate.h>

@interface LxmMessageReceiveVC : BaseTableViewController
@property(nonatomic,weak)BaseViewController * preVC;

- (void)updata;

@end

@interface LxmHuDongmessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UILabel * redlab;
@property (nonatomic, strong) UILabel * timeLab;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * contentLab;

@end

@interface LxmDanmessageCell : UITableViewCell

@property (nonatomic, strong) EMConversation *dataModel;

@property (nonatomic, copy) void (^userImageViewDidSelected)();

@end
