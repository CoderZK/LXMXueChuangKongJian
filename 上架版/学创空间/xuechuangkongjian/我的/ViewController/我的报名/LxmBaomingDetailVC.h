//
//  LxmBaomingDetailVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmBaomingDetailVC : BaseTableViewController
@property (nonatomic , strong) NSNumber *applyId;
@property (nonatomic , copy) void(^refreshPreVC)(void);
@end
