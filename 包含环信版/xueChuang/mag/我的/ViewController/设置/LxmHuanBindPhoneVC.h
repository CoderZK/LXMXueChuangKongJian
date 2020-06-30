//
//  LxmHuanBindPhoneVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_ENUM(NSInteger,LxmHuanBindPhoneVC_type) {
    LxmHuanBindPhoneVC_type_first,
    LxmHuanBindPhoneVC_type_second
};

@interface LxmHuanBindPhoneVC : BaseTableViewController
@property (nonatomic , strong)NSString * phone;
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmHuanBindPhoneVC_type)type;

@end
@interface LxmHuanBindPhoneView : UIView
@property (nonatomic , strong)UILabel * leftlab;
@property (nonatomic , strong)UITextField * leftTF;
@property (nonatomic , strong)UIButton * rightBtn;
@end
