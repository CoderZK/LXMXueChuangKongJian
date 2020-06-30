//
//  LxmModifyUserInfoVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmModifyUserInfoVC : BaseTableViewController
@property (nonatomic , strong)LxmUserInfoModel * model;
@property (nonatomic , copy) void(^refreshPreVC)();

@end
