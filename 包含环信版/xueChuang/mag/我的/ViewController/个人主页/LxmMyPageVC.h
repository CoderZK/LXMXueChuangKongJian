//
//  LxmMyPageVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,LxmMyPageVC_type) {
    LxmMyPageVC_type_me,
    LxmMyPageVC_type_other
};

@interface LxmMyPageVC : BaseTableViewController
@property (nonatomic , strong)LxmUserInfoModel * infoModel;
@property (nonatomic , strong)LxmOtherInfoModel * otherInfoModel;
@property (nonatomic,  strong)NSString *otherId;
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmMyPageVC_type)type;

@end

@interface LxmMyPageInfoView : UIView
@property (nonatomic , strong) UIButton * modifyBtn;
@property (nonatomic , strong) UIButton * codeBtn;

@property (nonatomic , strong)LxmUserInfoModel * infoModel;
@property (nonatomic , strong)LxmOtherInfoModel * otherInfoModel;

@end
@interface LxmMyPageCommentCell : UITableViewCell
@property (nonatomic , strong) LxmMyEvaluateListModel * model;
@end
